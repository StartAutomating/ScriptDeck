if (-not $event.MessageData.payload.settings) { return }

$settingsSplat = @{}
$command = $ExecutionContext.SessionState.InvokeCommand.GetCommand('Start-Process', 'Cmdlet')
foreach ($prop in $event.MessageData.payload.settings.psobject.properties) {
    if ($prop.Name -match '(?<n>.+)Script$' -and 
        $command.Parameters.($Matches.n)
        ) {
        $sb = try { [ScriptBlock]::Create($prop.Value) } catch { }

        if ($sb) {
            $settingsSplat[$command.Parameters[$Matches.n]] = & $sb
        }
    }
    elseif ($command.parameters.($prop.Name)) {
        $settingsSplat[$prop.Name] = $prop.Value
    }
}

foreach ($k in @($settingsSplat.Keys)) {
    if (-not $settingsSplat[$k]) {
        $settingsSplat.Remove($k)
    }
}

try {
    & $command @settingsSplat
    Send-StreamDeck -ShowOK -Context $event.MessageData.Context
} catch {
    Send-StreamDeck -ShowAlert -Context $event.MessageData.Context
    $_ | Out-GridView
}
