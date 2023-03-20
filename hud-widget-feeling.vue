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
    <div v-bind:style="style" class="feeling">
        <div v-show="show" class="bar">
            <div class="feeling challenge">
                <div class="cols">
                    <div data-type="challenge" data-val="1" v-bind:class="{ col: true, max: cols.challenge[1].max }"></div>
                    <div data-type="challenge" data-val="2" v-bind:class="{ col: true, max: cols.challenge[2].max }"></div>
                    <div data-type="challenge" data-val="3" v-bind:class="{ col: true, max: cols.challenge[3].max }"></div>
                    <div data-type="challenge" data-val="4" v-bind:class="{ col: true, max: cols.challenge[4].max }"></div>
                    <div data-type="challenge" data-val="5" v-bind:class="{ col: true, max: cols.challenge[5].max }"></div>
                </div>
                <div class="legend">
                    <div class="l1">{{ cols.challenge[1].count }}</div>
                    <div class="l2">{{ cols.challenge[2].count }}</div>
                    <div class="l3">{{ cols.challenge[3].count }}</div>
                    <div class="l4">{{ cols.challenge[4].count }}</div>
                    <div class="l5">{{ cols.challenge[5].count }}</div>
                </div>
                <div class="name">
                    Your Challenges
                </div>
            </div>
            <div class="feeling mood">
                <div class="cols">
                    <div data-type="mood" data-val="1" v-bind:class="{ col: true, max: cols.mood[1].max }"></div>
                    <div data-type="mood" data-val="2" v-bind:class="{ col: true, max: cols.mood[2].max }"></div>
                    <div data-type="mood" data-val="3" v-bind:class="{ col: true, max: cols.mood[3].max }"></div>
                    <div data-type="mood" data-val="4" v-bind:class="{ col: true, max: cols.mood[4].max }"></div>
                    <div data-type="mood" data-val="5" v-bind:class="{ col: true, max: cols.mood[5].max }"></div>
                </div>
                <div class="legend">
                    <div class="l1">{{ cols.mood[1].count }}</div>
                    <div class="l2">{{ cols.mood[2].count }}</div>
                    <div class="l3">{{ cols.mood[3].count }}</div>
                    <div class="l4">{{ cols.mood[4].count }}</div>
                    <div class="l5">{{ cols.mood[5].count }}</div>
                </div>
                <div class="name">
                    Your Moods
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.feeling {
    opacity: var(--opacity);
    .bar {
        margin: 20px;
        margin-bottom: 0;
        border-radius: 8px;
        padding: 8px;
        background-color: var(--background);
        display: flex;
        flex-direction: row;
        justify-content: space-evenly;
        .feeling {
            width: calc(50% - 40px);
            display: flex;
            flex-direction: column;
            align-items: center;
            .cols {
                width: 100%;
                min-height: 120px;
                max-height: 120px;
                height: 120px;
                margin-top: 8px;
                margin-bottom: 5px;
                display: flex;
                flex-direction: row;
                align-items: flex-end;
                .col {
                    width: 20%;
                    margin-right: 4px;
                    border-radius: 4px;
                    background-color: var(--stdbarcolor);
                    &.max {
                        background-color: var(--maxbarcolor);
                    }
                }
                .col:last-child {
                    margin-right: 0px;
                }
            }
            .legend {
                width: 100%;
                height: 24px;
                display: flex;
                flex-direction: row;
                border: 1px solid var(--bordercolor);
                .l1, .l2, .l3, .l4, .l5 {
                    height: 24px;
                    width: 20%;
                    font-family: "TypoPRO Fira Sans";
                    font-weight: normal;
                    font-size: 14pt;
                    color: var(--legendcolor);
                    text-align: center;
                }
            }
            &.challenge {
                .legend {
                    .l1 { background-color: var(--c1color); }
                    .l2 { background-color: var(--c2color); }
                    .l3 { background-color: var(--c3color); }
                    .l4 { background-color: var(--c4color); }
                    .l5 { background-color: var(--c5color); }
                }
            }
            &.mood {
                .legend {
                    .l1 { background-color: var(--m1color); }
                    .l2 { background-color: var(--m2color); }
                    .l3 { background-color: var(--m3color); }
                    .l4 { background-color: var(--m4color); }
                    .l5 { background-color: var(--m5color); }
                }
            }
            .name {
                margin-top: 6px;
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
export default {
    name: "feeling",
    props: {
        opacity:     { type: Number, default: 1.0 },
        background:  { type: String, default: "" },
        textcolor:   { type: String, default: "" },
        bordercolor: { type: String, default: "" },
        legendcolor: { type: String, default: "" },
        stdbarcolor: { type: String, default: "" },
        maxbarcolor: { type: String, default: "" },
        c1color:     { type: String, default: "" },
        c2color:     { type: String, default: "" },
        c3color:     { type: String, default: "" },
        c4color:     { type: String, default: "" },
        c5color:     { type: String, default: "" },
        m1color:     { type: String, default: "" },
        m2color:     { type: String, default: "" },
        m3color:     { type: String, default: "" },
        m4color:     { type: String, default: "" },
        m5color:     { type: String, default: "" }
    },
    data: () => ({
        show:     false,
        feelings: {},
        cols:     {
            challenge: {
                1: { count: 0, height: 0, max: false },
                2: { count: 0, height: 0, max: false },
                3: { count: 0, height: 0, max: false },
                4: { count: 0, height: 0, max: false },
                5: { count: 0, height: 0, max: false }
            },
            mood: {
                1: { count: 0, height: 0, max: false },
                2: { count: 0, height: 0, max: false },
                3: { count: 0, height: 0, max: false },
                4: { count: 0, height: 0, max: false },
                5: { count: 0, height: 0, max: false }
            }
        },
        timer1: null,
        timer2: null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        /*  recalculate the feelings  */
        recalc () {
            const recalcFeeling = (name) => {
                /*  determine feelings  */
                for (let val = 1; val <= 5; val++)
                    this.cols[name][val].count = 0
                for (const client of Object.keys(this.feelings)) {
                    const val = this.feelings[client][name]
                    this.cols[name][val].count++
                }

                /*  determine maximum count  */
                let max = 0
                for (let val = 1; val <= 5; val++)
                    if (max < this.cols[name][val].count)
                        max = this.cols[name][val].count

                /*  determine individual heights and mark maximums  */
                for (let val = 1; val <= 5; val++) {
                    this.cols[name][val].height = (max === 0 ?
                        "0%" :
                        Math.ceil((this.cols[name][val].count / max) * 100) + "%"
                    )
                    this.cols[name][val].max = (this.cols[name][val].count === max)
                }
            }
            recalcFeeling("challenge")
            recalcFeeling("mood")
        },

        /*  update the display  */
        update () {
            if (this.timer2 !== null)
                clearTimeout(this.timer2)
            this.timer2 = setTimeout(() => {
                this.recalc()
                this.$nextTick(() => {
                    if (!this.$refs || !this.show)
                        return

                    /*  determine columns  */
                    const cols = this.$el.getElementsByClassName("col")

                    /*  detect whether any changes in the column heights are necessary  */
                    let changes = false
                    for (const col of cols) {
                        const type = col.getAttribute("data-type")
                        const val  = col.getAttribute("data-val")
                        const height = this.cols[type][val].height
                        if (height !== col.style.height) {
                            changes = true
                            break
                        }
                    }

                    /*  in case of changes, animate columns to their target heights  */
                    if (changes) {
                        soundfx.play("slide1")
                        for (const col of cols) {
                            const type = col.getAttribute("data-type")
                            const val  = col.getAttribute("data-val")
                            const height = this.cols[type][val].height
                            if (height !== col.style.height) {
                                anime({
                                    targets:   col,
                                    duration:  400,
                                    autoplay:  true,
                                    direction: "normal",
                                    easing:    "easeOutSine",
                                    height
                                })
                            }
                        }
                    }
                })
            }, 500)
        },

        /*  receive the attendee events  */
        attendance (data) {
            if (data.event === "end")
                delete this.feelings[data.client]
        },

        /*  toggle the widget  */
        toggle () {
            this.show = !this.show
            if (this.show) {
                this.update()
                soundfx.play("beep3")
            }
            else
                soundfx.play("whoosh2")
        },

        /*  receive the feedback events  */
        event (data) {
            this.feelings[data.client] = {
                seen:      (new Date()).getTime(),
                challenge: data.challenge,
                mood:      data.mood
            }
        }
    },
    created () {
        /*  expire feedbacks  */
        this.timer1 = setInterval(() => {
            /*  expire feelings not seen recently  */
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.feelings)) {
                const seen = this.feelings[client].seen
                if (seen + ((20 + 2) * 60 * 1000) < now)
                    delete this.feelings[client]
            }
            this.update()
        }, 2 * 1000)
    },
    mounted () {
        /*  initialize heights  */
        for (const col of this.$el.getElementsByClassName("col"))
            col.style.height = "0%"
    }
}
</script>

