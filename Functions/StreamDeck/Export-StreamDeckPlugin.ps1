function Export-StreamDeckPlugin
{
    <#
    .Synopsis
        Exports Stream Deck Plugins
    .Description
        Exports one or more Stream Deck plguins
    .Link
        Get-StreamDeckPlugin
    .Example        
        Export-StreamDeckPlugin -PluginPath (Get-Module ScriptDeck | Split-Path | Join-Path -ChildPath "ScriptDeck.sdPlugin")
    #>
    [OutputType([IO.FileInfo])]
    param(
    # The path of the plugin
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $PluginPath,

    # The output path for the profile.
    # If the output path is not provided, profiles will be backed up to $home
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $OutputPath,

    # If set, will overwrite an existing export of the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force
    )

    begin {
        $distroToolUrlRoot = 'https://developer.elgato.com/documentation/stream-deck/distributiontool'
        if (-not $DistributionToolRoot) {
            
            $DistributionToolRoot = 
                if ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    $distroToolUrl =  "$distroToolUrlRoot/DistributionToolWindows.zip"
                    Join-Path "$env:AppData\Elgato\StreamDeck\" -ChildPath Tools
                    
                    
                } elseif ($PSVersionTable.Platform -eq 'Unix') {
                    $distroToolUrl =  "$distroToolUrlRoot/DistributionToolMac.zip"
                    if ($PSVersionTable.OS -like '*darwin*' -and -not $env:GITHUB_WORKSPACE) {
                        Join-Path "~/Library/Application Support/com.elgato.StreamDeck/StreamDeck" -ChildPath Tools
                    } elseif ($env:GITHUB_WORKSPACE) {
                        Join-Path $env:GITHUB_WORKSPACE -ChildPath elgago | Join-Path -ChildPath Tools
                    } else {
                        Join-Path $home  -ChildPath elgato | Join-Path -ChildPath Tools
                    }
                }
        }
        if (-not $DistributionToolRoot) {
            Write-Error -Message "Could not locate an appropriate root for the distribution tool"
            return
        }

        if (-not (Test-Path $DistributionToolRoot)) {
            New-Item -ItemType Directory -Path $DistributionToolRoot -Force
        }
        
        if (-not ('IO.Compression.ZipFile' -as [type])) {
            Add-Type -AssemblyName System.IO.Compression.Filesystem
        }

        $distroToolExe = 
            Get-ChildItem -Path $DistributionToolRoot -ErrorAction SilentlyContinue -Filter DistributionTool* | Sort-Object Length | Select-Object -First 1

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        if (-not $distroToolExe) {
            $distroZipPath = Split-Path $DistributionToolRoot |
                Join-Path -ChildPath "DistributionTool.zip"
            if ($env:GITHUB_WORKSPACE) {
                "Attempting to download $distroToolUrl to $distroZipPath" | Out-Host
            }
            Invoke-WebRequest -Uri $distroToolUrl | 
                Select-Object -ExpandProperty Content |
                Set-Content -Path $distroZipPath -AsByteStream
            
            [IO.Compression.ZipFile]::ExtractToDirectory("$distroZipPath", "$DistributionToolRoot")
            $distroToolExe = 
                Get-ChildItem -Path $DistributionToolRoot -ErrorAction SilentlyContinue -Filter DistributionTool* | Sort-Object Length | Select-Object -First 1
        }            
    }

    process {
        $splat = @{PluginPath=$PluginPath}
        $sdplugins = @(Get-StreamDeckPlugin @splat)
        if (-not $OutputPath) {
            $OutputPath = $sdplugins | Select-Object -ExpandProperty PluginPath | Split-Path | Split-Path
        }

        #region Export Profiles
        foreach ($sdp in $sdplugins) {
            # $sdpOutputDirectory = Join-Path $outputPath "$($sdp.Name)_sdPlugin" | Join-Path -ChildPath "$($sdp.Name.ToLower()).sdPlugin"
            $sdpOutputPath      = Join-Path $OutputPath "$(($sdp.Name -replace '\s').ToLower()).streamDeckPlugin"            
            $sdPluginRoot = ($sdp.PluginPath | Split-path)
            $sdPluginRootName = $sdPluginRoot | Split-Path -Leaf

            $sdpOutputPath = Join-Path $OutputPath "$($sdPluginRootName -replace '\.sdPlugin$').streamDeckPlugin"
            if ((Test-Path $sdpOutputPath)) {
                if (-not $Force) { continue }                
                Remove-Item -Path $sdpOutputPath
            }

            $sdPluginRoot = ($sdp.PluginPath | Split-path)
            $movedFiles = Get-ChildItem -Path $sdPluginRoot -Filter *.ps1.json |
                Move-Item -Destination ($sdPluginRoot | Split-Path) -PassThru -Force
            
            $hasPs1Files = Get-ChildItem -Path $sdPluginRoot -Recurse -Filter *.ps1
            if ($hasPs1Files) {
                Get-Command Send-StreamDeck, Receive-StreamDeck, Watch-StreamDeck |
                    ForEach-Object {
                        $cmd = $_
                        $scriptFile = [IO.FileInfo]$_.ScriptBlock.File                    
                        if ($env:GITHUB_WORKSPACE) {
                            "Copying Latest $cmd to $sdPluginRoot" | Out-Host
                        }
                        Copy-Item $scriptFile.FullName (Join-Path $sdPluginRoot "$($cmd.Name).ps1")
                    }
            }

            $lines = & $distroToolExe.Fullname -b -i $sdPluginRoot -o $OutputPath 
            if ($env:GITHUB_WORKSPACE) {
                "Distribution Tool Has Completed (output below)" | Out-Host
                $lines | Out-Host
            }
            $hadErrorLines = $false
            foreach ($line in $lines) {
                Write-Verbose "$line"                    
                if ($line -like '*Error:*') {
                    $useless, $useful = $line -split 'Error\:\s{0,}'
                    $hadErrorLines = $true
                    Write-Error -Message $useful
                }
            }

            if (-not $LASTEXITCODE) {
                if ($env:GITHUB_WORKSPACE) {
                    "Plugin files found:" | Out-Host
                    Get-ChildItem -Filter *.streamDeckPlugin | select name | Out-Host
                    "SdpOutputPath $sdpOutputPath" | Out-Host
                    Get-ChildItem -Path $OutputPath -Recurse | 
                        Where-Object Name -like '*.sdplugin' |
                        Select-Object -ExpandProperty Fullname |
                        Out-Host
                }

                Get-Item -LiteralPath ($sdpOutputPath -replace '\.streamDeckPlugin', '.sdPlugin')
            }

            if ($movedFiles) {
                $movedFiles | Move-Item -Path { $_.Fullname } -Destination { 
                    Join-Path $sdPluginRoot $_.Name
                }
            }
        }
        #endregion Export Profiles
    }
}

