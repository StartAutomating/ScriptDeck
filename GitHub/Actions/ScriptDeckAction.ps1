<#
.Synopsis
    GitHub Action for ScriptDeck
.Description
    GitHub Action for ScriptDeck.  This will:

    * Run all *.ScriptDeck.ps1 files beneath the workflow directory
    * Run a .ScriptDeckScript parameter.
    * Attempt an export of all *.sdplugin directories benath the workflow directory

    Any files changed can be outputted by the script, and those changes can be checked back into the repo.
    Make sure to use the "persistCredentials" option with checkout.
#>

param(
# A PowerShell Script that uses ScriptDeck.  
# Any files outputted from the script will be added to the repository.
# If those files have a .Message attached to them, they will be committed with that message.
[string]
$ScriptDeckScript,

# If set, will not process any files named *.ScriptDeck.ps1
[switch]
$SkipScriptDeckPS1,

# If set, will not export any *.sdplugin directories as StreamDeck plugins.
[switch]
$SkipStreamDeckPluginExport,

# If provided, will commit any remaining changes made to the workspace with this commit message.
[string]
$CommitMessage,

# The user email associated with a git commit.
[string]
$UserEmail,

# The user name associated with a git commit.
[string]
$UserName
)



"::group::Parameters" | Out-Host
[PSCustomObject]$PSBoundParameters | Format-List | Out-Host
"::endgroup::" | Out-Host

$gitHubEvent = if ($env:GITHUB_EVENT_PATH) {
    [IO.File]::ReadAllText($env:GITHUB_EVENT_PATH) | ConvertFrom-Json
} else { $null }

@"
::group::GitHubEvent
$($gitHubEvent | ConvertTo-Json -Depth 100)
::endgroup::
"@ | Out-Host

$PSD1Found = Get-ChildItem -Recurse -Filter "*.psd1" | Where-Object Name -eq 'ScriptDeck.psd1' | Select-Object -First 1

if ($PSD1Found) {
    $ScriptDeckModulePath = $PSD1Found
    Import-Module $PSD1Found -Force -PassThru | Out-Host
} elseif ($env:GITHUB_ACTION_PATH) {
    $ScriptDeckModulePath = Join-Path $env:GITHUB_ACTION_PATH 'ScriptDeck.psd1'
    if (Test-path $ScriptDeckModulePath) {
        Import-Module $ScriptDeckModulePath -Force -PassThru | Out-String
    } else {
        throw "ScriptDeck not found"
    }
} elseif (-not (Get-Module ScriptDeck)) {    
    throw "Action Path not found"
}

$anyFilesChanged = $false
$processScriptOutput = { process { 
    $out = $_
    $outItem = Get-Item -Path $out -ErrorAction SilentlyContinue
    $fullName, $shouldCommit = 
        if ($out -is [IO.FileInfo]) {
            $out.FullName, (git status $out.Fullname -s)
        } elseif ($outItem) {
            $outItem.FullName, (git status $outItem.Fullname -s)
        }
    if ($shouldCommit) {
        git add $fullName
        if ($out.Message) {
            git commit -m "$($out.Message)"
        } elseif ($out.CommitMessage) {
            git commit -m "$($out.CommitMessage)"
        }
        elseif ($CommitMessage) {
            git commit -m $CommitMessage   
        }
        elseif ($gitHubEvent.head_commit.message) {
            git commit -m "$($gitHubEvent.head_commit.message)"
        }        
        $anyFilesChanged = $true
    }
    $out
} }

"::notice title=ModuleLoaded::ScriptDeck Loaded from Path - $($ScriptDeckModulePath)" | Out-Host

if (-not $UserName)  {
    $UserName =  
        if ($env:GITHUB_TOKEN) {
            Invoke-RestMethod -uri "https://api.github.com/user" -Headers @{
                Authorization = "token $env:GITHUB_TOKEN"
            } |
                Select-Object -First 1 -ExpandProperty name
        } else {
            $env:GITHUB_ACTOR
        }
}

