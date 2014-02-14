{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Drive pilot for R2D2
//
//
// Author: Stefan Wendler
// Updated: 2014-02-02
// Designed For: P8X32A
// Version: 1.0
//
// Copyright (c) 2014 Stefan Wendler
// See end of file for terms of use.
//
// Update History:
//
// v1.0 - Initial release       - 2014-02-02
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Circuit Diagram:
//
// None
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Brief Description:
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detailed Description:
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

CON

  NONE     = 0
  DRIVE_FW = 1
  DRIVE_BW = 2
  DRIVE_TL = 3
  DRIVE_TR = 4
  DRIVE_ST = 5

OBJ

  mc   : "tb6612fng"
  mb   : "mb1000"

  dbg	: "Full-Duplex_COMEngine"

VAR

  byte actionNext
  byte actionCurrent
  byte actionLast

  byte emBrSens
  byte emBrMinDist

  byte minSpeedA
  byte minSpeedB
  byte curSpeedA
  byte curSpeedB

  byte speedDelta
  byte speedDelay

  byte pinAO1
  byte pinAO2
  byte pinBO1
  byte pinBO2
  byte pinPWMA
  byte pinPWMB

  byte pinMB

  byte curDist

  long stack[32]

PUB start(aPinAO1, aPinAO2, aPinPWMA, aPinBO1, aPinBO2, aPinPWMB, aPinMB)

  pinAO1 := aPinAO1
  pinAO2 := aPinAO2
  pinBO1 := aPinBO1
  pinBO2 := aPinBO2
  pinPWMA:= aPinPWMA
  pinPWMB:= aPinPWMB
  pinMB  := aPinMB

  actionNext    := NONE
  actionCurrent := NONE
  actionLast    := NONE

  emBrSens := 40
  emBrMinDist := 30

  minSpeedA := 40
  minSpeedB := 40

  curSpeedA := 40
  curSpeedB := 40

  speedDelta := 20
  speedDelay := 70

  curDist := 0

  dbg.COMEngineStart(31, 30, 115_200)
  dbg.writeString(string("Drive Pilot"))
  dbg.writeString(string(10, 13))

  cognew(mainLoop, @stack[0])

PUB scheduleAction(action)

  actionNext := action

PUB getCurDist

  return curDist

PRI mainLoop | emBrCnt

  mc.init(pinAO1, pinAO2, pinPWMA, pinBO1, pinBO2, pinPWMB)
  mc.setSpeed(mc#MOT_A, curSpeedA)
  mc.setSpeed(mc#MOT_B, curSpeedB)

  mb.init(pinMB)

  emBrCnt := 0

  repeat

    curDist := mb.getRangeCm

    antiCollisionAssistent

    if actionNext <> NONE and (actionNext <> actionLast or actionLast == NONE) and actionCurrent == NONE
      actionCurrent := actionNext
      actionNext := NONE
      processAction

PRI processAction

  dbg.writeString(string("ProcessAction "))

  if actionCurrent == DRIVE_FW
    dbg.writeString(string("DRIVE_FW "))
    antiFlippOverAssistent
    mc.operateSync(mc#CMD_CW)
    speedUp
    dbg.writeString(string(" OK"))
  elseif actionCurrent == DRIVE_BW
    dbg.writeString(string("DRIVE_BW "))
    antiFlippOverAssistent
    mc.operateSync(mc#CMD_CCW)
    dbg.writeString(string(" OK"))
  elseif actionCurrent == DRIVE_TL
    dbg.writeString(string("DRIVE_TL "))
    antiFlippOverAssistent
    mc.operateAsync(mc#CMD_CCW, mc#CMD_CW)
    dbg.writeString(string(" OK"))
  elseif actionCurrent == DRIVE_TR
    dbg.writeString(string("DRIVE_TR "))
    antiFlippOverAssistent
    mc.operateAsync(mc#CMD_CW, mc#CMD_CCW)
    dbg.writeString(string(" OK"))
  elseif actionCurrent == DRIVE_ST
    dbg.writeString(string("DRIVE_ST "))
    antiFlippOverAssistent
    mc.operateSync(mc#CMD_STOP)
    dbg.writeString(string(" OK"))

  dbg.writeString(string(10, 13))

  actionLast := actionCurrent
  actionCurrent := NONE

PRI antiFlippOverAssistent

    slowDown

    '' omit flipp overs cause by rapid direction changes
    if actionLast == DRIVE_FW or actionLast == DRIVE_BW  ' or actionLast == DRIVE_ST
      waitcnt(clkfreq / 2 + cnt)

PRI antiCollisionAssistent | emBrCnt

    '' Emergency break if distance to low
    if actionLast == DRIVE_FW and curDist < emBrMinDist
      emBrCnt := emBrCnt + 1

      if emBrCnt > emBrSens
        dbg.writeString(string("Emergency Break!", 10, 13))
        actionNext := DRIVE_ST
        emBrCnt := 0
    else
      emBrCnt := 0

PRI slowDown | s

    repeat s from curSpeedA to minSpeedA
      waitcnt(clkfreq / speedDelay + cnt)
      dbg.writeString(string("-"))
      mc.setSpeedAsync(s, s)

    curSpeedA := minSpeedA
    curSpeedB := minSpeedB

PRI speedUp | s

    repeat s from curSpeedA to (minSpeedA + speedDelta)
      waitcnt(clkfreq / speedDelay + cnt)
      dbg.writeString(string("+"))
      mc.setSpeedAsync(s, s)

    curSpeedA := minSpeedA + speedDelta
    curSpeedB := minSpeedB + speedDelta

