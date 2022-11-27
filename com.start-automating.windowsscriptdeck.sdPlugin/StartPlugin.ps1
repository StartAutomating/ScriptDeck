# Now let's register the functions we need.

# |Function|Purpose                                           |
# |--------|--------------------------------------------------|
# |Send-StreamDeck     |Sends messages to the StreamDeck      |
. $psScriptRoot\Send-StreamDeck.ps1
# |Receive-StreamDeck  |Receives messages from the StreamDeck |
. $psScriptRoot\Receive-StreamDeck.ps1
# |Watch-StreamDeck    |Watches events from the StreamDeck    |
. $psScriptRoot\Watch-StreamDeck.ps1

# We simply pipe the arguments in to start the plugin.
$args | Watch-StreamDeck 
return
