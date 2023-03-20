
Training HUD for HUDS
======================

**Training HUD for Head-Up-Display Server (HUDS)**

<p/>
<img src="https://nodei.co/npm/huds-hud-training.png?downloads=true&stars=true" alt=""/>

<p/>
<img src="https://david-dm.org/rse/huds-hud-training.png" alt=""/>

Abstract
--------

This is a Head-Up-Display (HUD) running under the [Head-Up-Display Server
(HUDS)](https://github.com/rse/huds) for performing online trainings as broadcasted live-video streams.
It acts as a HUD or "overlay" in your video
production scenario. It is specially intended to be used with [OBS Studio](https://obsproject.com/)'s
[CEF](https://en.wikipedia.org/wiki/Chromium_Embedded_Framework)-based
[Browser Source](https://obsproject.com/wiki/Sources-Guide#browsersource)
and optionally the [Elgato Stream Deck](https://www.elgato.com/en/gaming/stream-deck)
remote control device and its [System:Website](https://help.elgato.com/hc/en-us/articles/360028234471-Elgato-Stream-Deck-System-Actions) function.

Example
-------

![screenshot-1](screenshot-1.jpg)

![screenshot-2](screenshot-2.png)

Usage
-----

1.  **Install [Node.js](https://nodejs.org/):**<br/>
    First, install the [Node.js](https://nodejs.org/) run-time execution environment
    by following the instructions on the [Node.js](https://nodejs.org/) website.

2.  **Install and Start Training HUD:**<br/>
    Now install and start this training HUD with the help of the
    [Head-Up-Display Server (HUDS)](https://github.com/rse/huds)
    and optionally a customized [training configuration](./training.yaml).
    Here you have three different options:

    -   **Option 1**: Without any installation (directly from source tree):

        ```sh
        $ git clone https://github.com/rse/huds-hud-training
        $ cd huds-hud-training
        $ npm install
        $ vi training.yaml  # optionally edit the training configuration
        $ npm run huds -- \
            -a 127.0.0.1 -p 9999 \
            -d training:.,training.yaml
        ```

    -   **Option 2**: Without any installation (from distribution)

        ```sh
        $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
        $ vi training.yaml  # optionally edit the training configuration
        $ npx -p huds -p huds-hud-training huds \
            -a 127.0.0.1 -p 9999 \
            -d training:@huds-hud-training,training.yaml
        ```

    -   **Option 3**: With global system installation:

        ```sh
        $ npm install -g huds huds-hud-training
        $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
        $ vi training.yaml  # optionally edit the training configuration
        $ huds \
            -a 127.0.0.1 -p 9999 \
            -d training:@huds-hud-training,training.yaml
        ```

    Hint: when customizing the [training configuration](./training.yaml)
    feel free to both replace (for adjustment) or even completey
    kick-out (for disabling) the `title`, `progress`, `banner` and
    `logo` sections.

3.  **Start [OBS Studio](https://obsproject.com/)**:</br>
    Start [OBS Studio](https://obsproject.com/) and add a [Browser
    Source](https://obsproject.com/wiki/Sources-Guide#browsersource) to
    any scene. As the URL for the browser source use:

    ```
    http://127.0.0.1:9999/training/
    ```

4.  **Locally Control HUD** (Keystrokes):<br/>
    If you want to interact with the HUD directly from within [OBS
    Studio](https://obsproject.com/), right-click onto the browser
    source and choose "Interact". In the interaction window, you then
    can press the particular control keys mentioned for each Widget
    below.

5.  **Remote Control HUD (Programmatically)**:<br/>
    Now you can also programmatically control the HUD by remotely triggering the events
    from any shell with the help of the [cURL](https://curl.haxx.se/) utility:

    ```sh
	curl -D- http://127.0.0.1:9999/training/event/logo.animate
	curl -D- http://127.0.0.1:9999/training/event/title.animate
	curl -D- http://127.0.0.1:9999/training/event/progress.prev
	curl -D- http://127.0.0.1:9999/training/event/progress.next
	curl -D- http://127.0.0.1:9999/training/event/agenda.toggle
	curl -D- http://127.0.0.1:9999/training/event/attendance.animate
	curl -D- http://127.0.0.1:9999/training/event/attendance?data={"client":"...","event":"..."}
	curl -D- http://127.0.0.1:9999/training/event/attendees.toggle
	curl -D- http://127.0.0.1:9999/training/event/latency.toggle
	curl -D- http://127.0.0.1:9999/training/event/timer.start?data=<minutes>
	curl -D- http://127.0.0.1:9999/training/event/timer.stop
	curl -D- http://127.0.0.1:9999/training/event/votes.toggle
	curl -D- http://127.0.0.1:9999/training/event/votes.type.judge
	curl -D- http://127.0.0.1:9999/training/event/votes.type.evaluate
	curl -D- http://127.0.0.1:9999/training/event/votes.type.quiz
	curl -D- http://127.0.0.1:9999/training/event/votes.type.choose
	curl -D- http://127.0.0.1:9999/training/event/votes.type.propose
	curl -D- http://127.0.0.1:9999/training/event/votes.receive?data={"client":"...","choice":"..."}
	curl -D- http://127.0.0.1:9999/training/event/votes.reveal
	curl -D- http://127.0.0.1:9999/training/event/votes.disclose
	curl -D- http://127.0.0.1:9999/training/event/votes.quiz.prev
	curl -D- http://127.0.0.1:9999/training/event/votes.quiz.next
	curl -D- http://127.0.0.1:9999/training/event/popup.add?data={"client":"...","type":<type>[,"title":"..."],"text":"..."[,"image":"..."][,"audio":"..."]}
	curl -D- http://127.0.0.1:9999/training/event/popup.remove
	curl -D- http://127.0.0.1:9999/training/event/feeling.toggle
	curl -D- http://127.0.0.1:9999/training/event/feeling?data={"client":"...","challenge":N,"mood":M}
	curl -D- http://127.0.0.1:9999/training/event/feedback?data={"client":"...","type":"..."}
	curl -D- http://127.0.0.1:9999/training/event/banner.pause.toggle
	curl -D- http://127.0.0.1:9999/training/event/banner.rant.toggle
	curl -D- http://127.0.0.1:9999/training/event/banner.qna.toggle
	curl -D- http://127.0.0.1:9999/training/event/closure.begin.toggle
	curl -D- http://127.0.0.1:9999/training/event/closure.pause.toggle
	curl -D- http://127.0.0.1:9999/training/event/closure.end.toggle
	curl -D- http://127.0.0.1:9999/training/event/message?data={"client":"...","text":"..."[,"image":"..."][,"audio":"..."]}
	curl -D- http://127.0.0.1:9999/training/event/confetti.raise
	curl -D- http://127.0.0.1:9999/training/event/snowfall.toggle
	curl -D- http://127.0.0.1:9999/training/event/peer.reconnect
	curl -D- http://127.0.0.1:9999/training/event/peer.disconnect
    ```

6.  **Remote Control HUD (Device)**:<br/>
    Optionally, trigger the events from an
    [Elgato Stream Deck](https://www.elgato.com/en/gaming/stream-deck)
    remote control device and its [System:Website](https://help.elgato.com/hc/en-us/articles/360028234471-Elgato-Stream-Deck-System-Actions) functions.
    For this, generate key images with the help of the companion tool
    [Stream-Deck Key-Image Generator (SDKIG)](https://github.com/rse/sdkig)
	and the provided script [training-key.sh](./training-key.sh).
	Just use the [System:Website](https://help.elgato.com/hc/en-us/articles/360028234471-Elgato-Stream-Deck-System-Actions) function
	with the generated key images, the URLs above and just let them be executed in the background.

Widgets
-------

This HUD provides the following on-screen widgets:

-   **LOGO**:<br/>
    This widget displays a logo at the top-right of the screen
    and rotationally animates it every 5 minutes automatically.
    The intention of this widget is to just provide some
    vendor/employer-related branding. The widget has to be configured
    with...

    ```yaml
    logo:
        opacity:               0.60
        svg: |
            <svg>[...]</svg>
    ```

    ...and can be manually animated interactively with the keystroke
    <kbd>l</kbd> or programmatically with the remote HUDS event
    `logo.animate`.

-   **TITLE**:<br/>
    This widget displays a title bar at the bottom-right of the
    screen. The intention of this widget is to just provide some
    training-specific branding. The widget has to be configured with...

    ```yaml
    title:
        opacity:               0.80
        background:            "#336699"
        iconname:              graduation-cap
        iconcolor:             "#77aadd"
        nametext:              Dr. Ralf S. Engelschall
        namecolor:             "#e0f0ff"
        titletext:             Grundlagen der IT-Architektur
        titlecolor:            "#ffffff"
    ```

    ...and can be manually animated interactively with the keystroke
    <kbd>t</kbd> or programmatically with the remote HUDS event
    `title.animate`.

-   **ATTENDANCE**:<br/>
    This widget displays a short box at the bottom-right of the screen
    with the number of attendees. The intention of this widget is to
    just provide some audience size information. The widget has to be
    configured with...

    ```yaml
    attendance:
        opacity:               0.80
        background:            "#6699cc"
        iconcolor:             "#99ccff"
        textcolor:             "#e0f0ff"
    ```

    ...and can be manually animated interactively with the keystroke
    <kbd>A</kbd> or programmatically with the remote HUDS event
    `attendance.animate`. The number of attendees is tracked by the
    remote HUDS event `attendance` (usually injected into HUDS via MQTT
    through the integration of a companion message queue system).

-   **ATTENDEES**:<br/>
    This widget displays a large box at the left edge of the screen with
    the portraits and names of all attendees. The intention of this
    widget is to provide a visual overview of the audience. The widget
    has to be configured with...

    ```yaml
    attendance:
        opacity:               0.80
        background:            "#336699"
        namecolorbg:           "#003366"
        namecolorfg:           "#e0f0ff"
        noattendeestext:       "This training has still no attendees."
    ```

    ...and can be manually toggled on/off interactively with the keystroke
    <kbd>e</kbd> or programmatically with the remote HUDS event
    `attendees.toggle`. The number of attendees is tracked by the
    remote HUDS event `attendance` (usually injected into HUDS via MQTT
    through the integration of a companion message queue system).

-   **FEEDBACK**:<br/>
    This widget displays bouncing smilies at the right edge of the
    screen. The intention of this widget is to allow visual feedback for
    the audience. The widget has to be configured with...

    ```yaml
    feedback:
        opacity:               0.80
        surprisecolor1:        "#222222"
        surprisecolor2:        "#f0f0f0"
        surprisecolor3:        "#c0c0c0"
        surprisecolor4:        "#000000"
        smilecolor1:           "#221100"
        smilecolor2:           "#d08840"
        smilecolor3:           "#a05810"
        smilecolor4:           "#ffffff"
        frowncolor1:           "#99ccff"
        frowncolor2:           "#336699"
        frowncolor3:           "#003366"
        frowncolor4:           "#ffffff"
        sadnesscolor1:         "#cccccc"
        sadnesscolor2:         "#333333"
        sadnesscolor3:         "#000000"
        sadnesscolor4:         "#ffffff"
    ```

    ...and can be controlled programmatically with the remote HUDS
    event `feedback?data={"client":"...","type":"..."}`. The client is
    a unique id of the client and type can select one of the following
    four smilies: `surprise`, `smile`, `frown` or `sadness`.

-   **FEELING**:<br/>
    This widget displays a statistics box at the right corner and above
    the title widget. The intention of this widget is to allow attendees
    to continuously express their feeling and let the tainer regularly
    show an aggregated view on the feelings. The widget has to be
    configured with...

    ```yaml
    feeling:
        opacity:               0.80
        background:            "#336699"
        textcolor:             "#e0f0ff"
        stdbarcolor:           "#d0e0f0"
        maxbarcolor:           "#ffffff"
        bordercolor:           "#99ccff"
        legendcolor:           "#ffffff"
        c1color:               "#b06820"
        c2color:               "#909090"
        c3color:               "#336699"
        c4color:               "#909090"
        c5color:               "#b06820"
        m1color:               "#905810"
        m2color:               "#b06820"
        m3color:               "#909090"
        m4color:               "#336699"
        m5color:               "#225588"
    ```

    ...and can be manually toggled on/off interactively with the
    keystroke <kbd>f</kbd> or programmatically with the remote HUDS
    event `feeling.toggle`. The feelings are tracked by the remote
    HUDS event `feeling?data={"client":"...","challenge":N,"mood":M}`
    (usually injected into HUDS via MQTT through the integration of a
    companion message queue system).

-   **PROGRESS**:<br/>
    This widget displays a permanently visible progress bar at the
    bottom-left of the screen. The intention of this widget is to allow
    the attendees to see the current training progress at any time. The
    widget has to be configured with...

    ```yaml
    progress:
        opacity:               0.80
        slots:                 16
        donecolorbg:           "#6699cc"
        donecolorfg:           "#f0f0ff"
        currcolorbg:           "#336699"
        currcolorfg:           "#ffffff"
        todocolorbg:           "#f0f0f0"
        todocolorfg:           "#999999"
    ```

    ...and is controlled interactively with the keystrokes
    <kbd>LEFT</kbd> (previous slot) and <kbd>RIGHT</kbd>
    (next slot) or programmatically with the remote HUDS events
    `progress.prev` (previous slot) and
    `progress.next` (next slot).

-   **AGENDA**:<br/>
    This widget displays a training agenda list at the left border of
    the screen. The intention of this widget is to allow the attendees
    to regularly see the agenda slots and current training progress
    during the training. The widget has to be configured with...

    ```yaml
    agenda:
        opacity:               0.90
        donecolorbg:           "#6699cc"
        donecolorfg:           "#f0f0ff"
        currcolorbg:           "#336699"
        currcolorfg:           "#ffffff"
        todocolorbg:           "#f0f0f0"
        todocolorfg:           "#999999"
        slots:
            -   Agenda point 1
            -   Agenda point 2
            [...]
    ```

    ...and is toggled interactively with the keystroke
    <kbd>a</kbd> or programmatically with the remote HUDS event
    `agenda.toggle`.

-   **LATENCY**:<br/>
    This widget displays a latency timer at the bottom-right
    corner of the screen. The intention of this widget is to allow
    one to determine the network latency, i.e., the lag between
    uploading/upstreaming the video stream (a the trainer side) and
    the downloading/downstreaming of the video stream (usually at the
    attendee side). For this it displays the current (upstreaming)
    time and keeps space for the downstreaming time, which has to be
    overlayed separately to the HUD in OBS Studio through an RTMP
    downstream Media Source. It has to be configured with...

    ```yaml
    latency:
        opacity:               0.80
        background:            "#336699"
        foreground:            "#ffffff"
        iconcolor:             "#77aadd"
    ```

    ...and is toggled interactively with the keystroke
    <kbd>!</kbd> or programmatically with the remote HUDS event
    `latency.toggle`.

-   **TIMER**:<br/>
    This widget displays a combined wall clock and stopwatch at the
    bottom-left corner of the screen. The intention of this widget is
    to allow the trainer to raise a pause for a certain amount of time
    and clearly indicate the remaining time to the attendees. It has to
    be configured with...

    ```yaml
    timer:
        opacity:               0.80
        background1:           "#555555"
        background2:           "#f0f0f0"
        ticks:                 "#333333"
        digits:                "#666666"
        pointer1:              "#000000"
        pointer2:              "#222222"
        pointer3:              "#cc3333"
        segment1:              "#b06820"
        segment2:              "#f4dbc2"
        segment3:              "#2068b0"
        segment4:              "#c2dbf4"
    ```

    ...and is controlled interactively with the keystrokes
    <kbd>0</kbd> (stop timer manually),
    <kbd>1</kbd> (start 5-minute timer),
    <kbd>2</kbd> (start 10-minute timer),
    <kbd>3</kbd> (start 15-minute timer),
    <kbd>4</kbd> (start 20-minute timer),
    <kbd>5</kbd> (start 25-minute timer),
    <kbd>6</kbd> (start 30-minute timer),
    <kbd>7</kbd> (start 35-minute timer),
    <kbd>8</kbd> (start 40-minute timer) and
    <kbd>9</kbd> (start 45-minute timer),
    or programmatically with the remote HUDS events
    `timer.stop` and `timer.start?data=<minutes>`.

-   **VOTES**:<br/>
    This widget displays voting results at the bottom-left corner of the
    screen. The intention of this widget is to allow the attendees to
    give votes during the training which are anonymously shown by the
    trainer. It has to be configured with...

    ```yaml
    votes:
        opacity:               0.90
        winnamecolorbg:        "#b06820"
        winnamecolorfg:        "#ffffff"
        maxnamecolorbg:        "#336699"
        maxnamecolorfg:        "#ffffff"
        stdnamecolorbg:        "#6699cc"
        stdnamecolorfg:        "#ffffff"
        xtrnamecolorbg:        "#999999"
        xtrnamecolorfg:        "#ffffff"
        winvotecolorbg:        "#ffffff"
        winvotecolorfg:        "#666666"
        maxvotecolorbg:        "#ffffff"
        maxvotecolorfg:        "#666666"
        stdvotecolorbg:        "#f0f0f0"
        stdvotecolorfg:        "#999999"
        xtrvotecolorbg:        "#f0f0f0"
        xtrvotecolorfg:        "#999999"
        allvotecolorbg:        "#60606080"
        allvotecolorbd:        "#999999"
        quizidcolorbg:         "#225588"
        quizidcolorfg:         "#e0e0ff"
        quiztxtcolorbg:        "#336699"
        quiztxtcolorfg:        "#ffffff"
        hintcolorbg:           "#f0f0f0"
        hintcolorfg:           "#666666"
    ```

    ...and is toggled interactively with the keystroke <kbd>v</kbd> or
    programmatically with the remote HUDS event `votes.toggle`. The
    votes of the attendees are extracted from the `text`
    field in data received with the remote HUDS event `message` (usually
    injected into HUDS via MQTT through the integration of a companion
    chat system).

-   **POPUP**:<br/>
    This widget displays popups at the bottom-left corner of the
    screen. The intention of this widget is to let attendees raise
    questions, objections and comments during the training.
    It has to be configured with...

    ```yaml
    popup:
        opacity:               0.80
        questionbackground:    "#336699"
        questiontitlecolor:    "#e0f0ff"
        questionmessagecolor:  "#ffffff"
        objectionbackground:   "#333333"
        objectiontitlecolor:   "#e0e0e0"
        objectionmessagecolor: "#ffffff"
        commentbackground:     "#f0f0f0"
        commenttitlecolor:     "#333333"
        commentmessagecolor:   "#000000"
    ```

    ...and is controlled interactively with the keystroke
    <kbd>BACKSPACE</kbd> (for removing the lowest/oldest popup) or
    programmatically with the remote HUDS event `popup.remove`. The
    popups of the attendees are extracted from `text` field in data
    received with the remote HUDS event `message` (usually injected into
    HUDS via MQTT through the integration of a companion chat system). A
    message ending in "?" is considered a question. a message ending in
    "!" is considered an objection and everything else is considered a
    comment. In addition to the HUDS event `message` one can also use the
    `popup.add` event with the data `{ client, text, title?, image?, type }`
    to add a popup.

-   **BANNER**:<br/>
    This widget displays arbitrary banners at the top-left corner of the
    screen. The intention of this widget is to flag special parts of the
    training, ensure that the right expectations for the attendees and
    allow one to also easily recognize the flagged parts in a potential
    video recording of the training. It has to be configured with...

    ```yaml
    banner:
        opacity:               0.80
        background:            "#f0f0f0"
        banner:
            -   name:          pause
                key:           p
                iconname:      pause-circle
                iconcolor:     "#336699"
                titletext:     PAUSE
                titlecolor:    "#000000"
            -   name:          rant
                key:           r
                iconname:      radiation-alt
                iconcolor:     "#bb0000"
                titletext:     RANT
                titlecolor:    "#000000"
            -   name:          qna
                key:           q
                iconname:      comments
                iconcolor:     "#ccaa00"
                titletext:     "Q&A"
                titlecolor:    "#000000"
    ```

    ...and is controlled interactively with the configured
    keystrokes (in the example <kbd>p</kbd>, <kbd>r</kbd> and
    <kbd>q</kbd>) or programmatically with the remote HUDS events
    `banner.<i>name</i>.toggle` (in the example with the
    names `pause`, `rant` and `qna`).

-   **CLOSURE**:<br/>
    This widget displays three partly-transparent full-screen closures.
    The intention of this widget is clearly indicate the begin phase
    (the time before the training starts but where the video streaming
    has to be ensured to work), the pause phases (the time the trainer
    is away from the video stream) and the end phase (the time after
    the training ended but where the video streaming is still sent).
    It has to be configured with...

    ```yaml
    closure:
        opacity:               0.75
        background:            "#000000"
        beginiconname:         "play-circle"
        beginiconcolor:        "#b06820"
        beginhinttext:         "The training will start soon.<br/>Please be patient!"
        beginhintcolor:        "#ffffff"
        pauseiconname:         "pause-circle"
        pauseiconcolor:        "#336699"
        pausehinttext:         "The training is paused.<br/>Please be patient!"
        pausehintcolor:        "#ffffff"
        endiconname:           "stop-circle"
        endiconcolor:          "#b06820"
        endhinttext:           "The training already has ended.<br/>Thanks for your attention!"
        endhintcolor:          "#ffffff"
    ```

    ...and is controlled interactively with the keystrokes
    <kbd>UP</kbd> (for begin closure), <kbd>RETURN</kbd>
    (for pause closure) and <kbd>DOWN</kbd> (for end
    closure) or programmatically with the remote HUDS events
    `closure.begin.toggle`, `closure.pause.toggle`
    and `closure.end.toggle`.

-   **CONFETTI**:<br/>
    This widget displays a confetti bomb.
    The intention of this widget is to celebrate a special situation.
    It has to be configured with...

    ```yaml
    confetti:
        opacity:               1.00
    ```

    ...and is controlled interactively with the keystroke <kbd>c</kbd>
    or programmatically with the remote HUDS event `confetti.raise`.

-   **SNOWFALL**:<br/>
    This widget displays a snowfall.
    The intention of this widget is to celebrate a special situation.
    It has to be configured with...

    ```yaml
    snowfall:
        opacity:               1.00
    ```

    ...and is controlled interactively with the keystroke <kbd>s</kbd>
    or programmatically with the remote HUDS event `snowfall.toggle`.

License
-------

Copyright &copy; 2020-2023 Dr. Ralf S. Engelschall (http://engelschall.com/)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

