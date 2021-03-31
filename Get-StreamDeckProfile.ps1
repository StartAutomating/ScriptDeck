function Get-StreamDeckProfile
{
    <#
    .Synopsis
        Gets StreamDeck Profiles
    .Description
        Gets profiles for the StreamDeck application.
    .Example
        Get-StreamDeckProfile
    .Link
        New-StreamDeckProfile
    .Link
        Remove-StreamDeckProfile
    #>
    [OutputType('StreamDeck.Profile')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "", Justification="Parameter is being used")]
    param(
    # The name of the profile
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # If set, will get profiles recursively
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Recurse
    )

    begin {
        #region [ScriptBlock]$importProfile
        $importProfile = { process {
            $inFile = $_
            $jsonObject = ConvertFrom-Json ([IO.File]::ReadAllText($inFile.Fullname)) # Read in the file content
            $jsonObject.pstypenames.clear()
            $jsonObject.pstypenames.add('StreamDeck.Profile') # decorate the type
            $jsonObject.psobject.properties.add([PSNoteProperty]::new('GUID',  # add .Guid
                $inFile.Directory.Name -replace '\.sdprofile$'))
            $jsonObject.psobject.properties.add([PSNoteProperty]::new('Path',  # add .Path
                $inFile.Fullname))
            $maxX = 0
            $maxY = 0

            foreach ($act in $jsonObject.Actions.psobject.properties) { # Decorate each action
                $x,$y = $act.Name -split ','
                if ($maxX -lt $x ) {$maxX = [int]$x}
                if ($maxY -lt $y) {$maxY = [int]$y}
                $act.value.pstypenames.clear()
                $act.value.pstypenames.add('StreamDeck.Action')
            }
            $jsonObject.Actions.pstypenames.clear()
            $jsonObject.Actions.pstypenames.add('StreamDeck.ProfileAction') # Decorate the actions.
            if ($Name -and $jsonObject.Name -notlike $Name) { return } # filter
            $jsonObject # output.
        } }
        #endregion [ScriptBlock]$importProfile
    }

    process {
        if (-not $PSVersionTable.Platform -or ($PSVersionTable.Platform -eq 'Windows')) {
            Get-ChildItem -Path "$env:AppData\Elgato\StreamDeck\ProfilesV2\" |
                Get-ChildItem -Filter manifest.json -Recurse:$Recurse |
                & $importProfile
        } elseif ($PSVersionTable.Platform -eq 'Unix') {
            if ($PSVersionTable.OS -like '*darwin*') {
                Get-ChildItem -Path "~/Library/Application Support/elgato/StreamDeck/ProfilesV2" |
                    & $importProfile
            }
        }
    }
}
