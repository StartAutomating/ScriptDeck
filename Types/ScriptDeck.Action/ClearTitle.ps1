<#
.SYNOPSIS
    Clears a ScriptDeck action's title
.DESCRIPTION
    Clears any dynamically provided title applied to a ScriptDeck action.

    Titles assigned thru the StreamDeck UI will always take precedence.

    If one has been provided in the UI, this will not change it.
#>
param()

$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setTitle.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    EventName = 'setTitle'
    Context = $this.Context
    Payload = @{
        "title" = ''
    }
} -Path $exportPath
