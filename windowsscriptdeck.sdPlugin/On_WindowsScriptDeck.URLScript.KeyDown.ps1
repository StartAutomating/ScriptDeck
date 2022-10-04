if ($event.MessageData.payload.settings.script) {
    Invoke-Expression -Command $event.MessageData.payload.settings.script 2>&1 |
        Foreach-Object {
            if ($_ -is [uri] -or $_ -like 'http*') {
                Start-Process -FilePath "$_"
            }
        }
}
