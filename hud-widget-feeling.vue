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
    <div v-bind:style="style" class="feeling">
        <div v-show="show" class="bar">
            <div class="feeling challenge">
                <div class="boxplot">
                    <div ref="cq1" class="q1"></div>
                    <div ref="cq2" class="q2"></div>
                    <div ref="cq3" class="q3"></div>
                    <div ref="cq4" class="q4"></div>
                </div>
                <div class="legend">
                    <div class="l1"></div>
                    <div class="l2"></div>
                    <div class="l3"></div>
                    <div class="l4"></div>
                    <div class="l5"></div>
                </div>
                <div class="name">
                    Your Challenge
                </div>
            </div>
            <div class="feeling mood">
                <div class="boxplot">
                    <div ref="mq1" class="q1"></div>
                    <div ref="mq2" class="q2"></div>
                    <div ref="mq3" class="q3"></div>
                    <div ref="mq4" class="q4"></div>
                </div>
                <div class="legend">
                    <div class="l1"></div>
                    <div class="l2"></div>
                    <div class="l3"></div>
                    <div class="l4"></div>
                    <div class="l5"></div>
                </div>
                <div class="name">
                    Your Mood
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.feeling {
    opacity: var(--opacity);
    .bar {
        height: 64px;
        margin: 20px;
        border-radius: 8px;
        padding: 4px;
        background-color: var(--background);
        display: flex;
        flex-direction: row;
        justify-content: space-evenly;
        .feeling {
            border: 1px solid red;
            width: calc(50% - 20px);
            display: flex;
            flex-direction: column;
            align-items: center;
            .boxplot {
                width: 100%;
                height: 30px;
                display: flex;
                flex-direction: row;
                .q1 { background-color: var(--q1color); }
                .q2 { background-color: var(--q2color); }
                .q3 { background-color: var(--q3color); }
                .q4 { background-color: var(--q4color); }
                .q1, .q2, .q3, .q4 {
                    height: 30px;
                    min-height: 30px;
                    border: 1px solid white;
                }
            }
            .legend {
                width: 100%;
                height: 10px;
                min-height: 10px;
                display: flex;
                flex-direction: row;
                .l1, .l2, .l3, .l4, .l5 {
                    height: 10px;
                    min-height: 10px;
                    width: 20%;
                }
            }
            &.challenge {
                .legend {
                    .l1 { background-color: var(--c1color); }
                    .l2 { background-color: var(--c2color); }
                    .l3 { background-color: var(--c3color); }
                    .l4 { background-color: var(--c4color); }
                    .l5 { background-color: var(--c4color); }
                }
            }
            &.mood {
                .legend {
                    .l1 { background-color: var(--m1color); }
                    .l2 { background-color: var(--m2color); }
                    .l3 { background-color: var(--m3color); }
                    .l4 { background-color: var(--m4color); }
                    .l5 { background-color: var(--m4color); }
                }
            }
            .name {
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                font-size: 14pt;
                color: var(--textcolor);
            }
        }
    }
}
</style>

<script>
module.exports = {
    name: "feeling",
    props: {
        opacity:    { type: Number, default: 1.0 },
        background: { type: String, default: "" },
        textcolor:  { type: String, default: "" },
        q1color:    { type: String, default: "" },
        q2color:    { type: String, default: "" },
        q3color:    { type: String, default: "" },
        q4color:    { type: String, default: "" },
        c1color:    { type: String, default: "" },
        c2color:    { type: String, default: "" },
        c3color:    { type: String, default: "" },
        c4color:    { type: String, default: "" },
        c5color:    { type: String, default: "" },
        m1color:    { type: String, default: "" },
        m2color:    { type: String, default: "" },
        m3color:    { type: String, default: "" },
        m4color:    { type: String, default: "" },
        m5color:    { type: String, default: "" }
    },
    data: () => ({
        show: false
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
        /*  receive the feedback events  */
        this.$on("event", (data) => {
        })

        /*  toggle the widget  */
        this.$on("toggle", () => {
            this.show = !this.show
            if (this.show)
                soundfx.play("beep3")
            else
                soundfx.play("whoosh2")
        })
    }
}
</script>

