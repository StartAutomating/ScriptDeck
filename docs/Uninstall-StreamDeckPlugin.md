Uninstall-StreamDeckPlugin
--------------------------
### Synopsis
Uninstalls StreamDeck Plugins

---
### Description

Uninstalls StreamDeck Plugins.

StreamDeck must not be running when this command is run.

---
### Related Links
* [Stop-StreamDeck](Stop-StreamDeck.md)



* [Install-StreamDeckPlugin](Install-StreamDeckPlugin.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Uninstall-StreamDeckPlugin ScriptDeck
```

#### EXAMPLE 2
```PowerShell
Uninstall-StreamDeckPlugin WindowsScriptDeck
```

---
### Parameters
#### **Name**

The name of the plugin



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UUID**

The Plugin UUID



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will rebuild the cache of streamdeck plugins.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PluginPath**

The path to a plugin or a directory containing plugins.



> **Type**: ```[String]```

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
Uninstall-StreamDeckPlugin [-Name <String>] [-UUID <String>] [-Force] [-PluginPath <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
