{{
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TIN CAN BASED R2D - SHELL
//
// Author: Stefan Wendler
// Updated: 2013-11-28
// Designed For: P8X32A
// Version: 1.0
//
// Copyright (c) 2013 Stefan Wendler
// See end of file for terms of use.
//
// Update History:
//
// v1.0 - Initial release       - 2013-11-28
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Circuit Diagram:
//
// TODO
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Brief Description:
//
// M2M Shell which allows to remotely operate a tin can based R2D robot through bulethoot.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Detailed Description:
//
// The protocol implementatin is as follows:
//
// Drive:
// ======
//
// +d <b|f|l|r|s>
// - b : backward
// - f : foreward
// - l : turn left
// - r : turn right
// - s : stop (break)
//
// On success, noting is returned.
// On error, an error message of the form:
//
// !ERR <err-nr:1..2>
//
// is returned.
//
// Example 1: drive foreward:
//
// +d f
// <nothing returned>
//
// Example 2: stop:
//
// +d s
// <nothing returned>
//
// Example 3: invalid command:
//
// +d x
// !ERR 2
//
//
// Increase/decrease Motor Speed:
// ==============================
//
// +s <a|b> <+|->
// - a : adjust speed for motor A
// - b : adjust speed for motor
// - + : increase speed for selected motor
// - - : decrease speed for selected motor
//
//
// On success, noting is returned.
// On error, an error message of the form:
//
// !ERR <err-nr:1..4>
//
// is returned.
//
// Example 1: increase speed of motor A:
//
// +s a +
// <nothing returned>
//
// Example 2: decrease speed of motor B:
//
// +s b -
// <nothing returned>
//
// Example 3: invalid motor:
//
// +s c +
// !ERR 2
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}}

CON

  '' Clock settings
  '' _clkmode = rcfast                                  ' Internal clock at 12MHz

  _CLKMODE = XTAL1 + PLL16X                             ' External clock at 80MHz
  _XINFREQ = 5_000_000

  BAUD_RATE_V1     = 9_600

  RX_PIN_V1 	   = 1
  TX_PIN_V1 	   = 0

  MOT_AO1_V1       = 3
  MOT_AO2_V1       = 2
  MOT_PWMA_V1      = 6
  MOT_BO1_V1       = 5
  MOT_BO2_V1       = 4
  MOT_PWMB_V1      = 7

  SPEAKER_V1       = 8
  MB1000_V1        = 9

  LED1_V1          = 16
  LED2_V1          = 26
  LED3_V1          = 18
  LED4_V1          = 20
  LED5_V1          = 24
  LED6_V1          = 22
  LED7_V1          = 14

  BAUD_RATE_V2     = 115_200

  RX_PIN_V2 	   = 1
  TX_PIN_V2 	   = 0

  MOT_AO1_V2       = 5
  MOT_AO2_V2       = 4
  MOT_PWMA_V2      = 6
  MOT_BO1_V2       = 2
  MOT_BO2_V2       = 3
  MOT_PWMB_V2      = 7

  SPEAKER_V2       = 8
  MB1000_V2        = 9

  LED1_V2          = 14
  LED2_V2          = 24
  LED3_V2          = 18
  LED4_V2          = 22
  LED5_V2          = 16
  LED6_V2          = 26
  LED7_V2          = 20

OBJ

  ps	: "propshell"
  dp    : "drivepilot"
  se    : "soundeffects"
  le    : "lighteffects"

VAR

  '' None

