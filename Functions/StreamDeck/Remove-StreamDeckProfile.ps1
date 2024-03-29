﻿function Remove-StreamDeckProfile
{
    <#
    .Synopsis
        Removes StreamDeck Profiles
    .Description
        Removes StreamDeck Profiles and their directory contents.

        This cannot be undone.
    .Example
        Get-StreamDeckProfile -Name GoodbyeProfile | Remove-StreamDeckProfile
    .Link
        Get-StreamDeckProfile
    #>
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    [OutputType([nullable])]
    param(
    # The Profile Path
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [ValidatePattern('manifest\.json$')]
    [Alias('Path')]
    [string]
    $ProfilePath
    )

    process {
        #region Confirm and Remove
        if (-not (Test-Path $ProfilePath)) { return }
        if ($PSCmdlet.ShouldProcess("Remove '$ProfilePath'")) {
            $ProfilePath | Split-Path | Remove-Item -Recurse -Force
        }
        #endregion Confirm and Remove
    }
}
