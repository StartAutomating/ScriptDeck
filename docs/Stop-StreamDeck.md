Stop-StreamDeck
---------------

### Synopsis
Stops the StreamDeck application

---

### Description

Stops the StreamDeck application.  Attempts to gracefully exit plugins.

---

### Examples
> EXAMPLE 1

```PowerShell
Stop-StreamDeck
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
Stop-StreamDeck [-PassThru] [<CommonParameters>]
```
