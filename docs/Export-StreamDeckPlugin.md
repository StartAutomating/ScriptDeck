Export-StreamDeckPlugin
-----------------------
### Synopsis
Exports Stream Deck Plugins

---
### Description

Exports one or more Stream Deck plguins

---
### Related Links
* [Get-StreamDeckPlugin](Get-StreamDeckPlugin.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Export-StreamDeckPlugin -PluginPath (Get-Module ScriptDeck | Split-Path | Join-Path -ChildPath "ScriptDeck.sdPlugin")
```

---
### Parameters
#### **PluginPath**

The path of the plugin



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **OutputPath**

The output path for the profile.
If the output path is not provided, profiles will be backed up to $home



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Force**

If set, will overwrite an existing export of the plugin.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)




---
### Syntax
```PowerShell
Export-StreamDeckPlugin [-PluginPath] <String> [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```
---
