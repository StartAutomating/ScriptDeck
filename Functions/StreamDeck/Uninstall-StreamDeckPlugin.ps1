
function Uninstall-StreamDeckPlugin
{
    <#
    .SYNOPSIS
        Uninstalls StreamDeck Plugins
    .DESCRIPTION
        Uninstalls StreamDeck Plugins.
        
        StreamDeck must not be running when this command is run.
    .EXAMPLE
        Uninstall-StreamDeckPlugin ScriptDeck
    .EXAMPLE
        Uninstall-StreamDeckPlugin WindowsScriptDeck
    .LINK
        Stop-StreamDeck
    .LINK
        Install-StreamDeckPlugin
    #>
    [CmdletBinding(SupportsShouldProcess, ConfirmImpact='High')]
    param(
    # The name of the plugin
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The Plugin UUID
    [Parameter(ParameterSetName='Plugin',ValueFromPipelineByPropertyName)]
    [string]
    $UUID,

    # If set, will rebuild the cache of streamdeck plugins.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force,

    # The path to a plugin or a directory containing plugins.    
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $PluginPath
    )

    begin {
        $getStreamDeckPlugin = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Get-StreamDeckPlugin', 'Function')
    }

    process {
        $myParams  = [Ordered]@{} + $PSBoundParameters
        
        $getStreamDeckParams = [Ordered]@{}
        foreach ($param in $getStreamDeckPlugin.Parameters.Keys) {
            if ($myParams.Contains($param)) {
                $getStreamDeckParams[$param] = $myParams[$param]
            }
        }
        $pluginFound = Get-StreamDeckPlugin @getStreamDeckParams
        
        if ($pluginFound) {
            $pluginFound |
                Select-Object -ExpandProperty PluginPath | 
                Split-Path |
                Remove-Item -Recurse -Force
            if ($?) {
                [PSCustomObject]@{
                    PSTypeName = 'StreamDeck.Plugin.Uninstall'
                    Uninstalled = $myParams
                }
            }
        } else {
            Write-Warning "Could not find plugin: $([PSCustomObject]$getStreamDeckParams)"
        }

        
    }
}