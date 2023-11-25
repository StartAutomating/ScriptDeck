<#
.SYNOPSIS
    Gets the device name
.DESCRIPTION
    Gets the friendly name of the StreamDeck device associated to an action.
#>
if (-not $this.'.DeviceInfo') {
    if (-not $script:streamDeckDevices) {
        $script:streamDeckDevices = (Get-ScriptDeck).StreamDeckDevices
    }
    
    $this | Add-Member NoteProperty '.DeviceInfo' ($script:streamDeckDevices | Where-Object DeviceID -eq $this.device) -Force
}

$this.'.DeviceInfo'.Name