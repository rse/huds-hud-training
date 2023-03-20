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
    <div class="ctl">
        <attendance ref="attendance" class="attendance"
            v-bind:background="config.attendance.background"
            v-bind:iconcolor="config.attendance.iconcolor"
            v-bind:textcolor="config.attendance.textcolor"
        ></attendance>
        <attendees ref="attendees" class="attendees"
            v-bind:background="config.attendees.background"
            v-bind:namecolorbg="config.attendees.namecolorbg"
            v-bind:namecolorfg="config.attendees.namecolorfg"
            v-bind:noattendeestext="config.attendees.noattendeestext"
            v-bind:privacylevel="config.attendees.privacylevel"
        ></attendees>
        <feeling ref="feeling" class="feeling"
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
        <timer ref="timer" class="timer"
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
        <agenda ref="agenda" class="agenda"
            v-bind:donecolorbg="config.agenda.donecolorbg"
            v-bind:donecolorfg="config.agenda.donecolorfg"
            v-bind:currcolorbg="config.agenda.currcolorbg"
            v-bind:currcolorfg="config.agenda.currcolorfg"
            v-bind:todocolorbg="config.agenda.todocolorbg"
            v-bind:todocolorfg="config.agenda.todocolorfg"
            v-bind:slotlist="config.agenda.slots"
        ></agenda>
        <popup ref="popup" class="popup"
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
    </div>
</template>

<style lang="less" scoped>
.ctl {
    width: 100vw;
    height: 100vh;
    position: relative;
    font-family: sans-serif;
    font-size: 12pt;
    overflow: hidden;
    background-color: #333333;
    color: #ffffff;
    > .attendance {
        position: absolute;
        right: 520px;
        bottom: 20px;
        width: 270px;
    }
    > .attendees {
        position: absolute;
        top: 20px;
        left: 20px;
        width:  calc(100vw - 830px);
        height: calc(100vh - 40px);
    }
    > .feeling {
        position: absolute;
        right: 520px;
        bottom: 100px;
        width: 270px;
    }
    > .timer {
        position: absolute;
        right: 20px;
        bottom: 20px;
        width: 470px;
        height: 470px;
    }
    > .agenda {
        position: absolute;
        top: 20px;
        right: 30px;
        width: 760px;
        height: calc(100vh - 530px);
    }
    > .popup {
        position: absolute;
        bottom: 40px;
        width: calc(50vw);
        height: calc(100vh - 80px);
        left: 40px;
    }
}
</style>

<script>
export default {
    name: "ctl",
    data: () => ({
        config:   huds.config(),
        debug:    typeof huds.options.debug === "boolean" ? huds.options.debug : false
    }),
    components: {
        "attendance":   Vue.loadComponent("ctl-widget-attendance.vue"),
        "attendees":    Vue.loadComponent("ctl-widget-attendees.vue"),
        "feeling":      Vue.loadComponent("ctl-widget-feeling.vue"),
        "timer":        Vue.loadComponent("ctl-widget-timer.vue"),
        "agenda":       Vue.loadComponent("ctl-widget-agenda.vue"),
        "popup":        Vue.loadComponent("ctl-widget-popup.vue")
    },
    created () {
        /*  receive messages for the attendance channel  */
        huds.bind("attendance", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client  === "string" && data.client !== ""
                  && typeof data.event   === "string" && data.event  !== ""))
                return
            const a1 = this.$refs.attendance
            a1.attendance(data)
            const a2 = this.$refs.attendees
            a2.attendance(data)
            const f = this.$refs.feeling
            f.attendance(data)
            const p = this.$refs.popup
            p.attendance(data)
        })

        /*  receive messages for the attendance channel  */
        huds.bind("feeling", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client    === "string" && data.client !== ""
                  && typeof data.challenge === "number" && typeof data.mood === "number"))
                return
            const f = this.$refs.feeling
            f.event(data)
        })

        /*  receive messages for the progress and agenda channel  */
        huds.bind("progress.*", (event, data) => {
            const t = this.$refs.timer
            const a = this.$refs.agenda
            if (event === "progress.prev") {
                a.prev()
                t.restart()
            }
            else if (event === "progress.next") {
                a.next()
                t.restart()
            }
        })

        /*  receive messages for the popup channel  */
        huds.bind("popup.add", (event, data) => {
            const a = this.$refs.popup
            a.add(data)
        })
        huds.bind("popup.remove", (event, data) => {
            const a = this.$refs.popup
            a.remove()
        })

        /*  receive messages for the voting channel  */
        let votesEnabled = false
        huds.bind("votes.*", (event, data) => {
            if (event === "votes.toggle")
                votesEnabled = !votesEnabled
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

            /*  short-circuit voting messages  */
            if (votesEnabled)
                return

            /*  react on particular message types  */
            if (data.text.match(/^(.+?)\?$/)) {
                const a = this.$refs.popup
                a.add({ ...data, type: "question" })
            }
            else if (data.text.match(/^(.+?)!$/)) {
                const a = this.$refs.popup
                a.add({ ...data, type: "objection" })
            }
            else {
                const a = this.$refs.popup
                a.add({ ...data, type: "comment" })
            }
        })
    }
}
</script>

