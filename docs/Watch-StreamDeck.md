Watch-StreamDeck
----------------




### Synopsis
Watches StreamDeck



---


### Description

Watches StreamDeck for events.

This function provides the backbone of a StreamDeck plugin written in PowerShell.

Watch-StreamDeck should not be called directly, unless you are testing a plugin.



---


### Related Links
* [Send-StreamDeck](Send-StreamDeck.md)



* [Receive-StreamDeck](Receive-StreamDeck.md)





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






|Type        |Required|Position|PipelineInput |
|------------|--------|--------|--------------|
|`[PSObject]`|false   |1       |true (ByValue)|



#### **HandlerPath**

The path containing event handlers.  By default, the current directory.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |2       |false        |



#### **AsJob**

If set, will receive events from StreamDeck in a background job.
This allows Watch-StreamDeck to not block and still mostly work as expected.
The main runspace will not be able to send data back to the StreamDeck.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **LogPath**

The log path.
If no log path is provided, one will be created in the same directory as this script.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |



#### **NoMessageOutput**

If set, will not log individual StreamDeck messages to disk.
These messages are normally outputted to disk so that ScriptDeck may externally watch for events.
All events from a prior session will be removed on plugin launch.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **NoMessageInput**

If set, will not allow message input from disk.
These messages are normally monitored so that a StreamDeck action can be externally controlled.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



#### **NoScriptInput**

If set, will not allow script input from disk.
Script input is normally allowed enable out-of-process manipulation of global state.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |





---


### Syntax
```PowerShell
Watch-StreamDeck [[-StreamDeckInfo] <PSObject>] [[-HandlerPath] <String>] [-AsJob] [[-LogPath] <String>] [-NoMessageOutput] [-NoMessageInput] [-NoScriptInput] [<CommonParameters>]
```
