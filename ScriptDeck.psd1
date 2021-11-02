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
* Adding Support for Folders and Pages (#7)
* Support for Plugin Authoring (#8)
'@
        }
    }
}