CON

  '' Nothing

PUB play8kHzU8(pcm, pin, length) : bOK | n, i, nextCnt, dcnt

  DIRA[pin]~~                              'Set Right Pin to output

  'Set up the counters
  CTRA:= %00110 << 26 + 0<<9 + pin         'NCO/PWM Single-Ended APIN=Pin (BPIN=0 always 0)

  'sample rate 8KHz
  dcnt:=10000

  'Get ready for fast loop
  n := length
  n--
  i:=0
  nextCnt:=cnt+15000

  'Play loop
  repeat i from 0 to n
    nextCnt += dcnt   ' need this to be 5000 for 16KSPS   @ 80 MHz
    waitcnt(nextCnt)
    FRQA:=(byte[pcm + i]) << 24

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
