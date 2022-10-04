$evt = Get-Event -SourceIdentifier "StreamDeck.PendingSetting.$($event.MessageData.context)" -ErrorAction SilentlyContinue
$global:STREAMDECK_SETTINGS[$event.MessageData.Context] = [PSObject]::new()
if ($evt) {        
    $global:STREAMDECK_SETTINGS[$event.MessageData.Context] = $event.MessageData.Payload.Settings
    foreach ($prop in $evt.MessageData.psobject.properties) {            
        Add-Member -InputObject $global:STREAMDECK_SETTINGS[
            $event.MessageData.Context
        ] -MemberType NoteProperty -Name $prop.Name -Value $prop.Value -Force
    }
    $evt | Remove-Event
} else {
    $global:STREAMDECK_SETTINGS[$event.MessageData.Context] = $event.MessageData.Payload.Settings
}
$settingsObject = $global:STREAMDECK_SETTINGS[$event.MessageData.Context]
$newSettings    = [PSObject]::new()
if ($settingsObject -is [Collections.IDictionary]) {
    foreach ($kv in $settingsObject.GetEnumerator()) {
        $newSettings | Add-Member -memberType NoteProperty $kv.Key $kv.Value
    }
} else {
    foreach ($prop in $settingsObject.psobject.properties) {
        if ($prop.Name -in 'Count', 'IsFixedSize', 'IsReadOnly', 'IsSynchronized', 'Keys', 'SyncRoot', 'Values') {
            continue
        }
        $newSettings | Add-Member -memberType NoteProperty -Name $prop.Name -Value $prop.Value            
    }
}




    
Send-StreamDeck -Context $event.MessageData.Context -EventName setSettings -Payload $newSettings