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
    <div class="hud" v-bind:class="{ minimize: minimize }">
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
        <feedback ref="feedback" class="feedback"
            v-bind:opacity="config.feedback.opacity"
            v-bind:surprisecolor1="config.feedback.surprisecolor1"
            v-bind:surprisecolor2="config.feedback.surprisecolor2"
            v-bind:surprisecolor3="config.feedback.surprisecolor3"
            v-bind:surprisecolor4="config.feedback.surprisecolor4"
            v-bind:smilecolor1="config.feedback.smilecolor1"
            v-bind:smilecolor2="config.feedback.smilecolor2"
            v-bind:smilecolor3="config.feedback.smilecolor3"
            v-bind:smilecolor4="config.feedback.smilecolor4"
            v-bind:frowncolor1="config.feedback.frowncolor1"
            v-bind:frowncolor2="config.feedback.frowncolor2"
            v-bind:frowncolor3="config.feedback.frowncolor3"
            v-bind:frowncolor4="config.feedback.frowncolor4"
            v-bind:sadnesscolor1="config.feedback.sadnesscolor1"
            v-bind:sadnesscolor2="config.feedback.sadnesscolor2"
            v-bind:sadnesscolor3="config.feedback.sadnesscolor3"
            v-bind:sadnesscolor4="config.feedback.sadnesscolor4"
            v-bind:thumbsupcolor1="config.feedback.thumbsupcolor1"
            v-bind:thumbsupcolor2="config.feedback.thumbsupcolor2"
            v-bind:thumbsupcolor3="config.feedback.thumbsupcolor3"
            v-bind:thumbsupcolor4="config.feedback.thumbsupcolor4"
            v-bind:thumbsdncolor1="config.feedback.thumbsdncolor1"
            v-bind:thumbsdncolor2="config.feedback.thumbsdncolor2"
            v-bind:thumbsdncolor3="config.feedback.thumbsdncolor3"
            v-bind:thumbsdncolor4="config.feedback.thumbsdncolor4"
        ></feedback>
        <attendance ref="attendance" class="attendance"
            v-bind:opacity="config.attendance.opacity"
            v-bind:background="config.attendance.background"
            v-bind:iconcolor="config.attendance.iconcolor"
            v-bind:textcolor="config.attendance.textcolor"
        ></attendance>
        <attendees ref="attendees" class="attendees"
            v-bind:opacity="config.attendees.opacity"
            v-bind:background="config.attendees.background"
            v-bind:namecolorbg="config.attendees.namecolorbg"
            v-bind:namecolorfg="config.attendees.namecolorfg"
            v-bind:noattendeestext="config.attendees.noattendeestext"
            v-bind:privacylevel="config.attendees.privacylevel"
        ></attendees>
        <feeling ref="feeling" class="feeling"
            v-bind:opacity="config.feeling.opacity"
            v-bind:background="config.feeling.background"
            v-bind:textcolor="config.feeling.textcolor"
            v-bind:bordercolor="config.feeling.bordercolor"
            v-bind:legendcolor="config.feeling.legendcolor"
            v-bind:stdbarcolor="config.feeling.stdbarcolor"
            v-bind:maxbarcolor="config.feeling.maxbarcolor"
            v-bind:c1color="config.feeling.c1color"
            v-bind:c2color="config.feeling.c2color"
            v-bind:c3color="config.feeling.c3color"
            v-bind:c4color="config.feeling.c4color"
            v-bind:c5color="config.feeling.c5color"
            v-bind:m1color="config.feeling.m1color"
            v-bind:m2color="config.feeling.m2color"
            v-bind:m3color="config.feeling.m3color"
            v-bind:m4color="config.feeling.m4color"
            v-bind:m5color="config.feeling.m5color"
        ></feeling>
        <progress-bar ref="progressBar" class="progress"
            v-bind:opacity="config.progress.opacity"
            v-bind:donecolorbg="config.progress.donecolorbg"
            v-bind:donecolorfg="config.progress.donecolorfg"
            v-bind:currcolorbg="config.progress.currcolorbg"
            v-bind:currcolorfg="config.progress.currcolorfg"
            v-bind:todocolorbg="config.progress.todocolorbg"
            v-bind:todocolorfg="config.progress.todocolorfg"
            v-bind:slotlist="config.agenda.slots"
            v-on:pos="progressPos"
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
            v-bind:privacylevel="config.popup.privacylevel"
        ></popup>
        <votes ref="votes" class="votes"
            v-bind:opacity="config.votes.opacity"
            v-bind:winnamecolorbg="config.votes.winnamecolorbg"
            v-bind:winnamecolorfg="config.votes.winnamecolorfg"
            v-bind:maxnamecolorbg="config.votes.maxnamecolorbg"
            v-bind:maxnamecolorfg="config.votes.maxnamecolorfg"
            v-bind:stdnamecolorbg="config.votes.stdnamecolorbg"
            v-bind:stdnamecolorfg="config.votes.stdnamecolorfg"
            v-bind:xtrnamecolorbg="config.votes.xtrnamecolorbg"
            v-bind:xtrnamecolorfg="config.votes.xtrnamecolorfg"
            v-bind:winvotecolorbg="config.votes.winvotecolorbg"
            v-bind:winvotecolorfg="config.votes.winvotecolorfg"
            v-bind:maxvotecolorbg="config.votes.maxvotecolorbg"
            v-bind:maxvotecolorfg="config.votes.maxvotecolorfg"
            v-bind:stdvotecolorbg="config.votes.stdvotecolorbg"
            v-bind:stdvotecolorfg="config.votes.stdvotecolorfg"
            v-bind:xtrvotecolorbg="config.votes.xtrvotecolorbg"
            v-bind:xtrvotecolorfg="config.votes.xtrvotecolorfg"
            v-bind:allvotecolorbg="config.votes.allvotecolorbg"
            v-bind:allvotecolorbd="config.votes.allvotecolorbd"
            v-bind:quizidcolorbg="config.votes.quizidcolorbg"
            v-bind:quizidcolorfg="config.votes.quizidcolorfg"
            v-bind:quiztxtcolorbg="config.votes.quiztxtcolorbg"
            v-bind:quiztxtcolorfg="config.votes.quiztxtcolorfg"
            v-bind:hintcolorbg="config.votes.hintcolorbg"
            v-bind:hintcolorfg="config.votes.hintcolorfg"
            v-bind:hintjudge="config.votes.hintjudge"
            v-bind:hintevaluate="config.votes.hintevaluate"
            v-bind:hintquiz="config.votes.hintquiz"
            v-bind:hintchoose="config.votes.hintchoose"
            v-bind:hintpropose="config.votes.hintpropose"
            v-bind:quizzes="config.votes.quizzes"
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
            v-bind:iconcolor="config.latency.iconcolor"
        ></latency>
        <closure ref="closure" class="closure"
            v-bind:opacity="config.closure.opacity"
            v-bind:background1="config.closure.background1"
            v-bind:background2="config.closure.background2"
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
            v-bind:privacylevel="config.closure.privacylevel"
            v-bind:privacyclosedtext="config.closure.privacyclosedtext"
            v-bind:privacyopentext="config.closure.privacyopentext"
        ></closure>
        <confetti ref="confetti" class="confetti"
            v-bind:opacity="config.confetti.opacity"
        ></confetti>
        <snowfall ref="snowfall" class="snowfall"
            v-bind:opacity="config.snowfall.opacity"
        ></snowfall>
    </div>
