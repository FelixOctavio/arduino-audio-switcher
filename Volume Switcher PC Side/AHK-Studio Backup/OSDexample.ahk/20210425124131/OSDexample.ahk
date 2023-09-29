Gui +LastFound +AlwaysOnTop +ToolWindow -Caption ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, Black
Gui, Font, s14 q3  ; q3 to non-antialias the text, only works in AHK_L
Gui, Add, Text, vMyText cWhite w140, xCenter
return

~capslock:: ;The '~' prevents AHK from blocking the input of the button
GetKeyState, caps, CapsLock, T
If Caps = D
{
Gui, Show, xCenter y 840 NoActivate ; NoActivate avoids deactivating the currently active window.
GuiControl,, MyText, Headphone
SplashImage, %A_ScriptDir%\test.png, B,
}
else
{
Gui, Hide
GuiControl,, MyText,
SplashImage, Off 
}
return