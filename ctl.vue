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
    <div class="ctl">
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
        right: 20px;
        bottom: 20px;
        width: 270px;
    }
    > .attendees {
        position: absolute;
        top: 20px;
        left: 20px;
        width:  calc(100vw - 330px);
        height: calc(100vh - 40px);
    }
    > .feeling {
        position: absolute;
        right: 20px;
        bottom: 100px;
        width: 270px;
    }
}
</style>

<script>
module.exports = {
    name: "ctl",
    data: () => ({
        config:   huds.config(),
        debug:    typeof huds.options.debug === "boolean" ? huds.options.debug : false
    }),
    components: {
        "attendance":   "url:ctl-widget-attendance.vue",
        "attendees":    "url:ctl-widget-attendees.vue",
        "feeling":      "url:ctl-widget-feeling.vue"
    },
    created () {
        /*  receive messages from the attendance channel  */
        huds.bind("attendance", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client  === "string" && data.client !== ""
                  && typeof data.event   === "string" && data.event  !== ""))
                return
            const a1 = this.$refs.attendance
            a1.$emit("attendance", data)
            const a2 = this.$refs.attendees
            a2.$emit("attendance", data)
            const f = this.$refs.feeling
            f.$emit("attendance", data)
        })

        /*  receive messages from the attendance channel  */
        huds.bind("feeling", (event, data) => {
            /*  just react on correctly structured messages  */
            if (!(   typeof data.client    === "string" && data.client !== ""
                  && typeof data.challenge === "number" && typeof data.mood === "number"))
                return
            const f = this.$refs.feeling
            f.$emit("event", data)
        })
    }
}
</script>

