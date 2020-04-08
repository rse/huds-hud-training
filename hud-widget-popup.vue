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
    <div v-bind:style="style" class="popup">
        <div v-for="popup in popups" v-bind:key="popup.i" v-bind:data-i="popup.i" class="box" ref="box">
            <div v-if="popup.title" class="title">
                {{ popup.title }}
            </div>
            <div v-if="popup.message" class="message" v-html="popup.message">
            </div>
            <div v-if="popup.image" class="image">
                <img v-bind:src="popup.image"/>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.popup {
    opacity: var(--opacity);
    .box {
        position: absolute;
        opacity: 0;
        left: 0;
        margin-top: 20px;
        width: calc(20vw - 40px);
        padding: 20px;
        background-color: var(--background);
        border-radius: 10px;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        .title {
            width: 100%;
            font-family: "TypoPRO Fira Sans";
            font-weight: bold;
            font-size: 20pt;
            color: var(--titlecolor);
        }
        .message {
            width: 100%;
            margin-top: 10px;
            font-family: "TypoPRO Fira Sans";
            font-size: 20pt;
            color: var(--messagecolor);
        }
        .image {
            margin-top: 16px;
            border-radius: 10px;
            img {
                max-width: 100%;
                border-radius: 10px;
            }
        }
    }
}
</style>

<script>
module.exports = {
    name: "title-bar",
    props: {
        opacity:      { type: Number, default: 1.0 },
        background:   { type: String, default: "" },
        titlecolor:   { type: String, default: "" },
        messagecolor: { type: String, default: "" },
        imageurl:     { type: String, default: "" }
    },
    data: () => ({
        popups:  []
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        addBox (i) {
            const els    = this.$refs.box.sort((a, b) => parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
            const newer  = els[0]
            const others = els.slice(1)
            setTimeout(() => audio.bling.play(), 500)
            let pos = 0
            for (const el of others)
                pos += el.clientHeight + 20
            anime({
                targets:   newer,
                duration:  2000,
                autoplay:  true,
                direction: "normal",
                easing:    "easeOutBounce",
                opacity:   [ 1.0, 1.0 ],
                bottom:    [ 1000, pos ]
            }).finished.then(() => {
                audio.tack.play()
            })
        },
        removeBox () {
            const els    = this.$refs.box.sort((a, b) => parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
            const others = els.slice(0, els.length - 1)
            const older  = els[els.length - 1]

            let diff = older.clientHeight + 20
            audio.error1.play()
            anime({
                targets:   older,
                duration:  1000,
                autoplay:  true,
                direction: "normal",
                easing:    "easeOutSine",
                opacity:   [ 1.0, 0.0 ]
            }).finished.then(() => {
                this.popups.pop()
                let i = 0
                for (const el of others.reverse()) {
                    let posOld = parseInt(el.style.bottom.toString().replace(/px$/, ""))
                    let posNew = posOld - diff
                    anime({
                        targets:   el,
                        duration:  2000,
                        autoplay:  true,
                        direction: "normal",
                        easing:    "easeOutBounce",
                        delay:     200 * i++,
                        bottom:    [ posOld, posNew ]
                    }).finished.then(() => {
                        audio.tack.play()
                    })
                }
            })
        }
    },
    created () {
        let i = 0
        this.$on("popup-add", (data) => {
            data.i = i++
            this.popups.unshift(data)
            this.$nextTick(() => {
                this.addBox(data.i)
            })
        })
        this.$on("popup-remove", () => {
            this.removeBox()
        })
    }
}
</script>

