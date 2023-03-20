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
    <div v-bind:style="style" class="popup">
        <div v-for="(popup, i) in popups" v-bind:ref="(el) => boxes[i] = el" v-bind:key="popup.i" v-bind:data-i="popup.i"
            v-bind:class="{ box: true, [ popup.type ]: true }">
            <img v-if="popup.image" class="image" v-bind:src="popup.image" />
            <div v-if="popup.title" class="title">
                {{ popup.title }}
            </div>
            <div v-if="popup.audio" v-bind:class="{ audio: true, audioOnly: popup.text === '' }">
                <div v-show="!popup.audioPlaying">
                    <i class="fas fa-play-circle"></i>
                </div>
                <div v-show="popup.audioPlaying">
                    <i class="fas fa-stop-circle"></i>
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
    .box {
        position: absolute;
        left: 0;
        margin-top: 20px;
        width: calc(1000px);
        padding: 20px;
        border-radius: 10px;
        box-shadow: 2px 2px 10px 0px rgba(0, 0, 0, 0.75);
        .image {
            float: right;
            width: 200px;
            margin-bottom: 16px;
            margin-left: 32px;
            border-radius: 10px;
        }
        .title {
            display: block;
            font-family: "TypoPRO Fira Sans";
            font-weight: bold;
            font-size: 32pt;
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
            font-size: 32pt;
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
export default {
    name: "title-bar",
    props: {
        questionbackground:    { type: String, default: "" },
        questiontitlecolor:    { type: String, default: "" },
        questionmessagecolor:  { type: String, default: "" },
        objectionbackground:   { type: String, default: "" },
        objectiontitlecolor:   { type: String, default: "" },
        objectionmessagecolor: { type: String, default: "" },
        commentbackground:     { type: String, default: "" },
        commenttitlecolor:     { type: String, default: "" },
        commentmessagecolor:   { type: String, default: "" },
        privacylevel:          { type: String, default: "" }
    },
    data: () => ({
        queue:     [],
        popups:    [],
        attendees: {},
        timer:     null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    setup () {
        const boxes = Vue.ref([])
        Vue.onBeforeUpdate(() => { boxes.value = [] })
        return { boxes }
    },
    methods: {
        /*  add a popup box  */
        async addBox (data) {
            if (data.audio) {
                const dataURItoArrayBuffer = (dataURI) => {
                    dataURI = dataURI.split(",")
                    const byteString = window.atob(dataURI[1])
                    const byteStringLen = byteString.length
                    const ab = new ArrayBuffer(byteStringLen)
                    const intArray = new Uint8Array(ab)
                    for (let i = 0; i < byteStringLen; i++)
                        intArray[i] = byteString.charCodeAt(i)
                    return ab
                }
                const ac = new AudioContext()
                const arrayBuffer = dataURItoArrayBuffer(data.audio)
                const audioBuffer = await ac.decodeAudioData(arrayBuffer)
                data.audioDuration = audioBuffer.duration
                data.audioPlaying = false
            }
            return new Promise((resolve, reject) => {
                this.popups.unshift(data)
                this.$nextTick(() => {
                    /*  determine DOM elements  */
                    const els = this.boxes.filter((x) => x !== null).sort((a, b) =>
                        parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
                    const newer  = els[0]
                    const others = els.slice(1)

                    /*  find target position on popup stack  */
                    let pos = 0
                    for (const el of others)
                        pos += el.clientHeight + 20

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

        /*  remove a popup box  */
        async removeBox () {
            if (this.popups.length === 0)
                return
            return new Promise((resolve, reject) => {
                /*  determine DOM elements  */
                const els = this.boxes.filter((x) => x !== null).sort((a, b) =>
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
        },

        /*  allow a new popup to be added  */
        add: (function () {
            let i = 0
            return function (data) {
                data.i = i++
                if (this.attendees[data.client] !== undefined) {
                    if (typeof data.title !== "string" && this.attendees[data.client].name !== "")
                        data.title = this.attendees[data.client].name
                    if (typeof data.image !== "string" && this.attendees[data.client].image !== "")
                        data.image = this.attendees[data.client].image
                }
                this.queue.push({ method: "addBox", args: [ data ] })
            }
        })(),

        /*  allow the oldest popup to be removed  */
        remove () {
            this.queue.push({ method: "removeBox", args: [] })
        },

        /*  receive the attendee events  */
        attendance (data) {
            if (data.event === "begin") {
                let image     = data.data && data.data.image   ? data.data.image   : ""
                let name      = data.data && data.data.name    ? data.data.name    : ""
                const privacy = data.data && data.data.privacy ? data.data.privacy : "private"
                if (   (this.privacylevel === "closed" && (privacy === "anonymous"))
                    || (this.privacylevel === "open"   && (privacy === "private" || privacy === "anonymous"))) {
                    image = "avatar-undisclosed.svg"
                    name  = "UNDISCLOSED IDENTITY"
                }
                this.attendees[data.client] = {
                    image,
                    name,
                    seen:    (new Date()).getTime()
                }
            }
            else if (data.event === "refresh") {
                if (this.attendees[data.client] !== undefined)
                    this.attendees[data.client].seen = (new Date()).getTime()
            }
            else if (data.event === "end")
                delete this.attendees[data.client]
        }
    },
    created () {
        /*  track the attendees (similar to "attendance" widget to be in sync)  */
        this.timer = setInterval(() => {
            /*  expire attendees not seen recently
                (refresh usually every 10min, but we accept also up to 20min)  */
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.attendees)) {
                const seen = this.attendees[client].seen
                if (seen + ((20 + 2) * 60 * 1000) < now)
                    delete this.attendees[client]
            }
        }, 2 * 1000)

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

