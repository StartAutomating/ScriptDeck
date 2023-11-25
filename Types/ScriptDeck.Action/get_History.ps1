<#
.SYNOPSIS
    Gets a ScriptDeck action's history
.DESCRIPTION
    Gets all events related to a particular ScriptDeck action,
    from most recent to least recent.
#>
param()

$foundFiles = @(Get-ChildItem -Path (Split-Path $this.Plugin.PluginPath) -Filter "*.$($this.Context).received.clixml")

if ($this.'.HistoryFileCount' -ne $foundFiles.Length) {
    $foundFiles = @($foundFiles | Sort-Object LastWriteTime -Descending)
    $updatedHistory = @(
        if (-not $this.'.History' -or ($this.'.History'.Length -lt $foundFiles.Length)) {
            foreach ($foundFile in $foundFiles) {
                Import-Clixml -Path $foundFile.FullName
            }
        }
        else {
            foreach ($foundFile in $foundFiles[0..($foundFiles.Length - $this.'.History'.Length)]) {
                Import-Clixml -Path $foundFile.FullName
            }            
        }        
    )
    

    $this | Add-Member NoteProperty '.HistoryFileCount' $foundFiles.Length -Force
    $this | Add-Member NoteProperty '.History' $updatedHistory -Force
}

$this.'.History'