PUB main | i

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Main routine. Init the shell, prompt for commands, handle commands.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  '' initV1
  initV2

  dp.scheduleAction(dp#DRIVE_ST)

  repeat

    result := ps.prompt

    \cmdHandler(result)

PRI initV1

  le.start(LED1_V1, LED2_V1, LED3_V1, LED4_V1, LED5_V1, LED6_V1, LED7_V1)
  se.start(SPEAKER_V1)
  dp.start(MOT_AO1_V1, MOT_AO2_V1, MOT_PWMA_V1, MOT_BO1_V1, MOT_BO2_V1, MOT_PWMB_V1, MB1000_V1)

  le.scheduleEffect(le#POWERUP)
  se.scheduleEffect(se#BEEP1)

  ps.init(false, false, BAUD_RATE_V1, RX_PIN_V1, TX_PIN_V1)
  ps.puts(string("!INFO tinshell ready", ps#CR, ps#LF))

PRI initV2

  le.start(LED1_V2, LED2_V2, LED3_V2, LED4_V2, LED5_V2, LED6_V2, LED7_V2)
  se.start(SPEAKER_V2)
  dp.start(MOT_AO1_V2, MOT_AO2_V2, MOT_PWMA_V2, MOT_BO1_V2, MOT_BO2_V2, MOT_PWMB_V2, MB1000_V2)

  le.scheduleEffect(le#POWERUP)
  se.scheduleEffect(se#BEEP1)

  ps.init(false, false, BAUD_RATE_V2, RX_PIN_V2, TX_PIN_V2)
  ps.puts(string("!INFO tinshell ready", ps#CR, ps#LF))

PRI cmdHandler(cmdLine)

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Command handler. All shell commands are defined here.
'' //
'' // @param                    cmdLine                 Input to parse (from promt)
'' // @return                                           ture if cmdLine was NOT handled
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  '' Each command needs to have a single parameter: the result of ps.commandDef.
  '' Each ps.commandDef takes three parameters:
  '' - 1  name of command
  '' - 2  help/descriptoin for command (or false if no help)
  '' - 3  command line to check command against

  cmdDrv(ps.commandDef(string("+d"), false , cmdLine))
  cmdPlaySound(ps.commandDef(string("+p"), false , cmdLine))
  cmdGetRange(ps.commandDef(string("+r"), false , cmdLine))

  return true

PRI cmdDrv(forMe) | dir, d

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Drive tincan by using morots A and B
'' //
'' // @param                    forMe                   Ture if command should be handled, false otherwise
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if not forMe
    return

  ps.parseAndCheck(1, string("!ERR 1"), false)
  dir := ps.currentPar

  if strcomp(dir, string("b"))
    dp.scheduleAction(dp#DRIVE_BW)
    le.scheduleEffect(le#HAPPY)
    se.scheduleEffect(se#BEEP2)
  elseif strcomp(dir, string("f"))
    dp.scheduleAction(dp#DRIVE_FW)
    le.scheduleEffect(le#HAPPY)
    se.scheduleEffect(se#BEEP2)
  elseif strcomp(dir, string("l"))
    dp.scheduleAction(dp#DRIVE_TL)
    le.scheduleEffect(le#HAPPY)
    se.scheduleEffect(se#BEEP2)
  elseif strcomp(dir, string("r"))
    dp.scheduleAction(dp#DRIVE_TR)
    le.scheduleEffect(le#HAPPY)
    se.scheduleEffect(se#BEEP2)
  elseif strcomp(dir, string("s"))
    dp.scheduleAction(dp#DRIVE_ST)
    le.scheduleEffect(le#SAD)
    se.scheduleEffect(se#SAD)
  else
    ps.puts(string("!ERR 2", ps#CR, ps#LF))
    abort

  ps.commandHandled

PRI cmdPlaySound(forMe)

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Play typical R2D2 sound
'' //
'' // @param                    forMe                   Ture if command should be handled, false otherwise
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if not forMe
    return

  se.scheduleEffect(se#beep1)
  le.scheduleEffect(le#TALK)

  ps.commandHandled

PRI cmdGetRange(forMe) | r

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Play typical R2D2 sound
'' //
'' // @param                    forMe                   Ture if command should be handled, false otherwise
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if not forMe
    return

  r := dp.getCurDist

  ps.puts(string("!INFO range (cm): "))
  ps.putd(r)
  ps.puts(string(ps#CR, ps#LF))

  ps.commandHandled

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
