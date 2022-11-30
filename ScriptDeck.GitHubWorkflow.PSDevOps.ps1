#requires -Module PSDevOps
#requires -Module ScriptDeck
Push-Location $PSScriptRoot

Import-BuildStep -ModuleName ScriptDeck

New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildScriptDeck -Environment @{    
    NoCoverage = $true
    ReleaseAsset = "*.streamDeckPlugin"
} -OutputPath .\.github\workflows\TestAndPublish.yml

Import-BuildStep -ModuleName GitPub

New-GitHubWorkflow -Job RunGitPub -On Demand, Issue -Name GitPub -OutputPath .\.github\workflows\RunGitPub.yml

Pop-Location