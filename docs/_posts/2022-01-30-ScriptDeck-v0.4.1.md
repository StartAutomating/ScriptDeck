---

title: ScriptDeck v0.4.1
sourceURL: https://github.com/StartAutomating/ScriptDeck/releases/tag/v0.4.1
tag: release
---
0.4.1
---
Bugfixes:
* Add-StreamDeckAction -ProfileName now works. ([#10](https://github.com/StartAutomating/ScriptDeck/issues/10))
* Fixing rows/column when adding actions to a profile ([#11](https://github.com/StartAutomating/ScriptDeck/issues/11))

Initial ScriptDeck GitHub action support ([#12](https://github.com/StartAutomating/ScriptDeck/issues/12))

0.4
---
## New Commands:
* Add-StreamDeckProfile (enables adding commands to existing profiles)
* Add-StreamDeckAction (adds actions to a plugin (related to [#8](https://github.com/StartAutomating/ScriptDeck/issues/8)))
* Clear-StreamDeckProfile (enables clearing of rows, columns, or UUIDs in existing profiles)
* Export-StreamDeckPlugin ( publishes plugin using deploymentTool)
* Remove-StreamDeckAction (remove actions from a plugin (related to [#8](https://github.com/StartAutomating/ScriptDeck/issues/8)))
* Send-StreamDeck ( send WebSocket messages to a StreamDeck (re: [#8](https://github.com/StartAutomating/ScriptDeck/issues/8)))
* Receive-StreamDeck ( receive WebSocket messages from a StreamDeck (re: [#8](https://github.com/StartAutomating/ScriptDeck/issues/8)))

### Updated Commands:
* New-StreamDeckAction: Adding -ChildProfile, -NextPage, -PreviousPage, -BackToParent (re: [#7](https://github.com/StartAutomating/ScriptDeck/issues/7))
* New-StreamDeckProfile:  Adding -IsChildProfile, -IsNextPage, -ProfileRoot (re: [#7](https://github.com/StartAutomating/ScriptDeck/issues/7))
* Save-StreamDeckProfile: No longer automatically restarting after a save.
* Stop-StreamDeck: Fixing bug when -PassThru was not passed.