if (-not $UserEmail) { 
    $GitHubUserEmail = 
        if ($env:GITHUB_TOKEN) {
            Invoke-RestMethod -uri "https://api.github.com/user/emails" -Headers @{
                Authorization = "token $env:GITHUB_TOKEN"
            } |
                Select-Object -First 1 -ExpandProperty email
        } else {''}
    $UserEmail = 
        if ($GitHubUserEmail) {
            $GitHubUserEmail
        } else {
            "$UserName@github.com"
        }    
}

if (-not $UserName) { $UserName = $env:GITHUB_ACTOR }
if (-not $UserEmail) { $UserEmail = "$UserName@github.com" }
git config --global user.email $UserEmail
git config --global user.name  $UserName

if (-not $env:GITHUB_WORKSPACE) { throw "No GitHub workspace" }

# Check to ensure we are on a branch
$branchName = git rev-parse --abrev-ref HEAD
# If we were not, return.
if (-not $branchName) {  return }

git pull | Out-Host

$ScriptDeckScriptStart = [DateTime]::Now
if ($ScriptDeckScript) {
    Invoke-Expression -Command $ScriptDeckScript |
        . $processScriptOutput |
        Out-Host
}
$ScriptDeckScriptTook = [Datetime]::Now - $ScriptDeckScriptStart
# "::set-output name=ScriptDeckScriptRuntime::$($ScriptDeckScriptTook.TotalMilliseconds)"   | Out-Host

$ScriptDeckPS1Start = [DateTime]::Now
$ScriptDeckPS1List  = @()
if (-not $SkipScriptDeckPS1) {
    Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE |
        Where-Object Name -Match '\.ScriptDeck\.ps1$' |
        
        ForEach-Object {
            $ScriptDeckPS1List += $_.FullName.Replace($env:GITHUB_WORKSPACE, '').TrimStart('/')
            $ScriptDeckPS1Count++
            "::notice title=Running::$($_.Fullname)" | Out-Host
            . $_.FullName |            
                . $processScriptOutput  | 
                Out-Host
        }
}


if (-not $SkipStreamDeckPluginExport) {
    Get-ChildItem -Recurse -Path $env:GITHUB_WORKSPACE -Directory |
        Where-Object Name -Match '\.sdPlugin$' |
        Export-StreamDeckPlugin -Force |
        Add-Member CommitMessage "Exporting StreamDeck Plugin [skip ci]" -Force -PassThru |
        . $processScriptOutput
}


$ScriptDeckPS1EndStart = [DateTime]::Now
$ScriptDeckPS1Took = [Datetime]::Now - $ScriptDeckPS1Start
# "::set-output name=ScriptDeckPS1Count::$($ScriptDeckPS1List.Length)"   | Out-Host
# "::set-output name=ScriptDeckPS1Files::$($ScriptDeckPS1List -join ';')"   | Out-Host
# "::set-output name=ScriptDeckPS1Runtime::$($ScriptDeckPS1Took.TotalMilliseconds)"   | Out-Host
if ($CommitMessage -or $anyFilesChanged) {
    if ($CommitMessage) {
        dir $env:GITHUB_WORKSPACE -Recurse |
            ForEach-Object {
                $gitStatusOutput = git status $_.Fullname -s
                if ($gitStatusOutput) {
                    git add $_.Fullname
                }
            }

        git commit -m $ExecutionContext.SessionState.InvokeCommand.ExpandString($CommitMessage)
    }

    
    "::notice::Pushing Changes" | Out-Host
    $checkDetached = git symbolic-ref -q HEAD
    if (-not $LASTEXITCODE) {
        "::notice::Pulling Changes" | Out-Host
        git pull | Out-Host
        "::notice::Pushing Changes" | Out-Host
        git push | Out-Host
        "Git Push Output: $($gitPushed  | Out-String)"
    } else {
        "::notice::Not pushing changes (on detached head)" | Out-Host
        $LASTEXITCODE = 0
        exit 0
    }
    
    
    "Git Push Output: $($gitPushed  | Out-String)"
}

