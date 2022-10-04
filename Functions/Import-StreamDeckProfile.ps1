function Import-StreamDeckProfile
{
    <#
    .Synopsis
        Imports StreamDeck Profiles
    .Description
        Imports StreamDeck Profile files (*.StreamDeckProfile).

        Profiles are extracted to the ProfilesV2 directory of the local StreamDeck program.
    .Example
        Import-StreamDeckProfile -InputPath .\My.StreamDeckProfile
    .Link
        Export-StreamDeckProfile
    #>
    [OutputType([Nullable])]
    param(
    # The input path.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidatePattern('\.streamDeckProfile$')]
    [Alias('Fullname')]
    [string]
    $InputPath,

    # The output directory.
    # If not provided, will output to the StreamDeck profiles directory.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $OutputDirectory
    )

    begin {
        if (-not ('IO.Compression.ZipFile' -as [type])) {
            Add-Type -AssemblyName System.IO.Compression.Filesystem
        }
    }

    process {
        $resolvedInputPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($InputPath)
        if (-not $resolvedInputPath) { return }
        if (-not $OutputDirectory) {
            $OutputDirectory =
                if ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    "$env:AppData\Elgato\StreamDeck\ProfilesV2\"
                } elseif ($PSVersionTable.Platform -eq 'Unix' -and $PSVersionTable.OS -like '*darwin*') {
                    "~/Library/Application Support/elgato/StreamDeck/ProfilesV2"
                }
        }

        if (-not $OutputDirectory) { Write-Error "Could not determine -OutputDirectory."; return }
        #region Expand Profile .zip
        $unresolvedOutputDirectory =
            $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($OutputDirectory)
        [IO.Compression.ZipFile]::ExtractToDirectory("$resolvedInputPath", "$unresolvedOutputDirectory")
        #endregion Expand Profile .zip
        $streamDeckRunning = Get-Process streamdeck
        if ($streamDeckRunning) {
            $streamDeckRunning | Stop-Process
            Start-Process -Path $streamDeckRunning.Path | Out-Null
        }
    }
}
