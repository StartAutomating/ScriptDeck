Watch-StreamDeck
----------------
### Synopsis
Watches StreamDeck

---
### Description

Watches StreamDeck for events.
This function provides the backbone of a StreamDeck plugin written in PowerShell.

---
### Examples
#### EXAMPLE 1
```PowerShell
# This will start watching the plugin with arguments passed by StreamDeck
Watch-StreamDeck -StreamDeckInfo $args
```

---
### Parameters
#### **StreamDeckInfo**

The StreamDeck Information.
This will be the JSON object initially passed in.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByValue)



---
#### **HandlerPath**

The path containing event handlers.  By default, the current directory.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:false



---
#### **AsJob**

If set, will receive events from StreamDeck in a background job.
This allows Watch-StreamDeck to not block and still mostly work as expected.
The main runspace will not be able to send data back to the StreamDeck.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
#### **LogPath**

The log path.
If no log path is provided, one will be created in the same directory as this script.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:false



---
### Syntax
```PowerShell
Watch-StreamDeck [[-StreamDeckInfo] <PSObject>] [[-HandlerPath] <String>] [-AsJob] [[-LogPath] <String>] [<CommonParameters>]
```
---