</template>

<style lang="less" scoped>
html,
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
    > .attendance {
        position: absolute;
        right: 10px;
        bottom: 10px;
        width: 180px;
    }
    > .attendees {
        position: absolute;
        top: 30px;
        left: 30px;
        width:  calc(100vh - 150px);
        height: calc(100vh - 150px);
    }
    > .title {
        position: absolute;
        right: 170px;
        bottom: 10px;
        width: 540px;
    }
    > .feeling {
        position: absolute;
        right: 170px;
        bottom: 100px;
        width: 540px;
    }
    > .progress {
        position: absolute;
        bottom: 10px;
        left: 10px;
        width: calc(100% - 695px);
        height: 100px;
    }
    > .logo {
        position: absolute;
        top: 30px;
        right: 30px;
        width: 150px;
        height: auto;
    }
    > .feedback {
        position: absolute;
        right: 50px;
        bottom: 100px;
        width: 400px;
    }
    > .agenda {
        position: absolute;
        top: 30px;
        left: 30px;
        width: auto;
        height: calc(100% - 150px);
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
        width: calc(100% - 740px);
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
        bottom: 120px;
        left:   30px;
    }
    > .confetti {
        position: absolute;
        top:    0;
        left:   0;
        width:  100vw;
        height: 100vh;
    }
    > .snowfall {
        position: absolute;
        top:    0;
        left:   0;
        width:  100vw;
        height: 100vh;
    }
    &.minimize {
        > .attendance {
            display: none;
        }
        > .title {
            display: none;
        }
        > .progress {
            display: none;
        }
        > .logo {
            display: none;
        }
        > .feeling {
            bottom: 30px;
        }
        > .feedback {
            bottom: 20px;
        }
        > .attendees {
            width:  calc(100vh - 60px);
            height: calc(100vh - 60px);
        }
        > .agenda {
            height: calc(100% - 60px);
        }
        > .popup {
            bottom: 30px;
            height: calc(100vh - 30px);
        }
        > .votes {
            bottom: 30px;
            height: calc(100vh - 30px);
        }
        > .timer {
            bottom: 30px;
        }
        > .latency {
            bottom: 30px;
        }
    }
}
</style>

