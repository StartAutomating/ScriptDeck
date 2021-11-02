if (-not $this.Path) { return $true }
($this.Path | Split-Path | Split-Path | Split-Path | Split-Path -Leaf) -ne 'StreamDeck'
