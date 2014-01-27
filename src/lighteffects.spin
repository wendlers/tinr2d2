{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// LightEffects for R2D2
//
//
// Author: Stefan Wendler
// Updated: 2014-01-22
// Designed For: P8X32A
// Version: 1.0
//
// Copyright (c) 2014 Stefan Wendler
// See end of file for terms of use.
//
// Update History:
//
// v1.0 - Initial release       - 2014-01-28
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Circuit Diagram:
//
// None
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Brief Description:
//
// Show the light-effects of R2D2 in sperate cog
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detailed Description:
//
// For detailed usage, see the example.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

CON

  '' Nothing

  NONE     = 0
  TALK     = 1
  POWERUP  = 2
  HAPPY    = 3
  SAD      = 4
  ANGRY    = 5

OBJ

  led   : "ledpanel.spin"

VAR

  byte pinLed1
  byte pinLed2
  byte pinLed3
  byte pinLed4
  byte pinLed5
  byte pinLed6
  byte pinLed7

  byte effectNext
  byte effectCurrent
  byte effectRepeat

  long stack[32]

PUB start(aPinLed1, aPinLed2, aPinLed3, aPinLed4, aPinLed5, aPinLed6, aPinLed7)

  pinLed1 := aPinLed1
  pinLed2 := aPinLed2
  pinLed3 := aPinLed3
  pinLed4 := aPinLed4
  pinLed5 := aPinLed5
  pinLed6 := aPinLed6
  pinLed7 := aPinLed7

  effectNext    := NONE
  effectCurrent := NONE
  effectRepeat  := 1

  cognew(mainLoop, @stack[0])

PUB scheduleEffect(effect)

  scheduleEffectRepeat(effect, 1)

PUB scheduleEffectRepeat(effect, times)

  effectNext   := effect
  effectRepeat := times

PRI mainLoop

  led.init(pinLed1, pinLed2, pinLed3, pinLed4, pinLed5, pinLed6, pinLed7)
  led.setDot

  repeat
    if effectNext <> NONE and effectCurrent == NONE
      effectCurrent := effectNext
      effectNext := NONE
      processEffect

PRI processEffect

  if effectCurrent == TALK
    led.animateTalk(effectRepeat)
  elseif effectCurrent == POWERUP
    led.animatePowerup(effectRepeat)
  elseif effectCurrent == HAPPY
    led.setSmile
  elseif effectCurrent == SAD
    led.setSad
  elseif effectCurrent == ANGRY
    led.setAngry1

  effectCurrent := NONE
