<#
.SYNOPSIS
    Sets an Action's Image to SVG
.DESCRIPTION
    Sets an Action's Image to inline SVG.
.NOTES
    StreamDeck does not currently support advanced SVG features.
#>
param(
$SvgContent
)


if ($svgContent -is [xml] -or $SvgContent -is [xml.xmlelement]) {
    $SvgContent = $SvgContent.OuterXml
}

$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setImage.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    EventName = 'setImage'
    Context = $this.Context
    Payload = @{
        "image" = "data:image/svg+xml;charset=utf8,$SvgContent"
    }
} -Path $exportPath
