<!--
/*
**  HUDS ~~ Head-Up-Display Server (HUDS)
**  Copyright (c) 2020-2025 Dr. Ralf S. Engelschall <rse@engelschall.com>
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
            <div ref="svg1" class="svg1"></div>
            <div ref="svg2" class="svg2"></div>
            <div ref="svg3" class="svg3"></div>
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
        border-radius: 8px;
        background-color: var(--background0);
        .svg1, .svg2, .svg3 {
            position: absolute;
            top:      10px;
            left:     10px;
            width:    calc(100% - 20px);
            height:   calc(100% - 20px);
        }
        .svg2, .svg3 {
            opacity: 0.0;
        }
    }
}
</style>

<script>
export default {
    name: "timer",
    props: {
        background0: { type: String,  default: "#336699" },      /* canvas background */
        background1: { type: String,  default: "#555555" },      /* clock border */
        background2: { type: String,  default: "#f0f0f0" },      /* clock background  */
        background3: { type: String,  default: "#ffcc33" },      /* flash overlay (soft) */
        background4: { type: String,  default: "#ff3333" },      /* flash overlay (hard) */
        ticks:       { type: String,  default: "#333333" },      /* clock ticks  */
        digits:      { type: String,  default: "#666666" },      /* clock digits */
        pointer1:    { type: String,  default: "#000000" },      /* clock pointer 1 (hour) */
        pointer2:    { type: String,  default: "#222222" },      /* clock pointer 2 (minute) */
        pointer3:    { type: String,  default: "#cc0000" },      /* clock pointer 3 (second) */
        segment1:    { type: String,  default: "#b06820" },      /* segment done: border */
        segment2:    { type: String,  default: "#f4dbc2" },      /* segment done: background */
        segment3:    { type: String,  default: "#2068b0" },      /* segment todo: border */
        segment4:    { type: String,  default: "#c2dbf4" },      /* segment todo: background */
        segment5:    { type: String,  default: "#b04800" },      /* segment overrun: border */
        segment6:    { type: String,  default: "#ffbba2" },      /* segment overrun: background */
        overrun:     { type: Boolean, default: false     },      /* overruns shown */
        agenda:      { type: Array,   default () { return [] } } /* agenda slots */
    },
    data: () => ({
        config:      huds.config(),
        started:     0,      /* Unix epoch when timer was started */
        ending:      0,      /* Unix epoch when timer is ending */
        ended:       false,  /* whether the end of a timer was once reached */
        left:        {},     /* status of minutes left */
        elSVG1:      null,   /* SVG element #1 (main clock) */
        elSVG2:      null,   /* SVG element #2 (overlay soft) */
        elSVG3:      null,   /* SVG element #3 (overlay hard) */
        svg:         null,   /* SVG object #1 (main clock) */
        svg2:        null,   /* SVG object #2 (overlay soft) */
        svg3:        null,   /* SVG object #3 (overlay hard) */
        svgRefs:     {},     /* SVG objects of pointers 1-3 and segments 1-6 */
        stopping:    false,  /* flag for stopping clock */
        animFrameId: null,   /* reference to the animation */
        agendaPos:   0       /* position within agenda */
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    mounted () {
        this.init()
        this.start()
    },
    beforeUnmount () {
        this.stop()
    },
    methods: {
        prev () {
            if (this.agendaPos > 0) {
                this.agendaPos--
                this.scheduleAgendaSlot(this.agenda[this.agendaPos])
            }
        },
        next () {
            if (this.agendaPos < this.agenda.length - 1) {
                this.agendaPos++
                this.scheduleAgendaSlot(this.agenda[this.agendaPos])
            }
        },
        scheduleAgendaSlot (slot) {
            if (!Array.isArray(slot) || slot.length < 2)
                throw new Error("invalid agenda slot: must be an array with at least 2 elements")
            const parseHHMM = (time) => {
                const m = time.match(/^(\d+):(\d+)$/)
                if (!m)
                    throw new Error(`invalid time format: ${time}`)
                return moment().hour(parseInt(m[1], 10)).minute(parseInt(m[2], 10)).second(0)
                    .format("YYYY-MM-DDTHH:mm:ss")
            }
            const from  = parseHHMM(slot[0])
            const until = parseHHMM(slot[1])
            this.timer({ from, until })
        },
        start (options = {}) {
            /*  setup an update interval  */
            this.stopping = false
            const updateCallback = () => {
                if (this.stopping || this.svg === null)
                    return
                if (this.ending > 0) {
                    for (const minutesLeft of [ 3, 2, 1 ]) {
                        if (this.left[minutesLeft] && this.left[minutesLeft].time > 0
                            && !this.left[minutesLeft].done
                            && moment().isSameOrAfter(moment.unix(this.left[minutesLeft].time))
                            && moment().isSameOrBefore(moment.unix(this.ending))) {
                            this.left[minutesLeft].done = true
                            this.attention(5, "soft").catch(() => {})
                        }
                    }
                    if (!this.ended
                        && moment().isSameOrAfter(moment.unix(this.ending))
                        && moment().isSameOrBefore(moment.unix(this.ending) + 60)) {
                        /*  end timer  */
                        this.ended = true
                        this.attention(5, "hard").then(() => {
                            if (options.autostop)
                                this.stop()
                        })
                    }
                }
                this.update()
                if (!this.stopping)
                    this.animFrameId = requestAnimationFrame(updateCallback)
            }
            this.animFrameId = requestAnimationFrame(updateCallback)
            this.timer(options)
        },
        stop () {
            this.stopping = true
            if (this.animFrameId !== null) {
                cancelAnimationFrame(this.animFrameId)
                this.animFrameId = null
            }
            if (this.svg !== null) {
                this.svg.clear()
                this.svg = null
            }
            if (this.svg2 !== null) {
                this.svg2.clear()
                this.svg2 = null
            }
            if (this.svg3 !== null) {
                this.svg3.clear()
                this.svg3 = null
            }
            this.svgRefs = {}
        },
        timer (options) {
            this.started = 0
            this.ending  = 0
            this.ended   = false
            if (options.from !== undefined)
                this.started = moment(options.from).unix()
            if (options.duration !== undefined) {
                let duration = parseInt(options.duration, 10)
                if (isNaN(duration) || duration < 0)
                    duration = 0
                else {
                    duration = moment.duration(duration, "m").asSeconds()
                    if (duration > (60 * 60))
                        duration = (60 * 60)
                }
                this.ending = this.started + duration
            }
            else if (options.until !== undefined)
                this.ending = moment(options.until).unix()
            if (options.fraction !== undefined && this.ending > 0)
                this.ending = Math.ceil(this.ending / (5 * 60)) * (5 * 60)

            /*  determine current time  */
            const now = moment().unix()

            /*  determine additional information  */
            this.left = {
                3: { time: (this.ending - this.started) > 3 * 60 ? this.ending - 3 * 60 : 0, done: false },
                2: { time: (this.ending - this.started) > 2 * 60 ? this.ending - 2 * 60 : 0, done: false },
                1: { time: (this.ending - this.started) > 1 * 60 ? this.ending - 1 * 60 : 0, done: false }
            }
            this.segFrom = (this.started / 60) % 60
            this.segNow  = (now          / 60) % 60
            this.segTo   = (this.ending  / 60) % 60

            /*  clear existing segments  */
            this.clearSegments([ 1, 2, 3, 4, 5, 6 ])
        },
        clearSegments (segments) {
            for (const i of segments)
                this.svgRefs[`segment${i}`].clear()
        },
        calculateArcMax (deg1, deg2) {
            return deg2 > deg1 ?
                (deg2 - deg1 > 180 ? 1 : 0) :
                (deg1 - deg2 > 180 ? 0 : 1)
        },
        makeSegment (seg, rad1, rad2, max, b, col) {
            const W  = 500
            const R  = Math.ceil(W / 2)
            const x1 = R + Math.cos(rad1) * (R - b)
            const y1 = R - Math.sin(rad1) * (R - b)
            const x2 = R + Math.cos(rad2) * (R - b)
            const y2 = R - Math.sin(rad2) * (R - b)
            seg.clear()
            seg.path().M(R, R).L(x1, y1).A(R - b, R - b, 0, max, 1, { x: x2, y: y2 }).Z().fill(col)
        },
        attention (level = 1, type = "soft") {
            const opacity = []
            for (let i = 0; i < level; i++)
                opacity.push(0.0, 0.5)
            opacity.push(0.0)
            return anime({
                targets:   type === "soft" ? this.elSVG2 : this.elSVG3,
                duration:  level * 1000,
                autoplay:  true,
                ease:      "inOutSine",
                delay:     0,
                opacity
            }).finished
        },
        init () {
            const W = 500
            const H = 500
            const R = Math.ceil(W / 2)

            /*  initialize main clock  */
            this.elSVG1 = this.$refs.svg1
            const svg = SVG().addTo(this.elSVG1).viewbox(0, 0, W, H)
            this.svg = svg

            /*  initialize overlay  */
            this.elSVG2 = this.$refs.svg2
            const svg2 = SVG().addTo(this.elSVG2).viewbox(0, 0, W, H)
            this.svg2 = svg2
            svg2.circle(R * 2).move(0, 0).fill(this.background3)

            /*  initialize overlay  */
            this.elSVG3 = this.$refs.svg3
            const svg3 = SVG().addTo(this.elSVG3).viewbox(0, 0, W, H)
            this.svg3 = svg3
            svg3.circle(R * 2).move(0, 0).fill(this.background4)

            /*  create backgrounds  */
            svg.circle(R * 2).move(0, 0).fill(this.background1)
            svg.circle(R * 2 - 20).move(10, 10).fill(this.background2)
            svg.circle(40).move(R - 20, R - 20).fill(this.background1)
            for (let i = 1; i <= 6; i++)
                this.svgRefs[`segment${i}`] = svg.group()

            /*  create tick lines  */
            for (let i = 1; i <= 60; i++) {
                const w = i % 15 === 0 ? 8 : (i % 5 === 0 ? 8 : 2)
                const l = i % 15 === 0 ? 30 : 20
                svg.line(0, 0, 0, l)
                    .move(R, 30)
                    .rotate((360 / 60) * i, R, R)
                    .stroke({ color: this.ticks, width: w })
                    .css({ "stroke-linecap": "round" })
                if (i % 5 === 0) {
                    const g = svg.group()
                    const digit = (i / 5).toString()
                    const textElement = g.text(digit)
                        .fill(this.digits)
                        .font({
                            family: "TypoPRO Fira Sans",
                            anchor: "middle",
                            size:   (i / 5) % 3 === 0 ? 65 : 55,
                            weight: (i / 5) % 3 === 0 ? "bold" : "normal"
                        })
                    g.center(R, (i / 5) % 3 === 0 ? 100 : 90)
                        .rotate((360 / 12) * (i / 5), R, R)
                    textElement.rotate(-(360 / 12) * (i / 5))
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
        },
        update () {
            const W = 500
            const R = Math.ceil(W / 2)

            /*  determine times  */
            const now     = moment()
            const started = moment.unix(this.started)
            const ending  = moment.unix(this.ending)

            /*  determine current time parts  */
            const HH = now.hours()
            const M  = now.minutes()
            const S  = now.seconds()
            const MS = now.milliseconds()

            /*  update clock pointers  */
            this.svgRefs.p1.untransform().rotate((360 / 12) * (HH % 12) + (360 / 12) / 60   * M,  R, R)
            this.svgRefs.p2.untransform().rotate((360 / 60) * M         + (360 / 60) / 60   * S,  R, R)
            this.svgRefs.p3.untransform().rotate((360 / 60) * S         + (360 / 60) / 1000 * MS, R, R)

            /*  redraw clock segments  */
            const b = 10
            this.segNow = M + (1 / 60) * S
            const deg1 = (360 / 60) * this.segFrom
            const deg2 = (360 / 60) * this.segNow
            const deg3 = (360 / 60) * this.segTo
            const rad1 = SVG.utils.radians(90 - deg1)
            const rad2 = SVG.utils.radians(90 - deg2)
            const rad3 = SVG.utils.radians(90 - deg3)
            if (now.isAfter(ending.clone().subtract(1, "hours")) && now.isBefore(started)) {
                /*  draw todo segment only  */
                const max13 = this.calculateArcMax(deg1, deg3)
                this.clearSegments([ 1, 2 ])
                this.makeSegment(this.svgRefs.segment3, rad1, rad3, max13, 0, this.segment3)
                this.makeSegment(this.svgRefs.segment4, rad1, rad3, max13, b, this.segment4)
                this.clearSegments([ 5, 6 ])
            }
            else if (now.isSameOrAfter(started) && now.isSameOrBefore(ending)) {
                /*  draw done and todo segments  */
                const max12 = this.calculateArcMax(deg1, deg2)
                const max23 = this.calculateArcMax(deg2, deg3)
                this.makeSegment(this.svgRefs.segment1, rad1, rad2, max12, 0, this.segment1)
                this.makeSegment(this.svgRefs.segment2, rad1, rad2, max12, b, this.segment2)
                this.makeSegment(this.svgRefs.segment3, rad2, rad3, max23, 0, this.segment3)
                this.makeSegment(this.svgRefs.segment4, rad2, rad3, max23, b, this.segment4)
                this.clearSegments([ 5, 6 ])
            }
            else if (now.isAfter(ending) && now.isSameOrBefore(started.clone().add(1, "hours")) && this.overrun) {
                /*  draw done and overrun segments  */
                const max13 = this.calculateArcMax(deg1, deg3)
                const max32 = this.calculateArcMax(deg3, deg2)
                this.makeSegment(this.svgRefs.segment1, rad1, rad3, max13, 0, this.segment1)
                this.makeSegment(this.svgRefs.segment2, rad1, rad3, max13, b, this.segment2)
                this.clearSegments([ 3, 4 ])
                this.makeSegment(this.svgRefs.segment5, rad3, rad2, max32, 0, this.segment5)
                this.makeSegment(this.svgRefs.segment6, rad3, rad2, max32, b, this.segment6)
            }
            else
                this.clearSegments([ 1, 2, 3, 4, 5, 6 ])
        }
    }
}
</script>

