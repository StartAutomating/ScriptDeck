function Add-StreamDeckProfile
{
    <#
    .Synopsis
        Adds StreamDeck Actions to profiles.
    .Description
        Adds a StreamDeck action to a profile.
    .Example
        @(
            New-StreamDeckAction -Title "Select Next Line" -HotKey "SHIFT+DOWN"
            New-StreamDeckAction -Title "Select Prev Line" -HotKey "SHIFT+UP"
        )  |            
            Add-StreamDeckProfile -ProfileName ISE_XL
    .Link
        New-StreamDeckAction
    .Link
        Get-StreamDeckAction
    .Link
        Get-StreamDeckProfile
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
    # The name of one or more profiles
    [Parameter(Mandatory)]
    [string[]]
    $ProfileName,

    # The root directory to look for profiles.    
    [string]
    $ProfileRoot,

    # The row the action will be added to.  If a negative number is provided, will choose the first available row.
    [Parameter(ParameterSetName='Profile',ValueFromPipelineByPropertyName)]    
    [int]
    $Row = -1,

    # The column the action will be added to.  If a negative number is provided, will choose the first available column.
    [Parameter(ParameterSetName='Profile',ValueFromPipelineByPropertyName)]    
    [int]
    $Column = -1,

    # The action to add to a StreamDeck profile.  
    # This is created using New-StreamDeckAction.
    [Parameter(Mandatory,ParameterSetName='Profile',ValueFromPipelineByPropertyName,ValueFromPipeline)]
    [PSTypeName('StreamDeck.Action')]
    [PSObject]
    $Action
    )

    begin {
        $sdProfiles = Get-StreamDeckProfile -ProfileRoot $ProfileRoot | 
            Where-Object Name -In $ProfileName

        if (-not $sdProfiles) {
            Write-Error "StreamDeck Profile $ProfileName not found"           
        }
    }
    process {
        #region Add Actions to Profiles
        foreach ($prof in $sdProfiles) {
            if ($PSCmdlet.ShouldProcess("Add Action at $row, $column")) {            
                $prof.AddAction($Action, $Row, $Column)
                $prof.Save()
            }
        }
        #endregion Add Actions to Profiles
    }
}
