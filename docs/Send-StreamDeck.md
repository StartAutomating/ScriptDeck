Send-StreamDeck
---------------
### Synopsis
Sends messages to a StreamDeck

---
### Description

Sends messages to a StreamDeck.  

This function will often be used within StreamDeck plugins.

---
### Related Links
* [Receive-StreamDeck](Receive-StreamDeck.md)



* [https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/](https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/)



---
### Parameters
#### **EventName**

The name of the event






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|



---
#### **Payload**

The event payload.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |3       |true (ByPropertyName)|



---
#### **ShowOK**

If set, will send a showOk event to the Stream Deck application.
This will temporarily show an OK checkmark icon on the image displayed by an instance of an action.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|



---
#### **ShowAlert**

If set, will send a showAlert event to the Stream Deck application.
This will temporarily show an alert icon on the image displayed by an instance of an action.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|



---
#### **OpenURL**

If set, will send an openURL event to the Stream Deck application.
This will temporarily show an alert icon on the image displayed by an instance of an action.






|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|true    |named   |true (ByPropertyName)|



---
#### **LogMessage**

If set, will send an openURL event to the Stream Deck application.
This will temporarily show an alert icon on the image displayed by an instance of an action.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



---
#### **ImagePath**

If provided will send a showImage event to the Stream Deck application using the contents of the file in ImagePath






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



---
#### **Title**

The title






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



---
#### **State**

The state index of an image or title.  Defaults to zero.






|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |named   |true (ByPropertyName)|



---
#### **EventTarget**

The target of a title or image change.  Valid values are



Valid Values:

* both
* hardware
* software






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



---
#### **Context**

The event context.  
If not provided, the global variable STREAMDECK_CONTEXT will be used






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|



---
#### **WaitFor**

The maximum amount of time to wait for a WebSocket to open.  By default, 30 seconds.






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[TimeSpan]`|false   |named   |true (ByPropertyName)|



---
#### **WaitInterval**

The interval to wait while receiving a message.  By default, 11 milliseconds.






|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[TimeSpan]`|false   |named   |false        |



---
#### **Websocket**

The web socket.
If not provided, the global variable STREAMDECK_WEBSOCKET will be used.






|Type               |Required|Position|PipelineInput        |
|-------------------|--------|--------|---------------------|
|`[ClientWebSocket]`|false   |5       |true (ByPropertyName)|



---
#### **Port**

The web socket.
If not provided, the global variable STREAMDECK_WEBSOCKET will be used.






|Type     |Required|Position|PipelineInput        |
|---------|--------|--------|---------------------|
|`[Int32]`|false   |5       |true (ByPropertyName)|



---
#### **PluginUUID**

The plugin UUID.  This is used in plugin registration.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



---
#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.
    
If you pass ```-Confirm:$false``` you will not be prompted.
    
    
If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---
### Syntax
```PowerShell
Send-StreamDeck [-EventName] <String> [[-Payload] <PSObject>] [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -ShowOK [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -ShowAlert [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -OpenURL <Uri> [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -LogMessage <String> [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -ImagePath <String> [-State <Int32>] [-EventTarget <String>] [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck -Title <String> [-State <Int32>] [-EventTarget <String>] [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
```PowerShell
Send-StreamDeck [[-Context] <String>] [-WaitFor <TimeSpan>] [-WaitInterval <TimeSpan>] [[-Websocket] <ClientWebSocket>] [[-Port] <Int32>] -PluginUUID <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```
---
