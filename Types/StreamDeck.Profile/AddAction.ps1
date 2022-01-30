param(
[PSTypeName('StreamDeck.Action')]
$Action,

[int]
$Row = -1,

[int]
$Column = -1
)

$maxRows, $maxCols = $this.DeviceSize
$foundSpot = 
    if ($Row -lt 0) {
        :foundRow for ($r = 0; $r -lt $maxRows; $r++) {        
            if ($Column -lt 0) {
                for ($c =0 ; $c -lt $maxCols; $c++) {
                    if (-not $this.Actions."$c,$r") {
                        $r, $C
                        break foundRow
                    }
                }                           
            } else {
                if (-not $this.Actions."$Column,$r") {
                    $r, $Column
                    break foundRow
                }        
            }    
        }        
    } elseif ($Column -lt 0) {
        for ($c =0 ; $c -lt $maxCols; $c++) {
            if (-not $this.Actions."$c,$Row") {
                $Row, $c
                break
            }
        }
    } else {
        $row, $Column
    }


if (-not $foundSpot) {
    throw "Unable to find a location. Row: $row Column: $Column"
}

$r, $c = $foundSpot
Add-Member -MemberType NoteProperty "$c,$r" -Value $action -InputObject $this.Actions -Force