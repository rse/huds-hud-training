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

sdkig -b 336699 -s tag      -S 6699cc -i pause-circle          -I 99ccff -t "PAUSE"     -T ffffff -o training-key-hud-banner-pause.png
sdkig -b 336699 -s tag      -S 6699cc -i radiation-alt         -I 99ccff -t "RANT"      -T ffffff -o training-key-hud-banner-rant.png
sdkig -b 336699 -s tag      -S 6699cc -i award                 -I 99ccff -t "PRAISE"    -T ffffff -o training-key-hud-banner-praise.png
sdkig -b 336699 -s tag      -S 6699cc -i comments              -I 99ccff -t "Q&A"       -T ffffff -o training-key-hud-banner-qna.png

sdkig -b 336699 -s list-alt -S 6699cc -i chevron-circle-left   -I 99ccff -t "PREV"      -T ffffff -o training-key-hud-progress-prev.png
sdkig -b 336699 -s list-alt -S 6699cc -i chevron-circle-right  -I 99ccff -t "NEXT"      -T ffffff -o training-key-hud-progress-next.png

sdkig -b 336699                       -i list-alt              -I 99ccff -t "AGENDA"    -T ffffff -o training-key-hud-agenda.png

sdkig -b 336699 -s comment  -S 6699cc -i times-circle          -I 99ccff -t "DISMISS"   -T ffffff -o training-key-hud-popup-dismiss.png
sdkig -b 336699 -s comment  -S 6699cc -i play-circle           -I 99ccff -t "PLAY"      -T ffffff -o training-key-hud-popup-play.png

sdkig -b 336699                       -i sync-alt              -I 99ccff -t "LOGO"      -T ffffff -o training-key-hud-logo.png

sdkig -b 336699                       -i poll-h                -I 99ccff -t "VOTE"      -T ffffff -o training-key-hud-vote.png
sdkig -b 336699 -s poll-h -S 6699cc   -i gavel                 -I 99ccff -t "JUDGE"     -T ffffff -o training-key-hud-vote-judge.png
sdkig -b 336699 -s poll-h -S 6699cc   -i tachometer-alt        -I 99ccff -t "EVAL"      -T ffffff -o training-key-hud-vote-eval.png
sdkig -b 336699 -s poll-h -S 6699cc   -i hand-pointer          -I 99ccff -t "CHOOSE"    -T ffffff -o training-key-hud-vote-choose.png
sdkig -b 336699 -s poll-h -S 6699cc   -i comment-dots          -I 99ccff -t "PROPOSE"   -T ffffff -o training-key-hud-vote-propose.png

sdkig -b 336699                       -i clock                 -I 99ccff -t "TIMER-5"   -T ffffff -o training-key-hud-timer-5.png
sdkig -b 336699                       -i clock                 -I 99ccff -t "TIMER-10"  -T ffffff -o training-key-hud-timer-10.png
sdkig -b 336699                       -i clock                 -I 99ccff -t "TIMER-15"  -T ffffff -o training-key-hud-timer-15.png
sdkig -b 336699                       -i clock                 -I 99ccff -t "TIMER-45"  -T ffffff -o training-key-hud-timer-45.png
sdkig -b 996633                       -i clock                 -I eebb88 -t "TIMER-0"   -T ffffff -o training-key-hud-timer-0.png

sdkig -b 336699                       -i chart-bar             -I 99ccff -t "FEELING"   -T ffffff -o training-key-hud-feeling.png

sdkig -b 996633                       -i cloud-upload-alt      -I eebb88 -t "LTCY-UP"   -T ffffff -o training-key-hud-latency-upstream.png
sdkig -b 996633                       -i cloud-download-alt    -I eebb88 -t "LTCY-DOWN" -T ffffff -o training-key-hud-latency-downstream-on.png
sdkig -b 000000                       -i cloud-download-alt    -I 999999 -t "LTCY-DOWN" -T c0c0c0 -o training-key-hud-latency-downstream-off.png

