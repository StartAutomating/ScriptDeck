Get-StreamDeckPlugin
--------------------
### Synopsis
Gets Stream Deck Plugins

---
### Description

Gets plugins for StreamDeck.

---
### Related Links
* [New-StreamDeckAction](New-StreamDeckAction.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-StreamDeckPlugin
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
If -Template is provided, will look for Plugin Templates beneath -PluginPath.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Template**

If set, will get plugin template scripts.
PluginTemplates are defined in *.StreamDeckPluginTemplate.ps1 files.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Outputs
* StreamDeck.Plugin




---
### Syntax
```PowerShell
Get-StreamDeckPlugin [-Name <String>] [-UUID <String>] [-Force] [-PluginPath <String>] [<CommonParameters>]
```
```PowerShell
Get-StreamDeckPlugin [-Name <String>] [-Force] [-PluginPath <String>] [-Template] [<CommonParameters>]
```
---
