Write-FormatView -TypeName StreamDeck.Plugin -Action {
    @(
    ''
    '# ' + $_.Name, '[', $_.Version,']','(', $_.Author,')' -join ' '
    ''
    (' '* 3) + $_.Description -split '(?>\r\n|\n)' -join ('    ' + [Environment]::NewLine)


    ''
    '## Actions:'
    ''
    foreach ($act in $_.actions) {
        (' '* 2),$act.Name,'[',$act.uuid,']' -join ' '
        (' '* 2),'>',$act.tooltip -join ' '
    }
    ''
    ) -join [Environment]::NewLine
}

Write-FormatView -TypeName StreamDeck.Plugin -Property Name, Version, Author, Description -Wrap
