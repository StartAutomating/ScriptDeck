if (-not $event.MessageData.payload.settings) { return }

$invokeError = $null

# WillAppear and WillDisappear are both settings that will run a script.
foreach ($settingName in 'WillAppear', 'WillDisappear') {
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

# Keydown will run differently:
if ($event.SourceIdentifier -match 'KeyDown') {
    if ($event.MessageData.payload.settings.script) {
        Invoke-Expression -Command $event.MessageData.payload.settings.script 2>&1 |
            Foreach-Object {
                if ($_ -is [uri] -or $_ -like 'http*') {
                    Start-Process -FilePath "$_"
                }
            }
    }   
}