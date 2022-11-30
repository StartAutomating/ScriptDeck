Add-StreamDeckAction
--------------------
### Synopsis
Adds StreamDeck Action to Plugins.

---
### Description

Adds a StreamDeck Action to a Plugin

---
### Related Links
* [Get-StreamDeckAction](Get-StreamDeckAction.md)



* [Get-StreamDeckPlugin](Get-StreamDeckPlugin.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Add-StreamDeckAction -PluginPath .\MyPlugin.sdPlugin -Name MyPluginAction -Tooltip "Just the tip" -PropertyInspectorPath .\MyPropertyInspector.html
```

---
### Parameters
#### **PluginPath**

The path to a StreamDeck plugin



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Name**

The name of the action being added to the plugin.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Tooltip**

The tooltip for the plugin action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UUID**

The UUID for the plugin action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Icon**

The icon for the plugin action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **State**

One or more states for the plugin action.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PropertyInspectorPath**

The relative path to the property inspector for the plugin action.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SupportedInMultiAction**

If not explicitly set to false, the plugin action will be supported within MultiActions



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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
Add-StreamDeckAction -PluginPath <String> -Name <String> [-Tooltip <String>] [-UUID <String>] [-Icon <String>] [-State <PSObject[]>] [-PropertyInspectorPath <String>] [-SupportedInMultiAction] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
