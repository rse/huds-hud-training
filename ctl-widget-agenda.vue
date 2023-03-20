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
                <div class="num">{{ i + 1 }}</div>
                <div class="text">{{ slot }}</div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.agenda {
    .canvas {
        overflow: scroll;
        height: 100%;
        display: flex;
        flex-direction: column;
        justify-content: flex-start;
        .slot {
            margin-bottom: 2px;
            font-family: "TypoPRO Fira Sans";
            font-size: 24pt;
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
                width: 100%;
                text-align: left;
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
            }
        }
    }
}
</style>

<script>
export default {
    name: "agenda",
    props: {
        donecolorbg: { type: String, default: "" },
        donecolorfg: { type: String, default: "" },
        currcolorbg: { type: String, default: "" },
        currcolorfg: { type: String, default: "" },
        todocolorbg: { type: String, default: "" },
        todocolorfg: { type: String, default: "" },
        slotlist:    { type: String, default: [] }
    },
    data: () => ({
        pos: 0
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
    },
    mounted () {
        this.update()
    },
    methods: {
        update  () {
            const el = this.$refs.canvas
            const slot = el.querySelector(".slot.curr")
            slot.scrollIntoView({
                behavior: "auto",
                block:    "center",
                inline:   "center"
            })
        },
        prev () {
            if (this.pos > 0) {
                this.pos--
                this.$nextTick(() => this.update())
            }
        },
        next () {
            if (this.pos < this.slotlist.length - 1) {
                this.pos++
                this.$nextTick(() => this.update())
            }
        }
    }
}
</script>

