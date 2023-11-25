<#
.SYNOPSIS
    Sets a ScriptDeck action's title
.DESCRIPTION
    Sets a dynamically provided title to a ScriptDeck action.

    Titles assigned thru the StreamDeck UI will always take precedence.

    If one has been provided in the UI, this will not change it.
#>
param(
# The title of the StreamDeck action.
[string]
$Title
)

$this | Add-Member '.Title' $Title -Force
$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setTitle.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    Context = $this.Context
    Title = $Title
} -Path $exportPath
