Get-StreamDeckAction
--------------------
### Synopsis
Gets Actions for StreamDeck

---
### Description

Gets available actions for StreamDeck

---
### Related Links
* [Get-StreamDeckPlugin](Get-StreamDeckPlugin.md)



* [New-StreamDeckAction](New-StreamDeckAction.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-StreamDeckAction
```

---
### Parameters
#### **Name**

The name of the action



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **UUID**

The action UUID



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will rebuild the cache of streamdeck actions.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* StreamDeck.PluginAction




---
### Syntax
```PowerShell
Get-StreamDeckAction [[-Name] <String>] [[-UUID] <String>] [-Force] [<CommonParameters>]
```
---
