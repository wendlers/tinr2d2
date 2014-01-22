{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Simple 7-LED panel for TIN CAN BASED R2D
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
// v1.0 - Initial release       - 2014-01-22
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Circuit Diagram:
//
// Panel looks like this:
//
// +---------------------+
// |                     |
// | (7)             (6) |
// |     (5) (2) (3)     |
// | (1)             (4) |
// |                     |
// +---------------------+
//
// PIN LED1     - Pin used for LED1
// PIN LED2     - Pin used for LED2
// PIN LED3     - Pin used for LED3
// PIN LED4     - Pin used for LED4
// PIN LED5     - Pin used for LED5
// PIN LED6     - Pin used for LED6
// PIN LED7     - Pin used for LED7
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Brief Description:
//
// Driver for 7-LED panel used on tin can based R2D2.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detailed Description:
//
// For detailed usage, see the example.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

CON

  '' Clock settings
  '' _clkmode = rcfast                                  ' Internal clock at 12MHz

  _CLKMODE = XTAL1 + PLL16X                             ' External clock at 80MHz
  _XINFREQ = 5_000_000

VAR

  byte pinLed1
  byte pinLed2
  byte pinLed3
  byte pinLed4
  byte pinLed5
  byte pinLed6
  byte pinLed7

PUB main

  init(14, 16, 18, 20, 22, 24, 26)

  '' setPattern(%0100000)

  animatePowerup(4)
  animateAngry(10)
  animateSmileSad(10)
  animateSmileAngry(10)
  animateSadAngry(10)
  animateTalk(10)

  repeat

PUB init(aPinLed1, aPinLed2, aPinLed3, aPinLed4, aPinLed5, aPinLed6, aPinLed7)

  pinLed1 := aPinLed1
  pinLed2 := aPinLed2
  pinLed3 := aPinLed3
  pinLed4 := aPinLed4
  pinLed5 := aPinLed5
  pinLed6 := aPinLed6
  pinLed7 := aPinLed7

  dira[pinLed1] := 1
  dira[pinLed2] := 1
  dira[pinLed3] := 1
  dira[pinLed4] := 1
  dira[pinLed5] := 1
  dira[pinLed6] := 1
  dira[pinLed7] := 1

  setOff

PUB setOff

  outa[pinLed1] := 0
  outa[pinLed2] := 0
  outa[pinLed3] := 0
  outa[pinLed4] := 0
  outa[pinLed5] := 0
  outa[pinLed6] := 0
  outa[pinLed7] := 0

PUB setSmile

  setPattern(%1110110)

PUB setSad

  setPattern(%0011111)

PUB setAngry1

  setPattern(%1011110)

PUB setAngry2

  setPattern(%0110111)

PUB setNeutral

  setPattern(%0010110)

PUB setDot

  setPattern(%0000010)

PUB animatePowerup(times)

  repeat times
    setDot
    waitcnt(clkfreq/4 + cnt)
    setNeutral
    waitcnt(clkfreq/4 + cnt)
    setSmile
    waitcnt(clkfreq/4 + cnt)

PUB animateAngry(times)

  repeat times
    setAngry1
    waitcnt(clkfreq/4 + cnt)
    setAngry2
    waitcnt(clkfreq/4 + cnt)

PUB animateSmileSad(times)

  repeat times
    setSmile
    waitcnt(clkfreq/4 + cnt)
    setSad
    waitcnt(clkfreq/4 + cnt)

PUB animateSmileAngry(times)

  repeat times
    setSmile
    waitcnt(clkfreq/4 + cnt)
    setAngry1
    waitcnt(clkfreq/4 + cnt)

PUB animateSadAngry(times)

  repeat times
    setSad
    waitcnt(clkfreq/4 + cnt)
    setAngry2
    waitcnt(clkfreq/4 + cnt)

PUB animateTalk(times)

  repeat times
    setDot
    waitcnt(clkfreq/4 + cnt)
    setNeutral
    waitcnt(clkfreq/4 + cnt)
    setDot
    waitcnt(clkfreq/4 + cnt)
    setSmile
    waitcnt(clkfreq/4 + cnt)
    setOff
    waitcnt(clkfreq/4 + cnt)

PUB setPattern(pattern) | pos1, pos2, pos3, pos4, pos5, pos6, pos7

  pos1 := 1
  pos2 := 2
  pos3 := 4
  pos4 := 8
  pos5 := 16
  pos6 := 32
  pos7 := 64

  if pattern & pos1
    outa[pinLed1] := 1
  else
    outa[pinLed1] := 0

  if pattern & pos2
    outa[pinLed2] := 1
  else
    outa[pinLed2] := 0

  if pattern & pos3
    outa[pinLed3] := 1
  else
    outa[pinLed3] := 0

  if pattern & pos4
    outa[pinLed4] := 1
  else
    outa[pinLed4] := 0

  if pattern & pos5
    outa[pinLed5] := 1
  else
    outa[pinLed5] := 0

  if pattern & pos6
    outa[pinLed6] := 1
  else
    outa[pinLed6] := 0

  if pattern & pos7
    outa[pinLed7] := 1
  else
    outa[pinLed7] := 0

DAT

{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                  TERMS OF USE: MIT License
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
// Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
// WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}
