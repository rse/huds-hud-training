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
    <div v-bind:style="style" class="confetti">
        <canvas ref="canvas" class="canvas"></canvas>
    </div>
</template>

<style lang="less" scoped>
.confetti {
    width:  100%;
    height: 100%;
    opacity: var(--opacity);
    .canvas {
        width:  100%;
        height: 100%;
    }
}
</style>

<script>
export default {
    name: "confetti",
    props: {
        opacity: { type: Number, default: 1.0 }
    },
    data: () => ({
        confetti: null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    mounted () {
        /*  create a confetti instance on the canvas  */
        this.confetti = confetti.create(this.$refs.canvas, { useWorker: true, resize: true })
    },
    methods: {
        /*  react on event  */
        async raise () {
            /*  utility function for determining a random number  */
            const randomInRange = (min, max) =>
                Math.random() * (max - min) + min

            /*  fire a single confetti bomb  */
            const fire = (particleRatio, opts) => {
                setTimeout(() => {
                    this.confetti(Object.assign({}, {
                        gravity:       0.90,
                        ticks:         1000,
                        origin:        { x: 0.5, y: 1.0 },
                        shapes:        [ "circle", "square" ],
                        scalar:        1.5,
                        colors: [
                            "#909090", "#c0c0c0", "#ffffff", /* white  */
                            "#336699", "#6699cc", "#99ccff", /* blue   */
                            "#b06820", "#e09850", "#ffb870", /* brown  */
                            "#cc3333",                       /* red    */
                            "#ffff33"                        /* yellow */
                        ]
                    }, opts, {
                        angle:         randomInRange(55, 125),
                        particleCount: Math.floor(250 * particleRatio)
                    }))
                }, randomInRange(0, 200))
            }

            /*  perform ten rounds  */
            soundfx.play("fanfare1")
            await new Promise((resolve) => setTimeout(resolve, 3.0 * 1000))
            for (let i = 0; i < 10; i++) {
                /*  fire multiple confetti bombs  */
                soundfx.play(`cannon${(i % 2) + 1}`)
                fire(0.25, { spread:  26, startVelocity: 55, decay: 0.94 })
                fire(0.20, { spread:  60, startVelocity: 10, decay: 0.94 })
                fire(0.35, { spread: 100, startVelocity: 60, decay: 0.91 })
                fire(0.10, { spread: 120, startVelocity: 25, decay: 0.92 })
                fire(0.10, { spread: 120, startVelocity: 45, decay: 0.94 })
                await new Promise((resolve) => setTimeout(resolve, randomInRange(0, 300)))
            }
        }
    }
}

</script>

