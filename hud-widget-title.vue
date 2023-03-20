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
    <div v-bind:style="style" class="title-bar">
        <div ref="bar" class="bar">
            <div class="icon">
                <i v-bind:class="[ 'fas', 'fa-' + iconname ]"></i>
            </div>
            <div class="text">
                <div v-if="nametext"  ref="person" class="person fit">{{ nametext }}</div>
                <div v-if="titletext" ref="title"  class="title fit">{{ titletext }}</div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.title-bar {
    opacity: var(--opacity);
    .bar {
        width: calc(100% - 60px);
        height: 54px;
        margin: 20px;
        border-radius: 8px;
        padding: 4px;
        padding-left: 20px;
        background-color: var(--background);
        display: flex;
        flex-direction: row;
        .icon {
            padding-right: 20px;
            width: 60px;
            color: var(--iconcolor);
            font-size: 35pt;
        }
        .text {
            display: flex;
            flex-direction: column;
            justify-content: center;
            width: calc(100% - 120px);
            .fit {
                display: inline-block;
                white-space: nowrap;
            }
            .person {
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                color: var(--namecolor);
            }
            .title {
                font-family: "TypoPRO Fira Sans";
                font-weight: bold;
                color: var(--titlecolor);
            }
        }
    }
}
</style>

<script>
export default {
    name: "title-bar",
    props: {
        opacity:    { type: Number, default: 1.0 },
        background: { type: String, default: "" },
        iconname:   { type: String, default: "" },
        iconcolor:  { type: String, default: "" },
        nametext:   { type: String, default: "" },
        namecolor:  { type: String, default: "" },
        titletext:  { type: String, default: "" },
        titlecolor: { type: String, default: "" }
    },
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    mounted () {
        const person = this.$refs.person
        const title  = this.$refs.title
        fitty(person, { minSize: 12, maxSize: 18, multiLine: false })
        fitty(title,  { minSize: 12, maxSize: 28, multiLine: false })
    },
    methods: {
        /*  allow the title to be manually animated  */
        animate () {
            const bar = this.$refs.bar
            soundfx.play("bling1")
            const tl = anime.timeline({
                targets: bar,
                duration: 400,
                autoplay: true,
                direction: "normal",
                loop: 3,
                easing: "easeInOutSine"
            })
            tl.add({ scaleX: 1.10, scaleY: 1.20, translateY:  0, translateX:  0 })
                .add({ scaleX: 1.00, scaleY: 1.00, translateY:  0, translateX:  0 })
        }
    }
}
</script>

