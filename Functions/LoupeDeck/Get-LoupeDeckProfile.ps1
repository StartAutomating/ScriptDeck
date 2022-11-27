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
    param()

    process {
        $loupeDeckProfileFiles = 
            if ($IsWindows -or (-not $IsMacOS -and -not $IsLinux)) {
                $env:APPDATA | 
                    Split-Path | 
                    Join-Path -ChildPath Local |
                    Join-Path -ChildPath Loupedeck |
                    Join-Path -ChildPath Applications |
                    Get-ChildItem |
                    Get-ChildItem |
                    Get-ChildItem -Filter Profiles |
                    Get-ChildItem |
                    Get-ChildItem -Filter ProfileInfo.json
            } elseif ($IsMacOS) {
                Get-ChildItem "$env:HOME/.local/share/Loupedeck/Applications" |
                    Get-ChildItem |
                    Get-ChildItem |
                    Get-ChildItem -Filter Profiles |
                    Get-ChildItem |
                    Get-ChildItem -Filter ProfileInfo.json
            }
        foreach ($profileFile in $loupeDeckProfileFiles) {
            [IO.File]::ReadAllText($profileFile.FullName) |
                ConvertFrom-Json |
                & { process {
                    $_.pstypenames.clear()
                    $_.pstypenames.add('LoupeDeck.Profile')
                    $_
                } }
        }
    }
}
