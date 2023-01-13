Import-StreamDeckProfile
------------------------
### Synopsis
Imports StreamDeck Profiles

---
### Description

Imports StreamDeck Profile files (*.StreamDeckProfile).

Profiles are extracted to the ProfilesV2 directory of the local StreamDeck program.

---
### Related Links
* [Export-StreamDeckProfile](Export-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Import-StreamDeckProfile -InputPath .\My.StreamDeckProfile
```

---
### Parameters
#### **InputPath**

The input path.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|



---
#### **OutputDirectory**

The output directory.
If not provided, will output to the StreamDeck profiles directory.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |2       |true (ByPropertyName)|



---
### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)




---
### Syntax
```PowerShell
Import-StreamDeckProfile [[-InputPath] <String>] [[-OutputDirectory] <String>] [<CommonParameters>]
```
---
