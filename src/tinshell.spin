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

  '' Serial port settings for shell
  '' BAUD_RATE 	= 8_761                                ' Turns out to be about 9600 with rcfast on my board
  BAUD_RATE     = 9600

  RX_PIN 	= 1
  TX_PIN 	= 0

  ''RX_PIN 		= 31
  ''TX_PIN 		= 30

  MOT_AO1       = 3
  MOT_AO2       = 2
  MOT_PWMA      = 6
  MOT_BO1       = 5
  MOT_BO2       = 4
  MOT_PWMB      = 7

  MOT_SPEED_DELTA = 1

  SPEAKER       = 10

  LED1          = 14
  LED2          = 16
  LED3          = 18
  LED4          = 20
  LED5          = 22
  LED6          = 24
  LED7          = 26

OBJ

  ps	: "propshell"
  mc    : "tb6612fng"
  pcm   : "pcm"
  led   : "ledpanel"

VAR

  byte curSpeedA
  byte curSpeedB

PUB main | i

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Main routine. Init the shell, prompt for commands, handle commands.
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  curSpeedA := 40
  curSpeedB := 40

  mc.init(MOT_AO1, MOT_AO2, MOT_PWMA, MOT_BO1, MOT_BO2, MOT_PWMB)
  mc.setSpeed(mc#MOT_A, curSpeedB)
  mc.setSpeed(mc#MOT_B, curSpeedB)

  ps.init(false, false, BAUD_RATE, RX_PIN, TX_PIN)

  led.init(LED1, LED2, LED3, LED4, LED5, LED6, LED7)
  led.animatePowerup(1)

  ps.puts(string("!INFO tinshell ready", ps#CR, ps#LF))

  repeat

    result := ps.prompt

    \cmdHandler(result)

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
  cmdSetSpeed(ps.commandDef(string("+s"), false , cmdLine))
  cmdPlaySound(ps.commandDef(string("+p"), false , cmdLine))

  return true

PRI cmdDrv(forMe) | dir

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
    mc.operateSync(mc#CMD_CCW)
  elseif strcomp(dir, string("f"))
    mc.operateSync(mc#CMD_CW)
  elseif strcomp(dir, string("l"))
    mc.operateAsync(mc#CMD_CCW, mc#CMD_CW)
  elseif strcomp(dir, string("r"))
    mc.operateAsync(mc#CMD_CW, mc#CMD_CCW)
  elseif strcomp(dir, string("s"))
    mc.operateSync(mc#CMD_STOP)
  else
    ps.puts(string("!ERR 2", ps#CR, ps#LF))
    abort

  ps.commandHandled

PRI cmdSetSpeed(forMe) | ab, a, b, d, speed

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Drive tincan by using morots A and B
'' //
'' // @param                    forMe                   Ture if command should be handled, false otherwise
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  if not forMe
    return

  a := false
  b := false
  d := 0

  ps.parseAndCheck(1, string("!ERR 1"), false)
  ab := ps.currentPar

  if strcomp(ab, string("a"))
    a := true
  elseif strcomp(ab, string("b"))
    b := true
  else
    ps.puts(string("!ERR 2", ps#CR, ps#LF))
    abort

  ps.parseAndCheck(2, string("!ERR 3"), false)
  speed := ps.currentPar

  if strcomp(speed, string("+"))
    d :=  MOT_SPEED_DELTA
  elseif strcomp(speed, string("-"))
    d := -MOT_SPEED_DELTA
  else
    ps.puts(string("!ERR 4", ps#CR, ps#LF))
    abort

  if a
    curSpeedA := curSpeedA + d
    if curSpeedA > 100
      curSpeedA := 100
    elseif curSpeedA < 0
      curSpeedA := 0
    mc.setSpeed(mc#MOT_A, curSpeedA)
    ps.puts(string("!INFO speedA: "))
    ps.putd(curSpeedA)
    ps.puts(string(ps#CR, ps#LF))
  elseif b
    curSpeedB := curSpeedB + d
    if curSpeedB > 100
      curSpeedB := 100
    elseif curSpeedB < 0
      curSpeedB := 0
    mc.setSpeed(mc#MOT_B, curSpeedB)
    ps.puts(string("!INFO speedB: "))
    ps.putd(curSpeedB)
    ps.puts(string(ps#CR, ps#LF))

  ps.commandHandled

PRI cmdPlaySound(forMe)

'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
'' // Play typical R2D2 sound
'' //
'' // @param                    forMe                   Ture if command should be handled, false otherwise
'' ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  pcm.play8kHzU8(@wav_1, SPEAKER, wav_1_size)

DAT

wav_1 byte
File "r2d28bit.raw"

wav_1_size long 5233

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
