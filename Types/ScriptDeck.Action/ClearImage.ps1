<#
.SYNOPSIS
    Clears a ScriptDeck action's image
.DESCRIPTION
    Clears any dynamically provided image applied to a ScriptDeck action.

    Images assigned thru the StreamDeck UI will always take precedence.

    If one has been provided in the UI, this will not change it.
#>
param()

$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setTitle.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    EventName = 'setImage'
    Context = $this.Context
    Payload = @{
        "image" = ''
    }
} -Path $exportPath
