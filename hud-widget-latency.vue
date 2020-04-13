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
    <div v-if="show" v-bind:style="style" class="latency">
        <div class="time">
            {{ time }}
        </div>
    </div>
</template>

<style lang="less" scoped>
.latency {
    opacity: var(--opacity);
    .time {
        background-color: var(--background);
        color: var(--foreground);
        padding: 4px 10px 4px 10px;
        font-family: "TypoPRO DejaVu Sans Mono";
        font-size: 24pt;
    }
}
</style>

<script>
module.exports = {
    name: "latency",
    props: {
        opacity:    { type: Number, default: 1.0 },
        background: { type: String, default: "" },
        foreground: { type: String, default: "" }
    },
    data: () => ({
        show:  false,
        time:  "",
        timer: null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        start () {
            if (this.timer !== null)
                clearTimeout(this.timer)
            this.timer = setInterval(() => {
                this.time = moment().format("HH:mm:ss.S")
            }, 100)
        },
        stop () {
            if (this.timer !== null) {
                clearTimeout(this.timer)
                this.timer = null
            }
        }
    },
    mounted () {
        this.$on("toggle", () => {
            this.show = !this.show
            if (this.show)
                this.start()
            else
                this.stop()
        })
    }
}
</script>

