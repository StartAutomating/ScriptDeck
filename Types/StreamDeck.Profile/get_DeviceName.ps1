switch ($this.DeviceModel) {
    20GAI9901  { "StreamDeckMini" }
    20GAT9901  { "StreamDeckXL" }
    20GAA9901  { "StreamDeck" }
    20GAA9902  { "StreamDeck" } 
    'VSD/WiFi' { "StreamDeckMobile" }
    default { $this.DeviceModel }
}
