function Export-StreamDeckProfile
{
    <#
    .Synopsis
        Exports Stream Deck Profile
    .Description
        Exports one or more Stream Deck profiles
    .Link
        Get-StreamDeckProfile
    .Example
        Export-StreamDeckProfile
    #>
    param(
    # The name of the profile
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,
    
    # The output path for the profile.
    # If the output path is not provided, profiles will be backed up to $home
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string]
    $OutputPath
    )

    begin {
        if (-not ('IO.Compression.ZipFile' -as [type])) {
            Add-Type -AssemblyName System.IO.Compression.Filesystem
        }
    }

    process {
        $gspSplat = @{Name=$Name}
        $sdprofiles = @(Get-StreamDeckProfile @gspSplat)
        if (-not $OutputPath) {
            $OutputPath = $home
        }

        foreach ($sdp in $sdprofiles) {
            $sdpOutputDirectory = Join-Path $outputPath "$($sdp.Name)_Profile" | Join-Path -ChildPath "$($sdp.Guid).sdProfile"
            $sdpOutputPath      = Join-Path $OutputPath "$($sdp.Name).streamDeckProfile"
            if (-not (Test-Path $sdpOutputDirectory)) {
                $null = New-Item -ItemType Directory -Path $sdpOutputDirectory
                if (-not $?) { continue }
            }
            
            Copy-Item -Recurse -Path "$($sdp.Path | Split-Path)$([IO.Path]::DirectorySeparatorChar)*" -Destination $sdpOutputDirectory

            $manifestPath = Join-Path $sdpOutputDirectory "manifest.json"
            Get-Content $manifestPath -Raw | 
                ConvertFrom-Json | 
                ForEach-Object {
                    $_.psobject.properties.Remove('DeviceUUID')
                    $_
                } |
                ConvertTo-Json -Depth 100 |
                Set-Content -Path $manifestPath
            [IO.Compression.ZipFile]::CreateFromDirectory("$($sdpOutputDirectory | Split-path)", "$sdpOutputPath")

            Remove-Item -Recurse -Force $sdpOutputDirectory
        }

    }
}
