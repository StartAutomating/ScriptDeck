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



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **DestinationPath**

The destination path.  This will usually be automatically detected based off of the operating system.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will display the files copied.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Install-StreamDeckPlugin [-SourcePath] <String> [[-DestinationPath] <String>] [-PassThru] [<CommonParameters>]
```
---
