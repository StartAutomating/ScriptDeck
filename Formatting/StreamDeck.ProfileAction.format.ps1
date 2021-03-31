Write-FormatView -TypeName StreamDeck.ProfileAction -Action {
    $actionSet = $_

    @(foreach ($prop in $actionSet.psobject.properties) {
        $prop.Name + ' > ' + $prop.Value.Name
        '[' +$prop.Value.UUID + ']'        
        ($prop.Value.Settings | Format-List | Out-String).Trim()
        [Environment]::NewLine
    }) -join [Environment]::NewLine
}
