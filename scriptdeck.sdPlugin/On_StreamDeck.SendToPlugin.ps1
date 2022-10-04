$instanceSettings = [PSObject]::new()
if ($event.MessageData.Payload.sdpi_collection) {        
    $instanceSettings | 
        Add-Member NoteProperty -Name $event.MessageData.Payload.sdpi_collection.key -Value $event.MessageData.Payload.sdpi_collection.value
}
New-Event -SourceIdentifier "StreamDeck.PendingSetting.$($event.MessageData.context)" -MessageData $instanceSettings
Send-StreamDeck -Context $event.MessageData.context -EventName getSettings
