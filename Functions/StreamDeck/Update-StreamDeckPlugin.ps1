function Update-StreamDeckPlugin
{
    <#
    .Synopsis
        Updates a StreamDeck Plugin
    .Description
        Updates a StreamDeck Plugin
    .Link
        Get-StreamDeckPlugin
    .Example
        Update-StreamDeckPlugin -PluginPath .\MyPlugin -Name "MyPluginName" -Author "MyPluginAuthor" -Description "MyPluginDescription"
    .Example
        Get-StreamDeckPlugin -Name MyStreamDeckPlugin | # Get the plugin named MyStreamDeckPlugin 
            Update-StreamDeckPlugin -IncrementVersion Minor # Increment the minor version of the plugin.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The path to the streamdeck plugin.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $PluginPath,

    # The name of the plugin. This string is displayed to the user in the Stream Deck store.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The author of the plugin. This string is displayed to the user in the Stream Deck store.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Author,

    # Provides a general description of what the plugin does.
    # This is displayed to the user in the Stream Deck store.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # The version of the plugin which can only contain digits and periods. This is used for the software update mechanism.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Version]
    $Version,

    # If provided, will auto-increment the version of the extension.
    # * Major increments the major version ( 1.0   -> 2.0  )
    # * Minor increments the minor version ( 0.1   -> 0.2  )
    # * Patch increments the patch version ( 0.0.1 -> 0.0.2)
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateSet('Major','Minor','Patch')]
    [string]
    $AutoIncrement
    )

    process {
        # Find what's at the -PluginPath
        $pluginPathItem = Get-item -Path $PluginPath -ErrorAction SilentlyContinue
        if (-not $pluginPathItem) {
            # (error out if nothing's there).
            Write-Error "No Plugin path found at '$pluginPath'" -ErrorId PluginPath.Missing 
            return
        } elseif ($pluginPathItem -is [IO.DirectoryInfo]) {
            # If the -PluginPath was a directory, find manifest.json
            $manifestPath = Join-Path $pluginPathItem.FullName 'manifest.json'
            if (-not (Test-Path $manifestPath)) { 
                # (error out if we don't find it)
                Write-Error "No Plugin manifest found beneath '$manifestPath'" -ErrorId PluginManifestPath.Missing
                return
            }
            $pluginPathItem = Get-Item $manifestPath
        }

        # If whatever plugin path we have is not manifest.json,
        if ($pluginPathItem.Name -ne 'manifest.json') {
            # then error out.
            Write-Error "PluginPath '$($pluginPathItem.fullname)' is not manifest.json" -ErrorId PluginManifest.Missing
            return
        }

        # Load the plugin as JSON 
        $pluginManifestJson = Get-Content $pluginPathItem.FullName -Raw | ConvertFrom-Json
        $changed = $false # and track when it changes

        #region Handle Name, Author, and Description Changes
        if ($Name -and $Name -ne $pluginManifestJson.name) {
            $pluginManifestJson.name = $Name
            $changed = $true
        }

        if ($Description -and $Description -ne $pluginManifestJson.description) {
            $pluginManifestJson.description = $Description
            $changed = $true
        }

        if ($Author -and $Author -ne $pluginManifestJson.author) {
            $pluginManifestJson.author = $Author
            $changed = $true
        }
        #endregion Handle Name, Author, and Description Changes

        #region Handle Version Changes
        if (-not $AutoIncrement -and 
            $Version -and $Version -ne $pluginManifestJson.version) {
            $pluginManifestJson.version = $Version
            $changed = $true
        } elseif ($AutoIncrement -and $pluginManifestJson.version) {
            $Version = if ($pluginManifestJson.version) { $pluginManifestJson.version } else { '0.0' }
            if ($AutoIncrement -eq 'Major') {
                $Version = "$([Math]::Max($Version.Major,0) + 1).0"
            }
            elseif ($AutoIncrement -eq 'Minor') {
                $Version = "$($Version.Major).$([Math]::Max($Version.Minor,0) + 1)"
            }
            elseif ($AutoIncrement -eq 'Patch') {
                $Version = "$($Version.Major).$([Math]::Max($Version.Minor,0)).$([Math]::Max($Version.Build,0) + 1)"
            }
            $pluginManifestJson.version = "$Version"
            $changed = $true
        }
        #endregion Handle Version Changes

        # If -WhatIf was passed
        if ($WhatIfPreference) {
            return $pluginManifestJson # return the JSON, but don't set it.
        }
        # If changes were made, check .ShouldProcess.
        if ($changed -and $PSCmdlet.ShouldProcess("Update $($pluginPathItem.FullName)")) {
            $pluginManifestJson | # If we should process this item,
                ConvertTo-Json  | # make the manifest JSON again,
                Set-Content -Path $pluginPathItem.FullName -Encoding UTF8 # and then write it to disk.
        }
    }
}
