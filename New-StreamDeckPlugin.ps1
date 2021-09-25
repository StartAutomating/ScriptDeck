function New-StreamDeckPlugin
{
    <#
    .Synopsis
        Creates a StreamDeck Plugin 
    .Description
        Creates a new StreamDeck Plugin.
    .Link
        https://developer.elgato.com/documentation/stream-deck/sdk/manifest/
    .Link
        Get-StreamDeckPlugin
    #>
    param(
    # The name of the plugin. This string is displayed to the user in the Stream Deck store.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The author of the plugin. This string is displayed to the user in the Stream Deck store.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Author,

    # Specifies an array of actions. A plugin can indeed have one or multiple actions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        $validPropertyNames = 'Icon','Name','PropertyInspectorPath','States','SupportedInMultiActions','Tooltip'
        foreach ($prop in $_.psobject.properties) {
            
            if ($prop.name -notin $validPropertyNames) {
                throw "$($prop.Name) is not allowed.  Valid properties are:  $($validPropertyNames -join ' , ')"
            }
        }
    })]
    [Alias('Actions')]
    [PSObject[]]
    $Action,

    # Provides a general description of what the plugin does.
    # This is displayed to the user in the Stream Deck store.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Description,

    # The version of the plugin which can only contain digits and periods. This is used for the software update mechanism.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Version]
    $Version = "0.1",

    # The relative path to a PNG image without the .png extension. 
    # This image is displayed in the Plugin Store window.
    # The PNG image should be a 72pt x 72pt image. 
    # You should provide @1x and @2x versions of the image.
    # The Stream Deck application takes care of loading the appropriate version of the image.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [string]
    $Icon,

    # The name of the custom category in which the actions should be listed.
    # This string is visible to the user in the actions list.
    # If you don't provide a category, the actions will appear inside a "Custom" category.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Category,

    # The relative path to a PNG image without the .png extension.
    # This image is used in the actions list.
    # The PNG image should be a 28pt x 28pt image.
    # You should provide @1x and @2x versions of the image.
    # The Stream Deck application takes care of loading the appropriate version of the image.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $CategoryIcon,

    # The relative path to the HTML/binary file containing the code of the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $CodePath,

    # Override CodePath for Windows.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $CodePathWin,

    # Override CodePath for macOS.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $CodePathMac,

    # The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
    # If missing, the plugin will have an empty Property Inspector.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PropertyInspectorPath,

    # Specify the default window size when a Javascript plugin or Property Inspector opens a window using window.open().
    # Default value is [500, 650].
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $DefaultWindowSize,

    # The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $OS,

    # Indicates which version of the Stream Deck application is required to install the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if (-not $_.MinimumVersion) {
            throw "Must have minimum version"
        }
    })]
    [PSObject]
    $Software = @{MinimumVersion='4.1'},

    # A URL displayed to the user if he wants to get more info about the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uri]
    $Url,

    # List of application identifiers to monitor (applications launched or terminated).
    # See the applicationDidLaunch and applicationDidTerminate events.
    [Parameter(ValueFromPipelineByPropertyName)]
    [ValidateScript({
        if ($_ -is [Collections.IDictionary]) {
            foreach ($k in $_.keys) {
                if ($k -cnotin 'mac', 'windows') {
                    throw "Property names must be 'mac' or 'windows'"
                }
                if ($_[$k] -isnot [Object[]]) {
                    throw "Property values must be an array"
                }
            }
        } else {
            foreach ($prop in $_.psobject.properties) {
                if ($prop.Name -cnotin 'mac', 'windows') {
                    throw "Property names must be 'mac' or 'windows'"
                }
                if ($prop.Value -isnot [Object[]]) {
                    throw "Property values must be an array"
                }
            }
        }
        return $true
    })]
    [PSObject]
    $ApplicationsToMonitor,

    # Specifies an array of profiles.
    # A plugin can indeed have one or multiple profiles that are proposed to the user on installation.
    # This lets you create fullscreen plugins.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $Profiles,

    # The output path.  
    # If not provided, the plugin will be created in a directory beneath the current directory.
    # This directory will be named $Name.sdPlugin.
    [string]
    $OutputPath
    )

    process {
        # Create the manifest template.
        $pluginManifest = 
            [Ordered]@{
                Name        = $Name
                Version     = "$Version"
                Description = $Description
                Actions     = $Action
                Author      = $Author
                SDKVersion  = 2
                Software    = $Software
            }

        $generateScript = $false
        if (-not $CodePath) {
            $CodePath = "StartPlugin.cmd"
        }

        :nextParam foreach ($param in (
                    [Management.Automation.CommandMetaData]$MyInvocation.MyCommand
                ).Parameters.GetEnumerator()
        ) {
            if ($pluginManifest.Keys -contains $param.Key) { continue }
            foreach ($k in $pluginManifest.Keys) {
                if ($param.Value.Aliases -and $param.Value.Aliases -contains $k) {
                    continue nextParam
                }
            }
            $ParamVar = $ExecutionContext.SessionState.PSVariable.Get($param.Key)
            if ($ParamVar.Value -ne $null) {
                $pluginManifest[$param.Key] = $ParamVar.Value
            }
        }

        # Clear out any blank values from the manifest
        foreach ($k in @($pluginManifest.Keys)) {
            if (-not $pluginManifest[$k]) {
                $pluginManifest.Remove($k)
            }
        }

        # Remove the output path from the manifest 
        # (it will end up there as a side-effect of the previous code, and it's not a part of the 'schema')
        $pluginManifest.Remove('OutputPath')

        if (-not $OutputPath) {
            $OutputPath = Join-Path $pwd "$Name.sdPlugin"
        }
        if (-not (Test-Path $OutputPath)) {
            $createdDirectory = New-Item -ItemType Directory -Path $OutputPath
            if (-not $createdDirectory) { return }
        }
        $pluginManifestPath = Join-Path $OutputPath manifest.json
        $pluginManifest | ConvertTo-Json | Set-Content -Path $pluginManifestPath
        Get-Item $pluginManifestPath
    }
}
