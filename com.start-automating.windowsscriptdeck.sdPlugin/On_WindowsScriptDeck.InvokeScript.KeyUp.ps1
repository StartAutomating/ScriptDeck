$invokeError = $null
if ($event.MessageData.payload.settings.KeyUp) {
    Invoke-Expression -Command $event.MessageData.payload.settings.KeyUp -ErrorAction Continue -ErrorVariable $invokeError
    if ($invokeError) {
        Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
    } else {
        Send-StreamDeck -ShowOK -Context $event.MessageData.Context
    }
}
