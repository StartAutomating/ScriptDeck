
ScriptDeck [0.1]
================

PowerShell Tools for Elgato StreamDeck
----------------

### Commands
---------------------------
|  Verb|Noun              |
|-----:|:-----------------|
|Export|-StreamDeckProfile|
|   Get|-StreamDeckAction |
|      |-StreamDeckPlugin |
|      |-StreamDeckProfile|
|Import|-StreamDeckProfile|
|   New|-StreamDeckAction |
|      |-StreamDeckProfile|
|Remove|-StreamDeckProfile|
|  Save|-StreamDeckProfile|
---------------------------
ScriptDeck is a PowerShell module to help you work with Elgato StreamDeck devices.

Currently, you can use ScriptDeck to create and manage profiles and actions.

~~~PowerShell
Get-StreamDeckProfile # Gets StreamDeck Profiles

Get-StreamDeckPlugin  # Gets StreamDeck Plugins

Get-StreamDeckAction  # Gets actions available
~~~


You can create actions with New-StreamDeckAction:

~~~PowerShell
New-StreamDeckAction -HotKey "CTRL+V" -Title "Paste" 

New-StreamDeckAction -ProfileName "Default Profile" -Title '^'

New-StreamDeckAction -Uri https://github.com/ -Title GitHub

New-StreamDeckAction -ScriptBlock {
    foreach ($n in 1..10) {
        $n
        Start-Sleep -Seconds $n
    }
}
~~~ 


You can create profiles with New-StreamDeckProfile, and Save them with Save-StreamDeckProfile.

~~~PowerShell
New-StreamDeckProfile -Name NewProfile -Action @{
    "0,0" = New-StreamDeckAction -ProfileName "Default Profile" -Title '^'
    "1,0" = New-StreamDeckAction -ScriptBlock {
        foreach ($n in 1..10) {
            $n
            Start-Sleep -Seconds $n
        }
    } -Title "1..10"
    "2,0" = New-StreamDeckAction -Uri https://github.com/ -Title GitHub -Image https://github.githubassets.com/images/icons/emoji/octocat.png?v8
} |
    Save-StreamDeckProfile
~~~


Want the module to do something more?  Feel free to open an issue on GitHub.



