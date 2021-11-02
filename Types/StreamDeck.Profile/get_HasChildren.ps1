foreach ($act in $this.Actions.psobject.properties) {
    if ($act.value.uuid -in 'com.elgato.streamdeck.profile.openchild') {
        return $true
    }
}
