function Save-StreamDeckProfile
{
    <#
    .Synopsis
        Saves StreamDeck Profiles
    .Description
        Saves StreamDeck Profiles and restarts any running StreamDeck instances.
    .Example
        
    .Link
        Get-StreamDeckProfile
    .Link
        New-StreamDeckProfile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The StreamDeckProfile.  
    # Returned from Get-StreamDeckProfile or New-StreamDeckProfile.
    [Parameter(Mandatory,ValueFromPipeline)]
    [PSTypeName('StreamDeck.Profile')]
    [PSObject]
    $StreamDeckProfile
    )

    process {
        if (-not $PSCmdlet.ShouldProcess("Save $($StreamDeckProfile.Name)")) { return }
        $StreamDeckProfile.Save()
    }
}
