function Receive-StreamDeck {    
    <#
    .Synopsis
        Receives messages from a StreamDeck
    .Description
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
    .Link
        Send-StreamDeck
    .Link
        https://developer.elgato.com/documentation/stream-deck/sdk/events-received/
    #>
    param(
    # The registration event. This is used in plugin registration.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $RegisterEvent,

    # The plugin UUID.  This is used in plugin registration.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $PluginUUID,

    # The port.
    [Parameter(ValueFromPipelineByPropertyName)]
    [int]
    $Port,

    # The web socket.
    # If not provided, the $GLOBAL:STREAMDECK_WEBSOCKET will be used.
    # If $GLOBAL:STREAMDECK_WEBSOCKET has not been set, one will be created using -Port.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Net.WebSockets.ClientWebSocket]
    $Websocket,

    # The buffer size for received messages.  By default: 16 kilobytes.
    [int]$BufferSize = 16kb,

    # The maximum amount of time to wait for a WebSocket to open.  By default, 30 seconds.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Timespan]
    $WaitFor      = '00:00:30',

    # The interval to wait while receiving a message.  By default, 17 milliseconds.
    [TimeSpan]$WaitInterval = '00:00:00.017',

    # The output type.  Default is 'Data' Can be:
    # * Data    (the JSON event data)
    # * Event   (the PowerShell events)
    # * Message (the JSON message)
    # * None
    [ValidateSet('Data', 'Event','Message','None')]
    [string]$OutputType = 'Data',

    # If set, will watch the streamdeck in a background job.
    [switch]
    $AsJob
    )

    begin {
        if (-not $Global:STREAMDECK_DEVICES) {
            $Global:STREAMDECK_DEVICES = @{}
        }
        if (-not $Global:STREAMDECK_BUTTONS) {
            $Global:STREAMDECK_BUTTONS = @{}
        }
        if (-not $Global:STREAMDECK_SETTINGS) {
            $Global:STREAMDECK_SETTINGS = @{}
        }
    }

    process {
        if ($AsJob) {
            $myParams = @{} + $PSBoundParameters
            $myParams.Remove('AsJob')
            $myDef = [ScriptBlock]::Create(@"
param([Hashtable]`$params)
function $($MyInvocation.InvocationName) {
    $($MyInvocation.MyCommand.ScriptBlock)
}
$($MyInvocation.InvocationName) @params
"@)            
            Start-Job -Name $MyInvocation.MyCommand.Name -ArgumentList $myParams -ScriptBlock $myDef
            return
        }

        if (-not $Websocket -and $Global:STREAMDECK_WEBSOCKET -and 
            $Global:STREAMDECK_WEBSOCKET.State -ne 'Closed') {
            $Websocket = $Global:STREAMDECK_WEBSOCKET
        }

        if ($Websocket.State -like 'Close*' -or $Websocket.State -eq 'Aborted') {
            $Websocket = $null
        }

        if (-not $Websocket -and $Port) {
            
            $global:STREAMDECK_WEBSOCKET = $Websocket   = [Net.WebSockets.ClientWebSocket]::new()
            $ConnectTask = $Websocket.ConnectAsync("ws://$([IPAddress]::Loopback):$port", [Threading.CancellationToken]::new($false))
            $maxWaitTime = [DateTime]::Now + $WaitFor
            while (!$ConnectTask.IsCompleted -and [DateTime]::Now -lt $maxWaitTime) {
                Start-Sleep -Milliseconds $WaitInterval.TotalMilliseconds
            }
        }
        
        if (-not $Websocket) {
            Write-Error "Must provide a -WebSocket or -Port" -ErrorId WebSocket.Missing -Category ConnectionError
            return
        }

        $forwardedEvents = @{}
        Get-EventSubscriber | Where-Object ForwardEvent | ForEach-Object {
            $forwardedEvents[$_.SourceIdentifier] = $_
        }

        if ($PluginUUID -and $RegisterEvent) {
            $PayloadJson  = @{event=$RegisterEvent;uuid=$PluginUUID} | ConvertTo-Json -Depth 100
            $SendSegment  = [ArraySegment[Byte]]::new([Text.Encoding]::UTF8.GetBytes($PayloadJson))
            $SendTask     = $Websocket.SendAsync($SendSegment, 'Binary', $true, [Threading.CancellationToken]::new($false))
            while (-not $SendTask.IsCompleted) {
                Start-Sleep -Milliseconds $WaitInterval.TotalMilliseconds
            }
        }
        
        try {
            while ($true) {
                # Create a buffer for the response
                $buffer = [byte[]]::new($BufferSize)
                $receiveSegment = [ArraySegment[byte]]::new($buffer)
                if (!($Websocket.State -eq 'Open')) {
                    throw 'Websocket is not open anymore. {0}' -f $Websocket.State
                }
                # Receive the next response from the WebSocket,
                $receiveTask = $Websocket.ReceiveAsync($receiveSegment, [Threading.CancellationToken]::new($false))
                # then wait for it to complete.
                while (-not $receiveTask.IsCompleted) { Start-Sleep -Milliseconds $WaitInterval.TotalMilliseconds }
                $streamDeckMsg    = # Get the response and trim with extreme prejudice.
                    [Text.Encoding]::UTF8.GetString($buffer, 0, $receiveTask.Result.Count).Trim() -replace '\s+$'
                if ($OutputType -eq 'Message') { $streamDeckMsg }
                # Convert the response from JSON
                $streamDeckData   = try { $streamDeckMsg | ConvertFrom-Json -ErrorAction SilentlyContinue } catch { $null }

                if ($streamDeckData.event -eq 'deviceDidConnect') {                    
                    # Add-Member -InputObject $streamDeckData.deviceInfo -Name DeviceID -Value $streamDeckData.device
                    
                    
                    $Global:STREAMDECK_DEVICES[$streamDeckData.device] = [PSCustomObject][Ordered]@{
                        Name=$streamDeckData.deviceInfo.name
                        DeviceID = $streamDeckData.device
                        Size = [PSCustomObject][Ordered]@{
                            Columns = $streamDeckData.device.size.columns
                            Rows = $streamDeckData.device.size.rows
                        }
                        Type = $streamDeckData.type
                    }
                }
                elseif ($streamDeckData.event -eq 'deviceDidDisconnect') {
                    $Global:STREAMDECK_DEVICES.Remove($streamDeckData.device)
                }

                

                if ($streamDeckData.event -eq 'WillAppear') {
                    $coordinates  = $streamDeckData.payload.coordinates
                    $ctx = "$(
                        $streamDeckData.device
                    )@$($coordinates.Column),$($coordinates.Row)"

                    $Global:STREAMDECK_BUTTONS[$ctx] = [PSCustomObject][Ordered]@{
                        Row = $streamDeckData.payload.coordinates.row
                        Column = $streamDeckData.payload.coordinates.column
                        Settings = $streamDeckData.payload.settings
                        Key = $ctx
                        Context = $streamDeckData.context
                        State = $streamDeckData.payload.state
                        IsInMultiAction = $streamDeckData.payload.isInMultiAction
                        Device = $Global:STREAMDECK_DEVICES[$streamDeckData.device]
                    }
                    if ($VerbosePreference -ne 'silentlycontinue') {
                        Write-Verbose ($Global:STREAMDECK_BUTTONS[$ctx] | Out-String)
                    }
                } elseif ($streamDeckData.event -eq 'WillDisappear') {
                    $coordinates  = $streamDeckData.payload.coordinates
                    $ctx = "$(
                        $streamDeckData.device
                    )@$($coordinates.Column),$($coordinates.Row)"
                    $Global:STREAMDECK_BUTTONS.Remove($ctx)
                }
                

                if ($streamDeckData.Context) {
                    $Global:STREAMDECK_CONTEXT = $streamDeckData.Context
                    if ($streamDeckData.event -eq 'willAppear') {
                        # WillAppear events tell us when a given button has been mapped.                        
                    }                    
                }
                if ($OutputType -eq 'Data') { $streamDeckData}
                $streamDeckEvent  = @(
                    $sid = "StreamDeck.$($streamDeckData.event)"
                    if (-not $forwardedEvents[$sid]) {
                        $forwardedEvents[$sid] = Register-EngineEvent -SourceIdentifier $sid -Forward
                    }
                    New-Event -SourceIdentifier $sid -MessageData $streamDeckData
                    if ($streamDeckData.action) {
                        $actionSid = "$($streamDeckData.action).$($streamDeckData.event)"
                        if (-not $forwardedEvents[$actionSid]) {
                            $forwardedEvents[$sid] = Register-EngineEvent -SourceIdentifier $actionSid -Forward
                        }

                        $coordinates  = $streamDeckData.payload.coordinates
                        $ctx = "$($streamDeckData.device)@$($coordinates.Column),$($coordinates.Row)"
                        New-Event -SourceIdentifier "$($streamDeckData.action).$($streamDeckData.event)" -MessageData $streamDeckData -Sender $Global:STREAMDECK_BUTTONS[$ctx]
                    }
                )
                if ($OutputType -eq 'Event') { $streamDeckEvent}
                                               
                $buffer.Clear()
            }

        } catch {
            Write-Error -Exception $_.Exception -Message "StreamDeck Exception: $($_ | Out-String)" -ErrorId "WebSocket.State.$($Websocket.State)"
        }        
    }
}
