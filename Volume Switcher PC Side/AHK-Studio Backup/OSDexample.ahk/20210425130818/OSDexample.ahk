﻿Gui +LastFound +AlwaysOnTop +ToolWindow -Caption ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, Gray
WinSet, Transcolor, Gray 255
Gui, Font, s14 q3  ; q3 to non-antialias the text, only works in AHK_L
Gui, Add, Picture, x17 y15, %A_ScriptDir%\test.png
Gui, Add, Text, x25 vMyText cWlack w100
return

~capslock:: ;The '~' prevents AHK from blocking the input of the button
GetKeyState, caps, CapsLock, T
If Caps = D
{
	Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
	GuiControl,, MyText, Headphone
	Sleep 1000
	Gui, Hide
	GuiControl,, MyText,
}
return