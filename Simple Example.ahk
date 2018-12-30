#SingleInstance force
#include Include\AHK-ViGEm-Bus.ahk

; Create a new DS4 controller
ds4 := new ViGEmDS4()

; Create a new Xbox 360 controller
xb360 := new ViGEmXb360()

; Button codes
; https://github.com/ViGEm/ViGEm.NET/blob/master/ViGEmClient/Targets/DualShock4/DualShock4Report.cs
; https://github.com/ViGEm/ViGEm.NET/blob/master/ViGEmClient/Targets/Xbox360/Xbox360Report.cs
ds4Cross := 1 << 5
xb360A := 0x1000
return

F12::
  ; Press button 1 on both controllers
  ds4.SetButtonState(ds4Cross, true)
  ds4.SendReport()
  xb360.SetButtonState(xb360A, true)
  xb360.SendReport()
  return

F12 up::
  ; Release button 1 on both controllers
  ds4.SetButtonState(ds4Cross, false)
  ds4.SendReport()
  xb360.SetButtonState(xb360A, false)
  xb360.SendReport()
  return
