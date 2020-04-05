#!/bin/sh
##
##  HUDS -- Head-Up-Display Server (HUDS)
##  Copyright (c) 2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
##
##  Permission is hereby granted, free of charge, to any person obtaining
##  a copy of this software and associated documentation files (the
##  "Software"), to deal in the Software without restriction, including
##  without limitation the rights to use, copy, modify, merge, publish,
##  distribute, sublicense, and/or sell copies of the Software, and to
##  permit persons to whom the Software is furnished to do so, subject to
##  the following conditions:
##
##  The above copyright notice and this permission notice shall be included
##  in all copies or substantial portions of the Software.
##
##  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
##  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
##  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
##  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
##  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
##  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
##  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

#   Generate key images for Elgato Stream-Deck with the help of the companion tool
#   Stream-Deck Key-Image Generator (SDKIG) <https://github.com/rse/sdkig>

sdkig -b 336699 -i pause-circle         -I 99ccff -t "PAUSE"     -T ffffff -o training-key-hud-banner-pause.png
sdkig -b 336699 -i radiation-alt        -I 99ccff -t "RANT"      -T ffffff -o training-key-hud-banner-rant.png
sdkig -b 336699 -i comments             -I 99ccff -t "Q&A"       -T ffffff -o training-key-hud-banner-qna.png
sdkig -b 336699 -i chevron-circle-left  -I 99ccff -t "PREV"      -T ffffff -o training-key-hud-progress-prev.png
sdkig -b 336699 -i chevron-circle-right -I 99ccff -t "NEXT"      -T ffffff -o training-key-hud-progress-next.png
sdkig -b 336699 -i list-alt             -I 99ccff -t "AGENDA"    -T ffffff -o training-key-hud-agenda.png

sdkig -b bb8800 -i video                -I f0e0d0 -t "CAMERAS"   -T ffffff -o training-key-source-cameras-on.png
sdkig -b 000000 -i video                -I 999999 -t "CAMERAS"   -T c0c0c0 -o training-key-source-cameras-off.png
sdkig -b bb8800 -i microphone-alt       -I f0e0d0 -t "MICROS"    -T ffffff -o training-key-source-micros-on.png
sdkig -b 000000 -i microphone-alt       -I 999999 -t "MICROS"    -T c0c0c0 -o training-key-source-micros-off.png
sdkig -b bb8800 -i tablet               -I f0e0d0 -t "TABLET"    -T ffffff -o training-key-source-tablet-on.png
sdkig -b 000000 -i tablet               -I 999999 -t "TABLET"    -T c0c0c0 -o training-key-source-tablet-off.png
sdkig -b bb8800 -i laptop               -I f0e0d0 -t "NOTEBOOK"  -T ffffff -o training-key-source-notebook-on.png
sdkig -b 000000 -i laptop               -I 999999 -t "NOTEBOOK"  -T c0c0c0 -o training-key-source-notebook-off.png
sdkig -b bb8800 -i camera               -I f0e0d0 -t "NDI"       -T ffffff -o training-key-source-ndi-on.png
sdkig -b 000000 -i camera               -I 999999 -t "NDI"       -T c0c0c0 -o training-key-source-ndi-off.png

sdkig -b 339900 -i images               -I c0ffa0 -t "STUDIO"    -T ffffff -o training-key-scene-studio-on.png
sdkig -b 000000 -i images               -I 999999 -t "STUDIO"    -T c0c0c0 -o training-key-scene-studio-off.png
sdkig -b 339900 -i image                -I c0ffa0 -t "SCREENS"   -T ffffff -o training-key-scene-screens-on.png
sdkig -b 000000 -i image                -I 999999 -t "SCREENS"   -T c0c0c0 -o training-key-scene-screens-off.png

sdkig -b ff0000 -i wifi                 -I ffe0e0 -t "STREAM"    -T ffffff -o training-key-egress-stream-on.png
sdkig -b 000000 -i wifi                 -I 999999 -t "STREAM"    -T c0c0c0 -o training-key-egress-stream-off.png
sdkig -b ff0000 -i dot-circle           -I ffe0e0 -t "RECORD"    -T ffffff -o training-key-egress-record-on.png
sdkig -b 000000 -i dot-circle           -I 999999 -t "RECORD"    -T c0c0c0 -o training-key-egress-record-off.png

