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
}
