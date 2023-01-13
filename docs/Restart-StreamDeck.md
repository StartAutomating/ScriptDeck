Restart-StreamDeck
------------------
### Synopsis
Restarts the StreamDeck application

---
### Description

Stops the StreamDeck application, waits for it to exit, and launches a new process

---
### Related Links
* [Start-StreamDeck](Start-StreamDeck.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
Restart-StreamDeck
```

---
### Parameters
#### **PassThru**

If set, will output the process






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Outputs
* [Diagnostics.Process](https://learn.microsoft.com/en-us/dotnet/api/System.Diagnostics.Process)




---
### Syntax
```PowerShell
Restart-StreamDeck [-PassThru] [<CommonParameters>]
```
---
