<#
.SYNOPSIS
    Set StreamDeck action settings
.DESCRIPTION
    Changes the settings for a StreamDeck action
#>
param(
# Any updated settings
$Value
)

if ($Value) {
    if ($value -is [Collections.IDictionary]) {
        foreach ($kv in $Value.GetEnumerator()) {
            $settingValue = $kv.Value
            if ($settingValue -is [scriptblock]) {
                $settingValue = "$settingValue"
            }
            $this.Payload.Settings | Add-Member NoteProperty $kv.Key $kv.Value -Force
        }
    } elseif ($value -isnot [Object[]]) {
        foreach ($prop in $value.psobject.properties) {
            $settingValue = $kv.Key
            if ($settingValue -is [scriptblock]) {
                $settingValue = "$settingValue"
            }
            $this.Payload.Settings | Add-Member NoteProperty $kv.Name $kv.Value -Force
        }
    }
}

$exportPath = Join-Path ($this.Plugin.PluginPath | Split-Path) -ChildPath "$($this.Context).setSettings.Send-StreamDeck.clixml"
Export-Clixml -InputObject @{
    Context = $this.Context
    EventName = 'setSettings'
    Payload = $this.Payload.Settings
} -Path $exportPath

# Send-StreamDeck -Context $event.MessageData.Context -EventName setSettings -Payload $newSettings