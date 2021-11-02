if (-not $this.HasPages) { return 1 }
if (-not $this.IsChild)  { return 1 }
$page = $this.Parent
$pageNumber = 1
while ($page -and $page.Path -ne $this.Path) {
    $pageNumber++
    $page = $page.NextPage
}
if ($page) {
    $pageNumber
} else {
    return 0
}
