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






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|



---
#### **UUID**

The action UUID






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



---
#### **Force**

If set, will rebuild the cache of streamdeck actions.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



---
### Outputs
* StreamDeck.PluginAction




---
### Syntax
```PowerShell
Get-StreamDeckAction [[-Name] <String>] [[-UUID] <String>] [-Force] [<CommonParameters>]
```
---
