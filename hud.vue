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
    <div class="hud">
        <background v-if="debug" ref="background" class="background"
        ></background>
        <title-bar ref="titleBar" class="title"
            v-bind:opacity="config.title.opacity"
            v-bind:background="config.title.background"
            v-bind:iconname="config.title.iconname"
            v-bind:iconcolor="config.title.iconcolor"
            v-bind:nametext="config.title.nametext"
            v-bind:namecolor="config.title.namecolor"
            v-bind:titletext="config.title.titletext"
            v-bind:titlecolor="config.title.titlecolor"
        ></title-bar>
        <progress-bar ref="progressBar" class="progress"
            v-bind:opacity="config.progress.opacity"
            v-bind:slots="config.progress.slots"
            v-bind:donecolorbg="config.progress.donecolorbg"
            v-bind:donecolorfg="config.progress.donecolorfg"
            v-bind:currcolorbg="config.progress.currcolorbg"
            v-bind:currcolorfg="config.progress.currcolorfg"
            v-bind:todocolorbg="config.progress.todocolorbg"
            v-bind:todocolorfg="config.progress.todocolorfg"
        ></progress-bar>
        <banner
            v-for="banner in config.banner.banner"
            v-bind:key="banner.name"
            v-bind:ref="'banner-' + banner.name"
            class="banner"
            v-bind:opacity="config.banner.opacity"
            v-bind:background="config.banner.background"
            v-bind:iconname="banner.iconname"
            v-bind:iconcolor="banner.iconcolor"
            v-bind:titletext="banner.titletext"
            v-bind:titlecolor="banner.titlecolor"
        ></banner>
        <logo ref="logo" class="logo"
            v-bind:opacity="config.logo.opacity"
            v-html="config.logo.svg"
        ></logo>
        <agenda ref="agenda" class="agenda"
            v-bind:opacity="config.agenda.opacity"
            v-bind:donecolorbg="config.agenda.donecolorbg"
            v-bind:donecolorfg="config.agenda.donecolorfg"
            v-bind:currcolorbg="config.agenda.currcolorbg"
            v-bind:currcolorfg="config.agenda.currcolorfg"
            v-bind:todocolorbg="config.agenda.todocolorbg"
            v-bind:todocolorfg="config.agenda.todocolorfg"
            v-bind:slotlist="config.agenda.slots"
        ></agenda>
        <closure ref="closure" class="closure"
            v-bind:opacity="config.closure.opacity"
            v-bind:background="config.closure.background"
            v-bind:beginiconname="config.closure.beginiconname"
            v-bind:beginiconcolor="config.closure.beginiconcolor"
            v-bind:beginhinttext="config.closure.beginhinttext"
            v-bind:beginhintcolor="config.closure.beginhintcolor"
            v-bind:pauseiconname="config.closure.pauseiconname"
            v-bind:pauseiconcolor="config.closure.pauseiconcolor"
            v-bind:pausehinttext="config.closure.pausehinttext"
            v-bind:pausehintcolor="config.closure.pausehintcolor"
            v-bind:endiconname="config.closure.endiconname"
            v-bind:endiconcolor="config.closure.endiconcolor"
            v-bind:endhinttext="config.closure.endhinttext"
            v-bind:endhintcolor="config.closure.endhintcolor"
        ></closure>
        <popup ref="popup" class="popup"
            v-bind:opacity="config.popup.opacity"
            v-bind:questionbackground="config.popup.questionbackground"
            v-bind:questiontitlecolor="config.popup.questiontitlecolor"
            v-bind:questionmessagecolor="config.popup.questionmessagecolor"
            v-bind:objectionbackground="config.popup.objectionbackground"
            v-bind:objectiontitlecolor="config.popup.objectiontitlecolor"
            v-bind:objectionmessagecolor="config.popup.objectionmessagecolor"
            v-bind:commentbackground="config.popup.commentbackground"
            v-bind:commenttitlecolor="config.popup.commenttitlecolor"
            v-bind:commentmessagecolor="config.popup.commentmessagecolor"
        ></popup>
        <votes ref="votes" class="votes"
            v-bind:opacity="config.votes.opacity"
            v-bind:maxnamecolorbg="config.votes.maxnamecolorbg"
            v-bind:maxnamecolorfg="config.votes.maxnamecolorfg"
            v-bind:stdnamecolorbg="config.votes.stdnamecolorbg"
            v-bind:stdnamecolorfg="config.votes.stdnamecolorfg"
            v-bind:maxvotecolorbg="config.votes.maxvotecolorbg"
            v-bind:maxvotecolorfg="config.votes.maxvotecolorfg"
            v-bind:stdvotecolorbg="config.votes.stdvotecolorbg"
            v-bind:stdvotecolorfg="config.votes.stdvotecolorfg"
        ></votes>
        <timer ref="timer" class="timer"
            v-bind:opacity="config.timer.opacity"
            v-bind:background1="config.timer.background1"
            v-bind:background2="config.timer.background2"
            v-bind:ticks="config.timer.ticks"
            v-bind:digits="config.timer.digits"
            v-bind:pointer1="config.timer.pointer1"
            v-bind:pointer2="config.timer.pointer2"
            v-bind:pointer3="config.timer.pointer3"
            v-bind:segment1="config.timer.segment1"
            v-bind:segment2="config.timer.segment2"
            v-bind:segment3="config.timer.segment3"
            v-bind:segment4="config.timer.segment4"
        ></timer>
        <latency ref="latency" class="latency"
            v-bind:opacity="config.latency.opacity"
            v-bind:background="config.latency.background"
            v-bind:foreground="config.latency.foreground"
        ></latency>
    </div>
