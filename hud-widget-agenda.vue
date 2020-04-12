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
        .slot {
            height: var(--slotheight);
            margin-bottom: 4px;
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
        this.$on("pos", (pos) => {
            this.pos = pos
        })
        this.$on("toggle", () => {
            if (this.progress)
                return
            this.progress = true
            const oldstate = this.enabled
            const newstate = !oldstate
            if (!oldstate)
                this.enabled = true
            const el = this.$refs.canvas
            const tl = anime.timeline({
                targets:  el,
                duration: 3000,
                autoplay: true
            })
            if (newstate) {
                setTimeout(() => audio.play("whoosh3"), 2000)
                setTimeout(() => audio.play("click1"), 3000)
                tl.add({
                    easing:     "easeOutSine",
                    translateX: [ -1920, 0 ],
                    opacity:    [ 1.0, 1.0 ]
                })
            }
            else {
                setTimeout(() => audio.play("click1"), 50)
                setTimeout(() => audio.play("whoosh3"), 100)
                tl.add({
                    easing:     "easeInSine",
                    translateX: [ 0, -1920 ],
                    opacity:    [ 1.0, 0.0 ]
                })
            }
            tl.finished.then(() => {
                this.enabled  = newstate
                this.progress = false
            })
        })
    },
    mounted () {
        const el = this.$refs.canvas
        const slots = el.querySelectorAll(".slot")
        this.slotheight = Math.ceil(this.$el.clientHeight / slots.length) + "px"
    }
}
</script>

