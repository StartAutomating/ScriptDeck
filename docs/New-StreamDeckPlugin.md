New-StreamDeckPlugin
--------------------
### Synopsis
Creates a StreamDeck Plugin

---
### Description

Creates a new StreamDeck Plugin.

---
### Related Links
* [https://developer.elgato.com/documentation/stream-deck/sdk/manifest/](https://developer.elgato.com/documentation/stream-deck/sdk/manifest/)



* [Get-StreamDeckPlugin](Get-StreamDeckPlugin.md)



---
### Parameters
#### **Name**

The name of the plugin. This string is displayed to the user in the Stream Deck store.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 1

> **PipelineInput**:true (ByPropertyName)



---
#### **Author**

The author of the plugin. This string is displayed to the user in the Stream Deck store.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 2

> **PipelineInput**:true (ByPropertyName)



---
#### **Action**

Specifies an array of actions. A plugin can indeed have one or multiple actions.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 3

> **PipelineInput**:true (ByPropertyName)



---
#### **Description**

Provides a general description of what the plugin does.
This is displayed to the user in the Stream Deck store.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 4

> **PipelineInput**:true (ByPropertyName)



---
#### **Version**

The version of the plugin which can only contain digits and periods. This is used for the software update mechanism.



> **Type**: ```[Version]```

> **Required**: false

> **Position**: 5

> **PipelineInput**:true (ByPropertyName)



---
#### **Icon**

The relative path to a PNG image without the .png extension. 
This image is displayed in the Plugin Store window.
The PNG image should be a 72pt x 72pt image. 
You should provide @1x and @2x versions of the image.
The Stream Deck application takes care of loading the appropriate version of the image.



> **Type**: ```[String]```

> **Required**: true

> **Position**: 6

> **PipelineInput**:true (ByPropertyName)



---
#### **Category**

The name of the custom category in which the actions should be listed.
This string is visible to the user in the actions list.
If you don't provide a category, the actions will appear inside a "Custom" category.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 7

> **PipelineInput**:true (ByPropertyName)



---
#### **CategoryIcon**

The relative path to a PNG image without the .png extension.
This image is used in the actions list.
The PNG image should be a 28pt x 28pt image.
You should provide @1x and @2x versions of the image.
The Stream Deck application takes care of loading the appropriate version of the image.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 8

> **PipelineInput**:true (ByPropertyName)



---
#### **CodePath**

The relative path to the HTML/binary file containing the code of the plugin.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 9

> **PipelineInput**:true (ByPropertyName)



---
#### **CodePathWin**

Override CodePath for Windows.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 10

> **PipelineInput**:true (ByPropertyName)



---
#### **CodePathMac**

Override CodePath for macOS.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 11

> **PipelineInput**:true (ByPropertyName)



---
#### **PropertyInspectorPath**

The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
If missing, the plugin will have an empty Property Inspector.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 12

> **PipelineInput**:true (ByPropertyName)



---
#### **DefaultWindowSize**

Specify the default window size when a Javascript plugin or Property Inspector opens a window using window.open().
Default value is [500, 650].



> **Type**: ```[String]```

> **Required**: false

> **Position**: 13

> **PipelineInput**:true (ByPropertyName)



---
#### **OS**

The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 14

> **PipelineInput**:true (ByPropertyName)



---
#### **Software**

Indicates which version of the Stream Deck application is required to install the plugin.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 15

> **PipelineInput**:true (ByPropertyName)



---
#### **Url**

A URL displayed to the user if he wants to get more info about the plugin.



> **Type**: ```[Uri]```

> **Required**: false

> **Position**: 16

> **PipelineInput**:true (ByPropertyName)



---
#### **ApplicationsToMonitor**

List of application identifiers to monitor (applications launched or terminated).
See the applicationDidLaunch and applicationDidTerminate events.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: 17

> **PipelineInput**:true (ByPropertyName)



---
#### **Profiles**

Specifies an array of profiles.
A plugin can indeed have one or multiple profiles that are proposed to the user on installation.
This lets you create fullscreen plugins.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 18

> **PipelineInput**:true (ByPropertyName)



---
#### **OutputPath**

The output path.  
If not provided, the plugin will be created in a directory beneath the current directory.
This directory will be named $Name.sdPlugin.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 19

> **PipelineInput**:false



---
#### **Template**

The name of a StreamDeck plugin template.



> **Type**: ```[String]```

> **Required**: false

> **Position**: 20

> **PipelineInput**:true (ByPropertyName)



---
#### **TemplateParameter**

> **Type**: ```[IDictionary]```

> **Required**: false

> **Position**: 21

> **PipelineInput**:true (ByPropertyName)



---
#### **TemplateArgumentList**

> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: 22

> **PipelineInput**:true (ByPropertyName)



---
### Syntax
```PowerShell
New-StreamDeckPlugin [-Name] <String> [-Author] <String> [[-Action] <PSObject[]>] [-Description] <String> [[-Version] <Version>] [-Icon] <String> [[-Category] <String>] [[-CategoryIcon] <String>] [[-CodePath] <String>] [[-CodePathWin] <String>] [[-CodePathMac] <String>] [[-PropertyInspectorPath] <String>] [[-DefaultWindowSize] <String>] [[-OS] <PSObject[]>] [[-Software] <PSObject>] [[-Url] <Uri>] [[-ApplicationsToMonitor] <PSObject>] [[-Profiles] <PSObject[]>] [[-OutputPath] <String>] [[-Template] <String>] [[-TemplateParameter] <IDictionary>] [[-TemplateArgumentList] <PSObject[]>] [<CommonParameters>]
```
---
