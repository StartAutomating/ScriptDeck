function Get-StreamDeckAction
{
    <#
    .Synopsis
        Gets Actions for StreamDeck
    .Description
        Gets available actions for StreamDeck
    .Example
        Get-StreamDeckAction
    .Link
        Get-StreamDeckPlugin
    .Link
        New-StreamDeckAction
    #>
    param(
    # The name of the action
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The action UUID
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $UUID,

    # If set, will rebuild the cache of streamdeck actions.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force
    )    

    process {
        $plugins = Get-StreamDeckPlugin -Force:$Force
        if ($force -or -not $Script:CachedStreamDeckActions) {
            $Script:CachedStreamDeckActions =
                @(foreach ($plug in $plugins) {            
                    foreach ($act in $plug.Actions) {
                        $act.pstypenames.clear()
                        $act.pstypenames.add('StreamDeck.PluginAction')
                        $act
                    }
                })
        }
        
        if (-not ($Name -or $UUID)) {
            $Script:CachedStreamDeckActions
        } else {
            $Script:CachedStreamDeckActions | 
                Where-Object {
                    if ($UUID -and ($_.UUID -notlike $UUID)) { return} 
                    if ($Name -and ($_.Name -notlike $Name)) { return}
                    return $true
                }
        }
    }
}
