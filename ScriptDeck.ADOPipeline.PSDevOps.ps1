#requires -Module PSDevOps
Push-Location $PSScriptRoot
New-ADOPipeline -Stage PowerShellStaticAnalysis, TestPowerShellCrossPlatform, UpdatePowerShellGallery |
    Set-Content .\ScriptDeck.azure-pipeline.yml -Encoding UTF8
Pop-Location

