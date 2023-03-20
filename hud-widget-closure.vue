<!--
/*
**  HUDS ~~ Head-Up-Display Server (HUDS)
**  Copyright (c) 2020-2023 Dr. Ralf S. Engelschall <rse@engelschall.com>
**
**  Permission is hereby granted, free of charge, to any person obtaining
**  a copy of this software and associated documentation files (the
**  "Software"), to deal in the Software without restriction, including
**  without limitation the rights to use, copy, modify, merge, publish,
**  distribute, sublicense, and/or sell copies of the Software, and to
**  permit persons to whom the Software is furnished to do so, subject to
**  the following conditions:
**
**  The above copyright notice and this permission notice shall be included
**  in all copies or substantial portions of the Software.
**
**  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
**  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
**  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
**  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
**  CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
**  TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
**  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
-->

<template>
    <div v-bind:style="style" class="closure">
        <div v-show="beginShow" ref="begin" class="begin">
            <div class="left">
                <div class="icon">
                    <i v-bind:class="[ 'fas', 'fa-' + beginiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text">
                    <div class="hint" v-html="beginhinttext">
                    </div>
                    <div v-if="privacylevel === 'closed'" class="privacy" v-html="privacyclosedtext">
                    </div>
                    <div v-if="privacylevel === 'open'" class="privacy" v-html="privacyopentext">
                    </div>
                </div>
            </div>
        </div>
        <div v-show="pauseShow" ref="pause" class="pause">
            <div class="left">
                <div class="icon">
                    <i v-bind:class="[ 'fas', 'fa-' + pauseiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text">
                    <div class="hint" v-html="pausehinttext">
                    </div>
                </div>
            </div>
        </div>
        <div v-show="endShow" ref="end" class="end">
            <div class="left">
                <div class="icon">
                    <i v-bind:class="[ 'fas', 'fa-' + endiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text">
                    <div class="hint" v-html="endhinttext">
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.closure {
    opacity: var(--opacity);
    .begin, .pause, .end {
        position: absolute;
        left: 0;
        top: 0;
        width: 100vw;
        height: 100vh;
        .left {
            background: linear-gradient(90deg, var(--background1) 0%, var(--background2) 100%);
            position: absolute;
            left: -50%;
            width: 50vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            .icon {
                font-size: 400px;
                transform-origin: 50% 50%;
                transform-style:  preserve-3d;
            }
        }
        .right {
            background: linear-gradient(90deg, var(--background2) 0%, var(--background1) 100%);
            position: absolute;
            right: -50%;
            width: 50vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            .text {
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                padding-left: 150px;
                padding-right: 200px;
                .hint {
                    font-size: 32pt;
                }
                .privacy {
                    margin-top: 50px;
                    font-size: 20pt;
                }
                .privacy::v-deep b {
                    font-weight: 500;
                }
            }
        }
    }
    .begin .left  .icon { color: var(--beginiconcolor); }
    .begin .right .text { color: var(--beginhintcolor); }
    .pause .left  .icon { color: var(--pauseiconcolor); }
    .pause .right .text { color: var(--pausehintcolor); }
    .end   .left  .icon { color: var(--endiconcolor);   }
    .end   .right .text { color: var(--endhintcolor);   }
}
</style>

<script>
export default {
    name: "closure",
    props: {
        opacity:           { type: Number, default: 1.0 },
        background1:       { type: String, default: "" },
        background2:       { type: String, default: "" },
        beginiconname:     { type: String, default: "" },
        beginiconcolor:    { type: String, default: "" },
        beginhinttext:     { type: String, default: "" },
        beginhintcolor:    { type: String, default: "" },
        pauseiconname:     { type: String, default: "" },
        pauseiconcolor:    { type: String, default: "" },
        pausehinttext:     { type: String, default: "" },
        pausehintcolor:    { type: String, default: "" },
        endiconname:       { type: String, default: "" },
        endiconcolor:      { type: String, default: "" },
        endhinttext:       { type: String, default: "" },
        endhintcolor:      { type: String, default: "" },
        privacylevel:      { type: String, default: "" },
        privacyclosedtext: { type: String, default: "" },
        privacyopentext:   { type: String, default: "" }
    },
    data: () => ({
        begin:     "open",
        beginShow: false,
        beginIcon: null,
        pause:     "open",
        pauseShow: false,
        pauseIcon: null,
        end:       "open",
        endShow:   false,
        endIcon:   null,
        soundid:   0
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        /*  animate a particular closure to open or close  */
        animate (which, el, direction) {
            /*  determine references to left and right parts  */
            const left  = el.querySelector(".left")
            const right = el.querySelector(".right")

            /*  play an initial sound effect  */
            soundfx.play("click7")
            setTimeout(() => soundfx.play("whoosh2"), 500)

            /*  shared animation options  */
            const options = {
                duration: 4000,
                autoplay: true,
                direction: "normal",
                easing: "easeOutBounce"
            }

            /*  distinguish animations  */
            let promise
            if (direction === "open") {
                /*  animate into open state  */
                this[`${which}Show`] = true
                if (this.soundid) {
                    soundlp.fade(1.0, 0.0, 4 * 1000, this.soundid)
                    soundlp.once("fade", () => soundlp.stop(this.soundid), this.soundid)
                }
                promise = Promise.all([
                    anime({ ...options, targets: left,  left:  [ 0, "-50%" ] }).finished,
                    anime({ ...options, targets: right, right: [ 0, "-50%" ] }).finished
                ]).then(() => {
                    this[`${which}Show`] = false
                    this[`${which}Icon`].pause()
                })
            }
            else if (direction === "close") {
                /*  animate into close state  */
                this[`${which}Show`] = true
                this[`${which}Icon`].play()
                promise = Promise.all([
                    anime({ ...options, targets: left,  left:  [ "-50%", 0 ] }).finished,
                    anime({ ...options, targets: right, right: [ "-50%", 0 ] }).finished
                ])
                this.soundid = soundlp.play("piano5")
                soundlp.fade(0.0, 1.0, 4 * 1000, this.soundid)
            }
            promise.then(() => {
                soundfx.play("click7")
            })
            return promise
        },
        toggle (which) {
            if (this[which] === "open")
                this.animate(which, this.$refs[which], "close")
                    .then(() => { this[which] = "close" })
            else
                this.animate(which, this.$refs[which], "open")
                    .then(() => { this[which] = "open" })
        }
    },
    mounted () {
        /*  create the animated icons  */
        const options = {
            duration: 6000,
            easing:   "easeInOutQuad",
            autoplay: false,
            loop:     true,
            delay:    2000,
            rotateY:  [ 0, 360 ]
        }
        this.beginIcon = anime({ targets: this.$refs.begin.querySelector(".icon"), ...options })
        this.pauseIcon = anime({ targets: this.$refs.pause.querySelector(".icon"), ...options })
        this.endIcon   = anime({ targets: this.$refs.end.querySelector(".icon"),   ...options })
    }
}
</script>

