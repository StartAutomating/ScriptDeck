Receive-StreamDeck
------------------
### Synopsis
Receives messages from a StreamDeck

---
### Description

Receives websocket messages from a StreamDeck.

This is used in StreamDeck plugin development.

Unless -AsJob is passed, this function **This function will block until the StreamDeck webSocket closes.**

Each message receive will be converted from JSON and outputted.

Each message will also be transmitted as two events

|    SourceIdentifier   |         Example         |
|-----------------------|-------------------------|
| StreamDeck.$EventName |    StreamDeck.KeyDown   |
| $Action.$EventName    |    MyPlugin.KeyDown     |

These events can be handled using Register-EngineEvent, for example:

Register-EngineEvent -SourceIdentifier MyPlugin.KeyDown -Action {
    "MyPlugin.KeyDown was pressed" | Out-Gridview
}

---
### Related Links
* [Send-StreamDeck](Send-StreamDeck.md)



* [https://developer.elgato.com/documentation/stream-deck/sdk/events-received/](https://developer.elgato.com/documentation/stream-deck/sdk/events-received/)



---
### Parameters
#### **RegisterEvent**

The registration event. This is used in plugin registration.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **PluginUUID**

The plugin UUID.  This is used in plugin registration.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Port**

The port.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Websocket**

The web socket.
If not provided, the $GLOBAL:STREAMDECK_WEBSOCKET will be used.
If $GLOBAL:STREAMDECK_WEBSOCKET has not been set, one will be created using -Port.



> **Type**: ```[ClientWebSocket]```

> **Required**: false

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **BufferSize**

The buffer size for received messages.  By default: 16 kilobytes.



> **Type**: ```[Int32]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:false



---
#### **WaitFor**

The maximum amount of time to wait for a WebSocket to open.  By default, 30 seconds.



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **WaitInterval**

The interval to wait while receiving a message.  By default, 17 milliseconds.



> **Type**: ```[TimeSpan]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:false



---
#### **OutputType**

The output type.  Default is 'Data' Can be:
* Data    (the JSON event data)
* Event   (the PowerShell events)
* Message (the JSON message)
* None



Valid Values:

* Data
* Event
* Message
* None



> **Type**: ```[String]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:false



---
#### **AsJob**

If set, will watch the streamdeck in a background job.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:false



---
### Syntax
```PowerShell
Receive-StreamDeck [[-RegisterEvent] <String>] [[-PluginUUID] <String>] [[-Port] <Int32>] [[-Websocket] <ClientWebSocket>] [[-BufferSize] <Int32>] [[-WaitFor] <TimeSpan>] [[-WaitInterval] <TimeSpan>] [[-OutputType] <String>] [-AsJob] [<CommonParameters>]
```
---
