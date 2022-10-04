if (-not $this.Path) { throw "Cannot save profile, as it has no path" }

<#$streamdeckprocess = Get-Process streamdeck -ErrorAction SilentlyContinue
$streamDeckPath    = "$($streamdeckprocess.Path)"
if ($streamDeckPath) { 
    Start-Process -FilePath $streamDeckPath -ArgumentList '--quit' -Wait
}#>
#$streamdeckprocess | Stop-Process

foreach ($action in $this.Actions.psobject.properties) {
    $stateIndex = 0
    $actionImagePath  = $this.Path | 
        Split-Path | 
        Join-Path -ChildPath $action.Name |
        Join-Path -ChildPath CustomImages

    if ($action.value.uuid -in 'com.elgato.streamdeck.page.next', 'com.elgato.streamdeck.profile.openchild') {
        
        if ($action.value.settings.pstypenames -contains 'StreamDeck.Profile') {
            $childPluginPath = $action.value.settings.guid
            $root = $(if ($this.IsChild) {
                $this.Parent
            } else {
                $this
            })
            $childRoot = $root | 
                Split-Path | 
                Join-Path -ChildPath Profiles | 
                Join-Path -ChildPath "$($action.value.settings.guid).sdProfile" |
                Join-Path -ChildPath "manifest.json"
            
            $childPlugin = $action.value.settings | Add-Member NoteProperty Path "$childRoot" -Force -PassThru
            $childPlugin.Save()
            $action.value.settings = [PSCustomObject]@{ProfileUUID=$childPlugin.guid}
        }
    }
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
$scriptPropertyNames = $this.psobject.properties | Where-Object MemberType -EQ ScriptProperty | Select-Object -ExpandProperty Name -Unique
$excludedProperties = @('Path','GUID') + $scriptPropertyNames

if (-not (Test-Path $this.Path)) {
    $createdProfile = New-Item -ItemType File -Path $this.Path -Force
}

$this |
    Select-Object -Property * -ExcludeProperty $excludedProperties| 
    ConvertTo-Json -Depth 100 | 
    Set-Content -literalPath $this.Path -Encoding UTF8
<<<<<<< Updated upstream
<#
if ($streamDeckPath) {    
    $streamdeckprocess = Get-Process streamdeck -ErrorAction SilentlyContinue
    Register-ObjectEvent -InputObject $streamdeckProcess -EventName Exited -Action ([ScriptBlock]::Create(@"
Write-Verbose 'Process Exited, Starting a new one'
Start-Process '$($streamdeckprocess.Path)'
"@)) |Out-Null        
    Start-Sleep -Seconds 2
    Write-Verbose "Starting $streamDeckNewPath"
    Start-Process $streamDeckNewPath -PassThru 2>&1    
=======

if ($streamDeckPath) {
    for ($tries =0; $tries -lt 3; $tries++) {
        $streamdeckprocess = Get-Process streamdeck
        if (-not $streamdeckprocess) {break }
        Start-Sleep -Milliseconds 250
    }
    Start-Process $streamDeckPath
>>>>>>> Stashed changes
}
#>