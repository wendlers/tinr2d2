'  SPIN 8-bit WAV Player Ver. 1a  (Plays only mono 8-bit WAV at 8 or 16 ksps)
'  Copyright 2007 Raymond Allen  See end of file for terms of use. 
'  Settings for Demo Board Audio Output:  Right Pin# = 10, Left Pin# = 11   , VGA base=Pin16, TV base=Pin12


CON

  '' Nothing

PUB Player(pWav, PinR, n):bOK | i,nextCnt,dcnt

  DIRA[PinR]~~                              'Set Right Pin to output

  'Set up the counters
  CTRA:= %00110 << 26 + 0<<9 + PinR         'NCO/PWM Single-Ended APIN=Pin (BPIN=0 always 0)

  'sample rate 8KHz
  dcnt:=10000

  'Get ready for fast loop  
  n--
  i:=0
  NextCnt:=cnt+15000

  'Play loop
  repeat i from 0 to n
    NextCnt+=dcnt   ' need this to be 5000 for 16KSPS   @ 80 MHz
    waitcnt(NextCnt)
    FRQA:=(byte[pWav+i])<<24
       
      'Easy high-impedance output (e.g., to "line in" input of computer or sound system)
      '
      '              R=100
      ' Prop Pin ────┳──────── Audio Out
       '               C=0.1uF
       '                
       '               Vss
  return true

  
DAT

{{
                            TERMS OF USE: MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
}}
       
