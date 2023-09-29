#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, Button, default, Headphone  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Add, Button, default, Speaker  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, Simple Input Example
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
ButtonHeadphone:
MsgBox Headphone
ExitApp
ButtonSpeaker:
MsgBox Speaker
ExitApp
