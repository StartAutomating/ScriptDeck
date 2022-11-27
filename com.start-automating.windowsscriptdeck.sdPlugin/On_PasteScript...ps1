# This file handles all InvokeScript related events

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
    # It will compose a message containing
    $msg = @(
    if ($event.MessageData.payload.settings.header) {
        # the header,
        $event.MessageData.payload.settings.header
        
    }
    if ($event.MessageData.payload.settings.script) {
        # the output of the script (as a string)
        $bufferWidth = 1kb
        (Invoke-Expression -Command $event.MessageData.payload.settings.script 2>&1 | 
            Out-String -Width $bufferWidth).Trim()        
    }

    if ($event.MessageData.payload.settings.footer) {
        # and the footer
        $event.MessageData.payload.settings.footer
    }
    ) -join [Environment]::NewLine # (joined by newlines).

    # We pass this to the Set-Clipboard command.
    Set-Clipboard $msg
    (New-Object -ComObject WScript.Shell).SendKeys('^v')
}