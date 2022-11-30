$placesWithControls = 
    @(
        $this.layout
        $this.layout.layoutModes
    )

foreach ($controlHolder in $placesWithControls) {
    foreach ($layoutProperty in $controlHolder.psobject.properties) {
        if ($layoutProperty.Name -like '*Pages') {
            foreach ($v in $layoutProperty.Value) {
                if ($v.PressAction) {
                    $v.PressAction
                }
                if ($v.RotateAction) {
                    $v.RotateAction
                }
                
                if ($v.controls) {
                    foreach ($ctrl in $v.controls) {
                        if ($ctrl.PressAction) {
                            $ctrl.PressAction
                        }
                        if ($ctrl.RotateAction) {
                            $ctrl.RotateAction
                        }
                    }
                }
            }
        }
    }
}

