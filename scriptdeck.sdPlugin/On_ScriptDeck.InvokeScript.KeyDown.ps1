$invokeError = $null
"KeyDown Pressed @ $([DateTime]::Now)"  | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
if ($event.MessageData.payload.settings.KeyDown) {
    try {
        Invoke-Expression -Command $event.MessageData.payload.settings.KeyDown -ErrorAction Continue -ErrorVariable $invokeError
        if ($invokeError) {
            $invokeError | Out-string | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
            Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
        } else {
            Send-StreamDeck -ShowOK -Context $event.MessageData.Context
        }
    } catch {
        $_ | Out-String | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
    }
}
