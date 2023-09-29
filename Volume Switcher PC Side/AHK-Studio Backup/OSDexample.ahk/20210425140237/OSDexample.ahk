Gui +LastFound +AlwaysOnTop +ToolWindow -Caption ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, Black
Gui, Font, s14 q3  ; q3 to non-antialias the text, only works in AHK_L
; Gui, Add, Text, x25 vModeText cWhite w100
return

~capslock:: ;The '~' prevents AHK from blocking the input of the button
GetKeyState, caps, CapsLock, T
If Caps = D
{
	Gui, Add, Picture, x17 y10 w115 h115, %A_ScriptDir%\headphone.png
	Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
	; GuiControl,, ModeText, Headphone
}
else {
	Gui, Add, Picture, x17 y10 w115 h115, %A_ScriptDir%\speaker.png
	Gui, Show, xCenter y 840 AutoSize NoActivate ; NoActivate avoids deactivating the currently active window.
	; GuiControl,, ModeText, Speaker
	try if ((shellProvider := ComObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}"))) {
		try if ((flyoutDisp := ComObjQuery(shellProvider, "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}", "{41f9d2fb-7834-4ab6-8b1b-73e74064b465}"))) {
			DllCall(NumGet(NumGet(flyoutDisp+0)+3*A_PtrSize), "Ptr", flyoutDisp, "Int", 0, "UInt", 0)
					,ObjRelease(flyoutDisp)
		}
		ObjRelease(shellProvider)
	}
	Sleep 1000
	Gui, Hide
	return