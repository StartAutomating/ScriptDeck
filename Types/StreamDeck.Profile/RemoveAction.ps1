param(
[Parameter(Mandatory)]
[string[]]
$Row,
[Parameter(Mandatory)]
[string[]]
$Column
)

$toRemove = @($this.actions.psobject.properties | Select-Object -ExpandProperty Name |
    Where-Object {
        $rowCol  = $_.Row + "," + $_.Column
        $rowCol -like "$row,$column" -or $rowCol -match "$row,$column"
    })

foreach ($tr in $toRemove) {
    $this.actions.psobject.properties.Remove($tr)
}
