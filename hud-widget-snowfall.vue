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
    <div v-bind:style="style" class="snowfall">
        <canvas ref="canvas" class="canvas"></canvas>
    </div>
</template>

<style lang="less" scoped>
.snowfall {
    opacity: var(--opacity);
    canvas {
        width:  100%;
        height: 100%;
    }
}
</style>

<script>
export default {
    name: "snowfall",
    props: {
        opacity: { type: Number, default: 1.0 }
    },
    data: () => ({
        enabled: false,
        snowflakes: []
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        /*  remote control  */
        toggle () {
            this.enabled = !this.enabled
            if (this.enabled)
                this.start()
            else
                this.stop()
        },

        start: (function () {
            /*  encapsulate a single snowflake particle  */
            const Snowflake = class {
                constructor (c, w, h, x, y, radius, color, radians) {
                    this.c        = c
                    this.w        = w
                    this.h        = h
                    this.x        = x
                    this.y        = y
                    this.radius   = radius
                    this.color    = color
                    this.radians  = radians
                }

                /*  draw snowflake  */
                draw () {
                    this.radians += this.radius * 0.001
                    const x = this.x + Math.cos(this.radians) * 400
                    const y = this.y + Math.tan(this.radians) * 600
                    if (x < 0 || x > this.w || y < 0 || y > this.h)
                        return
                    this.c.beginPath()
                    this.c.arc(x, y, this.radius, 0, Math.PI * 2, false)
                    this.c.fillStyle = this.color
                    this.c.fill()
                    this.c.closePath()
                }
            }

            return function () {
                /*  initialize canvas  */
                const canvas  = this.$refs.canvas
                canvas.width  = this.$el.clientWidth
                canvas.height = this.$el.clientHeight

                /*  animate snowfall  */
                const animate = () => {
                    const c = canvas.getContext("2d")
                    if (!this.enabled) {
                        c.clearRect(0, 0, canvas.width, canvas.height)
                        return
                    }
                    c.clearRect(0, 0, canvas.width, canvas.height)
                    this.snowflakes.forEach((snowflake) => {
                        snowflake.draw()
                    })
                    requestAnimationFrame(animate)
                }

                /*  start snowfall  */
                this.snowflakes = []
                const randomIntFromRange = (min, max) =>
                    Math.floor(Math.random() * (max - min + 1) + min)
                const randomColor = (colors) =>
                    colors[Math.floor(Math.random() * colors.length)]
                const colors = [ "#e0e0e0", "#f0f0f0", "#ffffff" ]
                for (let i = 0; i < 800; i++) {
                    this.snowflakes.push(new Snowflake(
                        canvas.getContext("2d"),
                        canvas.width,
                        canvas.height,
                        Math.random() * canvas.width,
                        Math.random() * canvas.height,
                        randomIntFromRange(2.0, 4.0),
                        randomColor(colors),
                        Math.random() * 80
                    ))
                }
                animate()
            }
        })(),

        stop () {
            this.snowflakes = []
        }
    }
}
</script>

