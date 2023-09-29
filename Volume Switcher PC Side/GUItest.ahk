#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Gui, Add, Tab2,, First Tab|Second Tab|Third Tab  ; Tab2 vs. Tab requires [v1.0.47.05+].
Gui, Add, Checkbox, vMyCheckbox, Sample checkbox
Gui, Tab, 2
Gui, Add, Radio, vMyRadio, Headphone
Gui, Add, Radio,, Speaker
Gui, Tab, 3
Gui, Add, Edit, vMyEdit r5  ; r5 means 5 rows tall.
Gui, Tab  ; i.e. subsequently-added controls will not belong to the tab control.
Gui, Add, Button, default xm, OK  ; xm puts it at the bottom left corner.
Gui, Show
return

ButtonOK:
GuiClose:
GuiEscape:
Gui, Submit  ; Save each control's contents to its associated variable.
path := A_ScriptDir . "\ArduinoSystemVol.ps1"
MsgBox You entered:`n%MyCheckbox%`n%MyRadio%`n%MyEdit%`n%path%
ExitApp
