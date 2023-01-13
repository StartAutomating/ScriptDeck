New-StreamDeckProfile
---------------------
### Synopsis
Creates a StreamDeck profile

---
### Description

Creates a StreamDeck profile object

---
### Related Links
* [Get-StreamDeckProfile](Get-StreamDeckProfile.md)



* [Remove-StreamDeckProfile](Remove-StreamDeckProfile.md)



* [Save-StreamDeckProfile](Save-StreamDeckProfile.md)



---
### Examples
#### EXAMPLE 1
```PowerShell
New-StreamDeckProfile -Name Clippy -Action @{
    '0,0' =
        New-StreamDeckAction -Name "Switch Profile" -Setting @{
            DeviceUUID  = ''
            ProfileUUID = 'A0C89D39-F47D-4CE0-8262-4EE22E22CEFC'
        }
```
'0,1' = New-StreamDeckAction -HotKey "CTRL+X" -Title "Cut" -Image $home\Downloads\scissors.svg   # downloaded from FeatherIcons

    '1,1' = New-StreamDeckAction -HotKey "CTRL+C" -Title "Copy" -Image $home\Downloads\copy.svg      # downloaded from FeatherIcons

    '2,1' = New-StreamDeckAction -HotKey "CTRL+V" -Title "Paste" -Image $home\Downloads\code.svg     # downloaded from FeatherIcons
}
#### EXAMPLE 2
```PowerShell
$gitUser = 'StartAutomating'
$rows, $columns = 2,3
$repoList =  (Invoke-RestMethod -Uri https://api.github.com/users/$gitUser/repos?sort=pushed | ForEach-Object { $_ })
$n =0
$actions = [Ordered]@{}
for ($r = 0 ;$r -lt $rows; $r++) {
    for ($c = 0 ; $c -lt $columns; $C++) {
        $actions["$c,$r"] = New-StreamDeckAction -Uri $repoList[$n].html_url -Title $repoList[$n].name
        $n++
    }
}
```
New-StreamDeckProfile -Name GitRepos -Action $actions |
    Save-StreamDeckProfile
---
### Parameters
#### **Name**

The name of the profile






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|true    |1       |true (ByPropertyName)|



---
#### **Action**

A collection of actions.






|Type           |Required|Position|PipelineInput        |
|---------------|--------|--------|---------------------|
|`[IDictionary]`|true    |2       |true (ByPropertyName)|



---
#### **AppIdentifier**

The application identifier.
If provided, this profile will be activated whenever this application is given focus.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |3       |true (ByPropertyName)|



---
#### **DeviceModel**

The device model.
If not provided, the most commonly used device model from your other profiles will be used.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|



---
#### **DeviceUUID**

The device UUID.
If not provided, the most commonly used device uuid from your other profiles will be used.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |5       |true (ByPropertyName)|



---
#### **Version**

The version of the profile.  By default, 1.0






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|



---
#### **ProfileUUID**

The profile UUID.  If not provided, a GUID will be generated.






|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |7       |true (ByPropertyName)|



---
#### **ProfileRoot**

If provided, will create the profile beneath this directory.
If not provided, the profile will be created beneath the user's profiles directory.
On Windows, this is: "$env:AppData\Elgato\StreamDeck\ProfilesV2\"
On MacOS, this is  : "~/Library/Application Support/elgato/StreamDeck/ProfilesV2"






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |8       |false        |



---
#### **IsChildProfile**

If set, the stream deck profile created will be a child profile, and will not immediately be saved.
Child profiles will automatically have an action linking to the parent profile in the upper left.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
#### **IsNextPage**

If set, the stream deck profile created will be an additional page, and will not immediately be saved.
NextPages will automatically have an action linking to the previous page in the lower left.






|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |



---
### Outputs
* StreamDeck.Profile




---
### Syntax
```PowerShell
New-StreamDeckProfile [-Name] <String> [-Action] <IDictionary> [[-AppIdentifier] <String>] [[-DeviceModel] <String>] [[-DeviceUUID] <String>] [[-Version] <String>] [[-ProfileUUID] <String>] [[-ProfileRoot] <String>] [-IsChildProfile] [-IsNextPage] [<CommonParameters>]
```
---
