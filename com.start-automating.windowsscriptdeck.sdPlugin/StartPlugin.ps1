# Set up a log path for this plugin instance (make it based off of the starttime)
$global:STREAMDECK_PLUGINLOGPATH = $logPath = 
    Join-Path $psScriptRoot (        
        ([Datetime]::Now.ToString('o').replace(':','.') -replace '\.\d+(?=[+-])') + '.log'
    )

# Clear older logs (only keep the last 10 executions around)
Get-ChildItem -Path $psScriptRoot -Filter *.log |
    Sort-Object LastWriteTime -Descending |
    Select-Object -Skip 10 |
    Remove-Item

"Log Started @ $([DateTime]::Now.ToString('s')).  Running under process ID $($pid)" | Add-Content -Path $logPath

# Put each named argument into a dictionary.
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

foreach ($file in @(
$localFiles | Where-Object Name -Like '*.handler.ps1'
$localFiles | Where-Object Name -Like 'On_*.ps1'
)) {
    
    $scriptFile = $ExecutionContext.SessionState.InvokeCommand.GetCommand($file.Fullname, 'ExternalScript')
    $sourceIdentifier = $file.Name -replace '^On_' -replace '\.ps1$' -replace '\.handler$'
    Add-Content -Path $logPath -value "Registering Handler for '$sourceIdentifier': $($file.fullname)"
    $actionScriptBlock = [ScriptBlock]::Create("
        try { . '$($file.Fullname)' } catch {             
            `$err = `$_
            `$errorString = `$err | Out-String
            `$errorString | Add-Content -Path `$global:STREAMDECK_PLUGINLOGPATH
            if (-not `$IsLinux -or `$IsMac) {
                Start-Job -ScriptBlock {
                    (New-Object -ComObject WScript.Shell).Popup(`"`$args`",0,`"`StreamDeck - ProcessID: `$pid`", 16)
                } -ArgumentList `$errorString
            }
        }
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

"Log Stopped @ $([DateTime]::Now.ToString('s')).  Running under process ID $($pid)" | Add-Content -Path $logPath