<script>
export default {
    name: "hud",
    data: () => ({
        config:   huds.config(),
        debug:    typeof huds.options.debug === "boolean" ? huds.options.debug : false,
        banner:   null,
        logo:     null,
        minimize: false
    }),
    components: {
        "background":   Vue.loadComponent("hud-widget-background.vue"),
        "banner":       Vue.loadComponent("hud-widget-banner.vue"),
        "title-bar":    Vue.loadComponent("hud-widget-title.vue"),
        "attendance":   Vue.loadComponent("hud-widget-attendance.vue"),
        "attendees":    Vue.loadComponent("hud-widget-attendees.vue"),
        "feedback":     Vue.loadComponent("hud-widget-feedback.vue"),
        "feeling":      Vue.loadComponent("hud-widget-feeling.vue"),
        "progress-bar": Vue.loadComponent("hud-widget-progress.vue"),
        "agenda":       Vue.loadComponent("hud-widget-agenda.vue"),
        "logo":         Vue.loadComponent("hud-widget-logo.vue"),
        "closure":      Vue.loadComponent("hud-widget-closure.vue"),
        "popup":        Vue.loadComponent("hud-widget-popup.vue"),
        "votes":        Vue.loadComponent("hud-widget-votes.vue"),
        "timer":        Vue.loadComponent("hud-widget-timer.vue"),
        "latency":      Vue.loadComponent("hud-widget-latency.vue"),
        "confetti":     Vue.loadComponent("hud-widget-confetti.vue"),
        "snowfall":     Vue.loadComponent("hud-widget-snowfall.vue")
    },
    created () {
        /*  interaction for minimization  */
        Mousetrap.bind("m", (e) => {
            huds.send("minimize.toggle")
        })
        huds.bind("minimize.toggle", (event, data) => {
            this.minimize = !this.minimize
        })

        /*  interaction for logo  */
        Mousetrap.bind("l", (e) => {
            huds.send("logo.animate")
        })
        huds.bind("logo.animate", (event, data) => {
            const logo = this.$refs.logo
            logo.animate()
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
                pb.prev()
            else if (event === "progress.next")
                pb.next()
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
                closure.toggle("begin")
            else if (event === "closure.pause.toggle")
                closure.toggle("pause")
            else if (event === "closure.end.toggle")
                closure.toggle("end")
        })

        /*  interaction for title widget  */
        Mousetrap.bind("t", (e) => {
            huds.send("title.animate")
        })
        huds.bind("title.animate", (event, data) => {
            const tb = this.$refs.titleBar
            tb.animate()
        })

        /*  interaction for agenda widget  */
        Mousetrap.bind("a", (e) => {
            huds.send("agenda.toggle")
        })
        huds.bind("agenda.toggle", (event, data) => {
            const a = this.$refs.agenda
            a.toggle()
        })

        /*  interaction for popup widget  */
        Mousetrap.bind("backspace", (e) => {
            huds.send("popup.remove")
        })
        huds.bind("popup.add", (event, data) => {
            const a = this.$refs.popup
            a.add(data)
        })
        huds.bind("popup.remove", (event, data) => {
            const a = this.$refs.popup
            a.remove()
        })
        Mousetrap.bind("space", (e) => {
            huds.send("popup.play")
        })
        huds.bind("popup.play", (event, data) => {
            const a = this.$refs.popup
            a.play()
        })

        /*  interaction for latency widget  */
        Mousetrap.bind("!", (e) => {
            huds.send("latency.toggle")
        })
        huds.bind("latency.toggle", (event, data) => {
            const l = this.$refs.latency
            l.toggle()
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
                const b = this.$refs[`banner-${banner.name}`]
                if (this.banner === b) {
                    /*  disable ourself  */
                    progress = true
                    this.banner.toggle()
                    setTimeout(() => {
                        this.banner = null
                        progress = false
                    }, 1000)
                }
                else if (this.banner !== null) {
                    /*  disable foreign, then enable ourself  */
                    progress = true
                    this.banner.toggle()
                    setTimeout(() => {
                        b.toggle()
                        setTimeout(() => {
                            this.banner = b
                            progress = false
                        }, 1000)
                    }, 1000)
                }
                else {
                    /*  enable ourself  */
                    progress = true
                    b.toggle()
                    setTimeout(() => {
                        this.banner = b
                        progress = false
                    }, 1000)
                }
            })
        }

        /*  interaction for votes widget  */
        let votesEnabled = false
        Mousetrap.bind("v", (e) => {
            huds.send("votes.toggle")
        })
        Mousetrap.bind("V j", (e) => {
            huds.send("votes.type.judge")
        })
        Mousetrap.bind("V e", (e) => {
            huds.send("votes.type.evaluate")
        })
        Mousetrap.bind("V q", (e) => {
            huds.send("votes.type.quiz")
        })
        Mousetrap.bind("V c", (e) => {
            huds.send("votes.type.choose")
        })
        Mousetrap.bind("V p", (e) => {
            huds.send("votes.type.propose")
        })
        Mousetrap.bind("V right", (e) => {
            huds.send("votes.quiz.next")
        })
        Mousetrap.bind("V left", (e) => {
            huds.send("votes.quiz.prev")
        })
        Mousetrap.bind("V r", (e) => {
            huds.send("votes.reveal")
        })
        Mousetrap.bind("V d", (e) => {
            huds.send("votes.disclose")
        })
        huds.bind("votes.*", (event, data) => {
            let m
            const v = this.$refs.votes
            if (event === "votes.toggle") {
                votesEnabled = !votesEnabled
                v.toggle()
                if (votesEnabled)
                    huds.send("voting-begin", {}, this.config.id.peer)
                else
                    huds.send("voting-end", {}, this.config.id.peer)
            }
            else if ((m = event.match(/^votes\.type\.(.+)$/)) !== null) {
                const [ , type ] = m
                v.setType(type)
                huds.send("voting-type", { type }, this.config.id.peer)
            }
            else if (event === "votes.receive")
                v.receive(data)
            else if (event === "votes.reveal")
                v.doReveal()
            else if (event === "votes.disclose")
                v.doDisclose()
            else if (event === "votes.quiz.next")
                v.quizNext()
            else if (event === "votes.quiz.prev")
                v.quizPrev()
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
            t.start(data)
        })
        huds.bind("timer.stop", (event, data) => {
            const t = this.$refs.timer
            t.stop()
        })

        /*  receive messages from a companion chat  */
        huds.bind("message", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   (typeof data.client === "string" && data.client !== "")
                  && (typeof data.text === "string")))
                return

            /*  filter message markup  */
            data.text = data.text
                .replace(/&nbsp;/g, " ")
                .replace(/\s+/g, " ")
                .replace(/^\s+/, "")
                .replace(/\s+$/, "")
            data.text = data.text.replace(/<([a-z][a-zA-Z0-9:-]*)(?:\s+="[^""]*")*\s*>(.*?)<\/\1>/g, (_, tag, body) => {
                if (tag.match(/^(?:strong|em|u|s|b|i)$/))
                    return `<${tag}>${body}</${tag}>`
                else
                    return body
            })

            /*  react on particular message types  */
            if (votesEnabled) {
                const v = this.$refs.votes
                v.receive({ client: data.client, choice: data.text })
            }
            else if (data.text.match(/^(.+?)\?$/)) {
                const a = this.$refs.popup
                a.add({ ...data, type: "question" })
            }
            else if (data.text.match(/^(.+?)!$/)) {
                const a = this.$refs.popup
                a.add({ ...data, type: "objection" })
            }
            else if (!data.text.match(/^(?:[1-9]|YES|NO|ABSTAIN|-2|-1|0|\+1|\+2)$/)) {
                const a = this.$refs.popup
                a.add({ ...data, type: "comment" })
            }
        })

        /*  allow attendance widget to be interactively controlled  */
        Mousetrap.bind("A", (e) => {
            huds.send("attendance.animate")
        })
        huds.bind("attendance.animate", () => {
            const a = this.$refs.attendance
            a.animate()
        })

        /*  receive messages from the attendance channel  */
        huds.bind("attendance", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client  === "string" && data.client !== ""
                  && typeof data.event   === "string" && data.event  !== ""))
                return
            const a1 = this.$refs.attendance
            a1.attendance(data)
            const a2 = this.$refs.attendees
            a2.attendance(data)
            const v = this.$refs.votes
            v.attendanceEvent(data)
            const f = this.$refs.feeling
            f.attendance(data)
            const p = this.$refs.popup
            p.attendance(data)
        })

        /*  allow attendees widget to be interactively controlled  */
        Mousetrap.bind("e", (e) => {
            huds.send("attendees.toggle")
        })
        huds.bind("attendees.toggle", () => {
            const a = this.$refs.attendees
            a.toggle()
        })

        /*  receive messages from the feedback channel  */
        huds.bind("feedback", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client    === "string" && data.client  !== ""
                  && typeof data.type      === "string" && data.type    !== ""))
                return
            const f = this.$refs.feedback
            f.event(data)
        })

        /*  allow feeling widget to be interactively controlled  */
        Mousetrap.bind("f", (e) => {
            huds.send("feeling.toggle")
        })
        huds.bind("feeling.toggle", () => {
            const f = this.$refs.feeling
            f.toggle()
        })

        /*  receive messages from the attendance channel  */
        huds.bind("feeling", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client    === "string" && data.client !== ""
                  && typeof data.challenge === "number" && typeof data.mood === "number"))
                return
            const f = this.$refs.feeling
            f.event(data)
        })

        /*  allow confetti to be raised  */
        Mousetrap.bind("c", (e) => {
            huds.send("confetti.raise")
        })
        huds.bind("confetti.raise", () => {
            const c = this.$refs.confetti
            c.raise()
        })

        /*  allow snowfall to be raised  */
        Mousetrap.bind("s", (e) => {
            huds.send("snowfall.toggle")
        })
        huds.bind("snowfall.toggle", () => {
            const s = this.$refs.snowfall
            s.toggle()
        })

        /*  control peers  */
        huds.bind("peer.reconnect", () => {
            huds.send("reconnect", {}, this.config.id.peer)
        })
        huds.bind("peer.disconnect", () => {
            huds.send("disconnect", {}, this.config.id.peer)
        })
    },
    methods: {
        progressPos (pos) {
            /*  forward progress position to agenda  */
            if (this.$refs.agenda)
                this.$refs.agenda.setPos(pos)
        }
    }
}
</script>

