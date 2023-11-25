ScriptDeck.Action.SetImage()
----------------------------

### Synopsis
Sets an action's image

---

### Description

Sets a dynamic image for an action.

---

### Parameters
#### **ImagePath**
The path to the image

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |1       |false        |

---

### Notes
The StreamDeck api only allow for a static image to be provided.
If an animated .gif is provided, only it's first frame will be used.

---
