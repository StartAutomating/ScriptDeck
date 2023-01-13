Update-StreamDeckProfile
------------------------
### Synopsis
Updates a StreamDeck profile

---
### Description

Updates a StreamDeck profile

---
### Related Links
* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)



* [Remove-StreamDeckProfile](Remove-StreamDeckProfile.md)



* [Save-StreamDeckProfile](Save-StreamDeckProfile.md)



* [New-StreamDeckProfile](New-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
$vsCodeProfile = Get-StreamDeckProfile -Name VSCode
$defaultProfile = Get-streamDeckProfile -Name "Default Profile" |
    Where-Object DeviceName -eq StreamDeckXL
```
Update-StreamDeckProfile -Name VSCode -Action @{
    "0,0" =
        New-StreamDeckAction -ProfileName $defaultProfile.Guid -DeviceUUID $defaultProfile.DeviceUUID -Image C:\Users\JamesBrundage\Pictures\Gif\CountryHome.gif

    "0,1" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "issues:github.focus"
        } -name "Execute Command" -Title ("GitHub", "Issues" -join [Environment]::newline)
    "0,2" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
            command = "git pull"
        } -name "Execute Command" -Title ("git", "pull" -join [Environment]::newline)    
    "0,3" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
            command = "git push"
        } -name "Execute Command" -Title ("git", "push" -join [Environment]::newline)
    "0,4" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
            command = "git status"
        } -name "Execute Command" -Title ("git", "status" -join [Environment]::newline)
        
    "0,6" = 
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.debug.viewlet.action.removeAllBreakpoints"
        } -name "Execute Command" -Title ("Remove","All", "Breakpoints" -join [Environment]::newline)
    
    "0,7" = 
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.action.closeAllEditors"
        } -name "Execute Command" -Title "Close All"


    "1,0" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.action.toggleSidebarVisibility"
        } -name "Execute Command" -Title ("toggle", "sidebar" -join [Environment]::newline)
    "1,7" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.files.action.focusFilesExplorer"
        } -name "Execute Command" -Title "Files"
    
    "2,0" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.action.toggleScreencastMode"
        } -name "Execute Command" -Title "ScreenCast"
        
    "2,7" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.files.action.collapseExplorerFolders"
        } -name "Execute Command" -Title ("collapse", "folders" -join [Environment]::newline)
    "3,0" = 
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.action.toggleZenMode"
        } -name "Execute Command" -Title "zen"
    "3,1" =
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "workbench.action.toggleEditorVisibility"
        } -name "Execute Command" -Title ("toggle", "editor" -join [Environment]::newline)
    
    "3,7" = 
        New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
            command = "editor.action.formatDocument"
        } -name "Execute Command" -Title "format"
        
    "7,3" = $null
}
---
### Parameters
#### **Name**

The name of the profile






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|



---
#### **Action**

A collection of actions.






|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|true    |2       |true (ByPropertyName)|



---
#### **ProfileUUID**

The profile UUID.  If not provided, a GUID will be generated.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|



---
#### **DeviceType**




|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |4       |false        |



---
### Outputs
* StreamDeck.Profile




---
### Syntax
```PowerShell
Update-StreamDeckProfile [[-Name] <String>] [-Action] <IDictionary> [[-ProfileUUID] <String>] [[-DeviceType] <String>] [<CommonParameters>]
```
---
