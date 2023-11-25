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
> EXAMPLE 1

```PowerShell
Export-StreamDeckPlugin -PluginPath (Get-Module ScriptDeck | Split-Path | Join-Path -ChildPath "ScriptDeck.sdPlugin")
```

---

### Parameters
#### **PluginPath**
The path of the plugin

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|true    |1       |true (ByPropertyName)|Fullname|

#### **OutputPath**
The output path for the profile.
If the output path is not provided, profiles will be backed up to $home

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Force**
If set, will overwrite an existing export of the plugin.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Outputs
* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)

---

### Syntax
```PowerShell
Export-StreamDeckPlugin [-PluginPath] <String> [[-OutputPath] <String>] [-Force] [<CommonParameters>]
```
