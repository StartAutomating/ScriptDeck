if (-not $this.IsChild) { return $null }
($this.Path | Split-Path | Split-Path | Split-Path | Get-StreamDeckProfile -ProfileRoot { $_ })


