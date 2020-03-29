
Training HUD for HUDS
======================

**Training HUD for Head-Up-Display Server (HUDS)**

<p/>
<img src="https://nodei.co/npm/huds-hud-training.png?downloads=true&stars=true" alt=""/>

<p/>
<img src="https://david-dm.org/rse/huds-hud-training.png" alt=""/>

Abstract
--------

This is a Head-Up-Display (HUD) running under the Head-Up-Display Server
(HUDS) for performing online trainings as Webinars. It permanently
displays an animated progress bar in the bottom-left corner, an
animated title bar in the bottom-right corner, and a static logo in
the top-right corner. In addition, on-demand it displays one or more
animated banners in the top-left corner. The progress bar, title bar
and and banners can be controlled either interactively via keystrokes
(<kbd>LEFT</kbd>/<kbd>RIGHT</kbd> for the progress bar, <kbd>SPACE</kbd>
for the title bar and arbitrary configured keys for the banners) or
programmatically via HUDS' REST API.

Usage
-----

1. Start Training HUD:

    -   Option 1: Without any installation (directly from source tree):

        ```sh
        $ git clone https://github.com/rse/huds-hud-training
        $ cd huds-hud-training
        $ npm install
        $ vi training.yaml  # optionally edit the training configuration
        $ npm run huds -- \
            -a 127.0.0.1 -p 9999 \
          -U training -P training \
          -d training:.,training.yaml
        ```

    -   Option 2: Without any installation (from distribution)

        ```sh
        $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
        $ vi training.yaml  # optionally edit the training configuration
        $ npx -p huds-hud-training huds \
            -a 127.0.0.1 -p 9999 \
            -U training -P training \
            -d training:@huds-hud-training,training.yaml
        ```

    -   Option 3: With global system installation:

        ```sh
        $ npm install -g huds huds-hud-training
        $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
        $ vi training.yaml  # optionally edit the training configuration
        $ huds \
            -a 127.0.0.1 -p 9999 \
            -U training -P training \
            -d training:@huds-hud-training,training.yaml
        ```

2.  Start [OBS Studio](https://obsproject.com/)
    and add a [Browser Source](https://obsproject.com/wiki/Sources-Guide#browsersource)
    to any scene. As its URL use:

    ```
    http://training:training@127.0.0.1:9999/training/
    ```

    If you want to interact with it, right-click onto the source and
    choose "Interact". You can press <kbd>LEFT</kbd> (previous part),
    <kbd>RIGHT</kbd> (next part), <kbd>SPACE</kbd> (flash title),
    <kbd>p</kbd> (toggle Pause banner), <kbd>r</kbd> (toggle Rant
    banner) and <kbd>q</kbd> (toggle Q&A banner)
    in the interaction window.

3.  Now you can also remotely trigger the events with:

    ```sh
	curl -D- http://training:training@127.0.0.1:9999/training/event/progress.event=prev
	curl -D- http://training:training@127.0.0.1:9999/training/event/progress.event=next
	curl -D- http://training:training@127.0.0.1:9999/training/event/title.event=bounce
	curl -D- http://training:training@127.0.0.1:9999/training/event/banner-pause.event=toggle
	curl -D- http://training:training@127.0.0.1:9999/training/event/banner-rant.event=toggle
	curl -D- http://training:training@127.0.0.1:9999/training/event/banner-qna.event=toggle
    ```

4.  Optionally, trigger the events from an
    [Elgato Stream Deck](https://www.elgato.com/en/gaming/stream-deck)
    remote control device and its [System:Website](https://help.elgato.com/hc/en-us/articles/360028234471-Elgato-Stream-Deck-System-Actions) functions.
    For this generate key images with the help of the companion tool
    [Stream-Deck Key-Image Generator (SDKIG)](https://github.com/rse/sdkig)
	and the provided script [training-keys.sh](./training-keys.sh).
	Just use the [System:Website](https://help.elgato.com/hc/en-us/articles/360028234471-Elgato-Stream-Deck-System-Actions) function
	with the generated key images, the URLs above and just let them be executed in the background.

Example
-------

![screenshot](screenshot.jpg)

License
-------

Copyright &copy; 2020 Dr. Ralf S. Engelschall (http://engelschall.com/)

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

