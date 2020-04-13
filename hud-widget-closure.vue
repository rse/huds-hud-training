<!--
/*
**  HUDS ~~ Head-Up-Display Server (HUDS)
**  Copyright (c) 2020 Dr. Ralf S. Engelschall <rse@engelschall.com>
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
                    <i v-bind:class="[ 'fa', 'fa-' + beginiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text" v-html="beginhinttext">
                </div>
            </div>
        </div>
        <div v-show="pauseShow" ref="pause" class="pause">
            <div class="left">
                <div class="icon">
                    <i v-bind:class="[ 'fa', 'fa-' + pauseiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text" v-html="pausehinttext">
                </div>
            </div>
        </div>
        <div v-show="endShow" ref="end" class="end">
            <div class="left">
                <div class="icon">
                    <i v-bind:class="[ 'fa', 'fa-' + endiconname ]"></i>
                </div>
            </div>
            <div class="right">
                <div class="text" v-html="endhinttext">
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
            background-color: var(--background);
            position: absolute;
            left: -50%;
            width: 50vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            perspective: 0px;
            .icon {
                font-size: 400px;
                transform-origin: 50% 50%;
                transform-style:  preserve-3d;
            }
        }
        .right {
            background-color: var(--background);
            position: absolute;
            right: -50%;
            width: 50vw;
            height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            .text {
                padding-right: 150px;
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                font-size: 32pt;
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
module.exports = {
    name: "closure",
    props: {
        opacity:        { type: Number, default: 1.0 },
        background:     { type: String, default: "" },
        beginiconname:  { type: String, default: "" },
        beginiconcolor: { type: String, default: "" },
        beginhinttext:  { type: String, default: "" },
        beginhintcolor: { type: String, default: "" },
        pauseiconname:  { type: String, default: "" },
        pauseiconcolor: { type: String, default: "" },
        pausehinttext:  { type: String, default: "" },
        pausehintcolor: { type: String, default: "" },
        endiconname:    { type: String, default: "" },
        endiconcolor:   { type: String, default: "" },
        endhinttext:    { type: String, default: "" },
        endhintcolor:   { type: String, default: "" }
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
        endIcon:   null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
        const animate = (which, el, direction) => {
            let promise
            const left  = el.querySelector(".left")
            const right = el.querySelector(".right")
            soundfx.play("click7")
            setTimeout(() => soundfx.play("whoosh2"), 500)
            const options = {
                duration: 4000,
                autoplay: true,
                direction: "normal",
                easing: "easeOutBounce"
            }
            if (direction === "open") {
                this[`${which}Show`] = true
                promise = Promise.all([
                    anime({ ...options, targets: left,  left:  [ 0, "-50%" ] }).finished,
                    anime({ ...options, targets: right, right: [ 0, "-50%" ] }).finished
                ]).then(() => {
                    this[`${which}Show`] = false
                    this[`${which}Icon`].pause()
                })
            }
            else if (direction === "close") {
                this[`${which}Show`] = true
                this[`${which}Icon`].play()
                promise = Promise.all([
                    anime({ ...options, targets: left,  left:  [ "-50%", 0 ] }).finished,
                    anime({ ...options, targets: right, right: [ "-50%", 0 ] }).finished
                ])
            }
            promise.then(() => {
                soundfx.play("click7")
            })
            return promise
        }
        const toggle = (which) => {
            if (this[which] === "open")
                animate(which, this.$refs[which], "close").then(() => { this[which] = "close" })
            else
                animate(which, this.$refs[which], "open").then(() => { this[which] = "open" })
        }
        this.$on("begin-toggle", () => toggle("begin"))
        this.$on("pause-toggle", () => toggle("pause"))
        this.$on("end-toggle",   () => toggle("end"))
    },
    mounted () {
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

