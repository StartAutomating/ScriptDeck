Get-LoupeDeckProfile
--------------------

### Synopsis
Gets LoupeDeck Profiles

---

### Description

Gets Profiles for LoupeDeck

---

### Examples
> EXAMPLE 1

```PowerShell
Get-LoupeDeckProfile
```

---

### Parameters
#### **Name**
The name of the profile

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **ProfileRoot**
The profile root.
This will be automatically set if it is not provided.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|false   |2       |true (ByPropertyName)|

---

### Syntax
```PowerShell
Get-LoupeDeckProfile [[-Name] <String>] [[-ProfileRoot] <String[]>] [<CommonParameters>]
```
