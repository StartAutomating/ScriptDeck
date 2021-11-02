<#
.Synopsis
    Creates StreamDeck Plugins that use Windows PowerShell
.Description
    Creates the scaffolding for StreamDeck Plugins that use Windows PowerShell.

    This scaffolding consists of a pair of commands from ScriptDeck:  Send-StreamDeck and Receive-StreamDeck
#>
param(
# A list of required modules.
[string[]]
$RequiredModule,

[Parameter(Mandatory)]
[string]
$Name,

[Parameter(Mandatory)]
[string]
$OutputPath
)

begin {

# A few things are the same regardless of input.

# One of them is the definition of the core plugin.

$corePlugin = {

$PluginRoot = "$psScriptRoot"

# Set up a log path for this plugin instance (make it based off of the starttime)
$global:STREAMDECK_PLUGINLOGPATH = $logPath = 
    Join-Path $psScriptRoot (        
        ([Datetime]::Now.ToString('o').replace(':','.') -replace '\.\d+(?=[+-])') + '.log'
    )

"Log Started @ $([DateTime]::Now.ToString('s')).  Running under process ID $($pid)" | Add-Content -Path $logPath

# Get logs older than a week
$oldLogs = Get-ChildItem -Path $PluginRoot -Filter *.log | 
    Where-Object { ([DateTime]::now - [DateTime]$_.Name.Replace('.log','').Replace('.', ':')) -lt '7.00:00:00'}
# If there were any old logs, remove them.
if ($oldLogs) { $oldLogs | Remove-Item -ErrorAction SilentlyContinue }

if ($global:STREAMDECK_REQUIREDMODULES) {    
    $imported = @(foreach ($module in $global:STREAMDECK_REQUIREDMODULES) {
        $relativePath = (Join-Path $psScriptRoot $module)
        if (Test-Path $relativePath) {
            Import-Module $relativePath -Force -PassThru |
                Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH -PassThru
        } else {
            Save-Module -Name $module -Path $psScriptRoot
            Import-Module $relativePath -Force -PassThru |
                Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH -PassThru
        }
    })

    if ($imported.Count -ne $global:STREAMDECK_REQUIREDMODULES.Count) {
        return
    }
}


# Now we need to handle the arguments passed into the plugin.
# Let's put each named argument into a dictionary.
$argObject = [Ordered]@{}
for ($i = 0; $i -lt $args.Length; $i+=2 ) # We do this by going in twos thru the arguments
{       
    $k = $args[$i].TrimStart('-') # removing the - from the key
    $v = $args[$i + 1]
    $argObject[$k] = 
        if ("$v".StartsWith('{')) { # and converting any JSON-like input.
            $v | ConvertFrom-Json
        } else {
            $v
        }
}

$Host.UI.RawUI.WindowTitle = "StreamDeck $pid"

# Once we've collected an arguments dictionary, turn it into an object,
$argObject = [PSCustomObject]$argObject 
$argObject | 
    ConvertTo-Json | # convert it to JSON,
    Add-Content -Path $logPath # and add it to the log.

# Now let's register the functions we need.
# |Function|Purpose                                           |
# |--------|--------------------------------------------------|
# |Send-StreamDeck     |Sends messages to the StreamDeck      |
. $psScriptRoot\Send-StreamDeck.ps1
# |Receive-StreamDeck  |Receives messages from the StreamDeck |
. $psScriptRoot\Receive-StreamDeck.ps1

# We will want to declare a few globals to keep track of state.
if (-not $Global:STREAMDECK_DEVICES)  { $Global:STREAMDECK_DEVICES = @{} }
if (-not $Global:STREAMDECK_BUTTONS)  { $Global:STREAMDECK_BUTTONS = @{} }
if (-not $global:STREAMDECK_SETTINGS) { $global:STREAMDECK_SETTINGS = @{} }

$localFiles = Get-ChildItem -Path $psScriptRoot -Filter *.ps1

$heartbeatTimer = [Timers.Timer]::new()
$heartbeatTimer.Interval = [Timespan]::FromMinutes(10).totalmilliseconds
$heartbeatTimer.AutoReset = $true
$heartbeatTimer.Start()
Register-ObjectEvent -InputObject $heartbeatTimer -EventName Elapsed -Action {
    "Heartbeat @ $([DateTime]::Now.ToString('s'))" | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
}

$actionErrorHandler = {
    $err = $_
    $errorString = $err | Out-String
    $errorString | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
    Start-Job -ScriptBlock {
        param([string]$errorString,[string]$PluginName)
        $null  = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]
        $toastXml = [xml][Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastText01).Getxml()
        $toastXml.toast.visual.binding.text.InnerText = "$errorString"
        $xd = [windows.data.xml.dom.xmldocument]::New()
        $xd.LoadXml($toastXml.OuterXml)
        $toast = [Windows.UI.Notifications.ToastNotification]::new($xd)
        $toast.Tag   = "StreamDeck"
        $toast.Group = "PowerShell"
        $toast.ExpirationTime = [DateTime]::Now.AddSeconds(30)
        $toastName = if ($PluginName) {
            $PluginName
        } else {
            "StreamDeck Plugin $pid"
        }
        [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("$toastName").Show($toast)
    } -ArgumentList $errorString, $global:STREAMDECK_PLUGIN_NAME
}

foreach ($file in @(
$localFiles | Where-Object Name -Like '*.handler.ps1'
$localFiles | Where-Object Name -Like 'On_*.ps1'
)) {
    
    $scriptFile = $ExecutionContext.SessionState.InvokeCommand.GetCommand($file.Fullname, 'ExternalScript')
    $sourceIdentifier = $file.Name -replace '^On_' -replace '\.ps1$' -replace '\.handler$'
    Add-Content -Path $logPath -value "Registering Handler for '$sourceIdentifier': $($file.fullname)"
    $actionScriptBlock = [ScriptBlock]::Create("
        try { . '$($file.Fullname)' } catch $actionErrorHandler
    ")
    Register-EngineEvent -SourceIdentifier $sourceIdentifier -Action $actionScriptBlock
}


do {
    "Starting Watching Streamdeck  @ $([DateTime]::Now.ToString('s'))" | Add-Content -Path $logPath
    $argObject | 
        Receive-StreamDeck -OutputType Message 2>&1 | 
        Foreach-Object {
            if ($Global:STREAMDECK_WEBSOCKET.State -in 'Aborted' ,'CloseReceived') {
                $_ | Out-String | Add-Content -Path $logPath
                break
            }
            $_ | Out-String | Add-Content -Path $logPath
        }

    
    if ($Global:STREAMDECK_WEBSOCKET.State -in 'Aborted' ,'CloseReceived') {
        break
    }
    $sleepTime = (Get-Random -Minimum 30 -Maximum 180)        
    "Finished Watching Streamdeck @ $([DateTime]::Now.ToString('s')).  Trying again in $($sleepTime)" | Add-Content -Path $logPath
    Start-Sleep -Seconds $sleepTime
} while ($true)

}


# Another two are the default handlers for settings.

${On_StreamDeck.SendToPlugin} = {

# Create a property bag to receive settings
$instanceSettings = [PSObject]::new()
if ($event.MessageData.Payload.sdpi_collection) { # If the settings were sent in an sdpi_collection, pass along the key and value.
    $instanceSettings | 
        Add-Member NoteProperty -Name $event.MessageData.Payload.sdpi_collection.key -Value $event.MessageData.Payload.sdpi_collection.value
}
# Generate a new event containing the pending setting.  This will be merged with settings data later.
New-Event -SourceIdentifier "StreamDeck.PendingSetting.$($event.MessageData.context)" -MessageData $instanceSettings
# Then send the getSettings event.  This will generate a StreamDeck.DidReceiveSettings event with the rest of the original setting data.
Send-StreamDeck -Context $event.MessageData.context -EventName getSettings
}
${On_StreamDeck.DidReceiveSettings} = {
# Get any pending settings related to this context.
$evt = Get-Event -SourceIdentifier "StreamDeck.PendingSetting.$($event.MessageData.context)" -ErrorAction SilentlyContinue
# Update the global settings store with a new object.
$global:STREAMDECK_SETTINGS[$event.MessageData.Context] = [PSObject]::new()
# Start off with the settings we have now
$global:STREAMDECK_SETTINGS[$event.MessageData.Context] = $event.MessageData.Payload.Settings 
if ($evt) { # If we had pending settings    
    foreach ($prop in $evt.MessageData.psobject.properties) { # walk over each setting property
        Add-Member -InputObject $global:STREAMDECK_SETTINGS[
            $event.MessageData.Context
        ] -MemberType NoteProperty -Name $prop.Name -Value $prop.Value -Force # and add it to the object.
    }
    $evt | Remove-Event # then, remove the event (so that we can handle the next one)
}

# Get the existing settings object. 
$settingsObject = $global:STREAMDECK_SETTINGS[$event.MessageData.Context]
$newSettings    = [PSObject]::new() # and create a new settings object.
if ($settingsObject -is [Collections.IDictionary]) { # If it is a dictionary, 
    foreach ($kv in $settingsObject.GetEnumerator()) { # add the existing settings to the new settings.
        $newSettings | Add-Member -memberType NoteProperty $kv.Key $kv.Value
    }
} else {
    foreach ($prop in $settingsObject.psobject.properties) { # If the settings were not a dictionary
        # Skip values from collections
        if ($prop.Name -in 'Count', 'IsFixedSize', 'IsReadOnly', 'IsSynchronized', 'Keys', 'SyncRoot', 'Values') { 
            continue
        }
        # and add any other properties to the new settings object.
        $newSettings | Add-Member -memberType NoteProperty -Name $prop.Name -Value $prop.Value            
    }
}

# Log the new settings object
[pscustomobject][ordered]@{
    eventName = "setSettings"
    context = $event.messageData.context
    payload = $newSettings
} | ConvertTo-Json -Compress | Add-Content -Path $global:STREAMDECK_PLUGINLOGPATH
# and send it to StreamDeck.
Send-StreamDeck -Context $event.MessageData.Context -EventName setSettings -Payload $newSettings

}

$functionsToDeclare  = 'Send-StreamDeck', 'Receive-StreamDeck'
$nativeEventHandlers = 'On_StreamDeck.DidReceiveSettings', 'On_StreamDeck.SendToPlugin'

}

process {
    foreach ($func in $functionsToDeclare) {
        $funcDef = $ExecutionContext.SessionState.InvokeCommand.GetCommand($func, 'Function')
        $funcOutputPath = Join-Path $OutputPath "$($funcDef.Name).ps1"
        $regionName = "$($funcDef.Module.Name)@$($funcDef.Module.Version)/$($funcDef.Name)"
        @"
#region $regionName
function $($funcDef.Name) {
$($funcDef.Definition)
}
#endregion $regionName
"@ | 
        Set-Content -Path $funcOutputPath
    }


    foreach ($eventName in $nativeEventHandlers) {
        $eventDef = $ExecutionContext.SessionState.PSVariable.Get($eventName).Value    
        $eventDef | Set-Content -Path (Join-Path $OutputPath "$eventName.ps1")
    }


    @'
powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0StartPlugin.ps1" %*
'@ | 
    Set-Content -Path (Join-Path $OutputPath "StartPlugin.cmd")

    @"
`$global:STREAMDECK_PLUGIN_NAME = '$($Name.Replace("'","''"))'
$corePlugin
"@ |
    Set-Content -Path (Join-Path $OutputPath "StartPlugin.ps1")
@{
    CodePath = "StartPlugin.cmd"
}

}