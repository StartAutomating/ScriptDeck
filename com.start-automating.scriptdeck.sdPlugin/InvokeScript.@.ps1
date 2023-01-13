# This file handles all InvokeScript related events

$invokeError = $null

foreach ($settingName in 'KeyDown','KeyUp','WillAppear', 'WillDisappear', 'DialPress', 'DialRotate', 'TouchTap') {
    if ($event.SourceIdentifier -match $settingName -and
    $event.MessageData.payload.settings.$settingName) {
        $settingScript = $event.MessageData.payload.settings.$settingName
        Invoke-Expression $settingScript -ErrorAction Continue -ErrorVariable $invokeError
        if ($invokeError) {
            $invokeError | Out-string | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
            Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
        } else {
            Send-StreamDeck -ShowOK -Context $event.MessageData.Context
        }
    }
}
