foreach ($file in Get-ChildItem -Filter *-*.ps1 -Exclude *.*.ps1 -Recurse -Path $PsScriptRoot) {
    . $file.Fullname
}
