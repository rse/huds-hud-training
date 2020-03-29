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

sdkig -b 336699 -i couch                -I 99ccff -t "PAUSE"     -T ffffff -o training-key-hud-banner-pause.png
sdkig -b bb0000 -i radiation-alt        -I ffc0c0 -t "RANT"      -T ffffff -o training-key-hud-banner-rant.png
sdkig -b 339900 -i comments             -I c0ffc0 -t "Q&A"       -T ffffff -o training-key-hud-banner-qna.png

sdkig -b 336699 -i list-alt             -I 90ccff -t "Agenda"    -T ffffff -o training-key-hud-agenda.png

sdkig -b 336699 -i chevron-circle-left  -I 99ccff -t "Previous"  -T ffffff -o training-key-hud-progress-prev.png
sdkig -b 336699 -i chevron-circle-right -I 99ccff -t "Next"      -T ffffff -o training-key-hud-progress-next.png

sdkig -b ffffff -i images               -I 000000 -t "Studio"    -T 000000 -o training-key-scene-studio-on.png
sdkig -b 000000 -i images               -I 999999 -t "Studio"    -T c0c0c0 -o training-key-scene-studio-off.png

sdkig -b ffffff -i tablet               -I 000000 -t "Tablet"    -T 000000 -o training-key-scene-tablet-on.png
sdkig -b 000000 -i tablet               -I 999999 -t "Tablet"    -T c0c0c0 -o training-key-scene-tablet-off.png
sdkig -b ffffff -i laptop               -I 000000 -t "Notebook"  -T 000000 -o training-key-scene-notebook-on.png
sdkig -b 000000 -i laptop               -I 999999 -t "Notebook"  -T c0c0c0 -o training-key-scene-notebook-off.png
sdkig -b ffffff -i wifi                 -I 000000 -t "NDI"       -T 000000 -o training-key-scene-ndi-on.png
sdkig -b 000000 -i wifi                 -I 999999 -t "NDI"       -T c0c0c0 -o training-key-scene-ndi-off.png

sdkig -b ffffff -i tablet               -I 000000 -t "Tablet"    -T 000000 -o training-key-source-tablet-on.png
sdkig -b 000000 -i tablet               -I 999999 -t "Tablet"    -T c0c0c0 -o training-key-source-tablet-off.png
sdkig -b ffffff -i laptop               -I 000000 -t "Notebook"  -T 000000 -o training-key-source-notebook-on.png
sdkig -b 000000 -i laptop               -I 999999 -t "Notebook"  -T c0c0c0 -o training-key-source-notebook-off.png
sdkig -b ffffff -i wifi                 -I 000000 -t "NDI"       -T 000000 -o training-key-source-ndi-on.png
sdkig -b 000000 -i wifi                 -I 999999 -t "NDI"       -T c0c0c0 -o training-key-source-ndi-off.png

sdkig -b ff0000 -i dot-circle           -I ffffff -t "Record"    -T ffffff -o training-key-record-on.png
sdkig -b 660000 -i dot-circle           -I ffffff -t "Record"    -T ffffff -o training-key-record-off.png

