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
    <div v-bind:style="style" class="logo">
        <slot></slot>
    </div>
</template>

<style lang="less" scoped>
.logo {
    opacity: var(--opacity);
    perspective: 300px;
    svg {
        transform-origin: 50% 50%;
        transform-style:  preserve-3d;
    }
}
</style>

<script>
export default {
    name: "logo",
    props: {
        opacity: { type: Number, default: 1.0 }
    },
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        animate: (function () {
            /*  animate the logo  */
            let i = 0
            return function () {
                const tl = anime.timeline({
                    targets:  this.$el.querySelector("svg"),
                    duration: 2000,
                    easing:   "easeInOutQuad"
                })
                if (i++ % 2 === 0)
                    /*  rotate around the X-axis  */
                    tl.add({ rotateX: [ 0, 360 ] })
                else
                    /*  rotate around the Y-axis  */
                    tl.add({ rotateY: [ 0, 360 ] })
            }
        })()
    },
    mounted () {
        /*  animate every 5 minutes or on manual request  */
        setInterval(() => { this.animate() }, 5 * 60 * 1000)
    }
}
</script>

