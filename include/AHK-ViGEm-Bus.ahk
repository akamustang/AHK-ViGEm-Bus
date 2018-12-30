#Include %A_LineFile%\..\CLR.ahk

; Static class, holds ViGEm Client instance
class ViGEmClient {
  static asm := 0
  static client := 0
  
  Init(){
    if (this.client == 0){
      this.asm := CLR_LoadLibrary(A_LineFile "\..\Nefarius.ViGEmClient.dll")
      this.client := CLR_CreateObject(this.asm, "Nefarius.ViGEm.Client.ViGEmClient")
    }
  }
}

; Base class for ViGEm "Targets" (Controller types - eg xb360 / ds4) to inherit from
class ViGEmTarget {
  report := 0
  target := 0
  reportClass := ""
  controllerClass := ""

  __New(){
    ViGEmClient.Init()
    this.report := CLR_CreateObject(ViGEmClient.asm, this.reportClass)
    this.target := CLR_CreateObject(ViGEmClient.asm, this.controllerClass, ViGEmClient.client)
    this.target.Connect()
  }

  SetButtonState(button, state) {
    If (state) {
      this.report.Buttons |= button
    }
    Else {
      this.report.Buttons &= ~button
    }
  }

  SetDPad(value) {
    this.report.Buttons &= ~0xF
    this.report.Buttons |= value
  }

  SetAxis(axis, value) {
    If (axis = 0) {
      this.report.LeftTrigger := value
    }
    Else If (axis = 1) {
      this.report.RightTrigger := value
    }
    Else If (axis = 2) {
      this.report.LeftThumbX := value
    }
    Else If (axis = 3) {
      this.report.LeftThumbY := value
    }
    Else If (axis = 4) {
      this.report.RightThumbX := value
    }
    Else If (axis = 5) {
      this.report.RightThumbY := value
    }
  }

  SendReport(){
    this.target.SendReport(this.report)
  }
}

; DS4-specific info (DualShock 4 for Playstation 4)
class ViGEmDS4 extends ViGEmTarget {
  reportClass := "Nefarius.ViGEm.Client.Targets.DualShock4.DualShock4Report"
  controllerClass := "Nefarius.ViGEm.Client.Targets.DualShock4Controller"

  SetSpecialButtonState(button, state) {
    If (state) {
      this.report.SpecialButtons |= button
    }
    Else {
      this.report.SpecialButtons &= ~button
    }
  }
}

; Xb360-specific settings
class ViGEmXb360 extends ViGEmTarget {
  reportClass := "Nefarius.ViGEm.Client.Targets.Xbox360.Xbox360Report"
  controllerClass := "Nefarius.ViGEm.Client.Targets.Xbox360Controller"
}
