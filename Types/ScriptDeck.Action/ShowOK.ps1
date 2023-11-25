<#
.SYNOPSIS
    Shows an OK
.DESCRIPTION
    Sends a 'ShowOK' message to StreamDeck, which will show a checkmark briefly atop of an action.
#>
param()
$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).showAlert.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    Context = $this.Context
    ShowOK = $true
} -Path $exportPath
