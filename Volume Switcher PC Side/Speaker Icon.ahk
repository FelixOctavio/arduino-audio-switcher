Gui +LastFound +AlwaysOnTop +ToolWindow -Caption ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, Black
Gui, Font, s14 q3  ; q3 to non-antialias the text, only works in AHK_L
; Gui, Add, Text, x25 vModeText cWhite w100


Gui, Add, Picture, x17 y10 w115 h115, %A_ScriptDir%\speaker.png
Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
; GuiControl,, ModeText, Speaker

Sleep 2000
ExitApp
