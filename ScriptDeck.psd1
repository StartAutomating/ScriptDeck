@{
    Description = "PowerShell Tools for Elgato StreamDeck"
    ModuleVersion = '0.4'
    RootModule = 'ScriptDeck.psm1'
    TypesToProcess = 'ScriptDeck.types.ps1xml'
    FormatsToProcess = 'ScriptDeck.format.ps1xml'
    Copyright = '2021 Start-Automating'
    Author = 'James Brundage'
    Guid = '88ab43b5-d77a-4aa1-aabd-3fc6236b1b56'
    PrivateData = @{
        PSData = @{
            ProjectURI = 'https://github.com/StartAutomating/ScriptDeck'
            LicenseURI = 'https://github.com/StartAutomating/ScriptDeck/blob/main/LICENSE'            

            ReleaseNotes = @'
0.4
---
## New Commands:
* Add-StreamDeckProfile (enables adding commands to existing profiles)
* Add-StreamDeckAction (adds actions to a plugin (related to #8))
* Clear-StreamDeckProfile (enables clearing of rows, columns, or UUIDs in existing profiles)
* Export-StreamDeckPlugin ( publishes plugin using deploymentTool)
* Remove-StreamDeckAction (remove actions from a plugin (related to #8))
* Send-StreamDeck ( send WebSocket messages to a StreamDeck (re: #8))
* Receive-StreamDeck ( receive WebSocket messages from a StreamDeck (re: #8))

### Updated Commands:
* New-StreamDeckAction: Adding -ChildProfile, -NextPage, -PreviousPage, -BackToParent (re: #7)
* New-StreamDeckProfile:  Adding -IsChildProfile, -IsNextPage, -ProfileRoot (re: #7)
* Save-StreamDeckProfile: No longer automatically restarting after a save.
* Stop-StreamDeck: Fixing bug when -PassThru was not passed.
'@
        }
    }
}