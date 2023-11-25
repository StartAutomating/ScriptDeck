<#
.SYNOPSIS
    Get an action's event files  
.DESCRIPTION
    Get the event files related to an action.
    These contain the StreamDeck messages sent to the action.
#>
@(Get-ChildItem -Path (Split-Path $this.Plugin.PluginPath) -Filter "*.$($this.Context).received.clixml" | Sort-Object LastWriteTime -Descending) 