foreach ($act in $this.Actions.psobject.properties) {
    if ($act.value.uuid -in 'com.elgato.streamdeck.page.previous','com.elgato.streamdeck.page.next') {
        return $true
    }
}
