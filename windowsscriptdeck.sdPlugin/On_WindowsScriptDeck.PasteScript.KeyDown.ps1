if (-not ('windows.Clipboard' -as [type])) {
    Add-Type -AssemblyName PresentationCore
}
$msg = @(
if ($event.MessageData.payload.settings.header) {
    $event.MessageData.payload.settings.header
    
}
if ($event.MessageData.payload.settings.script) {
    $bufferWidth = 1kb
    (Invoke-Expression -Command $event.MessageData.payload.settings.script 2>&1 | 
        Out-String -Width $bufferWidth).Trim()        
}

if ($event.MessageData.payload.settings.footer) {
    $event.MessageData.payload.settings.footer
}

) -join [Environment]::NewLine
[Windows.Clipboard]::SetText($msg)
(New-Object -ComObject WScript.Shell).SendKeys('^v')
