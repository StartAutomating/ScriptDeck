# Include all of the *-StreamDeck.ps1 files
foreach ($file in Get-ChildItem -Filter *-StreamDeck.ps1) {
    . $file.FullName
}

# Pipe the arguments to Watch-StreamDeck to start the plugin.
$args | Watch-StreamDeck
return
