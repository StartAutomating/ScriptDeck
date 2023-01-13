Get-StreamDeckPlugin
--------------------
### Synopsis
Gets Stream Deck Plugins

---
### Description

Gets plugins for StreamDeck.

---
### Related Links
* [Install-StreamDeckPlugin](Install-StreamDeckPlugin.md)



* [New-StreamDeckPlugin](New-StreamDeckPlugin.md)



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






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



---
#### **UUID**

The Plugin UUID






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



---
#### **Force**

If set, will rebuild the cache of streamdeck plugins.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



---
#### **PluginPath**

The path to a plugin or a directory containing plugins.
If -Template is provided, will look for Plugin Templates beneath -PluginPath.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



---
#### **Template**

If set, will get plugin template scripts.
PluginTemplates are defined in *.StreamDeckPluginTemplate.ps1 files.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



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
