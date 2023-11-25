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

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|

#### **Author**
The author of the plugin. This string is displayed to the user in the Stream Deck store.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |2       |true (ByPropertyName)|

#### **Action**
Specifies an array of actions. A plugin can indeed have one or multiple actions.

|Type          |Required|Position|PipelineInput        |Aliases|
|--------------|--------|--------|---------------------|-------|
|`[PSObject[]]`|false   |3       |true (ByPropertyName)|Actions|

#### **Description**
Provides a general description of what the plugin does.
This is displayed to the user in the Stream Deck store.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |4       |true (ByPropertyName)|

#### **Version**
The version of the plugin which can only contain digits and periods. This is used for the software update mechanism.

|Type       |Required|Position|PipelineInput        |
|-----------|--------|--------|---------------------|
|`[Version]`|false   |5       |true (ByPropertyName)|

#### **Icon**
The relative path to a PNG image without the .png extension. 
This image is displayed in the Plugin Store window.
The PNG image should be a 72pt x 72pt image. 
You should provide @1x and @2x versions of the image.
The Stream Deck application takes care of loading the appropriate version of the image.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |6       |true (ByPropertyName)|

#### **Category**
The name of the custom category in which the actions should be listed.
This string is visible to the user in the actions list.
If you don't provide a category, the actions will appear inside a "Custom" category.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|

#### **CategoryIcon**
The relative path to a PNG image without the .png extension.
This image is used in the actions list.
The PNG image should be a 28pt x 28pt image.
You should provide @1x and @2x versions of the image.
The Stream Deck application takes care of loading the appropriate version of the image.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |8       |true (ByPropertyName)|

#### **CodePath**
The relative path to the HTML/binary file containing the code of the plugin.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |9       |true (ByPropertyName)|

#### **CodePathWin**
Override CodePath for Windows.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |10      |true (ByPropertyName)|

#### **CodePathMac**
Override CodePath for macOS.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |11      |true (ByPropertyName)|

#### **PropertyInspectorPath**
The relative path to the Property Inspector html file if your plugin want to display some custom settings in the Property Inspector.
If missing, the plugin will have an empty Property Inspector.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |12      |true (ByPropertyName)|

#### **DefaultWindowSize**
Specify the default window size when a Javascript plugin or Property Inspector opens a window using window.open().
Default value is [500, 650].

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |13      |true (ByPropertyName)|

#### **OS**
The list of operating systems supported by the plugin as well as the minimum supported version of the operating system.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |14      |true (ByPropertyName)|

#### **Software**
Indicates which version of the Stream Deck application is required to install the plugin.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |15      |true (ByPropertyName)|

#### **Url**
A URL displayed to the user if he wants to get more info about the plugin.

|Type   |Required|Position|PipelineInput        |
|-------|--------|--------|---------------------|
|`[Uri]`|false   |16      |true (ByPropertyName)|

#### **ApplicationsToMonitor**
List of application identifiers to monitor (applications launched or terminated).
See the applicationDidLaunch and applicationDidTerminate events.

|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|false   |17      |true (ByPropertyName)|

#### **Profiles**
Specifies an array of profiles.
A plugin can indeed have one or multiple profiles that are proposed to the user on installation.
This lets you create fullscreen plugins.

|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |18      |true (ByPropertyName)|

#### **OutputPath**
The output path.  
If not provided, the plugin will be created in a directory beneath the current directory.
This directory will be named $Name.sdPlugin.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |19      |false        |

#### **Template**
The name of a StreamDeck plugin template.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |20      |true (ByPropertyName)|

#### **TemplateParameter**

|Type           |Required|Position|PipelineInput        |Aliases           |
|---------------|--------|--------|---------------------|------------------|
|`[IDictionary]`|false   |21      |true (ByPropertyName)|TemplateParameters|

#### **TemplateArgumentList**

|Type          |Required|Position|PipelineInput        |Aliases          |
|--------------|--------|--------|---------------------|-----------------|
|`[PSObject[]]`|false   |22      |true (ByPropertyName)|TemplateArguments|

---

### Syntax
```PowerShell
New-StreamDeckPlugin [-Name] <String> [-Author] <String> [[-Action] <PSObject[]>] [-Description] <String> [[-Version] <Version>] [-Icon] <String> [[-Category] <String>] [[-CategoryIcon] <String>] [[-CodePath] <String>] [[-CodePathWin] <String>] [[-CodePathMac] <String>] [[-PropertyInspectorPath] <String>] [[-DefaultWindowSize] <String>] [[-OS] <PSObject[]>] [[-Software] <PSObject>] [[-Url] <Uri>] [[-ApplicationsToMonitor] <PSObject>] [[-Profiles] <PSObject[]>] [[-OutputPath] <String>] [[-Template] <String>] [[-TemplateParameter] <IDictionary>] [[-TemplateArgumentList] <PSObject[]>] [<CommonParameters>]
```
