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
    <div v-if="show" v-bind:style="style" class="latency">
        <div class="time">
            <div class="title">
                Upstream/Downstream Time
            </div>
            <div class="send">
                {{ time }}
                <i class="icon fas fa-arrow-alt-circle-right"></i>
            </div>
            <div class="recv">
                --:--:--.-
                <i class="icon fas fa-arrow-alt-circle-left"></i>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.latency {
    opacity: var(--opacity);
    border-radius: 10px;
    background-color: var(--background);
    padding: 12px 20px 12px 20px;
    color: var(--foreground);
    .time {
        .title {
            font-family: "TypoPRO Fira Sans";
            font-size: 14pt;
        }
        .recv {
            font-family: "TypoPRO DejaVu Sans Mono";
            font-size: 24pt;
            margin-top: 6px;
            .icon {
                color: var(--iconcolor);
            }
        }
        .send {
            font-family: "TypoPRO DejaVu Sans Mono";
            font-size: 24pt;
            margin-top: 6px;
            .icon {
                color: var(--iconcolor);
            }
        }
    }
}
</style>

<script>
export default {
    name: "latency",
    props: {
        opacity:    { type: Number, default: 1.0 },
        background: { type: String, default: "" },
        foreground: { type: String, default: "" },
        iconcolor:  { type: String, default: "" }
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
            /*  start widget  */
            if (this.timer !== null)
                clearTimeout(this.timer)
            this.timer = setInterval(() => {
                /*  update current time  */
                this.time = moment().format("HH:mm:ss.S")
            }, 100)
        },
        stop () {
            /*  stop widget  */
            if (this.timer !== null) {
                clearTimeout(this.timer)
                this.timer = null
            }
        },
        toggle () {
            this.show = !this.show
            if (this.show)
                this.start()
            else
                this.stop()
        }
    }
}
</script>

