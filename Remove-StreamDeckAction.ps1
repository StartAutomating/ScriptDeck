function Remove-StreamDeckAction
{
    <#
    .Synopsis
        Removes a StreamDeckAction
    .Description
        Removes a StreamDeckAction from a plugin or a profile.        
    #>
    param(
    # The path to a StreamDeck profile.
    [Parameter(Mandatory,ParameterSetName='Profile',ValueFromPipelineByPropertyName)]
    [string]
    $ProfilePath,

    # The row of actions that will be removed.  Can contain wildcards or regular expressions.
    [Parameter(ParameterSetName='Profile',ValueFromPipelineByPropertyName,ValueFromPipeline)]    
    [string]
    $Row,

    # The column of actions that will be removed.  Can contain wildcards or regular expressions.
    [Parameter(ParameterSetName='Profile',ValueFromPipelineByPropertyName,ValueFromPipeline)]    
    [string]
    $Column,

    # The path to a StreamDeck plugin
    [Parameter(Mandatory,ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $PluginPath,

    # The name of the action being removed from the plugin.
    [Parameter(Mandatory,ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $Name
    )

    process {
        if ($PSCmdlet.ParameterSetName -eq 'Profile') {
            $FoundProfile = Get-StreamDeckProfile -ProfileRoot $ProfilePath
            if (-not $FoundProfile) {
                Write-Error "No Profile found at '$profilePath'"
                return
            }
            if ($PSCmdlet.ShouldProcess("Remove Action at $row, $column")) {            
                $FoundProfile.RemoveAction($Row, $Column)
            }
            return
        }

        if ($PSCmdlet.ParameterSetName -EQ 'Plugin') {
            
            $pluginFound = Get-StreamDeckPlugin -PluginPath $PluginPath
            if (-not $pluginFound) {
                Write-Error "No Plugin found beneath '$pluginPath'"
                return
            }

            
            $currentPlugin = Get-Content -LiteralPath $pluginFound.PluginPath -Raw | ConvertFrom-Json
            $actionExists  = $currentPlugin.actions | Where-Object Name -eq $Name
            
            if ($actionExists) {
                $currentPlugin.actions = @($currentPlugin.actions | Where-Object Name -NE $Name)
                if ($PSCmdlet.ShouldProcess("Update Plugin $($PluginPath)")) {
                    $currentPlugin | ConvertTo-Json -Depth 100 | Set-content -LiteralPath $pluginFound.PluginPath.Raw
                }
            }                        
        }
    }    
}
