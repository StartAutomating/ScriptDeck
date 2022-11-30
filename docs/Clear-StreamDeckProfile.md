Clear-StreamDeckProfile
-----------------------
### Synopsis
Clears StreamDeck Profiles

---
### Description

Clears rows or columns from a StreamDeck profile.  By default, clears an entire profile.

---
### Parameters
#### **ProfileName**

The name of one or more profiles



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:false



---
#### **ProfileRoot**

The root directory to look for profiles.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **Row**

One or more rows to clear



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Column**

One or more columns to clear



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **UUID**

One or more action UUIDs to clear



> **Type**: ```[String[]]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Syntax
```PowerShell
Clear-StreamDeckProfile [-ProfileName] <String[]> [[-ProfileRoot] <String>] [[-Row] <String[]>] [[-Column] <String[]>] [[-UUID] <String[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
