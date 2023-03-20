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
    <div v-bind:style="style" class="background">
        <div ref="svg" class="svg">
        </div>
    </div>
</template>

<style lang="less" scoped>
.background {
    .svg {
        width:  100%;
        height: 100%;
    }
}
</style>

<script>
export default {
    name: "background",
    props: {
    },
    data: () => ({
        config: huds.config()
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    mounted () {
        this.render()
    },
    methods: {
        render () {
            /*  create an SVG canvas  */
            const el = this.$refs.svg
            const W = el.clientWidth
            const H = el.clientHeight
            const svg = SVG().addTo(el).size(W, H)

            /*  render the grid  */
            const G = 40
            for (let i = 0; i < Math.ceil(W / G); i++)
                for (let j = 0; j < Math.ceil(H / G); j++)
                    svg.rect(G, G).move(G * i, G * j)
                        .fill((i + j % 2) % 2 === 0 ? "#909090" : "#a0a0a0")
        }
    }
}
</script>

