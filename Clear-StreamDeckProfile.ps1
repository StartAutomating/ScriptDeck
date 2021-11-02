function Clear-StreamDeckProfile
{
    <#
    .Synopsis
        Clears StreamDeck Profiles
    .Description
        Clears rows or columns from a StreamDeck profile.  By default, clears an entire profile.
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

    # One or more rows to clear
    [Parameter(ValueFromPipelineByPropertyName)]    
    [string[]]
    $Row,

    # One or more columns to clear
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $Column,

    # One or more action UUIDs to clear
    [Parameter(ValueFromPipelineByPropertyName)]
    [string[]]
    $UUID
    )

    

    begin {
        $sdProfiles = Get-StreamDeckProfile -ProfileRoot $ProfileRoot | 
            Where-Object Name -In $ProfileName

        if (-not $sdProfiles) {
            Write-Error "StreamDeck Profile $ProfileName not found"           
        }
    }

    process {
        if (-not $UUID -and -not $Row -and -not $Column) {
            $row, $Column = '*', '*'
        }

        if ($UUID) {
            foreach ($prof in $sdProfiles) {
                $prof.Actions.psobject.Properties |
                    Where-Object { $_.Value.UUID -in $UUID } | 
                    Select-Object -ExpandProperty Name | 
                    ForEach-Object { $c, $r = $_ -split ','; $Row += $r; $Column += $c }
            }
        }

        if ($Row -and $Column) {
            foreach ($prof in $sdProfiles) {
                foreach ($r in $row) {
                    foreach ($c in $Column) {
                        if ($PSCmdlet.ShouldProcess("Remove Action at $r, $c")) {
                            $prof.RemoveAction($R, $C)
                            $prof.Save()
                        }
                    }
                }                
            }
        }
    }
}
