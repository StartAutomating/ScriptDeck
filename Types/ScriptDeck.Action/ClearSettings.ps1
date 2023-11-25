<#
.SYNOPSIS
    Clears action settings
.DESCRIPTION
    Clears all settings related to this ScriptDeck action
#>
$mySettings = $this.Settings
$toSet  = [Ordered]@{}
foreach ($settingsProperty in @($mySettings.psobject.properties)) {
    $toSet[$settingsProperty.Name] = $null
}
$this.Settings = $toSet
