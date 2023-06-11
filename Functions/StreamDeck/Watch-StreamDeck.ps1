function Watch-StreamDeck
{
    <#
    .SYNOPSIS
        Watches StreamDeck
    .DESCRIPTION
        Watches StreamDeck for events.
        
        This function provides the backbone of a StreamDeck plugin written in PowerShell.
        
        Watch-StreamDeck should not be called directly, unless you are testing a plugin.
    .EXAMPLE
        # This will start watching the plugin with arguments passed by StreamDeck
        Watch-StreamDeck -StreamDeckInfo $args
    .LINK
        Send-StreamDeck
    .LINK
        Receive-StreamDeck
    #>
    param(
    # The StreamDeck Information.
    # This will be the JSON object initially passed in.
    [Parameter(ValueFromPipeline)]
    [PSObject]
    $StreamDeckInfo,

    # The path containing event handlers.  By default, the current directory.
    [string]
    $HandlerPath = $pwd,

    # If set, will receive events from StreamDeck in a background job.
    # This allows Watch-StreamDeck to not block and still mostly work as expected.
    # The main runspace will not be able to send data back to the StreamDeck.
    [switch]
    $AsJob,

    # The log path.
    # If no log path is provided, one will be created in the same directory as this script.
    [string]
    $LogPath,

    # If set, will not log individual StreamDeck messages to disk.
    # These messages are normally outputted to disk so that ScriptDeck may externally watch for events.
    # All events from a prior session will be removed on plugin launch.
    [switch]
    $NoMessageOutput,


    # If set, will not allow message input from disk.
    # These messages are normally monitored so that a StreamDeck action can be externally controlled.
    [switch]
    $NoMessageInput,

    # If set, will not allow script input from disk.
    # Script input is normally allowed enable out-of-process manipulation of global state.
    [switch]
    $NoScriptInput
    )

    begin {
        $allArgs = @()
        function InitializeScriptDeckHandler
        {
            param($file)
            # If it does not look like a .handler.ps1 or is not like On_*.ps1
            if ($file.Name -notlike '*.handler.ps1' -and 
                $file.Name -notlike 'On_*.ps1' -and 
                $file.Name -notmatch '@') {
                return # keep moving.
            }
        
            # Remove the naming hints from the file to get the source identifier
            $sourceIdentifier = $file.Name -replace '^On_' -replace '\.ps1$' -replace '\.handler$' -replace '@', 
                '.' -replace '\.{1,}', '.'
            # and then break the source identifier into chunks.
            $sourceIdentifierParts = @($sourceIdentifier -split '\.')            
            
            # If we only have two chunks and the first chunk is not 'StreamDeck'
            if (($sourceIdentifierParts -ne '').Length -le 2 -and 
                $sourceIdentifierParts[0] -ne 'StreamDeck') {
                # then we need to include the plugin UUID in the source identifier
                $sourceIdentifierParts = @($StreamDeckInfo.info.plugin.uuid) + $sourceIdentifierParts
                $sourceIdentifier = $sourceIdentifierParts -ne '' -join '.'                
            }

            # Get the list of event names.
            $eventNames = 
                # multiple events can be separated with a plus sign or a comma
                @(if ($sourceIdentifierParts[-1] -match '[\,\+]') {
                    $sourceIdentifierParts[-1] -split '[\,\+]' -ne ''
                } else {
                    $sourceIdentifierParts[-1]
                })

            # If there was not an event name, register for all possible events.
            if (-not $eventNames) {
                $eventNames = 
                    'KeyDown', 'KeyUp', 
                    'TouchTap',
                    'DialPress','DialRotate',
                    'WillAppear', 'WillDisappear', 
                    'DeviceDidConnect', 'DeviceDidDisconnect',
                    'DidReceiveSettings', 'DidReceiveGlobalSettings',                
                    'TitleParametersDidChange', 
                    'ApplicationDidLaunch',
                    'ApplicationDidTerminate',
                    'SystemDidWakeUp',
                    'PropertyInspectorDidAppear',
                    'PropertyInspectorDidDisappear',
                    'SendToPlugin'
            }

            # Walk over each of the event names
            foreach ($eventName in $eventNames) {
                # and get the full source identifier for each event.
                $sourceIdentifier =
                    @(
                        @(
                            $sourceIdentifierParts[0..$($sourceIdentifierParts.Length - 2)] -notmatch 
                                '^\.$' -ne ''
                        ) +
                            $eventName
                    ) -join '.'

                # Log what we're about to do.
                Add-Content -Path $logPath -value "Registering Handler for '$sourceIdentifier': $($file.fullname)"
                $actionScriptBlock = [ScriptBlock]::Create(@"
try { . '$($file.Fullname)' } catch {             
    `$err = `$_
    `$errorString = `$err | Out-String
    `$errorString | Add-Content -Path `$global:STREAMDECK_PLUGINLOGPATH
    if (-not `$IsLinux -or `$IsMac) {
        Start-Job -ScriptBlock {
            (New-Object -ComObject WScript.Shell).Popup(`"`$args`",0,`"`StreamDeck - ProcessID: `$pid`", 16)
        } -ArgumentList `$errorString
    }
}
"@)
                # And register each handler.
                $existingSubscriber = Get-EventSubscriber -SourceIdentifier $sourceIdentifier -ErrorAction SilentlyContinue
                if ($existingSubscriber) {
                    $existingSubscriber | Unregister-Event
                }
                Register-EngineEvent -SourceIdentifier $sourceIdentifier -Action $actionScriptBlock
            }
        }
    }

    process {
        if ($StreamDeckInfo -is [string]) {
            $allArgs += $StreamDeckInfo
        }
    }

    end {
        # If we have not been provided with a -LogPath
        if (-not $LogPath) {
            # use a global variable if already declared
            if ($global:STREAMDECK_PLUGINLOGPATH) {
                $LogPath = $global:STREAMDECK_PLUGINLOGPATH
            }
            else {
                # Set up a log path for this plugin instance (make it based off of the starttime)
                $global:STREAMDECK_PLUGINLOGPATH = $logPath = 
                    Join-Path $psScriptRoot (        
                        ([Datetime]::Now.ToString('o').replace(':','.') -replace '\.\d+(?=[+-])') + '.log'
                    )
                # Clear older logs (only keep the last 10 executions around)
                Get-ChildItem -Path $psScriptRoot -Filter *.log |
                    Sort-Object LastWriteTime -Descending |
                    Select-Object -Skip 10 |
                    Remove-Item

                $global:STREAMDECK_STARTTIME = $startTime = $([DateTime]::Now.ToString('s'))

                $StartTime | Set-Content -Path (Join-Path $psScriptRoot "StartTime.txt")

                Get-ChildItem -Path $psScriptRoot -Filter *.clixml |
                    Where-Object LastWriteTime -lt $global:STREAMDECK_STARTTIME |
                    Remove-Item

                "Log Started @ $StartTime.  Running under process ID $($pid)" | Add-Content -Path $logPath
            }
        }

        if ($StreamDeckInfo -is [Object[]]) {
            $allArgs = $StreamDeckInfo
        }

        # If the stream deck info is an array, it is an array of arguments
        if ($allArgs) {# Put each named argument into a dictionary.
            $argObject = [Ordered]@{}
            for ($i = 0; $i -lt $allArgs.Length; $i+=2 ) # We do this by going in twos thru the arguments
            {       
                $k = $allArgs[$i].TrimStart('-') # removing the - from the key
                $v = $allArgs[$i + 1]
                $argObject[$k] = 
                    if ("$v".StartsWith('{')) { # and converting any JSON-like input.
                        $v | ConvertFrom-Json
                    } else {
                        $v
                    }
            }
            $StreamDeckInfo = [PSCustomObject]$argObject
        }


        # We will want to declare a few globals to keep track of state.
        if (-not $Global:STREAMDECK_DEVICES)  { $Global:STREAMDECK_DEVICES = @{} }
        if (-not $Global:STREAMDECK_BUTTONS)  { $Global:STREAMDECK_BUTTONS = @{} }
        if (-not $global:STREAMDECK_SETTINGS) { $global:STREAMDECK_SETTINGS = @{} }


        # Next, we'll want to wire up all of the files in the handler path.
        $localFiles = Get-ChildItem -Path $HandlerPath -Filter *.ps1    
        
        # Walk over each file we find
        foreach ($file in $localFiles) {
            # and initialize the handler
            . InitializeScriptDeckHandler $file            
        }

        # Now, set up a heartbeat (every 10 minutes)
        $heartbeatTimer = [Timers.Timer]::new()
        $heartbeatTimer.Interval = [Timespan]::FromMinutes(10).totalmilliseconds
        $heartbeatTimer.AutoReset = $true
        $heartbeatTimer.Start()
        Register-ObjectEvent -InputObject $heartbeatTimer -EventName Elapsed -Action {
            "Heartbeat @ $([DateTime]::Now.ToString('s'))" | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
        }

        if (-not $NoMessageInput) {
            if (-not $global:ScriptDeckResponseWatcher) {
                $fileSystemWatcher = [IO.FileSystemWatcher]::new()
                $fileSystemWatcher.Path = "$PSScriptRoot"
                $fileSystemWatcher.NotifyFilter = 'LastWrite'
                $propagateFileEvent = {
                    # Why not subscribe directly?
                    # FileSystemWatcher often sends multiple events,
                    # so we'll guard against that by propagating only the first in a timeframe.
                    if ($script:LastFileEvent) {
                        if (($event.TimeGenerated - $script:LastFileEvent.TimeGenerated) -gt '00:00:00.25') {
                            $script:LastFileEvent = $null
                        }
                    }
            
                    # If the last event was from the same context, return
                    if ($script:LastFileEvent -and $event.SourceArgs[1].FullPath -eq $script:LastFileEvent.SourceArgs[1].FullPath) {
                        return
                    }
                            
                    $script:LastFileEvent = $event
            
                    # Create an object for the file change
                    $eventMessageData = [Ordered]@{
                        FilePath = $event.SourceArgs[1].FullPath
                    }
                    # and get the subscriber.
                    $sourceSubscriber = Get-EventSubscriber | 
                        Where-Object { $_.SourceObject.SourceEvent.MessageData.Context -eq $fileChangedContext }            
                        
                    # The subscriber has the source event, which provides additional context
                    foreach ($prop in $sourceSubscriber.SourceObject.SourceEvent.MessageData.psobject.properties) {
                        # so add that to the message.
                        $eventMessageData[$prop.Name] = $prop.Value
                    }
            
                    New-Event -SourceIdentifier "ScriptDeck.FileChange" -EventArguments $event.SourceArgs -MessageData $event.SourceArgs[1].FullPath
                }
                $global:ScriptDeckResponseWatcher = Register-ObjectEvent -InputObject $fileSystemWatcher -EventName Changed -Action $propagateFileEvent
            }
            
            if (-not $global:FileChangeWatcher) {
                $global:FileChangeWatcher = Register-EngineEvent -SourceIdentifier ScriptDeck.FileChange -Action {
                    $filePath = $event.MessageData
                    $fileInfo = [IO.FileInfo]$filePath
                    switch -Regex ($event.MessageData) {
                        '\.ps1$' {
                            if ($filePath -notmatch '(?>Send|Receive|Watch)-Streamdeck' -and 
                                $filePath -notmatch 'StartPlugin.ps1$') {
                                if ($filePath -match '@') {
                                    InitializeScriptDeckHandler $fileInfo.FullName
                                } else {
                                    "Running $FilePath" | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
                                    . $event.MessageData
                                }                                
                            }                
                        }            
                        '\.clixml$' {
                            $imported = Import-Clixml -Path $event.MessageData
                            $eventFile = [IO.FileInfo]$event.MessageData
                            $eventFileName = $eventFile.Name.Substring(0,$eventFile.Name.Length - $eventFile.Extension.Length)
                            
                            if ($imported.pstypenames -match '(?>Hashtable|Dictionary)$') {
                                $imported = [Ordered]@{} + $imported
                                if ($eventFileName -match '\.Send-StreamDeck$') {
                                    "Splatting to Send-StreamDeck: $(ConvertTo-Json $imported)" | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
                                    try {
                                    Send-StreamDeck @imported
                                    } catch {
                                        $err = $_
                                        "Error Splatting to Send-StreamDeck: $($err | Out-String)" | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if ($AsJob) {
            $StreamDeckInfo | Receive-StreamDeck -AsJob -OutputType Message -NoMessageOutput:$NoMessageOutput
            return
        } 
        $Host.UI.RawUI.WindowTitle = "StreamDeck $pid"

        # And now begin monitoring the StreamDeck
        do {
            "Starting Watching Streamdeck  @ $([DateTime]::Now.ToString('s'))" | Add-Content -Path $logPath
            $StreamDeckInfo | 
                Receive-StreamDeck -OutputType Message 2>&1 -NoMessageOutput:$NoMessageOutput | 
                Foreach-Object {
                    if ($Global:STREAMDECK_WEBSOCKET.State -in 'Aborted' ,'CloseReceived') {
                        $_ | Out-String | Add-Content -Path $logPath
                        break
                    }
                    $_ | Out-String | Add-Content -Path $logPath
                }

            
            if ($Global:STREAMDECK_WEBSOCKET.State -in 'Aborted' ,'CloseReceived') {
                break
            }
            $sleepTime = (Get-Random -Minimum 30 -Maximum 180)        
            "Finished Watching Streamdeck @ $([DateTime]::Now.ToString('s')).  Trying again in $($sleepTime)" | Add-Content -Path $logPath
            Start-Sleep -Seconds $sleepTime
        } while ($true)
    }
}