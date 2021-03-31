$streamdeckprocess = Get-Process streamdeck
$streamDeckPath    = "$($streamdeckprocess.Path)"
$streamdeckprocess | Stop-Process

foreach ($action in $this.Actions.psobject.properties) {
    $stateIndex = 0
    $actionImagePath  = $this.Path | 
        Split-Path | 
        Join-Path -ChildPath $action.Name |
        Join-Path -ChildPath CustomImages
    foreach ($state in $action.value.states) {
        
        if ($state.Image) {
            if ($state.Image -match '^http(?:s)?://') {
                $imageUri = [uri]$state.Image
                $fileName = $imageUri.Segments[-1]
                
                $destinationPath  =  Join-Path $actionImagePath $fileName
                if (-not (Test-Path $destinationPath)) {
                    $null = New-Item -ItemType File -Path $destinationPath -Force
                }
                [Net.Webclient]::new().DownloadFile($imageUri, $destinationPath)
                $state.image = $fileName
            }
            elseif ($state.Image.Contains([IO.Path]::DirectorySeparatorChar) -and 
                -not $state.Image.ToLower().StartsWith($this.Path.ToLower)
            ) {
                $resolvedImagePath  = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($state.Image)
                if (-not $resolvedImagePath) {
                    Write-Warning "Could not update image for $($action.Name)"
                    continue
                }
                $fileName = [IO.Path]::GetFileName("$resolvedImagePath")
                $destinationPath  =  Join-Path $actionImagePath $fileName
                if (-not (Test-Path $destinationPath)) {
                    $null = New-Item -ItemType File -Path $destinationPath -Force
                }
                Copy-Item -Path $resolvedImagePath -Destination $destinationPath -Force
                $state.Image = $fileName
            }
        }
        $stateIndex++
    }
}
$this |
    Select-Object -Property * -ExcludeProperty Path, GUID | 
    ConvertTo-Json -Depth 100 | 
    Set-Content -literalPath $this.Path -Encoding UTF8

if ($streamDeckPath) {
    Start-Process $streamDeckPath
}
