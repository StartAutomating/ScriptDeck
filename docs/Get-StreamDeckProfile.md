Get-StreamDeckProfile
---------------------
### Synopsis
Gets StreamDeck Profiles

---
### Description

Gets profiles for the StreamDeck application.

---
### Related Links
* [New-StreamDeckProfile](New-StreamDeckProfile.md)



* [Remove-StreamDeckProfile](Remove-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Get-StreamDeckProfile
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
#### **ProfileRoot**

The profile root



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Recurse**

If set, will get profiles recursively



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
### Outputs
* StreamDeck.Profile




---
### Syntax
```PowerShell
Get-StreamDeckProfile [[-Name] <String>] [[-ProfileRoot] <String>] [-Recurse] [<CommonParameters>]
```
---
