Export-StreamDeckProfile
------------------------
### Synopsis
Exports Stream Deck Profile

---
### Description

Exports one or more Stream Deck profiles

---
### Related Links
* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Export-StreamDeckProfile
```

---
### Parameters
#### **Name**

The name of the profile



> **Type**: ```[String]```

> **Required**: false

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
### Outputs
* [IO.FileInfo](https://learn.microsoft.com/en-us/dotnet/api/System.IO.FileInfo)




---
### Syntax
```PowerShell
Export-StreamDeckProfile [[-Name] <String>] [[-OutputPath] <String>] [<CommonParameters>]
```
---
