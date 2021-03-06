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
                    if ($PSVersionTable.OS -like '*darwin*') {
                        Join-Path "~/Library/Application Support/elgato/StreamDeck" -ChildPath Tools
                    } elseif ($env:GITHUB_WORKSPACE) {
                        Join-Path '/tmp' | Join-Path -ChildPath elgago | Join-Path Tools
                    } else {
                        Join-Path $home | Join-Path -ChildPath elgago | Join-Path Tools
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

        if (-not $distroToolExe) {
            $distroZipPath = Split-Path $DistributionToolRoot | Join-Path -ChildPath ([uri]$distroToolUrlRoot).Segments[-1]
            [Net.WebClient]::new().DownloadFile($distroToolUrl, "$distroZipPath")
            [IO.Compression.ZipFile]::ExtractToDirectory("$distroZipPath", "$DistributionToolRoot")
            $distroToolExe = 
                Get-ChildItem -Path $DistributionToolRoot -ErrorAction SilentlyContinue -Filter DistributionTool* | Sort-Object Length | Select-Object -First 1
        }            
    }

    process {
        $splat = @{PluginPath=$PluginPath}
        $sdplugins = @(Get-StreamDeckPlugin @splat)
        if (-not $OutputPath) {
            $OutputPath = $home
        }

        #region Export Profiles
        foreach ($sdp in $sdplugins) {
            # $sdpOutputDirectory = Join-Path $outputPath "$($sdp.Name)_sdPlugin" | Join-Path -ChildPath "$($sdp.Name.ToLower()).sdPlugin"
            $sdpOutputPath      = Join-Path $OutputPath "$($sdp.Name).streamDeckPlugin"
            if ((Test-Path $sdpOutputPath)) {
                if (-not $Force) { continue }                
                Remove-Item -Path $sdpOutputPath
            }            

            $lines = & $distroToolExe.Fullname -b -i ($sdp.PluginPath | Split-path) -o $OutputPath 
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
                Get-Item -LiteralPath $sdpOutputPath
            }
        }
        #endregion Export Profiles
    }
}

