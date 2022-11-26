function Install-StreamDeckPlugin
{
    <#
    .Synopsis
        Installs a Stream Deck Plugin
    .Description
        Installs a Stream Deck Plugin.  This copies the files in the plugin directory to the 
    .Example
        Install-StreamDeckPlugin -SourcePath .\ScriptDeck.sdPlugin
    .Link
        Get-StreamDeckPlugin
    #>
    param(
    # The source path.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]
    $SourcePath,

    # The destination path.  This will usually be automatically detected based off of the operating system.
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string]
    $DestinationPath,

    # If set, will display the files copied.
    [switch]
    $PassThru
    )

    process {
                
        if (-not $DestinationPath) { # If no -DestinationPath was provided
            $DestinationPath = 
                if ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    # use AppData if it's windows
                    "$env:AppData\Elgato\StreamDeck\Plugins\"
                } elseif ($PSVersionTable.Platform -eq 'Unix') {                    
                    # or the library if it is a Mac
                    "~/Library/Application Support/com.elgato.StreamDeck/Plugins"
                }

            if (-not $DestinationPath) { # If we could not determine the -DestinationPath
                Write-Error "Could not determine -DestinationPath." -ErrorId StreamDeck.Destination.Missing 
                return # error out.
            }
        }

        # If we couldn't resolve the destination
        $resolvedDestinationPath =
            $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($DestinationPath)
        if (-not $resolvedDestinationPath) { return } # error out.
        # If we couldn't resolve the source
        $resolvedSourcePath      =
            $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($SourcePath)
        if (-not $resolvedSourcePath) { return } # error out.


        # Find the source item
        $sourcePathItem = $sourceFileInfo = Get-Item $resolvedSourcePath

        if ($sourcePathItem -is [IO.FileInfo]) { # If it is a file
            if ($sourcePathItem.Extension -notin '.zip', '.streamDeckPlugin') { # it must be a .zip or .streamDeckPlugin
                Write-Error "If -SourcePath is a file, it must be a .streamDeckPlugin or .zip file" -ErrorId StreamDeck.Plugin.Incorrect.Format
                return
            }
            # Find where temp is
            $tmpPathRoot   = if ($env:TEMP) { $env:TEMP } else { "/tmp" }
            # Create a temporary directory
            $sourceTempDir = Join-Path $tmpPathRoot $sourcePathItem.Name.Replace($sourcePathItem.Extension, '')
            if (Test-Path $sourceTempDir) { # If it already existed
                Remove-Item -Recurse -Force $sourceTempDir # clean it.
                if (-not $?) { return } # (if that didn't work, error out)
            }
            # Extract the plugin to that directory
            [IO.Compression.ZipFile]::ExtractToDirectory($sourcePathItem.fullname, $sourceTempDir)
           
            # Get ready to call yourself
            $MySplat = @{} + $PSBoundParameters
            $MySplat.Remove('SourcePath')
            # determine if the manifest is at root
            $manifestAtRoot = Get-ChildItem -Path $sourceTempDir -File -Filter manifest.json
            if (-not $manifestAtRoot) { # If it is not, install any plugin subdirectories
                Get-ChildItem -Path $sourceTempDir -Directory | Install-StreamDeckPlugin @MySplat
            } else { # If it is, install just this subdirectory.
                Install-StreamDeckPlugin @MySplat -sourcePath $manifestAtRoot.Directory
            }
            # clean out the temporary files.
            Remove-Item $sourceTempDir -Recurse -Force
            return
        }

        if ($sourcePathItem -isnot [IO.DirectoryInfo]) { # If the source path item was not a directory
            Write-Error "-SourcePath must be a directory or a plugin file" -ErrorId StreamDeck.Plugin.Not.Directory
            return # error out.
        }

        # Determine the destination path
        $DestinationPathLeaf = $resolvedDestinationPath | Split-Path -Leaf

        if ($DestinationPathLeaf -notlike '*.sdPlugin') { # If it's not already a .sdPlugin directory
            $destinationName = # determine the right .sdPlugin path
                if ($sourcePathItem.Extension) {
                    $sourcePathItem.Name.Replace("$($sourcePathItem.Extension)",'') + '.sdPlugin'
                } else {
                    ($sourcePathItem.Name -replace '\.sdPlugin$') + '.sdPlugin'
                }
            $newDestPath  = Join-Path $resolvedDestinationPath $destinationName 
            if (-not (Test-Path $newDestPath)) {
                $createdDirectory = New-Item -ItemType Directory -Path $newDestPath 
                if (-not $createdDirectory) {
                    Write-Error "Could not create plugin directory: '$newDestPath'"
                    return
                }
            }
            $resolvedDestinationPath = $newDestPath
        }

       
        # Get all of the files from source, recursively.
        $pluginFiles = @(Get-ChildItem $sourcePathItem -Recurse)
        $c, $t = 0, $pluginFiles.Length
        $progressId  = Get-Random
        foreach ($pluginFile in $pluginFiles) {
            # determine it's relative path,        
            $relativePath = $pluginFile.FullName.Substring($sourcePathItem.FullName.Length) -replace '^[\\/]'
            $newPath = Join-Path $resolvedDestinationPath $relativePath
            $null = 
                try {
                    # create the directory structure with New-Item -Force,
                    New-Item -ItemType $(
                        if ($pluginFile -is [IO.FileInfo]){
                            'File'
                        } else {
                            'Directory'
                        }
                    ) -Path $newPath -Force
                } catch {
                    $_
                }
            $c++
            $p = [Math]::Min(100, $c * 100 / $t)
            # and copy the file.
            Write-Progress "Copying" "$newPath" -PercentComplete $p -Id $progressId
            if ($pluginFile -is [IO.FileInfo]) {
                Copy-Item -Path $pluginFile.Fullname -Destination $newPath -Force -PassThru:$PassThru
            }
        }

        Write-Progress "Copying" "Done" -Completed -Id $progressId
    }
}
