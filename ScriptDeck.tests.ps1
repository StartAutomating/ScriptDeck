#requires -Module ScriptDeck
#requires -Module Pester
describe ScriptDeck {
    context ProfileActions {
        it 'Creates actions that open a -URI' {
            $action = New-StreamDeckAction -Title GitHub -Uri https://github.com/
            $action.settings.path | should -Be https://github.com/
        }
        it 'Create actions that press a -HotKey' {
            $action = New-StreamDeckAction -HotKey "CTRL+V"
            $action.settings.hotkeys[0].KeyCtrl | should -Be $true
            $action.settings.hotkeys[0].VKeyCode | should -Be ([int][char]'V')
        }
    }
    context Plugins {
        it 'Can create and update plugins' {
            $tmpPath = if ($env:TEMP) { $env:TEMP } else { '/tmp' }
            $tmpPath = Join-Path $tmpPath (Get-Random)
            New-Item -ItemType Directory -Path $tmpPath
            Push-Location -Path $tmpPath
            $newPlugin = New-StreamDeckPlugin -Name MyTestPlugin -Author Me -Description "A brief description" -Icon NoIcon.png  -Template WindowsPowerShell -OutputPath $tmpPath            
            Update-StreamDeckPlugin -PluginPath $tmpPath -AutoIncrement Patch
            Get-StreamDeckPlugin -PluginPath $tmpPath | Select-Object -ExpandProperty Version | Should -Be '0.1.1'
            Update-StreamDeckPlugin -PluginPath MyTestPlugin.sdPlugin -AutoIncrement Minor
            Get-StreamDeckPlugin -PluginPath $tmpPath | Select-Object -ExpandProperty Version | Should -Be '0.2'
            Update-StreamDeckPlugin -PluginPath MyTestPlugin.sdPlugin -AutoIncrement Major
            Get-StreamDeckPlugin -PluginPath $tmpPath | Select-Object -ExpandProperty Version | Should -Be '1.0'
            Pop-Location
            Remove-Item -Path $tmpPath -Recurse -Force
        }   
    }
}
