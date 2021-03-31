function Get-StreamDeckPlugin
{
    <#
    .Synopsis
        Gets Stream Deck Plugins
    .Description
        Gets plugins for StreamDeck.
    .Example
        Get-StreamDeckPlugin
    .Link
        New-StreamDeckAction
    #>
    [OutputType('StreamDeck.Plugin')]
    param(
    # The name of the plugin
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The Plugin UUID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $UUID,

    # If set, will rebuild the cache of streamdeck plugins.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force
    )

    process {
        #region Cache StreamDeck Plugins
        if ($force -or -not $Script:CachedStreamDeckPlugins) {
            $importManifest = { process {
                $inFile = $_
                $jsonObject = ConvertFrom-Json ([IO.File]::ReadAllText($inFile.Fullname))
                $jsonObject.pstypenames.clear()
                $jsonObject.pstypenames.add('StreamDeck.Plugin')
                $jsonObject.psobject.properties.add([PSNoteProperty]::new('Path', $inFile.Fullname))
                $jsonObject
            } }
            $Script:CachedStreamDeckPlugins = @(
                if (-not $PSVersionTable.Platform -or ($PSVersionTable.Platform -eq 'Windows')) {
                    Get-ChildItem -Path "$env:AppData\Elgato\StreamDeck\Plugins\" -Directory |
                        Get-ChildItem -Filter manifest.json |
                        & $importManifest

                    Get-ChildItem -Path "$env:ProgramFiles\Elgato\StreamDeck\plugins" -Directory |
                        Get-ChildItem -Filter manifest.json |
                        & $importManifest
                } elseif ($PSVersionTable.Platform -eq 'Unix') {
                    if ($PSVersionTable.OS -like '*darwin*') {
                        Get-ChildItem -Path "~/Library/Application Support/elgato/StreamDeck/Plugins" |
                            Get-ChildItem -Filter manifest.json |
                            & $importManifest

                        Get-ChildItem -Path "/Applications/Stream Deck.app/Contents/Plugins" -Directory |
                            Get-ChildItem -Filter manifest.json |
                            & $importManifest
                    }
                }
            )
        }
        #endregion Cache StreamDeck Plugins

        $Script:CachedStreamDeckPlugins
    }
}
