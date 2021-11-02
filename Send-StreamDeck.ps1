function Send-StreamDeck {
    <#
    .Synopsis
        Sends messages to a StreamDeck
    .Description
        Sends messages to a StreamDeck.  
        
        This function will often be used within StreamDeck plugins.
    .Link
        Receive-StreamDeck
    .Link
        https://developer.elgato.com/documentation/stream-deck/sdk/events-sent/
    #>
    [CmdletBinding(SupportsShouldProcess,DefaultParameterSetName='EventName')]
    param(
    # The name of the event
    [Parameter(Mandatory,Position=0,ValueFromPipelineByPropertyName,ParameterSetName='EventName')]
    [Alias('Event')]
    [string]
    $EventName,

    # The event payload.
    [Parameter(Position=2,ParameterSetName='EventName',ValueFromPipelineByPropertyName)]
    [PSObject]
    $Payload,

    # If set, will send a showOk event to the Stream Deck application.
    # This will temporarily show an OK checkmark icon on the image displayed by an instance of an action.
    [Parameter(Mandatory,ParameterSetName='showOK',ValueFromPipelineByPropertyName)]
    [switch]
    $ShowOK,

    # If set, will send a showOk event to the Stream Deck application.
    # This will temporarily show an alert icon on the image displayed by an instance of an action.
    [Parameter(Mandatory,ParameterSetName='showAlert',ValueFromPipelineByPropertyName)]
    [switch]
    $ShowAlert,

    # If set, will send an openURL event to the Stream Deck application.
    # This will temporarily show an alert icon on the image displayed by an instance of an action.
    [Parameter(Mandatory,ParameterSetName='openURL',ValueFromPipelineByPropertyName)]
    [uri]
    $OpenURL,

    # If set, will send an openURL event to the Stream Deck application.
    # This will temporarily show an alert icon on the image displayed by an instance of an action.
    [Parameter(Mandatory,ParameterSetName='logMessage',ValueFromPipelineByPropertyName)]
    [string]
    $LogMessage,

    # If provided will send a showImage event to the Stream Deck application using the contents of the file in ImagePath
    [Parameter(Mandatory,ParameterSetName='setImage',ValueFromPipelineByPropertyName)]
    [Alias('Fullname')]
    [string]
    $ImagePath,

    # The state index of an image or title.  Defaults to zero.
    [Parameter(ParameterSetName='setTitle',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='setImage',ValueFromPipelineByPropertyName)]
    [int]
    $State = 0,

    # The target of a title or image change.  Valid values are
    [Parameter(ParameterSetName='setTitle',ValueFromPipelineByPropertyName)]
    [Parameter(ParameterSetName='setImage',ValueFromPipelineByPropertyName)]
    [ValidateSet('both','hardware', 'software')]
    [string]
    $EventTarget = 'both',

    # The event context.  
    # If not provided, the global variable STREAMDECK_CONTEXT will be used
    [Parameter(Position=3,ValueFromPipelineByPropertyName)]
    [string]
    $Context,

    # The maximum amount of time to wait for a WebSocket to open.  By default, 30 seconds.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Timespan]
    $WaitFor      = '00:00:30',

    # The interval to wait while receiving a message.  By default, 11 milliseconds.
    [TimeSpan]$WaitInterval = '00:00:00.011',

    # The web socket.
    # If not provided, the global variable STREAMDECK_WEBSOCKET will be used.
    [Parameter(Position=4,ValueFromPipelineByPropertyName)]
    [Net.WebSockets.ClientWebSocket]
    $Websocket,

    # The web socket.
    # If not provided, the global variable STREAMDECK_WEBSOCKET will be used.
    [Parameter(Position=4,ValueFromPipelineByPropertyName)]
    [int]
    $Port,

    # The plugin UUID.  This is used in plugin registration.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName,ParameterSetName='registerPlugin')]
    [string]
    $PluginUUID
    )
    process {
        # If no -WebSocket was provided, use the $global:STREAMDECK_WEBSOCKET
        if (-not $Websocket -and $Global:STREAMDECK_WEBSOCKET) {
            $Websocket = $Global:STREAMDECK_WEBSOCKET 
        }

        # A number of different parameter sets are named to reflect the EventName StreamDeck expects.
        # If we find an argument that hints that this is true
        if ($ShowOK -or $ShowAlert -or $OpenURL -or $LogMessage -or $ImagePath) {
            $EventName = $PSCmdlet.ParameterSetName # set -EventName to the $psCmdlet.ParameterSetName.
        }

        if ($OpenURL) { # If we're going to -OpenURL, 
            $Payload = @{url="$OpenURL"} # the payload is a single property, URL.
        }

        if ($LogMessage) { # If we're going to -LogMessage
            $Payload = @{message=$LogMessage} # the payload is a single property, message.
        }
        
        if ($ImagePath) { # If we're going to send an image,            
            # find the file
            $resolvedPath = $ExecutionContext.SessionState.Path.GetResolvedPSPathFromPSPath($ImagePath) 
            if (-not $resolvedPath) { return } 
            $resolvedItem = Get-Item -LiteralPath $resolvedPath 
            if (-not $resolvedItem) { return } 
            # and check that it actually is an image.
            $imageExtensions = '.svg','.png','.jpg','.gif','.bmp'
            if ($resolvedItem.Extension -notin $imageExtensions) {
                Write-Error "-ImagePath '$ImagePath' has an invalid extension. Valid extensions are: $imageExtensions"
                return
            }
            # Ensure that -EventTarget is lowercase and create a payload with the image data.
            $eventTarget = $EventTarget.ToLower()
            if ($resolvedItem.Extension -eq '.svg') { # If the image was an SVG,
                $Payload = [Ordered]@{
                    image = "data:image/svg+xml;charset=utf8,$( # it will be inline UTF8 text
                        [IO.File]::ReadAllText($resolvedItem.FullName, [Text.Encoding]::UTF8)
                    )"
                    target = $eventTarget
                    state  = $State
                }
            } else {
                $Payload = [Ordered]@{ # Otherwise, it's base64 binary.
                    image = "data:image/$($resolvedItem.Extension.TrimStart('.'));base64,$(
                        [Convert]::ToBase64String([IO.File]::ReadAllBytes($resolvedItem.FullName))
                    )"
                    target = $eventTarget
                    state  = $State
                }
            }
        }

        # If no one provided a -Context but $Global:STREAMDECK_CONTEXT is set,
        if ((-not $Context) -and $Global:STREAMDECK_CONTEXT) { 
            $Context = $Global:STREAMDECK_CONTEXT # use that.
        }
        
        $WebSocketPayload = @{
            event   = $EventName
            context = $Context
            payload = $Payload
        }        

        if (-not $WebSocketPayload.payload -or $WebSocketPayload.payload.count -eq 0) { # If the payload was blank
            $WebSocketPayload.Remove('payload') # remove it
        }
        if (-not $WebSocketPayload.context) { # If the context was blank,
            $WebSocketPayload.Remove('context') # remove it.
        }
        if ($PluginUUID) { # If we've got a plugin UUID, 
            $WebSocketPayload.uuid = $PluginUUID # set .uuid
        }
        if ($WhatIfPreference) { # If -WhatIf was passed
            return $WebSocketPayload # return the payload.
        }
        
        # If -Confirm was passed, and they chose not to send this payload, return.
        if (-not $PSCmdlet.ShouldProcess("Send $($WebSocketPayload | ConvertTo-json)")) {  return  }

        # If we don't have a context or a pluginUUID:
        if (-not $Context -and -not $PluginUUID) {
            Write-Error "Must provide -Context" -ErrorId Context.Missing -Category InvalidArgument # error out.
            return
        }

        if (-not $Websocket ){ # If we don't have a websocket:
            Write-Error "Must provide a -WebSocket" -ErrorId WebSocket.Missing -Category ConnectionError # error out.
            return
        }
        
                
        $PayloadJson  = $WebSocketPayload | ConvertTo-Json -Depth 100   # Construct the payload
        $SendSegment  = [ArraySegment[Byte]]::new([Text.Encoding]::UTF8.GetBytes($PayloadJson))        
        $SendTask     = $Websocket.SendAsync($SendSegment, 'Binary', $true, 
                            [Threading.CancellationToken]::new($false)) # send it
        while (!$SendTask.IsCompleted) { # and wait for it to be sent.
            Start-Sleep -Milliseconds $WaitInterval.TotalMilliseconds
        }
    }
}