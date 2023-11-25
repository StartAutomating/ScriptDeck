<#
.SYNOPSIS
    Gets settings for an action
.DESCRIPTION
    Gets the settings for a StreamDeck action
.NOTES
    If the action is updated manually, these may be out of sync.
#>
param()

if ($this.Payload.Settings) {
    $this.Payload.Settings
}
