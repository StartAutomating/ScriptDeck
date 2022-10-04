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
    [OutputType('StreamDeck.PluginAction')]
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
        #region Cache Plugins
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
        #endregion Cache Plugins

        #region Return Matching Plugins
        if (-not ($Name -or $UUID)) {
            $Script:CachedStreamDeckActions
        } else {
            foreach ($_ in $Script:CachedStreamDeckActions) {
                if ($UUID -and ($_.UUID -notlike $UUID)) { continue }
                if ($Name -and ($_.Name -notlike $Name)) { continue}
                $_
            }
        }
        #region Return Matching Plugins
    }
}
