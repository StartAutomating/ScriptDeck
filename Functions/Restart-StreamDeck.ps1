function Restart-StreamDeck
{
    <#
    .Synopsis
        Restarts the StreamDeck application
    .Description
        Stops the StreamDeck application, waits for it to exit, and launches a new process
    .Link
        Start-StreamDeck
    .Example
        Restart-StreamDeck
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
Write-Verbose 'Process Exited, Starting a new one'
New-Event -SourceIdentifier StreamDeck.Restarted -MessageData (Start-Process '$($streamdeckprocess.Path)' $(if ($PassThru) { '-PassThru'}))
"@)) |Out-Null

    Wait-Event -SourceIdentifier StreamDeck.Restarted | 
        ForEach-Object {
            if ($PassThru) {
                $_.MessageData
            }
        }
    
}