</template>

<style lang="less" scoped>
body {
    background-color: transparent;
}
.hud {
    width: 100vw;
    height: 100vh;
    position: relative;
    font-family: sans-serif;
    font-size: 22pt;
    overflow: hidden;
    > .background {
        position: absolute;
        width: 100vw;
        height: 100vh;
    }
    > .title {
        position: absolute;
        right: 10px;
        bottom: 10px;
        width: 30%;
    }
    > .progress {
        position: absolute;
        bottom: 10px;
        left: 10px;
        width: 70%;
        height: 100px;
    }
    > .logo {
        position: absolute;
        top: 30px;
        right: 30px;
        width: 150px;
        height: auto;
    }
    > .agenda {
        position: absolute;
        top: 10px;
        left: 10px;
        width: auto;
        height: calc(100% - 60px - 100px);
    }
    > .closure {
        position: absolute;
        top: 0;
        left: 0;
    }
    > .popup {
        position: absolute;
        bottom: 120px;
        width: calc(20vw);
        height: calc(100vh - 120px);
        left: 30px;
    }
    > .votes {
        position: absolute;
        bottom: 120px;
        width: calc(50vw - 30px);
        height: calc(100vh - 160px);
        left: 30px;
    }
    > .timer {
        position: absolute;
        bottom: 120px;
        width:  500px;
        height: 500px;
        left:   30px;
    }
    > .latency {
        position: absolute;
        top:    100px;
        right:  30px;
    }
}
</style>

