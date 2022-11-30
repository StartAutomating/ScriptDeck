
<div align='center'>
<img src='Assets/ScriptDeck.svg' />
<h2>Supercharge your StreamDeck with PowerShell</h2>
</div>

ScriptDeck is:

* A set of StreamDeck Plugins for PowerShell
* A PowerShell module to help you work with deck devices (StreamDeck and LoupeDeck)
* A GitHub action that helps you prepare Elgato StreamDeck plugins for publication.

### ScriptDeck and WindowsScriptDeck (the plugins)

ScriptDeck and WindowsScriptDeck are a pair of plugins that let your StreamDeck run PowerShell Core and Windows PowerShell, respectively.

Both plugins let you run any command at the touch of a button.

The PowerShell engine stays running and responsive, ready for your next press.

Using the plugins, you can:

* Run any PowerShell command from any module
* Watch a path 
* Populate the clipboard with a script's output, then paste the content
* Open as many URLs as a script returns.
* Start any Process with any verb (Run as Admin, Print, Edit)
* Launch PowerShell in a new window

Two variations of the ScriptDeck plugin can be downloaded:

|Plugin|Description|OS|
|-|-|-|
|[ScriptDeck](https://apps.elgato.com/plugins/com.start-automating.scriptdeck)|ScriptDeck running on PowerShell Core|MacOS/Windows|
|[WindowsScriptDeck](https://apps.elgato.com/plugins/com.start-automating.windowsscriptdeck)|ScriptDeck running on Windows PowerShell|Windows|

### ScriptDeck (the PowerShell Module)

Currently, you can use ScriptDeck to:

* Create and Manage StreamDeck Profiles and Actions.
* Create or Update StreamDeck Plugins
* Start, Stop, and Restart the StreamDeck Application

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