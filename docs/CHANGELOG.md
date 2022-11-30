## ScriptDeck 0.4.6:

* Plugin Improvements
  * Adding 'WatchPath' action: run code whenever files change.
  * Start-Process StreamDeck Action:  Fixing Multiaction support (Fixes #47)
  * Simplifying plugin structure
* Module Improvements
  * StreamDeck
    * Send-StreamDeck:  Fixing ShowOK event name (Fixes #55)
    * Send-StreamDeck:  Supporting -Title (Fixes #45)
    * Adding Uninstall-StreamDeckPlugin (Fixes #56)
    * Adding Watch-StreamDeck (Fixes #48)
    * Export-StreamDeckPlugin:  Copying Send/Receive/Watch-StreamDeck to plugin
    * Install-StreamDeckPlugin: Fixing Installed Path (Fixes #50)
  * LoupeDeck
    * Adding Start/Stop/Restart-LoupeDeck (Fixes #52)
    * Adding Get-LoupeDeckProfile (Fixes #53)
* GitHub Improvements
  * Cleaning up action (Fixes #58)
  * Using [GitPub](https://github.com/StartAutomating/GitPub) for microblogging (Fixes #57)

---

## ScriptDeck 0.4.5:

* Plugins now Include "Start PowerShell" and "Start PowerShell" (Fixes #41)
* Plugins now load PowerShell profiles (Fixes #39)

---

## ScriptDeck 0.4.4:
* Adding CopyScript to ScriptDeck and WindowsScriptDeck plugins (Fixes #35)
* MacOS ScriptDeck Plugin Fix (Fixes #33, thanks @corbob)
* MacOS Pathing problems resolved (Fixes #32)
* Install-StreamDeckPlugin pathing improvements (Fixes #36)

---


## ScriptDeck 0.4.3:
* Export-StreamDeckPlugin: Fixing plugin name prediction (Fixes #26)
* StreamDeck Plugin Improvements:
  * Adding Preview Images (#28)
  * Plugins clear old logs (#27)
  * StartPlugin.sh no longer contains carriage returns (#29)
  * Plugin names now use Reverse DNS Format (#25)
  * Plugins should be attached to GitHub Release (#30)

---

## ScriptDeck 0.4.2
* Plugins are here!
  * ScriptDeck - Run PowerShell Core using StreamDeck (should run on Mac/Windows)
  * WindowsScriptDeck - Run Windows PowerShell using StreamDeck.  
* Bugfixes:
  * Export-StreamDeckPlugin (Fixes #17 Fixes #18 Fixes #19)
  * Can now use action to export plugins

---

## ScriptDeck 0.4.1
Bugfixes:
* Add-StreamDeckAction -ProfileName now works. (#10)
* Fixing rows/column when adding actions to a profile (#11)

Initial ScriptDeck GitHub action support (#12)

---

## ScriptDeck 0.4
* New Commands:
  * Add-StreamDeckProfile (enables adding commands to existing profiles)
  * Add-StreamDeckAction (adds actions to a plugin (related to #8))
  * Clear-StreamDeckProfile (enables clearing of rows, columns, or UUIDs in existing profiles)
  * Export-StreamDeckPlugin ( publishes plugin using deploymentTool)
  * Remove-StreamDeckAction (remove actions from a plugin (related to #8))
  * Send-StreamDeck ( send WebSocket messages to a StreamDeck (re: #8))
  * Receive-StreamDeck ( receive WebSocket messages from a StreamDeck (re: #8))

* Updated Commands:
  * New-StreamDeckAction: Adding -ChildProfile, -NextPage, -PreviousPage, -BackToParent (re: #7)
  * New-StreamDeckProfile:  Adding -IsChildProfile, -IsNextPage, -ProfileRoot (re: #7)
  * Save-StreamDeckProfile: No longer automatically restarting after a save.
  * Stop-StreamDeck: Fixing bug when -PassThru was not passed.

---
