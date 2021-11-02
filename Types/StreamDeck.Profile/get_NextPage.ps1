foreach ($act in $this.Actions.psobject.properties) {
    if ($act.value.uuid -in 'com.elgato.streamdeck.page.next') {
        if ($this.Path) {
            $this.Path | 
                ForEach-Object {
                    if ($this.IsChild) {
                        $_ | Split-Path | Split-Path
                    } else {
                        $_ | Split-Path | Join-Path -ChildPath Profiles 
                    }
                } |                
                Join-Path -ChildPath "$($act.value.settings.profileUUID).sdProfile" |
                Get-StreamDeckProfile -ProfileRoot { $_ }            
        }
    }
}

