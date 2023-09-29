#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^!1::

SysGet, numOfMon, MonitorCount
path := A_ScriptDir . "\ArduinoSystemVol.ps1"
Runwait powershell.exe Set-ExecutionPolicy Unrestricted, ,hide
Runwait powershell.exe "%path%", ,hide
Runwait powershell.exe Set-ExecutionPolicy Restricted, ,hide
return

^!2::

SysGet, numOfMon, MonitorCount
path := A_ScriptDir . "\Arduino-HeadphoneSwitcher.ps1"
Runwait powershell.exe Set-ExecutionPolicy Unrestricted, ,hide
Runwait powershell.exe "%path%", ,hide
Runwait powershell.exe Set-ExecutionPolicy Restricted, ,hide
return

^!3::

SysGet, numOfMon, MonitorCount
path := A_ScriptDir . "\Arduino-SpeakerSwitcher.ps1"
Runwait powershell.exe Set-ExecutionPolicy Unrestricted, ,hide
Runwait powershell.exe "%path%", ,hide
Runwait powershell.exe Set-ExecutionPolicy Restricted, ,hide
return