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
        <div v-for="popup in popups" ref="box" v-bind:key="popup.i" v-bind:data-i="popup.i"
            v-bind:class="{ box: true, [ popup.type ]: true }">
            <div v-if="popup.title" class="title">
                {{ popup.title }}
            </div>
            <div v-if="popup.message" class="message" v-html="popup.message">
            </div>
            <div v-if="popup.image" class="image">
                <img v-bind:src="popup.image" />
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
        border-radius: 10px;
        display: flex;
        flex-direction: column;
        overflow: hidden;
        .title {
            width: 100%;
            font-family: "TypoPRO Fira Sans";
            font-weight: bold;
            font-size: 20pt;
        }
        .message {
            width: 100%;
            margin-top: 10px;
            font-family: "TypoPRO Fira Sans";
            font-size: 20pt;
        }
        .image {
            margin-top: 16px;
            border-radius: 10px;
            img {
                max-width: 100%;
                border-radius: 10px;
            }
        }
        &.question {
            background-color: var(--questionbackground);
            .title   { color: var(--questiontitlecolor);   }
            .message { color: var(--questionmessagecolor); }
        }
        &.objection {
            background-color: var(--objectionbackground);
            .title   { color: var(--objectiontitlecolor);   }
            .message { color: var(--objectionmessagecolor); }
        }
        &.comment {
            background-color: var(--commentbackground);
            .title   { color: var(--commenttitlecolor);   }
            .message { color: var(--commentmessagecolor); }
        }
    }
}
</style>

<script>
module.exports = {
    name: "title-bar",
    props: {
        opacity:               { type: Number, default: 1.0 },
        questionbackground:    { type: String, default: "" },
        questiontitlecolor:    { type: String, default: "" },
        questionmessagecolor:  { type: String, default: "" },
        objectionbackground:   { type: String, default: "" },
        objectiontitlecolor:   { type: String, default: "" },
        objectionmessagecolor: { type: String, default: "" },
        commentbackground:     { type: String, default: "" },
        commenttitlecolor:     { type: String, default: "" },
        commentmessagecolor:   { type: String, default: "" }
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
            soundfx.play("bling1")
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
                soundfx.play("click1")
            })
        },
        removeBox () {
            const els    = this.$refs.box.sort((a, b) => parseInt(b.getAttribute("data-i")) - parseInt(a.getAttribute("data-i")))
            const others = els.slice(0, els.length - 1)
            const older  = els[els.length - 1]

            const diff = older.clientHeight + 20
            soundfx.play("whoosh2")
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
                    const posOld = parseInt(el.style.bottom.toString().replace(/px$/, ""))
                    const posNew = posOld - diff
                    anime({
                        targets:   el,
                        duration:  2000,
                        autoplay:  true,
                        direction: "normal",
                        easing:    "easeOutBounce",
                        delay:     200 * i++,
                        bottom:    [ posOld, posNew ]
                    }).finished.then(() => {
                        soundfx.play("click1")
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

