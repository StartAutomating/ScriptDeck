<#
Write-FormatView -TypeName StreamDeck.Profile -Action {
    Write-FormatViewExpression -ScriptBlock {
        @(
        . $align $_.Name -Alignment Center
        ''
        . $align $_.DeviceModel -Alignment Center
        ''
        ) -join [Environment]::NewLine
    }

    Write-FormatViewExpression -ScriptBlock {
        $sdProfile = $_
        $maxX = 0
        $maxY = 0
        foreach ($actCoordinate in @($sdProfile.Actions.psobject.properties).Name) {
            $x, $y = $actCoordinate -split ','
            if ($x -gt $maxX ){$maxX = [int]$x }
            if ($y -gt $maxY) {$maxY = [int]$y }
        }

        $bufferWidth  = $Host.UI.RawUI.BufferSize.Width - 1
        $bufferHeight = [math]::Floor($bufferWidth * ([float]($maxY + 1)/[float]($maxX + 1)))
        
        $cellWidth  = ($bufferWidth  -2)/($maxX + 1)
        $cellHeight = ($bufferHeight - (2+$maxY))/($maxY + 1) 
        $emptyCellRow = ' ' * $cellWidth
        @(
            '-' * $bufferWidth
            (@(foreach ($columnNumber in 0..$maxX) {
                '|' + $emptyCellRow
            }) -join '')
            
            '-' * $bufferWidth
        ) -join [Environment]::NewLine
    }
}
#>


Write-FormatView -TypeName StreamDeck.Profile -Property Name, DeviceModel, DeviceUUID, Actions -Wrap -VirtualProperty @{
    Actions = {
        @(foreach ($prop in $_.Actions.psobject.properties) {
            $prop.Name + ' > ' + $prop.Value.Name
        }) -join [Environment]::NewLine
    }
} -Width 20,12,0 -GroupLabel Application -GroupByScript { if ($_.AppIdentifier) { $_.AppIdentifier } else { 'None' } }



