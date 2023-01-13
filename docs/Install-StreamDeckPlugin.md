Install-StreamDeckPlugin
------------------------
### Synopsis
Installs a Stream Deck Plugin

---
### Description

Installs a Stream Deck Plugin.  This copies the files in the plugin directory to the

---
### Related Links
* [Get-StreamDeckPlugin](Get-StreamDeckPlugin.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Install-StreamDeckPlugin -SourcePath .\ScriptDeck.sdPlugin
```

---
### Parameters
#### **SourcePath**

The source path.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|



---
#### **DestinationPath**

The destination path.  This will usually be automatically detected based off of the operating system.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



---
#### **PassThru**

If set, will display the files copied.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Syntax
```PowerShell
Install-StreamDeckPlugin [-SourcePath] <String> [[-DestinationPath] <String>] [-PassThru] [<CommonParameters>]
```
---
