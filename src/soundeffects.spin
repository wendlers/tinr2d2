{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// SoundEffects for R2D2
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
// Play sound for R2D2 in sperate cog
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detailed Description:
//
// For detailed usage, see the example.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

CON

  NONE     = 0
  BEEP1    = 1
  BEEP2    = 2
  SAD      = 3

OBJ

  pcm   : "pcm.spin"

VAR

  byte pinSpeaker

  byte effectNext
  byte effectCurrent
  byte effectRepeat

  long stack[32]

PUB start(aPinSpeaker)

  pinSpeaker := aPinSpeaker

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

  repeat
    if effectNext <> NONE and effectCurrent == NONE
      effectCurrent := effectNext
      effectNext := NONE
      processEffect

PRI processEffect | i

  if effectCurrent == BEEP1
    repeat i from 1 to effectRepeat
      pcm.play8kHzU8(@wav_1, pinSpeaker, wav_1_size)
  if effectCurrent == BEEP2
    repeat i from 1 to effectRepeat
      pcm.play8kHzU8(@wav_2, pinSpeaker, wav_2_size)
  elseif effectCurrent == SAD
    repeat i from 1 to effectRepeat
      pcm.play8kHzU8(@wav_3, pinSpeaker, wav_3_size)

  effectCurrent := NONE

DAT

wav_1 byte
File "r2d28bit.raw"

wav_1_size long 5233

wav_2 byte
File "2ndr2d28bit.raw"

wav_2_size long 2548

wav_3 byte
File "sadr2d28bit.raw"

wav_3_size long 5174
