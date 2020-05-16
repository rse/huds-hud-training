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
    <div v-bind:style="style" class="popup">
        <div v-for="popup in popups" ref="box" v-bind:key="popup.i" v-bind:data-i="popup.i"
            v-bind:class="{ box: true, [ popup.type ]: true }">
            <img v-if="popup.image" class="image" v-bind:src="popup.image" />
            <div v-if="popup.title" class="title">
                {{ popup.title }}
            </div>
            <div v-if="popup.audio" v-bind:class="{ audio: true, audioOnly: popup.text === '' }">
                <div v-show="!popup.audioPlaying">
                    <i class="fa fa-play-circle"></i>
                </div>
                <div v-show="popup.audioPlaying">
                    <i class="fa fa-stop-circle"></i>
                </div>
            </div>
            <div v-if="popup.audio && popup.audioDuration" class="message">
                 <span class="duration">(audio message duration: <b>{{ popup.audioDuration.toFixed(1) }}</b> sec)</span>
            </div>
            <div v-if="popup.text !== ''" class="message" v-html="popup.text">
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.popup {
    opacity: var(--opacity);
    .box {
        position: absolute;
        opacity: 0;
        left: 0;
        margin-top: 20px;
        width: calc(500px);
        padding: 20px;
        border-radius: 10px;
        .image {
            float: right;
            width: 150px;
            margin-bottom: 16px;
            margin-left: 32px;
            border-radius: 10px;
        }
        .title {
            display: block;
            font-family: "TypoPRO Fira Sans";
            font-weight: bold;
            font-size: 20pt;
        }
        .audio {
            float: left;
            display: inline-block;
            font-size: 40pt;
            margin-right: 12px;
            margin-top: 10px;
            margin-bottom: 2px;
        }
        .audio.audioOnly {
            font-size: 70pt;
        }
        .message {
            display: block;
            width: 100%;
            margin-top: 10px;
            font-family: "TypoPRO Fira Sans";
            font-size: 20pt;
            .duration {
                font-weight: 200;
                b {
                    font-weight: normal;
                }
            }
        }
        &.question {
            background-color: var(--questionbackground);
            .title   { color: var(--questiontitlecolor);   }
            .audio   { color: var(--questionmessagecolor); }
            .message { color: var(--questionmessagecolor); }
        }
        &.objection {
            background-color: var(--objectionbackground);
            .title   { color: var(--objectiontitlecolor);   }
            .audio   { color: var(--objectionmessagecolor); }
            .message { color: var(--objectionmessagecolor); }
        }
        &.comment {
            background-color: var(--commentbackground);
            .title   { color: var(--commenttitlecolor);   }
            .audio   { color: var(--commentmessagecolor); }
            .message { color: var(--commentmessagecolor); }
        }
    }
}
</style>

<script>
module.exports = {
    name: "title-bar",
    props: {
        opacity:               { type: Number, default: 1.0 },
        questionbackground:    { type: String, default: "" },
        questiontitlecolor:    { type: String, default: "" },
        questionmessagecolor:  { type: String, default: "" },
        objectionbackground:   { type: String, default: "" },
        objectiontitlecolor:   { type: String, default: "" },
        objectionmessagecolor: { type: String, default: "" },
        commentbackground:     { type: String, default: "" },
        commenttitlecolor:     { type: String, default: "" },
        commentmessagecolor:   { type: String, default: "" }
    },
    data: () => ({
        queue:  [],
        popups: []
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        /*  add a popup box  */
        async addBox (data) {
            if (data.audio) {
                const ac = new AudioContext()
                const blob = await (await fetch(data.audio)).blob()
                const arrayBuffer = await blob.arrayBuffer()
                const audioBuffer = await ac.decodeAudioData(arrayBuffer)
                data.audioDuration = audioBuffer.duration
                data.audioPlaying = false
            }
            return new Promise((resolve, reject) => {
                this.popups.unshift(data)
                this.$nextTick(() => {
                    /*  determine DOM elements  */
                    const els = this.$refs.box.sort((a, b) =>
                        parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
                    const newer  = els[0]
                    const others = els.slice(1)

                    /*  find target position on popup stack  */
                    let pos = 0
                    for (const el of others)
                        pos += el.clientHeight + 20

                    /*  indicate coming popup  */
                    if (pos < 1000)
                        soundfx.play("bling1")

                    /*  animate into target position on popup stack  */
                    anime({
                        targets:   newer,
                        duration:  pos < 1000 ? 2000 : 0,
                        autoplay:  true,
                        direction: "normal",
                        easing:    "easeOutBounce",
                        opacity:   [ 1.0, 1.0 ],
                        bottom:    [ 1000, pos ]
                    }).finished.then(() => {
                        resolve()
                    })
                })
            })
        },

        /*  play audio of a popup box  */
        async playBox () {
            if (this.popups.length === 0)
                return
            const data = this.popups[this.popups.length - 1]
            if (data.audio === undefined || data.audio === null)
                return
            const audioElement = new Audio()
            audioElement.src = data.audio
            audioElement.volume = 1.0
            data.audioPlaying = true
            this.$forceUpdate()
            audioElement.addEventListener("ended", () => {
                data.audioPlaying = false
                this.$forceUpdate()
            })
            audioElement.play()
        },

        /*  remove a popup box  */
        async removeBox () {
            if (this.popups.length === 0)
                return
            return new Promise((resolve, reject) => {
                /*  determine DOM elements  */
                const els = this.$refs.box.sort((a, b) =>
                    parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
                const others = els.slice(0, els.length - 1)
                const older  = els[els.length - 1]

                /*  determine height of popup to remove  */
                const diff = older.clientHeight + 20

                /*  fade out the popup  */
                anime({
                    targets:   older,
                    duration:  500,
                    autoplay:  true,
                    direction: "normal",
                    easing:    "easeOutSine",
                    opacity:   [ 1.0, 0.0 ]
                }).finished.then(() => {
                    /*  remove from popups  */
                    this.popups.pop()

                    /*  animate all the remaining popups into their new target position  */
                    let i = 0
                    const promises = []
                    for (const el of others.reverse()) {
                        /*  determine old and new position  */
                        const posOld = parseInt(el.style.bottom.toString().replace(/px$/, ""))
                        const posNew = posOld - diff

                        /*  shift popup into new position  */
                        promises.push(anime({
                            targets:   el,
                            duration:  1000,
                            autoplay:  true,
                            direction: "normal",
                            easing:    "easeOutBounce",
                            delay:     200 * i++,
                            bottom:    [ posOld, posNew ]
                        }).finished)
                    }
                    Promise.all(promises).then(() => {
                        resolve()
                    })
                })
            })
        }
    },
    created () {
        /*  allow a new popup to be added  */
        let i = 0
        this.$on("popup-add", (data) => {
            data.i = i++
            this.queue.push({ method: "addBox", args: [ data ] })
        })

        /*  allow audio of oldest popup to be played  */
        this.$on("popup-play", () => {
            this.queue.push({ method: "playBox", args: [] })
        })

        /*  allow the oldest popup to be removed  */
        this.$on("popup-remove", () => {
            this.queue.push({ method: "removeBox", args: [] })
        })

        /*  queue worker loop  */
        const progress = async () => {
            while (this.queue.length > 0) {
                const cmd = this.queue.shift()
                try {
                    await this[cmd.method](...cmd.args)
                }
                catch (err) {
                    /*  no-op  */
                }
            }
            this.timer = setTimeout(progress, 50)
        }
        this.timer = setTimeout(progress, 50)
    }
}
</script>

