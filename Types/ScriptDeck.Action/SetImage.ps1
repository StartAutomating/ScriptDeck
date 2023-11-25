<#
.SYNOPSIS
    Sets an action's image
.DESCRIPTION
    Sets a dynamic image for an action.
.NOTES
    The StreamDeck api only allow for a static image to be provided.
    If an animated .gif is provided, only it's first frame will be used.
#>
param(
# The path to the image
[string]
$ImagePath
)

$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setTitle.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    Context = $this.Context
    ImagePath = $ImagePath
} -Path $exportPath
