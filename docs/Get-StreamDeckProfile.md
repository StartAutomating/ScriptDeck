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
> EXAMPLE 1

```PowerShell
Get-StreamDeckProfile
```

---

### Parameters
#### **Name**
The name of the profile

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|

#### **ProfileRoot**
The profile root

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|

#### **Recurse**
If set, will get profiles recursively

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|

---

### Outputs
* StreamDeck.Profile

---

### Syntax
```PowerShell
Get-StreamDeckProfile [[-Name] <String>] [[-ProfileRoot] <String>] [-Recurse] [<CommonParameters>]
```
