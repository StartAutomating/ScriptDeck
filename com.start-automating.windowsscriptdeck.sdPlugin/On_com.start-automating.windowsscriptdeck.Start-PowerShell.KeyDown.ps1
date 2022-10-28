$powerShellArgs = @(
if ($event.MessageData.payload.settings.NoLogo) {
    "-nologo"
}
if ($event.MessageData.payload.settings.NoProfile) {
    "-noprofile"
}
if ($event.MessageData.payload.settings.NoExit) {
    "-noexit"
}
if ($event.MessageData.payload.settings.WorkingDirectory) {
    "-workingdirectory"
    $event.MessageData.payload.settings.WorkingDirectory
}

if ($event.MessageData.payload.settings.ScriptFile) {
    "-file"
    $scriptfile = 
        $event.MessageData.payload.settings.ScriptFile
    if ($scriptfile -like 'file:///*') {
        ([uri]$scriptfile).AbsolutePath
    } else {
        [Web.HttpUtility]::UrlDecode(
            ($event.MessageData.payload.settings.ScriptFile -replace '^C\:\\fakepath\\')) -replace 
                '[\\/]', ([IO.Path]::DirectorySeparatorChar)
    }
}

)

$exePath = (Get-Process -id $pid).Path
Start-Process -FilePath $exePath -ArgumentList $powerShellArgs

