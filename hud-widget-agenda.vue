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
    <div v-bind:style="style" class="agenda">
        <div ref="canvas" class="canvas">
            <div v-for="(slot, i) in slotlist"
                v-bind:key="slot"
                v-bind:class="{
                    first: i === 0,
                    done:  i < pos,
                    curr:  i === pos,
                    todo:  i > pos,
                    last:  i === slotlist.length - 1 }"
                class="slot">
                <div class="num">{{ i+1 }}</div>
                <div class="text">{{ slot }}</div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.agenda {
    opacity: var(--opacity);
    .canvas {
        opacity: 0;
        height: 100%;
        margin: 20px;
        display: flex;
        flex-direction: column;
        justify-content: flex-end;
        .slot {
            height: var(--slotheight);
            margin-bottom: 2px;
            font-family: "TypoPRO Fira Sans";
            font-size: calc(var(--slotheight) * 0.70);
            display: flex;
            flex-direction: row;
            &.first {
                border-top-left-radius:  10px;
                border-top-right-radius: 10px;
            }
            &.last {
                border-bottom-left-radius:  10px;
                border-bottom-right-radius: 10px;
            }
            &.done {
                background-color: var(--donecolorbg);
                color: var(--donecolorfg);
            }
            &.curr {
                background-color: var(--currcolorbg);
                color: var(--currcolorfg);
            }
            &.todo {
                background-color: var(--todocolorbg);
                color: var(--todocolorfg);
            }
            .num {
                padding-left:  30px;
                padding-right: 10px;
                text-align: center;
                width: 50px;
            }
            .text {
                padding-left:  10px;
                padding-right: 30px;
                width: auto;
                text-align: left;
            }
        }
    }
}
</style>

<script>
module.exports = {
    name: "agenda",
    props: {
        opacity:     { type: Number, default: 1.0 },
        donecolorbg: { type: String, default: "" },
        donecolorfg: { type: String, default: "" },
        currcolorbg: { type: String, default: "" },
        currcolorfg: { type: String, default: "" },
        todocolorbg: { type: String, default: "" },
        todocolorfg: { type: String, default: "" },
        slotheight:  { type: String, default: 0 },
        slotlist:    { type: String, default: [] }
    },
    data: () => ({
        enabled:  false,
        progress: false,
        pos:      0
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
        /*  receive particular agenda position (from progress bar)  */
        this.$on("pos", (pos) => {
            this.pos = pos
        })

        /*  toggle agenda on/off  */
        this.$on("toggle", () => {
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
                    translateX: [ -(20 + this.$el.clientWidth), 0 ],
                    opacity:    [ 1.0, 1.0 ]
                })
            }
            else {
                /*  toggle agenda off  */
                setTimeout(() => soundfx.play("click1"), 50)
                setTimeout(() => soundfx.play("whoosh3"), 500)
                tl.add({
                    easing:     "cubicBezier(0.625, -0.480, 0.505, 1.000)",
                    translateX: [ 0, -(20 + this.$el.clientWidth) ],
                    opacity:    [ 1.0, 1.0 ]
                })
            }
            tl.finished.then(() => {
                if (newstate)
                    soundfx.play("click1")
                this.enabled  = newstate
                this.progress = false
            })
        })
    },
    mounted () {
        /*  dynamically determine height of an agenda slot  */
        const el = this.$refs.canvas
        const slots = el.querySelectorAll(".slot")
        let height = Math.ceil(this.$el.clientHeight / slots.length)
        if (height > 50)
            height = 50
        this.slotheight = height + "px"
    }
}
</script>

