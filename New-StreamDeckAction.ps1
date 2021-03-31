function New-StreamDeckAction
{
    <#
    .Synopsis
        Creates a StreamDeck action
    .Description
        Creates a StreamDeck action, to be used as part of a profile.
    .Example
        New-StreamDeckAction -HotKey "CTRL+F4" -Title "Close"
    .Example
        New-StreamDeckAction -Uri https://github.com/ -Title "GitHub" 
    .Link
        Get-StreamDeckAction
    #>
    [OutputType('StreamDeck.Action')]
    param(
    # The name of the plugin.
    [Parameter(Mandatory,ParameterSetName='PluginName',ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # The StreamDeck Plugin UUID.
    [Parameter(ParameterSetName='PluginName',ValueFromPipelineByPropertyName)]
    [string]
    $UUID,

    # A sequence of hotkeys
    [Parameter(Mandatory,ParameterSetName='Hotkey',ValueFromPipelineByPropertyName)]
    [string[]]
    $HotKey,

    # A URI.
    [Parameter(Mandatory,ParameterSetName='OpenUri',ValueFromPipelineByPropertyName)]
    [alias('Url')]
    [uri]
    $Uri,

    # A PowerShell ScriptBlock.
    # Currently, this will run using pwsh by default, and use -WindowsPowerShell if provided.
    [Parameter(Mandatory,ParameterSetName='ScriptBlock',ValueFromPipelineByPropertyName)]
    [ScriptBlock]
    $ScriptBlock,

    # If set, will run the ScriptBlock in Windows PowerShell.
    # By default, will run the Scriptblock in PowerShell core.
    # This option is obviously not supported on MacOS.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $WindowsPowerShell,

    # The path to an application.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='ApplicationPath')]
    [string]
    $ApplicationPath,

    # The text that should be automatically typed
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='Text')]
    [string]
    $Text,

    # If set, will send an enter key after typing the text.
    [Parameter(ValueFromPipelineByPropertyName,ParameterSetName='Text')]
    [Alias('Enter','Return', 'SendReturn')]
    [switch]
    $SendEnter,

    # The settings passed to the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Settings')]
    [PSObject]
    $Setting = @{},

    # The title of the action
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Title,

    # The image used for the action
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Image,

    # The font size
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FSize')]
    [string]
    $FontSize,

    # The font family
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FFamily')]
    [string]
    $FontFamily,

    # If set, will underline the action title
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('FontUnderline')]
    [switch]
    $Underline,

    # The possible states of the plugin.
    [Parameter(ValueFromPipelineByPropertyName)]
    [PSObject[]]
    $States = @(),

    # The state index.
    [Parameter(ValueFromPipelineByPropertyName)]
    [uint32]
    $State = 0,

    # If set, will not show a title.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $HideTitle
    )

    begin {
        $streamDeckActions = Get-StreamDeckAction

    }

    process {
            switch ($PSCmdlet.ParameterSetName) {
                PluginName {
                    if (-not $UUID) {
                        $uuid = $streamDeckActions | Where-Object Name -EQ $name | Select-Object -ExpandProperty UUID
                        if (-not $uuid) {
                            Write-Warning "Could not find UUID for Name '$name', assuming com.elgato.streamdeck.system.$name"
                            $uuid = "com.elgato.streamdeck.system.$name"
                        }
                    }


                    $matchingPlugin =
                        $streamDeckActions | Where-Object UUID -EQ $UUID
                    $uuid = $matchingPlugin.uuid
                }
                OpenURI {
                    $name = 'Website'
                    $uuid = 'com.elgato.streamdeck.system.website'
                    $Setting = [Ordered]@{
                        openInBrowser = $true
                        path = $Uri
                    }
                }
                ApplicationPath {
                    $name = 'open'
                    $uuid = 'com.elgato.streamdeck.system.open'
                    $Setting = [Ordered]@{
                        openInBrowser =  $true
                        path = $ApplicationPath
                    }
                }
                Text {
                    $name ='text'
                    $uuid = 'com.elgato.streamdeck.system.text'
                    $setting = @{
                        isSendingEnter = ($Newline -as [bool])
                        pastedText = $Text
                    }
                }
                HotKey {
                    $name = 'HotKey'
                    $uuid = 'com.elgato.streamdeck.system.hotkey'
                    $HotKeyRegex = [Regex]::new(@'
(?<Modifier>
    (?>
        (?<Control>Control|Ctrl|LeftCtrl|RightCtrl)
        |
        (?<Command>Command|Cmd|LeftCmd|RightCmd|Windows|Win|Apple|OpenApple)
        |
        (?<Alt>Option|Alt|LeftAlt|RightAlt)
        |
        (?<Shift>Shift|LeftShift|RightShift)
    )
\+){0,3}
(?<Key>.+$)
'@, 'IgnoreCase,IgnorePatternWhitespace')
                    $Setting =
                        [Ordered]@{
                            Hotkeys = @(
                                foreach ($hot in $HotKey) {
                                    $matched =  $HotKeyRegex.Match($Hot)

                                    $keyCmd = $matched.Groups["Command"].Success
                                    $keyControl = $matched.Groups["Control"].Success
                                    $keyOption = $matched.Groups["Alt"].Success
                                    $keyShift = $matched.Groups["Shift"].Success
                                    $modifiers = 0

                                    if ($keyShift) { $modifiers = $modifiers -bor 1 }
                                    if ($keyControl) { $modifiers = $modifiers -bor 2 }
                                    if ($keyOption ) { $modifiers = $modifiers -bor 4 }
                                    if ($keyCmd) { $modifiers = $modifiers -bor 8 }
                                    $nativeCode = $vKey = $qtKey =
                                        if ($matched.Groups["Key"].Length -eq 1) {
                                            # Easy mode, turn the key into a char to get the v-key
                                            [char]$matched.Groups["Key"].Value
                                        } else {
                                            # lookup table time.
                                            $matchedKey = $matched.Groups["Key"].Value
                                            switch -Regex ($matchedKey)  {
                                                'F(?>[1-2][0-9]|[0-9])' { # F1-F24
                                                    [int]($matchedKey -replace 'F') + 0x6f
                                                }
                                                '(?>#|Num|NumPad)[0-9]' { # Numpad
                                                    [int]($matchedKey -replace '\D') + 0x60
                                                }
                                                'Back|Backspace' {
                                                    0x8
                                                }
                                                Tab { 0x9 }
                                                Clear { 0xc }
                                                End {0x23}
                                                Home {0x24}
                                                Left {0x25}
                                                Up { 0x26}
                                                Right { 0x27}
                                                Down { 0x28}
                                                Select { 0x29}
                                                Print { 0x2a}
                                                Execute { 0x2b}
                                                'Insert|Ins' { 0x2d}
                                                'Delete|Del' { 0x2e}
                                                Help { 0x2f}
                                                'Space|Spacebar|\s' { 0x20}
                                                'Prior|PageUp' {0x21}
                                                'Next|PageDown' {0x22}
                                                'Enter|Return' { 0xd}
                                                'Caps|CapsLock' { 0x14}
                                                'Kana|Hangul|Hanguel'{ 0x15}
                                                'Junja' { 0x17}
                                                'Final' { 0x18}
                                                'Hanja|Kanji' {0x19}
                                                Sleep {0x5f}
                                                Multiply { 0x6a}
                                                Add { 0x6b}
                                                Subtract { 0x6d}
                                                Decimal { 0x6e}
                                                Divide { 0x6f}
                                                'Num|NumLock' {0x90}
                                                BrowserBack {0xa6}
                                                BrowserForward {0xa7}
                                                BrowserRefresh {0xa8}
                                                BrowserStop {0xa9}
                                                BrowserSearch { 0xaa}
                                                BrowserHome {0xac}
                                                'Mute|VolumeMute|MediaMute' {0xad}
                                                'VolumeDown|MediaDown' {0xae}
                                                'VolumeUp|MediaUp' {0xaf}
                                                'NextTrack|MediaNextTrack' { 0xb0}
                                                'PreviousTrack|MediaPreviousTrack' { 0xb1}
                                                'Stop|MediaStop' { 0xb2 }
                                                'Play|Pause|MediaPlayPause|TogglePlay' {0xb3}
                                                'Mail|LaunchMail' {0xb4}
                                                '\+|Plus|OEMPlus' {0xbb}
                                                ',|Comma|OEMComma' {0xbc}
                                                '\-|Minus|OEMMinus' {0xbd}
                                                '\.|Period|OEMPeriod' {0xbe}
                                            }
                                        }

                                    if (-not $nativeCode) { Write-Error "Could not map key code for HotKey '$hot'"; return}

                                    [PSCustomObject][Ordered]@{
                                        KeyCmd = $keyCmd
                                        KeyCtrl = $keyControl
                                        KeyModifiers = $modifiers
                                        KeyOption = $keyOption
                                        KeyShift = $keyShift
                                        NativeCode = $nativeCode -as [int]
                                        QTKeyCode = $qtKey -as [int]
                                        VKeyCode = $vKey -as [int]
                                    }
                                }
                                [PSCustomObject][Ordered]@{
                                    KeyCmd = $false
                                    KeyCtrl = $false
                                    KeyModifiers = 0
                                    KeyOption = $false
                                    KeyShift = $false
                                    NativeCode = 146
                                    QTKeyCode = 33554431
                                    VKeyCode = -1
                                }
                            )
                        }
                }

                ScriptBlock {
                    $name = 'Open'
                    $uuid = 'com.elgato.streamdeck.system.open'

                    $cmdSequence =
                        @(
                        if ($WindowsPowerShell) {
                            'powershell'
                        }
                        else {
                            'pwsh'
                        }
                        '-noprofile'
                        '-nologo'
                        '-encodedCommand'
                        [Convert]::ToBase64String($OutputEncoding.GetBytes("$ScriptBlock"))
                        ) -join ' '

                    if (-not $cmdPath) {
                        Write-Error "Could not find PowerShell/pwsh in the path"
                        return
                    }

                    $Setting = [Ordered]@{
                        openInBrowser = $true
                        path = $cmdSequence
                    }


                }
            }


        if (-not $States) {
            $States =
                @(if ($matchingPlugin.states) {
                    foreach ($s in $matchingPlugin.states) {
                        $sc = [Ordered]@{}
                        foreach ($p in $s.psobject.properties) {
                            $sc[$p.Name] = $p.Value
                        }
                        [PSCustomObject]$sc
                    }
                } else {
                    [PSCustomObject][Ordered]@{
                        FFamily= $fontFamily
                        FSize = $fontSize
                        FUnderline = $Underline -as [bool]
                        Image = $Image
                        Title = $title
                        TitleAlignment = $titleAlignment
                        TitleColor = $titleColor
                        TitleShow = (-not $HideTitle)
                    }
                })
        }
        foreach ($s in $States) {
            if ($Image) { $s | Add-Member NoteProperty Image $Image -Force }
            if ($Title) { $s | Add-Member NoteProperty Title $Title -Force }
            if ($FontSize) { $s | Add-Member NotePropety FSize $FontSize -Force}
            if ($Underline) { $s | Add-Member NotePropety FUnderline ($Underline -as [bool]) -Force }
            if ($FontFamily) { $s | Add-Member NoteProperty FFamily $FontFamily -Force}
            if ($titleColor) { $s | Add-Member NoteProperty TitleColor $titleColor -Force }
            if ($titleAlignment) { $s | Add-Member NoteProperty TitleAlignment $titleAlignment -Force }
            if ($HideTitle) { $s | Add-Member TitleShow (-not $HideTitle) -Force  }
        }


        [PSCustomobject]([Ordered]@{
            Name = $Name
            UUID = $UUID
            States = @($States)
            State = $State
            Settings = $Setting
            PSTypeName = 'StreamDeck.Action'
        })
    }
}

