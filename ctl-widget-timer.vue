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
    <div v-bind:style="style" class="timer">
        <div ref="canvas" class="canvas">
            <div ref="svg" class="svg">
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.timer {
    position: relative;
    .canvas {
        position: relative;
        width:  100%;
        height: 100%;
        .svg {
            width:  100%;
            height: 100%;
        }
    }
}
</style>

<script>
export default {
    name: "timer",
    props: {
        duration:    { type: Number, default: 0 },
        background1: { type: String, default: "" },
        background2: { type: String, default: "" },
        ticks:       { type: String, default: "" },
        digits:      { type: String, default: "" },
        pointer1:    { type: String, default: "" },
        pointer2:    { type: String, default: "" },
        pointer3:    { type: String, default: "" },
        segment1:    { type: String, default: "" },
        segment2:    { type: String, default: "" }
    },
    data: () => ({
        config:    huds.config(),
        timer:     null,
        ticked:    false,
        svg:       null,
        svgRefs:   {}
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
    },
    mounted () {
        this.restart()
        this.timer = setInterval(() => {
            this.update()
        }, 50)
    },
    methods: {
        restart () {
            /*  determine the duration-related information  */
            const now = Math.floor((new Date()).getTime() / 1000)
            this.segFrom = Math.floor(now / 60) % 60
            this.segNow  = this.segFrom
        },
        update () {
            if (this.svg === null) {
                /*  initially render clock  */
                const el = this.$refs.svg
                const W = el.clientWidth
                const H = el.clientHeight
                const svg = SVG().addTo(el).size(W, H)
                this.svg = svg
                const R = Math.ceil(W / 2)

                /*  create backgrounds  */
                svg.circle(R * 2).move(0, 0).fill(this.background1)
                svg.circle(R * 2 - 20).move(10, 10).fill(this.background2)
                this.svgRefs.segment1 = svg.group()
                this.svgRefs.segment2 = svg.group()
                svg.circle(40).move(R - 20, R - 20).fill(this.background1)

                /*  create tick lines  */
                for (let i = 1; i <= 60; i++) {
                    const w = i % 15 === 0 ? 8 : (i % 5 === 0 ? 8 : 2)
                    const l = i % 15 === 0 ? 30 : (i % 5 === 0 ? 20 : 20)
                    svg.line(0, 0, 0, l)
                        .move(R, 30)
                        .rotate((360 / 60) * i, R, R)
                        .stroke({ color: this.ticks, width: w })
                        .css({ "stroke-linecap": "round" })
                    if (i % 5 === 0) {
                        const g = svg.group()
                        const digit = (i / 5).toString()
                        const t = g.text(digit)
                            .fill(this.digits)
                            .font({
                                family: "TypoPRO Fira Sans",
                                anchor: "middle",
                                size:   (i / 5) % 3 === 0 ? 65 : 55,
                                weight: (i / 5) % 3 === 0 ? "bold" : "normal"
                            })
                        g.center(R, (i / 5) % 3 === 0 ? 100 : 90)
                            .rotate((360 / 12) * (i / 5), R, R)
                        t.rotate(-(360 / 12) * (i / 5))
                    }
                }

                /*  create pointers  */
                this.svgRefs.p1 = svg.line(0, 0, 0, R - (30 + 100))
                    .move(R, 30 + 100)
                    .stroke({ color: this.pointer1, width: 25 })
                    .css({ "stroke-linecap": "round" })
                this.svgRefs.p2 = svg.line(0, 0, 0, R - 30)
                    .move(R, 30)
                    .stroke({ color: this.pointer2, width: 15 })
                    .css({ "stroke-linecap": "round" })
                this.svgRefs.p3 = svg.line(0, 0, 0, R - 30)
                    .move(R, 30)
                    .stroke({ color: this.pointer3, width: 5 })
                    .css({ "stroke-linecap": "round" })
            }

            /*  update clock pointers  */
            const el = this.$refs.svg
            const W = el.clientWidth
            const R = Math.ceil(W / 2)
            const now = new Date()
            const H = now.getHours()
            const M = now.getMinutes()
            const S = now.getSeconds()
            const MS = now.getMilliseconds()
            this.svgRefs.p1.untransform().rotate((360 / 12) * (H % 12) + (360 / 12) / 60 * M, R, R)
            this.svgRefs.p2.untransform().rotate((360 / 60) * M, R, R)
            this.svgRefs.p3.untransform().rotate((360 / 60) * S + (360 / 60) / 1000 * MS, R, R)

            /*  perform minute ticks  */
            if (S === 0 && !this.ticked) {
                this.ticked = true
                this.segNow = M
            }
            else if (S > 0)
                this.ticked = false

            /*  redraw minute segments  */
            const deg1 = (360 / 60) * this.segFrom
            const deg2 = (360 / 60) * this.segNow
            const rad1 = SVG.utils.radians(90 - deg1)
            const rad2 = SVG.utils.radians(90 - deg2)
            const max12 = deg2 > deg1 ? (deg2 - deg1 > 180 ? 1 : 0) : (deg1 - deg2 > 180 ? 0 : 1)
            const makeSegment = (seg, rad1, rad2, max, b, col) => {
                const x1 = R + Math.cos(rad1) * (R - b)
                const y1 = R - Math.sin(rad1) * (R - b)
                const x2 = R + Math.cos(rad2) * (R - b)
                const y2 = R - Math.sin(rad2) * (R - b)
                seg.clear()
                seg.path().M(R, R).L(x1, y1).A(R - b, R - b, 0, max, 1, { x: x2, y: y2 }).Z().fill(col)
            }
            const b = 10
            makeSegment(this.svgRefs.segment1, rad1, rad2, max12, 0, this.segment1)
            makeSegment(this.svgRefs.segment2, rad1, rad2, max12, b, this.segment2)
        }
    }
}
</script>

