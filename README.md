
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
displays an animated progress bar in the bottom-left corner, an animated
title bar in the bottom-right corner, and a static logo in the top-right
corner. In addition, on-demand it displays one or more animated banners
in the top-left corner. The progress bar, title bar and and banners can
be controlled either interactively via keystrokes (LEFT/RIGHT for the
progress bar, SPACE for the title bar and arbitrary configured keys for
the banners) or programmatically via HUDS' REST API.

Usage
-----

-   Without any installation (directly from source tree):

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

-   Without any installation (from distribution)

    ```sh
    $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
    $ vi training.yaml  # optionally edit the training configuration
    $ npx -p huds-hud-training huds \
        -a 127.0.0.1 -p 9999 \
        -U training -P training \
        -d training:@huds-hud-training,training.yaml
    ```

-   With global system installation:

    ```sh
    $ npm install -g huds huds-hud-training
    $ curl -LO https://github.com/rse/huds-hud-training/raw/master/training.yaml
    $ vi training.yaml  # optionally edit the training configuration
    $ huds \
        -a 127.0.0.1 -p 9999 \
        -U training -P training \
        -d training:@huds-hud-training,training.yaml
    ```

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

