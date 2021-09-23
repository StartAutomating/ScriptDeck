function Stop-StreamDeck
{
    <#
    .Synopsis
        Stops the StreamDeck application
    .Description
        Stops the StreamDeck application.  Attempts to gracefully exit plugins.
    .Example
        Stop-StreamDeck
    #>
    [OutputType([Diagnostics.Process])]
    param(
    # If set, will output the process
    [switch]
    $PassThru
    )
    
    $streamdeckprocess = Get-Process streamdeck -ErrorAction SilentlyContinue
    if (-not $streamdeckprocess) { 
        Start-StreamDeck -PassThru:$PassThru
        return 
    }
    $streamDeckPath    = "$($streamdeckprocess.Path)"
    if ($streamDeckPath) { 
        Start-Process -FilePath $streamDeckPath -ArgumentList '--quit' -Wait -PassThru:$PassThru
    }
        
    $streamdeckprocess = Get-Process streamdeck -ErrorAction SilentlyContinue
    Register-ObjectEvent -InputObject $streamdeckProcess -EventName Exited -Action ([ScriptBlock]::Create(@"
Write-Verbose 'StreamDeck Process Exited'
New-Event -SourceIdentifier StreamDeck.Stopped -MessageData ($(if ($PassThru) { "`$event.Sender"}))
"@)) |Out-Null

    Wait-Event -SourceIdentifier StreamDeck.Stopped | 
        ForEach-Object {
            if ($PassThru) {
                $_.MessageData
            }
        }
    
}

