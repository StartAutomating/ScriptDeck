function Start-StreamDeck
{
    <#
    .Synopsis
        Starts StreamDeck
    .Description
        Starts the StreamDeck application.
    .Example
        Start-StreamDeck
    .Link
        Restart-StreamDeck
    #>
    param(
    # The Path to StreamDeck.  
    # If this parameter is provided, this will attempt to launch StreamDeck from the default installation folder.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $StreamDeckPath,

    # If set, will output the created process.
    [switch]
    $PassThru
    )

    process {
        if (-not $StreamDeckPath) {
            $streamDeckProcess = Get-Process StreamDeck -ErrorAction SilentlyContinue
            $StreamDeckPath =
                if ($streamDeckProcess) {
                    $streamDeckProcess.Path
                } elseif ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    "$env:ProgramFiles\Elgato\StreamDeck\StreamDeck.exe"
                } elseif ($PSVersionTable.Platform -eq 'Unix' -and $PSVersionTable.OS -like '*darwin*') {
                    "/Applications/Stream Deck.app”
                }
        }

        if (-not $StreamDeckPath) {
            Write-Error "Could not automatically detect a -StreamDeckPath.  Please provide one"
            return
        } else {
            Start-Process $StreamDeckPath -PassThru:$PassThru
        }
    }
}
