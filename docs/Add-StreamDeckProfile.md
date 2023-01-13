Add-StreamDeckProfile
---------------------
### Synopsis
Adds StreamDeck Actions to profiles.

---
### Description

Adds a StreamDeck action to a profile.

---
### Related Links
* [New-StreamDeckAction](New-StreamDeckAction.md)



* [Get-StreamDeckAction](Get-StreamDeckAction.md)



* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
@(
    New-StreamDeckAction -Title "Select Next Line" -HotKey "SHIFT+DOWN"
    New-StreamDeckAction -Title "Select Prev Line" -HotKey "SHIFT+UP"
)  |            
    Add-StreamDeckProfile -ProfileName ISE_XL
```

---
### Parameters
#### **ProfileName**

The name of one or more profiles






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|true    |named   |false        |



---
#### **ProfileRoot**

The root directory to look for profiles.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |



---
#### **Row**

The row the action will be added to.  If a negative number is provided, will choose the first available row.






|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|



---
#### **Column**

The column the action will be added to.  If a negative number is provided, will choose the first available column.






|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|



---
#### **Action**

The action to add to a StreamDeck profile.  
This is created using New-StreamDeckAction.






|Type        |Required|Position|PipelineInput                 |
|------------|--------|--------|------------------------------|
|`[PSObject]`|true    |named   |true (ByValue, ByPropertyName)|



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Syntax
```PowerShell
Add-StreamDeckProfile -ProfileName <String[]> [-ProfileRoot <String>] [-Row <Int32>] [-Column <Int32>] -Action <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
