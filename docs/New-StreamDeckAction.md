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



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **UUID**

The StreamDeck Plugin UUID.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **HotKey**

A sequence of hotkeys



> **Type**: ```[String[]]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Uri**

A URI.



> **Type**: ```[Uri]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ScriptBlock**

A PowerShell ScriptBlock.
Currently, this will run using pwsh by default, and use -WindowsPowerShell if provided.



> **Type**: ```[ScriptBlock]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **WindowsPowerShell**

If set, will run the ScriptBlock in Windows PowerShell.
By default, will run the Scriptblock in PowerShell core.
This option is obviously not supported on MacOS.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ApplicationPath**

The path to an application.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ProfileName**

The name of a StreamDeck profile.



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **DeviceUUID**

The device UUID, when switching profiles.



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **NextPage**

The next page.  This should be created by New-StreamDeckProfile, passing -IsNextPage



> **Type**: ```[PSObject]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **ChildProfile**

A Child Profile.  These should be created by New-StreamDeckProfile, passing -IsChildProfile



> **Type**: ```[PSObject]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **BackToParent**

If set, will create an action that will navigate back to the parent folder.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **PreviousPage**

If set, will create an action that will navigate back to the previous page.



> **Type**: ```[Switch]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Text**

The text that should be automatically typed



> **Type**: ```[String]```

> **Required**: true

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **SendEnter**

If set, will send an enter key after typing the text.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Setting**

The settings passed to the plugin.



> **Type**: ```[PSObject]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Title**

The title of the action



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Image**

The image used for the action



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FontSize**

The font size



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **FontFamily**

The font family



> **Type**: ```[String]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **Underline**

If set, will underline the action title



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **States**

The possible states of the plugin.



> **Type**: ```[PSObject[]]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **State**

The state index.



> **Type**: ```[UInt32]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



---
#### **HideTitle**

If set, will not show a title.



> **Type**: ```[Switch]```

> **Required**: false

> **Position**: named

> **PipelineInput**:true (ByPropertyName)



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
---
