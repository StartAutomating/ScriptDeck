New-StreamDeckAction
--------------------




### Synopsis
Creates a StreamDeck action



---


### Description

Creates a StreamDeck action, to be used as part of a profile.



---


### Related Links
* [Get-StreamDeckAction](Get-StreamDeckAction.md)





---


### Examples
#### EXAMPLE 1
```PowerShell
New-StreamDeckAction -HotKey "CTRL+F4" -Title "Close"
```

#### EXAMPLE 2
```PowerShell
New-StreamDeckAction -Uri https://github.com/ -Title "GitHub"
```



---


### Parameters
#### **Name**

The name of the plugin.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



#### **UUID**

The StreamDeck Plugin UUID.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **HotKey**

A sequence of hotkeys






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[String[]]`|true    |named   |true (ByPropertyName)|



#### **Uri**

A URI.






|Type   |Required|Position|PipelineInput        |Aliases|
|-------|--------|--------|---------------------|-------|
|`[Uri]`|true    |named   |true (ByPropertyName)|Url    |



#### **ScriptBlock**

A PowerShell ScriptBlock.
Currently, this will run using pwsh by default, and use -WindowsPowerShell if provided.






|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[ScriptBlock]`|true    |named   |true (ByPropertyName)|



#### **WindowsPowerShell**

If set, will run the ScriptBlock in Windows PowerShell.
By default, will run the Scriptblock in PowerShell core.
This option is obviously not supported on MacOS.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|



#### **ApplicationPath**

The path to an application.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



#### **ProfileName**

The name of a StreamDeck profile.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



#### **DeviceUUID**

The device UUID, when switching profiles.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **NextPage**

The next page.  This should be created by New-StreamDeckProfile, passing -IsNextPage






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|true    |named   |true (ByPropertyName)|



#### **ChildProfile**

A Child Profile.  These should be created by New-StreamDeckProfile, passing -IsChildProfile






|Type        |Required|Position|PipelineInput        |
|------------|--------|--------|---------------------|
|`[PSObject]`|true    |named   |true (ByPropertyName)|



#### **BackToParent**

If set, will create an action that will navigate back to the parent folder.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|



#### **PreviousPage**

If set, will create an action that will navigate back to the previous page.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|true    |named   |true (ByPropertyName)|



#### **Text**

The text that should be automatically typed






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |named   |true (ByPropertyName)|



#### **SendEnter**

If set, will send an enter key after typing the text.






|Type      |Required|Position|PipelineInput        |Aliases                        |
|----------|--------|--------|---------------------|-------------------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|Enter<br/>Return<br/>SendReturn|



#### **Setting**

The settings passed to the plugin.






|Type        |Required|Position|PipelineInput        |Aliases |
|------------|--------|--------|---------------------|--------|
|`[PSObject]`|false   |named   |true (ByPropertyName)|Settings|



#### **Title**

The title of the action






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **Image**

The image used for the action






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |named   |true (ByPropertyName)|



#### **FontSize**

The font size






|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|FSize  |



#### **FontFamily**

The font family






|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|false   |named   |true (ByPropertyName)|FFamily|



#### **Underline**

If set, will underline the action title






|Type      |Required|Position|PipelineInput        |Aliases      |
|----------|--------|--------|---------------------|-------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|FontUnderline|



#### **States**

The possible states of the plugin.






|Type          |Required|Position|PipelineInput        |
|--------------|--------|--------|---------------------|
|`[PSObject[]]`|false   |named   |true (ByPropertyName)|



#### **State**

The state index.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[UInt32]`|false   |named   |true (ByPropertyName)|



#### **HideTitle**

If set, will not show a title.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[Switch]`|false   |named   |true (ByPropertyName)|





---


### Outputs
* StreamDeck.Action






---


### Syntax
```PowerShell
New-StreamDeckAction -Name <String> [-UUID <String>] [-WindowsPowerShell] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction -HotKey <String[]> [-WindowsPowerShell] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction -Uri <Uri> [-WindowsPowerShell] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction -ScriptBlock <ScriptBlock> [-WindowsPowerShell] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -ApplicationPath <String> [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -ProfileName <String> [-DeviceUUID <String>] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -NextPage <PSObject> [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -ChildProfile <PSObject> [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -BackToParent [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -PreviousPage [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
```PowerShell
New-StreamDeckAction [-WindowsPowerShell] -Text <String> [-SendEnter] [-Setting <PSObject>] [-Title <String>] [-Image <String>] [-FontSize <String>] [-FontFamily <String>] [-Underline] [-States <PSObject[]>] [-State <UInt32>] [-HideTitle] [<CommonParameters>]
```
