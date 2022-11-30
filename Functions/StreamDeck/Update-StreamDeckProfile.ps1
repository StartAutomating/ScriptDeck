function Update-StreamDeckProfile
{
    <#
    .Synopsis
        Updates a StreamDeck profile
    .Description
        Updates a StreamDeck profile
    .Example    
        $vsCodeProfile = Get-StreamDeckProfile -Name VSCode
        $defaultProfile = Get-streamDeckProfile -Name "Default Profile" |
            Where-Object DeviceName -eq StreamDeckXL

        Update-StreamDeckProfile -Name VSCode -Action @{
            "0,0" =
                New-StreamDeckAction -ProfileName $defaultProfile.Guid -DeviceUUID $defaultProfile.DeviceUUID -Image C:\Users\JamesBrundage\Pictures\Gif\CountryHome.gif

            "0,1" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "issues:github.focus"
                } -name "Execute Command" -Title ("GitHub", "Issues" -join [Environment]::newline)
            "0,2" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
                    command = "git pull"
                } -name "Execute Command" -Title ("git", "pull" -join [Environment]::newline)    
            "0,3" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
                    command = "git push"
                } -name "Execute Command" -Title ("git", "push" -join [Environment]::newline)
            "0,4" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executeterminalcommand -Setting @{
                    command = "git status"
                } -name "Execute Command" -Title ("git", "status" -join [Environment]::newline)
                
            "0,6" = 
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.debug.viewlet.action.removeAllBreakpoints"
                } -name "Execute Command" -Title ("Remove","All", "Breakpoints" -join [Environment]::newline)
            
            "0,7" = 
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.action.closeAllEditors"
                } -name "Execute Command" -Title "Close All"


            "1,0" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.action.toggleSidebarVisibility"
                } -name "Execute Command" -Title ("toggle", "sidebar" -join [Environment]::newline)
            "1,7" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.files.action.focusFilesExplorer"
                } -name "Execute Command" -Title "Files"
            
            "2,0" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.action.toggleScreencastMode"
                } -name "Execute Command" -Title "ScreenCast"
                
            "2,7" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.files.action.collapseExplorerFolders"
                } -name "Execute Command" -Title ("collapse", "folders" -join [Environment]::newline)
            "3,0" = 
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.action.toggleZenMode"
                } -name "Execute Command" -Title "zen"
            "3,1" =
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "workbench.action.toggleEditorVisibility"
                } -name "Execute Command" -Title ("toggle", "editor" -join [Environment]::newline)
            
            "3,7" = 
                New-StreamDeckAction -UUID com.nicollasr.streamdeckvsc.executecommand -Setting @{
                    command = "editor.action.formatDocument"
                } -name "Execute Command" -Title "format"
                
            "7,3" = $null
        }
    .Link
        Get-StreamDeckProfile
    .Link
        Remove-StreamDeckProfile
    .Link
        Save-StreamDeckProfile
    .Link
        New-StreamDeckProfile
    #>
    [OutputType('StreamDeck.Profile')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification="Does not change state")]
    param(
    # The name of the profile
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Name,

    # A collection of actions.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    [ValidateScript({
        foreach ($k in $_.Keys) {
            if ($k -notmatch '\d+,\d+') {
                throw "Action keys must be in the form row, column (e.g. 0,2)."
            }
        }
        return $true
    })]
    $Action,
    
    # The profile UUID.  If not provided, a GUID will be generated.
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('guid')]
    [string]
    $ProfileUUID,

    [string]
    $DeviceType
    )    


    process {        
        $streamDeckProfiles = 
            if ($_ -and $_.pstypenames -contains 'StreamDeck.Profile') {
                $_
            } elseif ($ProfileUUID) {
                Get-StreamDeckProfile -Recurse | Where-Object Guid -eq $ProfileUUID
            } elseif ($name) {
                Get-StreamDeckProfile | Where-Object Name -eq $name
            }

        if ($streamDeckProfiles -is [Object[]] -and $DeviceType) {
            $streamDeckProfiles = $streamDeckProfiles | Where-Object DeviceType -eq $DeviceType
        }

        foreach ($streamDeckProfileObject in $streamDeckProfiles) {
            #region Map Actions
            foreach ($act in $Action.GetEnumerator()) {
                if (-not $act.Value) {
                    $streamDeckProfileObject.RemoveAction.Invoke(@($act.Key -split ','))                    
                } else {
                    $streamDeckProfileObject.AddAction.Invoke(@(
                        $act.Value
                        $act.Key -split ','
                    ))
                }                
            }            
            #endregion Map Actions

            $streamDeckProfileObject
            $streamDeckProfileObject.Save()
        }        
    }
}