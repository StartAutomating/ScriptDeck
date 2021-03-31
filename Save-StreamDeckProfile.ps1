function Save-StreamDeckProfile
{
    <#
    .Synopsis
        Saves StreamDeck Profiles
    .Description
        Saves StreamDeck Profiles and restarts any running StreamDeck instances.
    .Example
        New-StreamDeckProfile -Name TestProfile -Action @{
            New-StreamDeckAction -Uri https://github.com/StartAutomating/ScriptDeck -Title ScriptDeck
        } |
            Save-StreamDeckProfile
    .Link
        Get-StreamDeckProfile
    .Link
        New-StreamDeckProfile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType([Nullable])]
    param(
    # The StreamDeckProfile.
    # Returned from Get-StreamDeckProfile or New-StreamDeckProfile.
    [Parameter(Mandatory,ValueFromPipeline)]
    [PSTypeName('StreamDeck.Profile')]
    [PSObject]
    $StreamDeckProfile
    )

    process {
        #region .ShouldProcess and Save
        if (-not $PSCmdlet.ShouldProcess("Save $($StreamDeckProfile.Name)")) { return }
        $StreamDeckProfile.Save()
        #endregion .ShouldProcess and Save
    }
}
