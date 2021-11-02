param(
[Parameter(Mandatory)]
[string]
$Row,
[Parameter(Mandatory)]
[string]
$Column
)

$obj = $this
$toRemove = @($obj.actions.psobject.properties | Select-Object -ExpandProperty Name |
    Where-Object {
        $c, $r = $_ -split ','
        $colRow  = ''+  $c + "," + $r
        $colRow -like "$column,$Row"
    })

foreach ($tr in $toRemove) {
    $obj.actions.psobject.properties.Remove($tr)
}
