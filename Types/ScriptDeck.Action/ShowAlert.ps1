<#
.SYNOPSIS
    Shows an Alert
.DESCRIPTION
    Sends a 'ShowAlert' message to StreamDeck, which will show a warning icon briefly atop of an action.
#>
$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).showAlert.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    Context = $this.Context
    ShowAlert = $true
} -Path $exportPath
