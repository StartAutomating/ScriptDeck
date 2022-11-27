Import-Module .\ScriptDeck.psd1 -Global 

Save-MarkdownHelp -Module ScriptDeck -PassThru |
    Where-Object Name -NotLike '*PropertyInspector*' |
    Where-Object FullName -NotLike '*.sdPlugin*'

