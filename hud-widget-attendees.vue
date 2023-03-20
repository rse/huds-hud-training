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
    <div v-bind:style="style" class="attendees">
        <div ref="canvas" class="canvas">
            <div v-if="cells.length > 0">
                <div v-for="(cell, i) in cells" v-bind:key="i" class="cell">
                    <img v-if="cell.image" class="image" v-bind:src="cell.image" alt="" />
                    <div v-if="cell.name"  class="name">{{ cell.name }}</div>
                </div>
            </div>
            <div v-if="cells.length == 0" class="noattendees">
                {{ noattendeestext }}
            </div>
        </div>
        <resize-observer v-on:notify="handleResize" />
    </div>
</template>

<style lang="less" scoped>
.attendees {
    opacity: var(--opacity);
    .canvas {
        opacity: 0;
        border-radius: 8px;
        background-color: var(--background);
        height: 100%;
        width: 100%;
        padding-left: 4px;
        padding-top: 4px;
        .cell {
            position: relative;
            float: left;
            margin-right: 4px;
            margin-bottom: 4px;
            display: block;
            border: 2px solid var(--namecolorbg);
            border-radius: 8px;
            width:  var(--cellsize);
            height: var(--cellsize);
            .image {
                border-radius: 8px;
                width:  var(--cellsize);
                height: var(--cellsize);
            }
            .name {
                position: absolute;
                bottom: -2px;
                left: -2px;
                padding: 2px 10px 2px 10px;
                border-top-right-radius: 8px;
                border-bottom-left-radius: 8px;
                background-color: var(--namecolorbg);
                color: var(--namecolorfg);
                font-family: "TypoPRO Fira Sans";
                font-size: calc(var(--cellsize) / 12);
                font-weight: 200;
                display: block;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 85%;
            }
        }
        .noattendees {
            font-family: "TypoPRO Fira Sans";
            font-size: 24pt;
            color: var(--namecolorfg);
            position: absolute;
            top: 45%;
            width: 100%;
            text-align: center;
        }
    }
}
</style>

<script>
export default {
    name: "attendees",
    props: {
        opacity:           { type: Number, default: 1.0 },
        background:        { type: String, default: "" },
        namecolorbg:       { type: String, default: "" },
        namecolorfg:       { type: String, default: "" },
        noattendeestext:   { type: String, default: "" },
        privacylevel:      { type: String, default: "" }
    },
    data: () => ({
        enabled:      false,
        progress:     false,
        attendees:    {},
        timer:        null,
        cellsize:     0,
        cells:        []
    }),
    computed: {
        style: function () {
            const css = HUDS.vueprop2cssvar().call(this)
            return {
                ...css,
                "--cellsize": this.cellsize
            }
        }
    },
    methods: {
        /*  handle canvas resizing (in case of HUD minimization)  */
        handleResize () {
            this.recalc()
        },

        /*  recalculate the cells and their size  */
        recalc () {
            /*  ensure we have the canvas available  */
            if (!(this.$refs && this.$refs.canvas))
                return

            /*  determine all potential cells  */
            const cells = Object.keys(this.attendees)
                .map((client) => this.attendees[client])
                .filter((client) => client.name || client.image)
                .sort((a, b) => a.name.localeCompare(b.name))

            /*  determine canvas size (can differ on minimize HUD view)  */
            const el = this.$refs.canvas
            const H  = el.clientHeight - 4
            const W  = el.clientWidth  - 4

            /*  determine maximum cell size  */
            let k = cells.length
            const b = 4 + 4
            const S = 30
            let s = 300
            while (s > S) {
                const nx = Math.floor(W / (s + b))
                const ny = Math.floor(H / (s + b))
                if (nx * ny >= k)
                    break
                s -= 1
            }

            /*  if cell size would have to be further reduced,
                truncate the number of cells instead  */
            if (s === S) {
                const nx = Math.floor(W / (s + b))
                const ny = Math.ceil(H / (s + b))
                k = nx * ny
            }

            /*  finally deliver results  */
            this.cellsize = s + "px"
            this.cells = cells.slice(0, k)
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
            this.recalc()
        },

        /*  toggle attendees on/off  */
        toggle () {
            /*  do nothing if we are still progressing  */
            if (this.progress)
                return
            this.progress = true

            /*  determine old and new toggle state  */
            const oldstate = this.enabled
            const newstate = !oldstate
            if (!oldstate)
                this.enabled = true

            /*  create the on/off animation  */
            const el = this.$refs.canvas
            const tl = anime.timeline({
                targets:  el,
                duration: 1000,
                autoplay: true
            })
            if (newstate) {
                /*  toggle agenda on  */
                setTimeout(() => soundfx.play("whoosh3"), 200)
                tl.add({
                    easing:     "cubicBezier(0.570, 0.000, 0.340, 1.390)",
                    translateX: [ -(120 + el.clientWidth), 0 ],
                    opacity:    [ 1.0, 1.0 ]
                })
            }
            else {
                /*  toggle agenda off  */
                setTimeout(() => soundfx.play("click1"), 50)
                setTimeout(() => soundfx.play("whoosh3"), 500)
                tl.add({
                    easing:     "cubicBezier(0.625, -0.480, 0.505, 1.000)",
                    translateX: [ 0, -(120 + el.clientWidth) ],
                    opacity:    [ 1.0, 1.0 ]
                })
            }
            tl.finished.then(() => {
                if (newstate)
                    soundfx.play("click1")
                this.enabled  = newstate
                this.progress = false
            })
        }
    },
    created () {
        /*  track the attendees (similar to "attendance" widget to be in sync)  */
        this.timer = setInterval(() => {
            /*  expire attendees not seen recently
                (refresh usually every 10min, but we accept also up to 20min)  */
            let changed = false
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.attendees)) {
                const seen = this.attendees[client].seen
                if (seen + ((20 + 2) * 60 * 1000) < now) {
                    delete this.attendees[client]
                    changed = true
                }
            }
            if (changed)
                this.recalc()
        }, 2 * 1000)
    }
}
</script>

