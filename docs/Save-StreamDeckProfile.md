Save-StreamDeckProfile
----------------------
### Synopsis
Saves StreamDeck Profiles

---
### Description

Saves StreamDeck Profiles and restarts any running StreamDeck instances.

---
### Related Links
* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)



* [New-StreamDeckProfile](New-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-StreamDeckProfile -Name TestProfile -Action @{
    New-StreamDeckAction -Uri https://github.com/StartAutomating/ScriptDeck -Title ScriptDeck
} |
    Save-StreamDeckProfile
```

---
### Parameters
#### **StreamDeckProfile**

The StreamDeckProfile.
Returned from Get-StreamDeckProfile or New-StreamDeckProfile.






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|true    |1       |true (ByValue)|



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
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)




---
### Syntax
```PowerShell
Save-StreamDeckProfile [-StreamDeckProfile] <PSObject> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
