Start-StreamDeck
----------------




### Synopsis
Starts StreamDeck



---


### Description

Starts the StreamDeck application.



---


### Related Links
* [Restart-StreamDeck](Restart-StreamDeck.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
Start-StreamDeck
```



---


### Parameters
#### **StreamDeckPath**

The Path to StreamDeck.  
If this parameter is provided, this will attempt to launch StreamDeck from the default installation folder.






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
Start-StreamDeck [[-StreamDeckPath] <String>] [-PassThru] [<CommonParameters>]
```
