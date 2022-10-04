function Add-StreamDeckAction
{
    <#
    .Synopsis
        Adds StreamDeck Action to Plugins.
    .Description
        Adds a StreamDeck Action to a Plugin
    .Example
        Add-StreamDeckAction -PluginPath .\MyPlugin.sdPlugin -Name MyPluginAction -Tooltip "Just the tip" -PropertyInspectorPath .\MyPropertyInspector.html
    .Link
        Get-StreamDeckAction
    .Link
        Get-StreamDeckPlugin
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The path to a StreamDeck plugin
    [Parameter(Mandatory,ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $PluginPath,

    # The name of the action being added to the plugin.
    [Parameter(Mandatory,ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The tooltip for the plugin action.
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $Tooltip,

    # The UUID for the plugin action.
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $UUID,

    # The icon for the plugin action.
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $Icon,

    # One or more states for the plugin action.
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [Alias('States')]
    [PSObject[]]
    $State,

    # The relative path to the property inspector for the plugin action.
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]    
    [string]
    $PropertyInspectorPath,

    # If not explicitly set to false, the plugin action will be supported within MultiActions
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]    
    [switch]
    $SupportedInMultiAction = $true
    )

    process {        
        $pluginFound = Get-StreamDeckPlugin -PluginPath $PluginPath
        if (-not $pluginFound) {
            Write-Error "No Plugin found beneath '$pluginPath'"
            return
        }

        if (-not $PSBoundParameters['UUID']) {
            $uuid = $PSBoundParameters['UUID'] = $pluginFound.Name + '.' + $PSBoundParameters['Name']
        }
        $paramCopy = [Ordered]@{} + $PSBoundParameters
        $paramCopy.Remove('PluginPath')

            
        $currentPlugin = Get-Content -LiteralPath $pluginFound.PluginPath -Raw | ConvertFrom-Json
        $actionExists  = $currentPlugin.actions | Where-Object UUID -eq $UUID
        $currentPlugin.actions =
            if ($actionExists) {
                @($currentPlugin.actions | Where-Object UUID -NE $UUID) + [PSCustomObject]$paramCopy
            } else {
                @() + $currentPlugin.actions + [PSCustomObject]$paramCopy
            }

        if ($PSCmdlet.ShouldProcess("Update Plugin $($PluginPath)")) {
            $currentPlugin | ConvertTo-Json -Depth 100 | Set-content -LiteralPath $pluginFound.PluginPath
        }
    }
}
