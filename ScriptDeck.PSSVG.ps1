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


$scriptDeckLogoAsSymbol =
    =<svg.symbol> -ViewBox 56,56 -Content @(
        =<svg.circle> -Cx 28 -Cy 28 -R (28*12/14)  -Stroke white -StrokeWidth .5 -Opacity .9    
        $psChevron
        $usePSChevron
    ) -Id ScriptDeckLogo


$windowsScriptDeckRoot = Join-Path $PSScriptRoot 'com.start-automating.windowsscriptdeck.sdPlugin'

if (-not (Test-Path $windowsScriptDeckRoot)) {
    $null = New-Item -ItemType Directory -Path $windowsScriptDeckRoot
}

=<svg> -ViewBox 1280, 640 -Content @(
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth 1.5 -Opacity .9 -Fill '#224488'
        $psChevronWhite
    ) -X 25% -Width 50% -Height 33% -Y 33%

    =<svg.text> -Content "WindowsScriptDeck" -FontSize 48 -X 50% -Y 70% -DominantBaseline 'middle' -TextAnchor 'middle' -FontFamily sans-serif -Fill '#224488'
    =<svg.text> -Content "Supercharge your StreamDeck with Windows PowerShell" -FontSize 36 -X 50% -Y 80% -DominantBaseline 'middle' -TextAnchor 'middle' -FontFamily sans-serif -Fill '#224488'
) -OutputPath (Join-Path $windowsScriptDeckRoot "1-preview.svg")

=<svg> -ViewBox 1280, 640 -Content @(
    =<svg.rect> -Fill white -Width 100% -Height 100%    
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth .5 -Opacity .9 -Fill '#224488'
        $psChevronWhite
    ) -X 10% -Width 10% -Height 10% -Y 10% -Fill '#224488'
    =<svg.text> -Content "WindowsScriptDeck Features" -FontSize 48 -X 20% -Y 16% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill '#224488'
    =<svg.text> -FontSize 24 -Y 30% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill '#224488' -Content @(
        =<svg.tspan> -Content "- Map Any StreamDeck Button to a PowerShell Script" -Dy 0 -X 20%
        =<svg.tspan> -Content "- The PowerShell Engine is always running (so it's nice and responsive)" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Share `$global variables between buttons" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Run any PowerShell command from any module in the gallery" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Paste a Script's Output" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Start any Process" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Open URLs programatically" -X 20% -Dy 2em
    )    
) -OutputPath (Join-Path $windowsScriptDeckRoot "2-preview.svg")

=<svg> -ViewBox 1280, 640 -Content @(    
    =<svg.rect> -Fill white -Width 100% -Height 100%    
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth .5 -Opacity .9 -Fill '#224488'
        $psChevronWhite
    ) -X 10% -Width 10% -Height 10% -Y 10% -Fill '#224488'
    # =<svg.use> -href '#ScriptDeckLogo' 
    =<svg.text> -Content "Windows ScriptDeck Support" -FontSize 48 -X 20% -Y 16% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill '#224488'
    =<svg.text> -FontSize 24 -Y 30% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill '#224488' -Content @(
        =<svg.tspan> -Content "WindowsScriptDeck is open source!" -Dy 0 -X 20%
        =<svg.tspan> -Content "https://github.com/Start-Automating/ScriptDeck" -X 30% -Dy 2em
        =<svg.tspan> -Content "Got a problem?" -X 20% -Dy 2em        
        =<svg.tspan> -Content "please file an issue" -X 30% -Dy 2em        
        =<svg.tspan> -Content "(we'd love to fix it)" -Dy 0em -FontSize 12
        =<svg.tspan> -Content "Want a feature?" -X 20% -Dy 2em        
        =<svg.tspan> -Content "please tell us about it" -X 30% -Dy 2em
        =<svg.tspan> -Content "(ideas are always welcome)" -Dy 0em -FontSize 12
    )    
) -OutputPath (Join-Path $windowsScriptDeckRoot "3-preview.svg")




=<svg> -ViewBox '100','100' -Content @(
    =<svg.circle> -Cx 50 -Cy 50 -R 45 -Fill '#224488' -Stroke white -StrokeWidth .5 -Opacity .9
    $psChevronWhite
) -OutputPath (Join-Path $windowsScriptDeckRoot WindowsScriptDeck.svg)

$ScriptDeckPluginRoot = Join-Path $PSScriptRoot 'com.start-automating.scriptdeck.sdPlugin'

if (-not (Test-Path $ScriptDeckPluginRoot)) {
    $null = New-Item -ItemType Directory -Path $ScriptDeckPluginRoot
}

=<svg> -ViewBox '100','100' -Content @(
    =<svg.circle> -Cx 50 -Cy 50 -R 45 -Fill 'black' -Stroke white -StrokeWidth .5 -Opacity .9
    $psChevronWhite
) -OutputPath (Join-Path $ScriptDeckPluginRoot ScriptDeck.svg)

=<svg> -ViewBox 1280, 640 -Content @(
    =<svg.rect> -Fill black -Width 100% -Height 100%
    
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth 1.5 -Opacity .9 -Fill 'black'
        $psChevronWhite
    ) -X 25% -Width 50% -Height 33% -Y 33%
    # $scriptDeckLogoAsSymbol
    # =<svg.use> -href '#ScriptDeckLogo' -X 25% -Width 50% -Height 33% -Y 33%
    =<svg.text> -Content "ScriptDeck" -FontSize 48 -X 50% -Y 70% -DominantBaseline 'middle' -TextAnchor 'middle' -FontFamily sans-serif -Fill 'white'
    =<svg.text> -Content "Supercharge your StreamDeck with PowerShell" -FontSize 36 -X 50% -Y 80% -DominantBaseline 'middle' -TextAnchor 'middle' -FontFamily sans-serif -Fill 'white'
) -OutputPath (Join-Path $ScriptDeckPluginRoot "1-preview.svg")

=<svg> -ViewBox 1280, 640 -Content @(
    =<svg.rect> -Fill black -Width 100% -Height 100%
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth .5 -Opacity .9 -Fill 'black'
        $psChevronWhite
    ) -X 10% -Width 10% -Height 10% -Y 10% -Fill '#224488'
    =<svg.text> -Content "ScriptDeck Features" -FontSize 48 -X 20% -Y 16% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill 'white'
    =<svg.text> -FontSize 24 -Y 30% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill 'white' -Content @(
        =<svg.tspan> -Content "- Map Any StreamDeck Button to a PowerShell Script" -Dy 0 -X 20%
        =<svg.tspan> -Content "- The PowerShell Engine is always running (so it's nice and responsive)" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Share `$global variables between buttons" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Run any PowerShell command from any module in the gallery" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Paste a Script's Output" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Start any Process" -X 20% -Dy 2em
        =<svg.tspan> -Content "- Open URLs programatically" -X 20% -Dy 2em
    )    
) -OutputPath (Join-Path $ScriptDeckPluginRoot "2-preview.svg")

