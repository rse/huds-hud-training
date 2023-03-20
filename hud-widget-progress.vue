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
    <div v-bind:style="style" class="progress-bar">
        <div ref="svg" class="svg">
        </div>
    </div>
</template>

<style lang="less" scoped>
.progress-bar {
    opacity: var(--opacity);
    .svg {
        width: 100%;
        height: 100%;
    }
}
</style>

<script>
export default {
    name: "progress",
    props: {
        opacity:      { type: Number, default: 1.0 },
        slotlist:     { type: String, default: [] },
        donecolorbg:  { type: String, default: "" },
        donecolorfg:  { type: String, default: "" },
        currcolorbg:  { type: String, default: "" },
        currcolorfg:  { type: String, default: "" },
        todocolorbg:  { type: String, default: "" },
        todocolorfg:  { type: String, default: "" }
    },
    emits: [ "pos" ],
    data: () => ({
        pos: 0,
        config: huds.config()
    }),
    computed: {
        style: HUDS.vueprop2cssvar(),
        slots: function () { return this.slotlist.length }
    },
    mounted () {
        /*  render once initially  */
        this.render()

        /*  emit our current position (for agenda widget)  */
        this.$emit("pos", this.pos)
    },
    methods: {
        /*  allow the user to go to previous and next slot  */
        prev () {
            if (this.pos > 0) {
                this.pos--
                soundfx.play("bling1")
            }
            this.update()
            this.$emit("pos", this.pos)
        },
        next () {
            if (this.pos < this.slots - 1) {
                this.pos++
                soundfx.play("bling1")
            }
            this.update()
            this.$emit("pos", this.pos)
        },

        /*  initially render the progress bar  */
        render () {
            /*  establish SVG canvas  */
            const el = this.$refs.svg
            const W = el.clientWidth
            const H = el.clientHeight
            const svg = SVG().addTo(el).size(W, H)
            this.svg = svg

            /*  determine the box sizes  */
            const b = 20
            const d = 4
            const w = Math.round((W - b * 2) / this.slots) - d
            const h = H - b * 2

            /*  create the progress bar boxes  */
            this.box = []
            for (let i = this.slots - 1; i >= 0; i--) {
                /*  determine box parameters  */
                const x = i * (w + d)
                const y = 0
                const r = Math.floor(h * 0.15)

                /*  create SVG group  */
                const n = svg.nested()
                    .move(x, y)
                    .size(w + b * 2, h + b * 2)
                const g = n.group()

                /*  draw the box  */
                const p = g.path()
                    .M(r, 0)
                    .L(w - r, 0)
                if (i === this.slots - 1)
                    p.Q(w, 0, w, r)
                        .L(w, h - r)
                        .Q(w, h, w - r, h)
                else
                    p.Q(w, r / 4, w, r)
                        .L(w + r, h / 2)
                        .L(w, h - r)
                        .Q(w, h - r / 4, w - r, h)
                p.L(r, h)
                if (i === 0)
                    p.Q(0, h, 0, h - r)
                        .L(0, r)
                        .Q(0, 0, r, 0)
                else
                    p.Q(0, h, 0, h - r)
                        .L(r, h / 2)
                        .L(0, r)
                        .Q(0, 0, r, 0)
                if (this.slotlist[i].match(/^(?:BREAK|LUNCH)$/)) {
                    const R = Math.floor(h * 0.08)
                    const X = R * 3
                    const Y = R * 2
                    if (this.slotlist[i] === "BREAK") {
                        /*  optionally mark break  */
                        p.M(X, h - Y)
                        p.m(-R, 0)
                        p.a(R, R, 0, 1, 0, { x:   R * 2,  y: 0 })
                        p.a(R, R, 0, 1, 0, { x: -(R * 2), y: 0 })
                    }
                    else if (this.slotlist[i] === "LUNCH") {
                        /*  optionally mark lunch  */
                        p.M(X, h - Y)
                        p.m(-R, 0)
                        p.a(R, R, 0, 1, 0, { x:   R * 2,  y: 0 })
                        p.a(R, R, 0, 1, 0, { x: -(R * 2), y: 0 })
                        p.M(X + R * 2.3, h - Y)
                        p.m(-R, 0)
                        p.a(R, R, 0, 1, 0, { x:   R * 2,  y: 0 })
                        p.a(R, R, 0, 1, 0, { x: -(R * 2), y: 0 })
                    }
                }
                p.Z()
                p.move(b, b)

                /*  create box text  */
                const t = g.text((i + 1).toString())
                    .font({ family: "TypoPRO Fira Sans", size: h * 0.50, anchor: "middle" })
                t.move(b, b)
                t.center(b + w / 2 + 3, b + h / 2)

                /*  remember box  */
                this.box.unshift({ n, g, p, t })
            }

            /*  force an initial update  */
            this.update()
        },

        /*  update the progress bar on changes  */
        update () {
            for (let i = this.slots - 1; i >= 0; i--) {
                const { n, g, p, t } = this.box[i]
                if (i < this.pos) {
                    /*  update all done boxes  */
                    p.fill(this.donecolorbg)
                    t.fill(this.donecolorfg)
                        .font({ weight: "normal" })
                }
                else if (i === this.pos) {
                    /*  update current box  */
                    n.front()
                    p.fill(this.currcolorbg)
                    t.fill(this.currcolorfg)
                        .font({ weight: 900 })

                    /*  animate the current box  */
                    const tl = anime.timeline({
                        targets: g.node,
                        duration: 400,
                        autoplay: true,
                        direction: "normal",
                        easing: "easeInOutSine"
                    })
                    tl.add({ scaleX: 0.8, scaleY: 0.8, translateY: +12, translateX: +15, duration: 200 })
                        .add({ scaleX: 1.2, scaleY: 1.2, translateY:  -9, translateX: -15 })
                        .add({ scaleX: 1.0, scaleY: 1.0, translateY:   0, translateX:   0 })
                        .add({ scaleX: 1.1, scaleY: 1.1, translateY:  -3, translateX: -10 })
                        .add({ scaleX: 1.0, scaleY: 1.0, translateY:   0, translateX:   0, duration: 800 })
                        .finished.then(() => {})
                }
                else {
                    /*  update all todo other boxes  */
                    p.fill(this.todocolorbg)
                    t.fill(this.todocolorfg)
                        .font({ weight: "normal" })
                }
            }
        }
    }
}
</script>

