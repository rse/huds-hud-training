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
    <div v-bind:style="style" class="timer">
        <div class="canvas" ref="canvas">
            <div ref="svg" class="svg">
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.timer {
    opacity: var(--opacity);
    position: relative;
    .canvas {
        position: relative;
        opacity: 0;
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
module.exports = {
    name: "timer",
    props: {
        opacity:     { type: Number, default: 1.0 },
        duration:    { type: Number, default: 0 },
        background1: { type: String, default: "" },
        background2: { type: String, default: "" },
        foreground:  { type: String, default: "" },
        pointer1:    { type: String, default: "" },
        pointer2:    { type: String, default: "" },
        pointer3:    { type: String, default: "" },
        duration:    { type: String, default: "" }
    },
    data: () => ({
        config:    huds.config(),
        duration:  0,
        remaining: 0,
        started:   null,
        show:      false,
        timer:     null,
        ticked:    false,
        ended:     false,
        svg:       null,
        svgRefs:   {}
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
    },
    mounted () {
        this.$on("start", (duration) => {
            this.start(duration)
        })
        this.$on("stop", () => {
            this.stop()
        })
    },
    methods: {
        start (duration) {
            if (this.timer)
                clearTimeout(this.timer)
            this.started   = Math.floor((new Date()).getTime() / 1000)
            this.ending    = this.started + (duration * 60)
            this.ended     = false
            this.segFrom   = Math.floor(this.started / 60) % 60
            this.segNow    = this.segFrom
            this.segTo     = Math.floor(this.ending / 60) % 60
            this.timer = setInterval(() => {
                let now = Math.floor((new Date()).getTime() / 1000)
                if (now >= this.ending) {
                    if (!this.ended) {
                        audio.play("chime4")
                        this.ended = true
                    }
                    setTimeout(() => {
                        this.stop()
                    }, 5 * 1000)
                }
                this.update()
            }, 50)
            this.$nextTick(() => {
                this.update()
                audio.play("slide4")
                anime({
                    targets:   this.$refs.canvas,
                    duration:  1000,
                    autoplay:  true,
                    direction: "normal",
                    easing:    "easeOutBounce",
                    delay:     200,
                    bottom:    [ 1000, 0 ],
                    opacity:   [ 1.0, 1.0 ],
                })
            })
        },
        stop () {
            if (this.timer) {
                clearTimeout(this.timer)
                this.timer = null
            }
            anime({
                targets:   this.$refs.canvas,
                duration:  1000,
                autoplay:  true,
                direction: "normal",
                easing:    "easeInSine",
                delay:     200,
                opacity:   [ 1.0, 0.0 ]
            })
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

                /*  create background  */
                const circle1 = svg.circle(R * 2).move(0, 0).fill(this.background1)
                const circle2 = svg.circle(R * 2 - 20).move(10, 10).fill(this.background2)
                this.svgRefs.segment1 = svg.group()
                this.svgRefs.segment2 = svg.group()
                this.svgRefs.segment3 = svg.group()
                this.svgRefs.segment4 = svg.group()
                const circle3 = svg.circle(40).move(R - 20, R - 20).fill(this.background1)

                /*  create tick lines  */
                for (let i = 1; i <= 60; i++) {
                    let w = i % 15 === 0 ? 8 : (i % 5 === 0 ? 8 : 2)
                    let l = i % 15 === 0 ? 30 : (i % 5 === 0 ? 20 : 20)
                    svg.line(0, 0, 0, l)
                        .move(R, 30)
                        .rotate((360 / 60) * i, R, R)
                        .stroke({ color: this.background1, width: w })
                        .css({ "stroke-linecap": "round" })
                    if (i % 5 === 0) {
                        const g = svg.group()
                        let digit = (i / 5).toString()
                        const t = g.text(digit)
                            .fill(this.background1)
                            .font({
                                family: "TypoPRO Fira Sans",
                                anchor: "middle",
                                size:   (i / 5) % 3 === 0 ? 60 : 55,
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
                    .stroke({ color: this.pointer1, width: 20 })
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
            let now = new Date()
            let H = now.getHours()
            let M = now.getMinutes()
            let S = now.getSeconds()
            let MS = now.getMilliseconds()

            this.svgRefs.p1.untransform().rotate((360 / 12) * (H % 12) + (360 / 12) / 60 * M, R, R)
            this.svgRefs.p2.untransform().rotate((360 / 60) * M, R, R)
            this.svgRefs.p3.untransform().rotate((360 / 60) * S + (360 / 60) / 1000 * MS, R, R)
            if (S === 0 && !this.ticked) {
                audio.play("click5")
                this.ticked = true
                this.segNow = M
            }
            else if (S > 0)
                this.ticked = false

            let deg1 = (360 / 60) * this.segFrom
            let deg2 = (360 / 60) * this.segNow
            let deg3 = (360 / 60) * this.segTo

            let rad1 = SVG.utils.radians(90 - deg1)
            let rad2 = SVG.utils.radians(90 - deg2)
            let rad3 = SVG.utils.radians(90 - deg3)
            let max12 = Math.abs(deg2 - deg1) > 180 ? 1 : 0
            let max23 = Math.abs(deg3 - deg2) > 180 ? 1 : 0

            let b = 10

            let x1 = R + Math.cos(rad1) * R
            let y1 = R - Math.sin(rad1) * R
            let x2 = R + Math.cos(rad2) * R
            let y2 = R - Math.sin(rad2) * R
            this.svgRefs.segment1.clear()
            this.svgRefs.segment1.path()
                .M(R, R)
                .L(x1, y1)
                .A(R, R, 0, max12, 1, { x: x2, y: y2 })
                .Z()
                .fill("#b06820")

            x1 = R + Math.cos(rad1) * (R - b)
            y1 = R - Math.sin(rad1) * (R - b)
            x2 = R + Math.cos(rad2) * (R - b)
            y2 = R - Math.sin(rad2) * (R - b)
            this.svgRefs.segment2.clear()
            this.svgRefs.segment2.path()
                .M(R, R)
                .L(x1, y1)
                .A(R - b, R - b, 0, max12, 1, { x: x2, y: y2 })
                .Z()
                .fill("#f4dbc2")

            x1 = R + Math.cos(rad2) * R
            y1 = R - Math.sin(rad2) * R
            x2 = R + Math.cos(rad3) * R
            y2 = R - Math.sin(rad3) * R
            this.svgRefs.segment3.clear()
            this.svgRefs.segment3.path()
                .M(R, R)
                .L(x1, y1)
                .A(R, R, 0, max23, 1, { x: x2, y: y2 })
                .Z()
                .fill("#2068b0")

            x1 = R + Math.cos(rad2) * (R - b)
            y1 = R - Math.sin(rad2) * (R - b)
            x2 = R + Math.cos(rad3) * (R - b)
            y2 = R - Math.sin(rad3) * (R - b)
            this.svgRefs.segment4.clear()
            this.svgRefs.segment4.path()
                .M(R, R)
                .L(x1, y1)
                .A(R - b, R - b, 0, max23, 1, { x: x2, y: y2 })
                .Z()
                .fill("#c2dbf4")
        }
    }
}
</script>
