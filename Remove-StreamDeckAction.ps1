function Remove-StreamDeckAction
{
    <#
    .Synopsis
        Removes a StreamDeckAction
    .Description
        Removes a StreamDeckAction from a plugin or a profile.        
    #>
    param(    
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
                $currentPlugin | ConvertTo-Json -Depth 100 | Set-content -LiteralPath $pluginFound.PluginPath
            }
        }
    }    
}
