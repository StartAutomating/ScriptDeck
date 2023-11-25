<#
.SYNOPSIS
    Gets the last title change
.DESCRIPTION
    Gets the last change to the title of a ScriptDeck action.
#>
$this.History | 
    Where-Object { $_.MessageData.event -eq 'titleParametersDidChange' } |
    Select-Object -First 1 |
    ForEach-Object { $_.MessageData.Payload }
    