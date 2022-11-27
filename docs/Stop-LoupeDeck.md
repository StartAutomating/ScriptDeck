Stop-LoupeDeck
--------------
### Synopsis
Stops Loupedeck

---
### Description

Stops the LoupeDeck application.

---
### Related Links
* [Start-LoupeDeck](Start-LoupeDeck.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Stop-LoupeDeck
```

#### EXAMPLE 2
```PowerShell
Restart-LoupeDeck
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
Stop-LoupeDeck [[-LoupeDeckPath] <String>] [-PassThru] [<CommonParameters>]
```
---
