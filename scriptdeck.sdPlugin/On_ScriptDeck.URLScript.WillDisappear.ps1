$invokeError = $null
if ($event.MessageData.payload.settings.WillDisappear) {
    Invoke-Expression -Command $event.MessageData.payload.settings.WillDisappear -ErrorAction Continue -ErrorVariable $invokeError
    if ($invokeError) {
        Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
    } else {
        Send-StreamDeck -ShowOK -Context $event.MessageData.Context
    }
}
