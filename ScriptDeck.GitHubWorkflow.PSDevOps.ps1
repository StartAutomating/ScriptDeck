#requires -Module PSDevOps
#requires -Module ScriptDeck
Import-BuildStep -ModuleName ScriptDeck
New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildScriptDeck -Environment @{    
    NoCoverage = $true
    ReleaseAsset = "*.streamDeckPlugin"
} |
    Set-Content .\.github\workflows\TestAndPublish.yml -Encoding UTF8 -PassThru
