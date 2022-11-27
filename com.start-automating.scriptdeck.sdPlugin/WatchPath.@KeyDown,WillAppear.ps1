$invokeError = $null
$settings = $event.MessageData.payload.settings
if (-not $settings.Path) { return }


$eventName         = $settings.Path
$fileWatcherFilter = $settings.PathFilter
$eventSubscribers  = Get-EventSubscriber
$separator         = [IO.Path]::DirectorySeparatorChar
$eventName         = $ExecutionContext.SessionState.InvokeCommand.ExpandString($eventName)
# If the event name was not a path,
if (-not "$eventName".Contains("$separator")) {
    return # we are done.
}

# Split the path into parts
$pathParts = @($eventName.Split("$separator"))
# If the last part contained wildcards, it's a filter
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
        $fileWatcherFilter
    }

# Find any previous event subscriptions from this button.
$toRemove = $eventSubscribers | 
    Where-Object {
        $_.SourceObject -is [IO.FileSystemWatcher] -and 
        $_.SourceObject.SourceEvent.MessageData.Context -eq $event.MessageData.Context
    }

# And remove them.
$toRemove |
    Unregister-Event

# Create a FileSystemWatcher
$fileSystemWatcher = [IO.FileSystemWatcher]::new()
$fileSystemWatcher | Add-Member SourceEvent $event -Force
$fileSystemWatcher.Path = $fileWatcherPath
# set the filter,
if ($fileWatcherFilter) {
    $fileSystemWatcher.Filter = $fileWatcherFilter
}
# (recurse if they said they want to),
if ($settings.Recurse) {
    $fileSystemWatcher.IncludeSubdirectories = $true
}
# set up the notification files,
$NotifyFilter = $settings.FileChangeEvent -as [IO.NotifyFilters]
if (-not $NotifyFilter) { $NotifyFilter = 'LastWrite'}
$fileSystemWatcher.NotifyFilter = $NotifyFilter
# predetermine the event id
$fileChangedSourceId = "FileChanged_$($event.MessageData.Context)"
# and create a handler to propagate the event.
$propagateFileEvent = "
    `$fileChangedContext  = '$($event.MessageData.Context)'
    `$fileChangedSourceId = '$fileChangedSourceId'
" + {
    # Why not subscribe directly?
    # FileSystemWatcher often sends multiple events,
    # so we'll guard against that by propagating only the first in a timeframe.
    if ($script:LastFileEvent) {
        if (($event.TimeGenerated - $script:LastFileEvent.TimeGenerated) -gt '00:00:00.25') {
            $script:LastFileEvent = $null
        }
    }

    # If the last event was from the same context, return
    if ($script:LastFileEvent -and $event.SourceArgs[1].FullPath -eq $script:LastFileEvent.SourceArgs[1].FullPath -and
        ($script:LastFileEvent.MessageData.Context -eq $event.MessageData.Context)) {
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

    $eventMessageData = [PSCustomObject]$eventMessageData
    # and generate the file event.
    New-Event -SourceIdentifier $fileChangedSourceId -MessageData $eventMessageData
}

# Now, we need to unregister all of the events subscribers related to this button.
Get-EventSubscriber -SourceIdentifier $fileChangedSourceId -ErrorAction Ignore | Unregister-Event

# and register our changed event.
Register-ObjectEvent -EventName Changed -Action (
    [scriptblock]::Create($propagateFileEvent)
) -InputObject $fileSystemWatcher

# If there was a specific handler
if ($settings.Handler) {
    try {
        # Register for it
        $createdHandler = [ScriptBlock]::Create($settings.Handler)
        Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action $createdHandler
    } catch {
        $ex = $_
        Send-StreamDeck -LogMessage "WatchEvent@ScriptDeck: Could not create handler: $($ex | Out-String)"
        Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
    }
}

# If they want to automatically set images
if ($settings.AutoSetImage) {
    # register a handler that
    Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action {
        $eventFile = $event.MessageData.FilePath -as [IO.FileInfo]
        # will set the image if the event file is an image file.
        if ($eventFile.Extension -in '.gif', '.svg' ,'.png', '.jpg', '.jpeg', '.bmp') {
            Send-StreamDeck -ImagePath $eventFile.Fullname -Context $event.MessageData.Context
        }
    }
}

# If they want to automatically set the title,
if ($settings.AutoSetTitle) {
    # register a handler
    Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action {
        $eventFile = $event.MessageData.FilePath -as [IO.FileInfo]
        # that sets the title to the name of the file.         
        Send-StreamDeck -Title $eventFile.Name -Context $event.MessageData.Context                
    }
}

# If they want to send a message
if ($settings.SendMessage) {
    # write this event to disk
    $context = $event.MessageData.context
    $messageDataJson = $event.MessageData | ConvertTo-Json -Depth 10
    $messagePath = 
        Join-Path $fileWatcherPath "$(@($event.SourceIdentifier -split '\.' -ne '')[-1]).$context.json"
    $messageDataJson | Set-Content $messagePath
}

# If they want to RunScripts
if ($settings.RunScripts) {
    # create a handler that will run any .ps1
    Register-EngineEvent -SourceIdentifier $fileChangedSourceId -Action {
        $eventFile = $event.MessageData.FilePath -as [IO.FileInfo]        
        if ($eventFile.Extension -ne '.ps1') { return }
        . $eventFile.FullName
    }
}
    
if ($invokeError) {
    Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
} else {
    Send-StreamDeck -ShowOK -Context $event.MessageData.Context
}
