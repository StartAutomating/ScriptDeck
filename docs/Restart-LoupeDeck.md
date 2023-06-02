Restart-LoupeDeck
-----------------




### Synopsis
Restarts Loupedeck



---


### Description

Restarts the LoupeDeck application.



---


### Related Links
* [Start-LoupeDeck](Start-LoupeDeck.md)



* [Stop-LoupeDeck](Stop-LoupeDeck.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Restart-LoupeDeck
```



---


### Parameters
#### **LoupeDeckPath**

The Path to LoupeDeck.  
If this parameter is not provided, this will attempt to launch Loupedeck from the default installation folder.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |1       |true (ByPropertyName)|



#### **PassThru**

If set, will output the created process.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Restart-LoupeDeck [[-LoupeDeckPath] <String>] [-PassThru] [<CommonParameters>]
```
