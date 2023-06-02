Remove-StreamDeckProfile
------------------------




### Synopsis
Removes StreamDeck Profiles



---


### Description

Removes StreamDeck Profiles and their directory contents.

This cannot be undone.



---


### Related Links
* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Get-StreamDeckProfile -Name GoodbyeProfile | Remove-StreamDeckProfile
```



---


### Parameters
#### **ProfilePath**

The Profile Path






|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |1       |true (ByPropertyName)|Path   |



#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.


If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.



---


### Outputs
* [Nullable](https://learn.microsoft.com/en-us/dotnet/api/System.Nullable)






---


### Syntax
```PowerShell
Remove-StreamDeckProfile [-ProfilePath] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```