=<svg> -ViewBox 1280, 640 -Content @(    
    =<svg.rect> -Fill black -Width 100% -Height 100%
    =<svg> -ViewBox 100,100 -Content @(
        =<svg.circle> -Cx 50 -Cy 50 -R 40  -Stroke 'White' -StrokeWidth .5 -Opacity .9 -Fill 'black'
        $psChevronWhite
    ) -X 10% -Width 10% -Height 10% -Y 10% -Fill '#224488'
    =<svg.text> -Content "ScriptDeck Support" -FontSize 48 -X 20% -Y 16% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill 'white'
    =<svg.text> -FontSize 24 -Y 30% -DominantBaseline 'middle' -TextAnchor 'left' -FontFamily sans-serif -Fill 'white' -Content @(
        =<svg.tspan> -Content "ScriptDeck is open source!" -Dy 0 -X 20%
        =<svg.tspan> -Content "https://github.com/Start-Automating/ScriptDeck" -X 30% -Dy 2em
        =<svg.tspan> -Content "Got a problem?" -X 20% -Dy 2em        
        =<svg.tspan> -Content "please file an issue" -X 30% -Dy 2em        
        =<svg.tspan> -Content "(we'd love to fix it)" -Dy 0em -Dx 2em -FontSize 12
        =<svg.tspan> -Content "Want a feature?" -X 20% -Dy 2em        
        =<svg.tspan> -Content "please tell us about it" -X 30% -Dy 2em
        =<svg.tspan> -Content "(ideas are always welcome)" -Dy 0em -FontSize 12 -Dx 2em
    )    
) -OutputPath (Join-Path $ScriptDeckPluginRoot "3-preview.svg")





