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
        <div v-show="show" class="box" ref="box">
            <div v-if="title" class="title">
                {{ title }}
            </div>
            <div v-if="message" class="message">
                {{ message }}
            </div>
            <div v-if="image" class="image">
                <img v-bind:src="image"/>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.popup {
    opacity: var(--opacity);
    .box {
        display: block;
        background-color: var(--background);
        width: 20vw;
        padding: 20px;
        border-radius: 10px;
        display: flex;
        flex-direction: column;
        .title {
            width: 100%;
            font-family: "TypoPRO Fira Sans";
            font-weight: bold;
            font-size: 24pt;
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
            margin-top: 20px;
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
        show:    false,
        message: null,
        title:   null,
        image:   null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
        this.$on("popup", (data) => {
            this.title   = data.title
            this.message = data.message
            this.image   = data.image
            this.show = true
            setTimeout(() => audio.bling.play(), 500)
            anime({
                targets:   this.$el,
                duration:  2000,
                autoplay:  true,
                direction: "normal",
                easing:    "easeOutBounce",
                opacity:   [ 1.0, 1.0 ],
                left:      [ -1000, 30 ]
            })
            setTimeout(() => {
                anime({
                    targets:   this.$el,
                    duration:  2000,
                    autoplay:  true,
                    direction: "normal",
                    easing:    "easeOutSine",
                    opacity:   [ 1.0, 0.0 ]
                }).finished.then(() => {
                    this.show = false
                })
            }, 30 * 1000)
        })
    }
}
</script>

