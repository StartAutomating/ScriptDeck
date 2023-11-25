<#
.SYNOPSIS
    Gets the ActionID
.DESCRIPTION
    Gets the Action Identifier for a StreamDeck action.
#>
@($this.Action -split '\.')[-1]