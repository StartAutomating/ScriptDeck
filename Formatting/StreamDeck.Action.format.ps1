Write-FormatView -TypeName StreamDeck.Action -Property Name, UUID, Settings -AutoSize -VirtualProperty @{
    Settings = {
        ($_.Settings | Format-List | Out-String).Trim()
    }
}
