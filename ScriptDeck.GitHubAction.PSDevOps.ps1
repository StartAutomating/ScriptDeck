#requires -Module PSDevOps
#requires -Module ScriptDeck
Import-BuildStep -ModuleName ScriptDeck

Push-Location $PSScriptRoot

New-GitHubAction -Name "BuildScriptDeck" -Description @'
Publish Plugins for StreamDeck
'@ -Action ScriptDeckAction -Icon film -OutputPath .\action.yml

Pop-Location
