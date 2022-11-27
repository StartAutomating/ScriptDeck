Start-LoupeDeck
---------------
### Synopsis
Starts Loupedeck

---
### Description

Starts the LoupeDeck application.

---
### Related Links
* [Stop-LoupeDeck](Stop-LoupeDeck.md)



* [Restart-LoupeDeck](Restart-LoupeDeck.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Start-LoupeDeck
```

---
### Parameters
#### **LoupeDeckPath**

The Path to LoupeDeck.  
If this parameter is not provided, this will attempt to launch Loupedeck from the default installation folder.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **PassThru**

If set, will output the created process.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Start-LoupeDeck [[-LoupeDeckPath] <String>] [-PassThru] [<CommonParameters>]
```
---
