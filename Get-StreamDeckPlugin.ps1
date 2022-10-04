function Get-StreamDeckPlugin
{
    <#
    .Synopsis
        Gets Stream Deck Plugins
    .Description
        Gets plugins for StreamDeck.
    .Example
        Get-StreamDeckPlugin
    .Link
        New-StreamDeckAction
    #>
    [OutputType('StreamDeck.Plugin')]
    [CmdletBinding(DefaultParameterSetName='Plugin')]
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
    # If -Template is provided, will look for Plugin Templates beneath -PluginPath.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PluginPath,

    # If set, will get plugin template scripts.
    # PluginTemplates are defined in *.StreamDeckPluginTemplate.ps1 files.
    [Parameter(ParameterSetName='PluginTemplate')]
    [Alias('PluginTemplate')]
    [switch]
    $Template
    )

    begin {
        filter manifest.json=>[StreamDeck.Plugin] {            
            $inFile = $_            
            try {
                $jsonObject = ConvertFrom-Json ([IO.File]::ReadAllText($inFile.Fullname))
                $jsonObject.pstypenames.clear()
                $jsonObject.pstypenames.add('StreamDeck.Plugin')
                $jsonObject.psobject.properties.add([PSNoteProperty]::new('PluginPath', $inFile.Fullname))
                $jsonObject
            } catch {
                Write-Error -ErrorRecord $_
            }            
        }
        ${?<PluginTemplate>} = 'StreamDeckPluginTemplate\.ps1$'
        filter .ps1=>[StreamDeck.PluginTemplate] {
            $inFile = $_
            $pluginTemplate = $ExecutionContext.SessionState.InvokeCommand.GetCommand($inFile.fullname,'ExternalScript')
            $pluginTemplate.pstypenames.clear()
            $pluginTemplate.pstypenames.add('StreamDeck.PluginTemplate')
            $pluginTemplate
        }
    }

    process {
        if ($PSCmdlet.ParameterSetName -eq 'PluginTemplate') {
            if ($Force -or -not $Script:CachedStreamDeckPluginTemplates) {
                $Script:CachedStreamDeckPluginTemplates = @($MyInvocation.MyCommand.Module |
                    Split-Path | 
                    Get-ChildItem -Filter *.ps1 |
                    Where-Object Name -Match ${?<PluginTemplate>} |
                    .ps1=>[StreamDeck.PluginTemplate])
            }

            $templateList = 
                if (-not $PluginPath) {
                    @() + $Script:CachedStreamDeckPluginTemplates
                } else {
                    @(if ($pluignPath -match ${?<PluginTemplate>}) {
                        Get-ChildItem -Path $pluignPath |
                                .ps1=>[StreamDeck.PluginTemplate]
                    } else {
                        Get-ChildItem -Path $PluginPath -Recurse -Filter *.ps1  |
                            Where-Object Name -Match ${?<PluginTemplate>} |                        
                            .ps1=>[StreamDeck.PluginTemplate]
                    }) 
                }

            if ($name) {
                $templateList | Where-Object { $_.Name -eq $Name -or $_.Name -like "$Name.ps1"}
            } else {
                $templateList
            }
            return
        }
        
        #region Cache StreamDeck Plugins
        if ($force -or -not $Script:CachedStreamDeckPlugins) {
            
            $Script:CachedStreamDeckPlugins = @(
                # On Windows, plugins can be in
                if ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    $sdPluginPath = "$env:AppData\Elgato\StreamDeck\Plugins\"
                    Write-Verbose "Searching for Plugins beneath '$sdPluginPath'"
                    Get-ChildItem -Path $sdPluginPath -Directory | # appdata
                        Get-ChildItem -Filter manifest.json |
                        manifest.json=>[StreamDeck.Plugin]

                    Get-ChildItem -Path "$env:ProgramFiles\Elgato\StreamDeck\plugins" -Directory | # or programfiles
                        Get-ChildItem -Filter manifest.json |
                        manifest.json=>[StreamDeck.Plugin]
                } elseif ($PSVersionTable.Platform -eq 'Unix') {
                    if ($PSVersionTable.OS -like '*darwin*' -and -not $env:GITHUB_WORKSPACE) { # On Mac, plugins can be in
                        Get-ChildItem -Path "~/Library/Application Support/elgato/StreamDeck/Plugins" | # the library
                            Get-ChildItem -Filter manifest.json |
                            manifest.json=>[StreamDeck.Plugin]

                        Get-ChildItem -Path "/Applications/Stream Deck.app/Contents/Plugins" -Directory | # or applications.
                            Get-ChildItem -Filter manifest.json |
                            manifest.json=>[StreamDeck.Plugin]
                    }
                }
            )
        }
        #endregion Cache StreamDeck Plugins
        $pluginList = 
            if (-not $PluginPath) {
                @() + $Script:CachedStreamDeckPlugins
            } else {
                @(if ($pluignPath -match '[\\/]manifest.json$') {
                    Get-ChildItem -Path $pluignPath |
                            manifest.json=>[StreamDeck.Plugin]
                } else {
                    Get-ChildItem -Path $PluginPath -Recurse -Filter manifest.json  |                        
                        manifest.json=>[StreamDeck.Plugin]
                }) 
            }
            


        if ($Name -or $UUID) {
            :nextPlugin foreach ($plugin in $pluginList) {
                if ($plugin.Name -like $name) { $plugin; continue }
                foreach ($act in $plugin.actions) {
                    if ($Name -and $act.Name -like $name) { $plugin; continue nextPlugin}
                    if ($UUID -and $act.uuid -like $UUID) { $plugin; continue nextPlugin}
                }
            }
        }
        else {
            $pluginList
        }
    }
}
