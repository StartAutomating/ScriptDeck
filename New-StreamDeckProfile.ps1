function New-StreamDeckProfile
{
    <#
    .Synopsis
        Creates a StreamDeck profile
    .Description
        Creates a StreamDeck profile object
    .Example
        New-StreamDeckProfile -Name Clippy -Action @{
            '0,0' =
                New-StreamDeckAction -Name "Switch Profile" -Setting @{
                    DeviceUUID  = ''
                    ProfileUUID = 'A0C89D39-F47D-4CE0-8262-4EE22E22CEFC'
                }

            '0,1' = New-StreamDeckAction -HotKey "CTRL+X" -Title "Cut" -Image $home\Downloads\scissors.svg   # downloaded from FeatherIcons

            '1,1' = New-StreamDeckAction -HotKey "CTRL+C" -Title "Copy" -Image $home\Downloads\copy.svg      # downloaded from FeatherIcons

            '2,1' = New-StreamDeckAction -HotKey "CTRL+V" -Title "Paste" -Image $home\Downloads\code.svg     # downloaded from FeatherIcons
        }
    .Example
        $gitUser = 'StartAutomating'
        $rows, $columns = 2,3
        $repoList =  (Invoke-RestMethod -Uri https://api.github.com/users/$gitUser/repos?sort=pushed | ForEach-Object { $_ })
        $n =0
        $actions = [Ordered]@{}
        for ($r = 0 ;$r -lt $rows; $r++) {
            for ($c = 0 ; $c -lt $columns; $C++) {
                $actions["$c,$r"] = New-StreamDeckAction -Uri $repoList[$n].html_url -Title $repoList[$n].name
                $n++
            }
        }

        New-StreamDeckProfile -Name GitRepos -Action $actions |
            Save-StreamDeckProfile
    .Link
        Get-StreamDeckProfile
    .Link
        Remove-StreamDeckProfile
    .Link
        Save-StreamDeckProfile
    #>
    [OutputType('StreamDeck.Profile')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not change state")]
    param(
    # The name of the profile
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # A collection of actions.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    [ValidateScript({
        foreach ($k in $_.Keys) {
            if ($k -notmatch '\d+,\d+') {
                throw "Action keys must be in the form row, column (e.g. 0,2)."
            }
        }
        return $true
    })]
    $Action,

    # The application identifier.
    # If provided, this profile will be activated whenever this application is given focus.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $AppIdentifier,

    # The device model.
    # If not provided, the most commonly used device model from your other profiles will be used.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DeviceModel,

    # The device UUID.
    # If not provided, the most commonly used device uuid from your other profiles will be used.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DeviceUUID,

    # The version of the profile.  By default, 1.0
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Version = '1.0'
    )


    process {
        #region Discover Device Model/UUID
        if (-not $DeviceModel -or -not $DeviceUUID) {
            $profiles = Get-StreamDeckProfile
            if (-not $DeviceModel) {
                $DeviceModel = $profiles |
                    Group-Object DeviceModel -NoElement |
                    Sort-Object Count -Descending |
                    Select-Object -First 1 -ExpandProperty Name
            }
            if (-not $DeviceUUID) {
                $DeviceUUID = $profiles |
                    Group-Object DeviceUUID -NoElement |
                    Sort-Object Count -Descending |
                    Select-Object -First 1 -ExpandProperty Name
            }
        }
        #endregion Discover Device Model/UUID

        #region Create Profile Object
        $streamDeckProfileObject = [Ordered]@{
            Name=$Name;
            DeviceModel=$DeviceModel;
            DeviceUUID=$DeviceUUID;
            Guid = [Guid]::NewGuid().ToString()
            Actions=[Ordered]@{}
            PSTypeName = 'StreamDeck.Profile'
            Version = $Version
        }
        #endregion Create Profile Object

        if ($AppIdentifier) {
            $streamDeckProfileObject.AppIdentifier = $AppIdentifier
        }

        #region Determine Profile Root
        $profileRoot=
            if ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                "$env:AppData\Elgato\StreamDeck\ProfilesV2\"
            } elseif ($PSVersionTable.Platform -eq 'Unix' -and $PSVersionTable.OS -like '*darwin*') {
                "~/Library/Application Support/elgato/StreamDeck/ProfilesV2"
            }

        $profileDirectory = Join-Path $profileRoot -ChildPath "$($streamDeckProfileObject.Guid).sdProfile"
        if (-not (Test-Path $profileDirectory)) {
            $createdDir = New-Item -ItemType Directory -Path $profileDirectory
            if (-not $createdDir) { return }
        }
        $manifestPath = Join-Path $profileDirectory -ChildPath manifest.json
        $streamDeckProfileObject.Path = "$manifestPath"
        #endregion Determine Profile Root

        #region Map Actions
        foreach ($act in $Action.GetEnumerator()) {
            $streamDeckProfileObject.Actions[$act.Name] = $act.value
        }
        if ($streamDeckProfileObject.Actions.Count) {
            $streamDeckProfileObject.Actions = [PSCustomobject]$streamDeckProfileObject.Actions
        }
        #endregion Map Actions

        [PSCustomObject]$streamDeckProfileObject
    }
}