sdkig -b 996633 -s th-large -S bb8855 -i play-circle           -I eebb88 -t "BEGIN"     -T ffffff -o training-key-hud-closure-begin.png
sdkig -b 996633 -s th-large -S bb8855 -i pause-circle          -I eebb88 -t "PAUSE"     -T ffffff -o training-key-hud-closure-pause.png
sdkig -b 996633 -s th-large -S bb8855 -i stop-circle           -I eebb88 -t "END"       -T ffffff -o training-key-hud-closure-end.png

sdkig -b ff0000                       -i wifi                  -I ffe0e0 -t "STREAM"    -T ffffff -o training-key-hud-egress-stream-on.png
sdkig -b 000000                       -i wifi                  -I 999999 -t "STREAM"    -T c0c0c0 -o training-key-hud-egress-stream-off.png
sdkig -b ff0000                       -i dot-circle            -I ffe0e0 -t "RECORD"    -T ffffff -o training-key-hud-egress-record-on.png
sdkig -b 000000                       -i dot-circle            -I 999999 -t "RECORD"    -T c0c0c0 -o training-key-hud-egress-record-off.png

sdkig -b 339900                       -i video                 -I c0ffa0 -t "CAMERAS"   -T ffffff -o training-key-obs-source-cameras-on.png
sdkig -b 000000                       -i video                 -I 999999 -t "CAMERAS"   -T c0c0c0 -o training-key-obs-source-cameras-off.png
sdkig -b 339900                       -i microphone-alt        -I c0ffa0 -t "MICROS"    -T ffffff -o training-key-obs-source-micros-on.png
sdkig -b 000000                       -i microphone-alt        -I 999999 -t "MICROS"    -T c0c0c0 -o training-key-obs-source-micros-off.png
sdkig -b 339900                       -i tablet                -I c0ffa0 -t "TABLET"    -T ffffff -o training-key-obs-source-tablet-on.png
sdkig -b 000000                       -i tablet                -I 999999 -t "TABLET"    -T c0c0c0 -o training-key-obs-source-tablet-off.png
sdkig -b 339900                       -i laptop                -I c0ffa0 -t "NOTEBOOK"  -T ffffff -o training-key-obs-source-notebook-on.png
sdkig -b 000000                       -i laptop                -I 999999 -t "NOTEBOOK"  -T c0c0c0 -o training-key-obs-source-notebook-off.png
sdkig -b 339900                       -i camera                -I c0ffa0 -t "NDI"       -T ffffff -o training-key-obs-source-ndi-on.png
sdkig -b 000000                       -i camera                -I 999999 -t "NDI"       -T c0c0c0 -o training-key-obs-source-ndi-off.png

sdkig -b 339900                       -i images                -I c0ffa0 -t "STUDIO"    -T ffffff -o training-key-obs-scene-studio-on.png
sdkig -b 000000                       -i images                -I 999999 -t "STUDIO"    -T c0c0c0 -o training-key-obs-scene-studio-off.png
sdkig -b 339900                       -i image                 -I c0ffa0 -t "SCREENS"   -T ffffff -o training-key-obs-scene-screens-on.png
sdkig -b 000000                       -i image                 -I 999999 -t "SCREENS"   -T c0c0c0 -o training-key-obs-scene-screens-off.png

sdkig -b 339900                       -i lightbulb             -I c0ffa0 -t "LIGHT"     -T ffffff -o training-key-obs-light-on.png
sdkig -b 000000                       -i lightbulb             -I 999999 -t "LIGHT"     -T c0c0c0 -o training-key-obs-light-off.png

sdkig -b 000000                       -i arrow-alt-circle-up   -I 888888 -t "PAGE-PREV" -T c0c0c0 -o training-key-sdk-page-prev.png
sdkig -b 000000                       -i arrow-alt-circle-down -I 888888 -t "PAGE-NEXT" -T c0c0c0 -o training-key-sdk-page-next.png

