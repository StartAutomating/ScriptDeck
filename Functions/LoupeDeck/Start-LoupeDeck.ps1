function Start-LoupeDeck
{
    <#
    .Synopsis
        Starts Loupedeck
    .Description
        Starts the LoupeDeck application.
    .Example
        Start-LoupeDeck    
    .Link
        Stop-LoupeDeck
    .LINK
        Restart-LoupeDeck
    #>
    param(
    # The Path to LoupeDeck.  
    # If this parameter is not provided, this will attempt to launch Loupedeck from the default installation folder.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $LoupeDeckPath,

    # If set, will output the created process.
    [switch]
    $PassThru
    )

    process {
        if (-not $loupeDeckPath) {
            $loupeDeckProcess = Get-Process Loupedeck* -ErrorAction SilentlyContinue | Select-Object -First 1
            $loupeDeckPath =
                if ($loupeDeckProcess) {
                    $loupeDeckProcess.Path
                } elseif ((-not $PSVersionTable.Platform) -or ($PSVersionTable.Platform -match 'Win')) {
                    "${env:ProgramFiles(x86)}\Loupedeck\Loupedeck2\Loupedeck2.exe"
                } elseif ($PSVersionTable.Platform -eq 'Unix' -and $PSVersionTable.OS -like '*darwin*') {
                    " /Applications/Loupedeck.app/Contents/Resources/LoupedeckServiceTool.app”
                }            
        }

        if (-not $loupeDeckPath) {
            Write-Error "Could not automatically detect a -LoupeDeckPath."
            return
        } else {
            $serviceToolPath = 
                $loupeDeckPath | Split-Path | Join-Path -ChildPath $(
                    if ($IsMacOS) {
                        "LoupedeckServiceTool.app"
                    } else {
                        "LoupedeckServiceTool.exe"
                    }
                )
            $serviceToolArgs = @(
                if ($IsMacOS) {
                    "--args"
                }
                "start"
            )
            & $serviceToolPath @serviceToolArgs
        }
    }
}
