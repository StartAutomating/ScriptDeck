function Get-LoupeDeckProfile
{
    <#
    .SYNOPSIS
        Gets LoupeDeck Profiles
    .DESCRIPTION
        Gets Profiles for LoupeDeck
    .EXAMPLE
        Get-LoupeDeckProfile
    #>
    param(
    # The name of the profile
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The profile root.
    # This will be automatically set if it is not provided.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $ProfileRoot
    )

    begin {
        filter ImportLoupeDeckProfile {
            [IO.File]::ReadAllText($_.FullName) |
                ConvertFrom-Json |
                & { process {
                    if ($name -and $_.DisplayName -notlike $name) { return } 
                    $_.pstypenames.clear()
                    $_.pstypenames.add('LoupeDeck.Profile')
                    $_
                } }
        }
    }

    process {
        if (-not $ProfileRoot) {
            $ProfileRoot = 
                if ($IsWindows -or (-not $IsMacOS -and -not $IsLinux)) {
                    $env:APPDATA | 
                        Split-Path | 
                        Join-Path -ChildPath Local |
                        Join-Path -ChildPath Loupedeck |
                        Join-Path -ChildPath Applications
                } elseif ($IsMacOS) {
                    Join-Path "$env:HOME/.local/share/Loupedeck" "Applications"
                }
        }        
        if (-not $ProfileRoot) { return }
        $ProfileRoot |
            Get-ChildItem |
            Get-ChildItem |
            Get-ChildItem -Filter Profiles |
            Get-ChildItem |
            Get-ChildItem -Filter ProfileInfo.json |
            ImportLoupeDeckProfile
    }
}
