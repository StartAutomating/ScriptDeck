$args -join '
----
'| Out-Host

$args -join '
' | Set-Content ".\$(Get-Random).log"

$Port = $args[1]
$PluginUUID = $args[3]
$RegisterEvent = $args[5]
$Info = $args[7] | ConvertFrom-Json


