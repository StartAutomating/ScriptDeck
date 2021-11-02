if (-not $this.HasChildren) { return }
@(if ($this.IsChild) {
    $this.Parent | 
        Split-Path |
        Join-Path -child Profiles 
} else {
    $this | 
        Split-Path |
        Join-Path -child Profiles 
}) | 
    Get-ChildItem | 
    Get-StreamDeckProfile -ProfileRoot {$_.fullname } 
