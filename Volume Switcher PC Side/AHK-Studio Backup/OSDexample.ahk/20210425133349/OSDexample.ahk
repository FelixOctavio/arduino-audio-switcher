Gui +LastFound +AlwaysOnTop +ToolWindow -Caption ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, BlacK
Gui, Font, s14 q3  ; q3 to non-antialias the text, only works in AHK_L
return

~capslock:: ;The '~' prevents AHK from blocking the input of the button
GetKeyState, caps, CapsLock, T
If Caps = D
{
	Gui, Add, Picture, x17 y15 w115 h115, %A_ScriptDir%\headphone.png
	Gui, Add, Text, x25 vModeText cWhite w100
	Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
	GuiControl,, ModeText, Headphone
	Sleep 1000
	Gui, Hide
	GuiControl,, ModeText,
	GuiClose:
}
else {
	Gui, Add, Picture, x17 y15 w115 h115, %A_ScriptDir%\speaker.png
	Gui, Add, Text, x39 vModeText cWhite w80
	Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
	GuiControl,, Mode2ext, Speaker
	Sleep 1000
	Gui, Hide
	GuiControl,, ModeText,
	GuiClose:
}
return