#requires -Module PSSVG

$psChevronPolygonPoints = @(
    "40,20"
    "45,20"
    "60,50"
    "35,80"
    "32.5,80"
    "55,50"
) -join ' '

$psChevronPolygon = 
    =<svg.polygon> -Points $psChevronPolygonPoints

$psChevronWhite = 
    =<svg.polygon> -Points $psChevronPolygonPoints -Fill White -Opacity .8

$psChevron = 
    =<svg.symbol> -Id psChevron -Content @(
        $psChevronPolygon
    ) -ViewBox 100, 100


$usePSChevron =
    =<svg.use> -Href '#psChevron' -Fill 'White' -Opacity .8 -Width 100% -Height 100%

$assetsRoot = Join-Path $PSScriptRoot Assets

if (-not (Test-Path $assetsRoot)) {
    $null = New-Item -ItemType Directory -Path $assetsRoot
}

=<svg> -ViewBox '28','28' -Content @(
    =<svg.circle> -Cx 14 -Cy 14 -R 12 -Fill '#224488' -Stroke white -StrokeWidth .25 -Opacity .9
    $psChevron
    $usePSChevron
) -Style @{"background-color"="#224488"} -OutputPath (Join-Path $assetsRoot ScriptDeck.svg)

=<svg> -ViewBox '56','56' -Content @(
    =<svg.circle> -Cx 28 -Cy 28 -R (28*12/14) -Fill '#224488' -Stroke white -StrokeWidth .5 -Opacity .9    
    $psChevron
    $usePSChevron
) -OutputPath (Join-Path $assetsRoot "ScriptDeck@2x.svg")

$windowsScriptDeckRoot = Join-Path $PSScriptRoot windowsscriptdeck.sdPlugin

if (-not (Test-Path $windowsScriptDeckRoot)) {
    $null = New-Item -ItemType Directory -Path $windowsScriptDeckRoot
}

=<svg> -ViewBox '100','100' -Content @(
    =<svg.circle> -Cx 50 -Cy 50 -R 45 -Fill '#224488' -Stroke white -StrokeWidth .5 -Opacity .9
    $psChevronWhite
) -OutputPath (Join-Path $windowsScriptDeckRoot WindowsScriptDeck.svg)

$ScriptDeckPluginRoot = Join-Path $PSScriptRoot scriptdeck.sdPlugin

if (-not (Test-Path $ScriptDeckPluginRoot)) {
    $null = New-Item -ItemType Directory -Path $ScriptDeckPluginRoot
}

=<svg> -ViewBox '100','100' -Content @(
    =<svg.circle> -Cx 50 -Cy 50 -R 45 -Fill 'black' -Stroke white -StrokeWidth .5 -Opacity .9
    $psChevronWhite
) -OutputPath (Join-Path $ScriptDeckPluginRoot ScriptDeck.svg)





