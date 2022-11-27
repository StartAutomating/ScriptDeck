$invokeError = $null
if ($event.MessageData.payload.settings.Path) {
        
    $eventName         = $event.MessageData.payload.settings.Path
    $fileWatcherFilter = $event.MessageData.payload.settings.PathFilter
    $eventSubscribers  = Get-EventSubscriber
    $separator         = [IO.Path]::DirectorySeparatorChar
        
    if ("$eventName".Contains("$separator")) {
        $pathParts = @($eventName.Split("$separator"))
        $fileWatcherPath, $fileWatcherFilter = 
            if ($pathParts[-1] -match '[\*\?]') {
                ($pathParts[0..($pathParts.Length - 2)] -join $separator)
                $pathParts[-1]
            }
            elseif ($pathParts[-1] -match '\.') {
                ($pathParts[0..($pathParts.Length - 2)] -join $separator)
                $pathParts[-1]
            }
            else {
                $pathParts -join $separator
                ''
            }
        $toRemove = $eventSubscribers | 
            Where-Object {
                $_.SourceObject -is [IO.FileSystemWatcher] -and 
                $_.SourceObject.SourceEvent.MessageData.Context -eq $event.MessageData.Context
            } 
        $toRemove |
            Unregister-Event
        
        $fileSystemWatcher = [IO.FileSystemWatcher]::new()
        $fileSystemWatcher | Add-Member SourceEvent $event -Force
        $fileSystemWatcher.Path = $fileWatcherPath
        if ($fileWatcherFilter) {
            $fileSystemWatcher.Filter = $fileWatcherFilter
        }
        $NotifyFilter = $event.MessageData.payload.settings.FileChangeEvent -as [IO.NotifyFilters]
        if (-not $NotifyFilter) { $NotifyFilter = 'LastWrite'}
        $fileSystemWatcher.NotifyFilter = $NotifyFilter
        $fileChangedSourceId = "FileChanged_$($event.MessageData.Context)"
        $propagateFileEvent = "
            `$fileChangedContext  = '$($event.MessageData.Context)'
            `$fileChangedSourceId = '$fileChangedSourceId'
        " + {
            # FileSystemWatcher often sends multiple events
            # so we'll guard against that by propagating only the first in a timeframe
            if ($script:LastFileEvent) {
                if (($event.TimeGenerated - $script:LastFileEvent.TimeGenerated) -gt '00:00:00.25') {
                    $script:LastFileEvent = $null
                }
            }

            if ($script:LastFileEvent -and $event.SourceArgs[1].FullPath -eq $script:LastFileEvent.SourceArgs[1].FullPath -and
                ($script:LastFileEvent.MessageData.Context -eq $event.MessageData.Context)) {
                return
            }
            $script:LastFileEvent = $event
            
            $eventMessageData = [Ordered]@{
                FilePath = $event.SourceArgs[1].FullPath
            }
            $sourceSubscriber = Get-EventSubscriber | 
                Where-Object { $_.SourceObject.SourceEvent.MessageData.Context -eq $fileChangedContext }            
                
            foreach ($prop in $sourceSubscriber.SourceObject.SourceEvent.MessageData.psobject.properties) {
                $eventMessageData[$prop.Name] = $prop.Value
            }
            $eventMessageData = [PSCustomObject]$eventMessageData
            New-Event -SourceIdentifier $fileChangedSourceId -MessageData $eventMessageData
        }

        Get-EventSubscriber -SourceIdentifier $fileChangedSourceId -ErrorAction Ignore | Unregister-Event

        Register-ObjectEvent -EventName Changed -Action (
            [scriptblock]::Create($propagateFileEvent)
        ) -InputObject $fileSystemWatcher

        if ($event.MessageData.payload.settings.Handler) {
            try {
                $createdHandler = [ScriptBlock]::Create($event.MessageData.payload.settings.Handler)
                Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action $createdHandler
            } catch {
                $ex = $_
                Send-StreamDeck -LogMessage "WatchEvent@ScriptDeck: Could not create handler: $($ex | Out-String)"
                Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
            }
        }

        if ($event.MessageData.payload.settings.AutoSetImage) {
            Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action {
                $eventFile = $event.MessageData.FilePath -as [IO.FileInfo]
                if ($eventFile.Extension -in '.gif', '.svg' ,'.png', '.jpg', '.jpeg', '.bmp') {
                    Send-StreamDeck -ImagePath $eventFile.Fullname -Context $event.MessageData.Context
                }
            }
        }

        if ($event.MessageData.payload.settings.SendMessage) {
            $context = $event.MessageData.context
            $messageDataJson = $event.MessageData | ConvertTo-Json -Depth 10
            $messagePath = 
                Join-Path $fileWatcherPath "Receive-StreamDeck.$(@($event.SourceIdentifier -split '\.' -ne '')[-1]).$context.json"
            $messageDataJson | Set-Content $messagePath
        }

        if ($event.MessageData.payload.settings.ReceiveMessage) {
            Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action {
                $eventFile = $event.MessageData.FilePath -as [IO.FileInfo]
                if ($eventFile.Name -notmatch '^Send-StreamDeck\.[^\.]+\.')   { return }
                if ($eventFile.Extension -ne '.ps1') { return }
                $eventInput = 
                    if ($eventFile.Extension -eq '.clixml') {
                        Import-Clixml -LiteralPath $eventFile.FullName
                    }
                    elseif ($eventfile.Extension -eq '.json') {
                        Get-Content -LiteralPath $eventFile.FullName -Raw | 
                            ConvertFrom-Json
                    } else {
                        . $eventFile.FullName
                    }

                foreach ($eventIn in $eventInput) {
                    $eventInParams = [Ordered]@{}
                    if ($eventIn -is [Collections.IDictionary]) {
                        $eventInParams += $eventIn
                    } else {
                        foreach ($prop in $eventIn.psobject.properties) {
                            $eventInParams[$prop.Name] = $prop.Value
                        }
                    }
                    $sendStreamDeckSplat = [Ordered]@{}
                    $sendStreamDeckCmd = $ExecutionContext.SessionState.InvokeCommand.Get('Send-StreamDeck', 'Function')
                    :nextProp foreach ($eventKv in $eventInParams.GetEnumerator()) {
                        if (-not $sendStreamDeckCmd.Parameters[$eventKv.Key]) {
                            foreach ($param in $sendStreamDeckCmd.Parameters.Values) {
                                if ($param.Aliases -contains $eventKv.Key) {
                                    $sendStreamDeckCmd.Parameters[$eventKv.Value] = $eventkv.Value
                                    continue nextProp
                                }
                            }
                        } else {
                            $sendStreamDeckCmd.Parameters[$eventKv.Key] = $eventkv.Value
                        }
                    }

                    if ($sendStreamDeckSplat.Count) {
                        Send-StreamDeck @sendStreamDeckSplat
                    }
                }

                
            }
        }

    } elseif ("$eventName") {
    }
    
    if ($invokeError) {
        Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
    } else {
        Send-StreamDeck -ShowOK -Context $event.MessageData.Context
    }
}