<script>
module.exports = {
    name: "hud",
    data: () => ({
        config: huds.config(),
        debug:  huds.options.debug,
        banner: null,
        logo:   null
    }),
    components: {
        "background":   "url:hud-widget-background.vue",
        "banner":       "url:hud-widget-banner.vue",
        "title-bar":    "url:hud-widget-title.vue",
        "progress-bar": "url:hud-widget-progress.vue",
        "agenda":       "url:hud-widget-agenda.vue",
        "logo":         "url:hud-widget-logo.vue",
        "closure":      "url:hud-widget-closure.vue",
        "popup":        "url:hud-widget-popup.vue",
        "votes":        "url:hud-widget-votes.vue",
        "timer":        "url:hud-widget-timer.vue",
        "latency":      "url:hud-widget-latency.vue"
    },
    created () {
        /*  interaction for logo */
        Mousetrap.bind("l", (e) => {
            huds.send("logo.animate")
        })
        huds.bind("logo.animate", (event, data) => {
            const logo = this.$refs.logo
            logo.$emit("animate")
        })

        /*  interaction for progress widget  */
        Mousetrap.bind("left", (e) => {
            huds.send("progress.prev")
        })
        Mousetrap.bind("right", (e) => {
            huds.send("progress.next")
        })
        huds.bind("progress.*", (event, data) => {
            const pb = this.$refs.progressBar
            if (event === "progress.prev")
                pb.$emit("prev")
            else if (event === "progress.next")
                pb.$emit("next")
        })

        /*  interaction for closure  */
        Mousetrap.bind("up", (e) => {
            huds.send("closure.begin.toggle")
        })
        Mousetrap.bind("return", (e) => {
            huds.send("closure.pause.toggle")
        })
        Mousetrap.bind("down", (e) => {
            huds.send("closure.end.toggle")
        })
        huds.bind("closure.*", (event, data) => {
            const closure = this.$refs.closure
            if (event === "closure.begin.toggle")
                closure.$emit("begin-toggle")
            else if (event === "closure.pause.toggle")
                closure.$emit("pause-toggle")
            else if (event === "closure.end.toggle")
                closure.$emit("end-toggle")
        })

        /*  interaction for title widget  */
        Mousetrap.bind("space", (e) => {
            huds.send("title.bounce")
        })
        huds.bind("title.bounce", (event, data) => {
            const tb = this.$refs.titleBar
            tb.$emit("bounce")
        })

        /*  interaction for agenda widget  */
        Mousetrap.bind("a", (e) => {
            huds.send("agenda.toggle")
        })
        huds.bind("agenda.toggle", (event, data) => {
            const a = this.$refs.agenda
            a.$emit("toggle")
        })

        /*  interaction for popup widget  */
        Mousetrap.bind("backspace", (e) => {
            huds.send("popup.remove")
        })
        huds.bind("popup.add", (event, data) => {
            const a = this.$refs.popup
            a.$emit("popup-add", data)
        })
        huds.bind("popup.remove", (event, data) => {
            const a = this.$refs.popup
            a.$emit("popup-remove")
        })

        /*  interaction for latency widget  */
        Mousetrap.bind("!", (e) => {
            huds.send("latency.toggle")
        })
        huds.bind("latency.toggle", (event, data) => {
            const l = this.$refs.latency
            l.$emit("toggle")
        })

        /*  interaction for progress widget  */
        let progress = false
        for (const banner of this.config.banner.banner) {
            Mousetrap.bind(banner.key, (e) => {
                huds.send(`banner.${banner.name}.toggle`)
            })
            huds.bind(`banner.${banner.name}.toggle`, (event, data) => {
                if (progress)
                    return
                const b = this.$refs[`banner-${banner.name}`][0]
                if (this.banner === b) {
                    /*  disable ourself  */
                    progress = true
                    this.banner.$emit("toggle")
                    setTimeout(() => {
                        this.banner = null
                        progress = false
                    }, 1000)
                }
                else if (this.banner !== null) {
                    /*  disable foreign, then enable ourself  */
                    progress = true
                    this.banner.$emit("toggle")
                    setTimeout(() => {
                        b.$emit("toggle")
                        setTimeout(() => {
                            this.banner = b
                            progress = false
                        }, 1000)
                    }, 1000)
                }
                else {
                    /*  enable ourself  */
                    progress = true
                    b.$emit("toggle")
                    setTimeout(() => {
                        this.banner = b
                        progress = false
                    }, 1000)
                }
            })
        }

        /*  interaction for votes widget  */
        Mousetrap.bind("v", (e) => {
            huds.send("votes.toggle")
        })
        huds.bind("votes.*", (event, data) => {
            const v = this.$refs.votes
            if (event === "votes.toggle")
                v.$emit("votes-toggle")
        })

        /*  interaction for timer widget  */
        Mousetrap.bind("0", (e) => { huds.send("timer.stop") })
        Mousetrap.bind("1", (e) => { huds.send("timer.start",  5) })
        Mousetrap.bind("2", (e) => { huds.send("timer.start", 10) })
        Mousetrap.bind("3", (e) => { huds.send("timer.start", 15) })
        Mousetrap.bind("4", (e) => { huds.send("timer.start", 20) })
        Mousetrap.bind("5", (e) => { huds.send("timer.start", 25) })
        Mousetrap.bind("6", (e) => { huds.send("timer.start", 30) })
        Mousetrap.bind("7", (e) => { huds.send("timer.start", 35) })
        Mousetrap.bind("8", (e) => { huds.send("timer.start", 40) })
        Mousetrap.bind("9", (e) => { huds.send("timer.start", 45) })
        huds.bind("timer.start", (event, data) => {
            const t = this.$refs.timer
            t.$emit("start", data)
        })
        huds.bind("timer.stop", (event, data) => {
            const t = this.$refs.timer
            t.$emit("stop")
        })

        /*  receive messages from a companion chat  */
        huds.bind("chat", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.title   === "string" && data.title   !== ""
                  && typeof data.message === "string" && data.message !== ""))
                return

            /*  filter message markup  */
            data.message = data.message
                .replace(/&nbsp;/g, " ")
                .replace(/\s+/g, " ")
                .replace(/^\s+/, "")
                .replace(/\s+$/, "")
            data.message = data.message.replace(/<([a-z][a-zA-Z0-9:-]*)(?:\s+="[^""]*")*\s*>(.*?)<\/\1>/g, (_, tag, body) => {
                if (tag.match(/^(?:strong|em|u|s|b|i)$/))
                    return `<${tag}>${body}</${tag}>`
                else
                    return body
            })

            /*  react on particular message types  */
            let m
            if ((m = data.message.match(/^#(\S+)$/)) !== null) {
                const v = this.$refs.votes
                v.$emit("votes-receive", { person: data.title, choice: m[1] })
            }
            else if ((m = data.message.match(/^(.+?)\?$/)) !== null) {
                const a = this.$refs.popup
                a.$emit("popup-add", { ...data, type: "question" })
            }
            else if ((m = data.message.match(/^(.+?)!$/)) !== null) {
                const a = this.$refs.popup
                a.$emit("popup-add", { ...data, type: "objection" })
            }
            else {
                const a = this.$refs.popup
                a.$emit("popup-add", { ...data, type: "comment" })
            }
        })
    },
    mounted () {
        /*  forward progress position to agenda  */
        setTimeout(() => {
            const pb = this.$refs.progressBar
            const a  = this.$refs.agenda
            pb.$on("pos", (pos) => {
                a.$emit("pos", pos)
            })
        }, 1500)
    }
}
</script>

