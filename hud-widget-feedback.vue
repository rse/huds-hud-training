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
    <div v-bind:style="style" class="feedback">
        <div v-show="shown" class="feedback-container">
            <div
                v-for="item of items"
                v-bind:key="item.type"
                v-bind:ref="(el) => itemEls.push(el)"
                v-bind:data-type="item.type"
                v-bind:class="[ 'item', 'item-' + item.type ]">
                <div class="icon-bg">
                    <i class="fas fa-circle"></i>
                </div>
                <div class="icon">
                    <i v-bind:class="[ 'fas', 'fa-' + item.icon ]"></i>
                </div>
                <div v-show="item.count > 1" class="badge">
                    {{ item.count }}
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.feedback {
    opacity: var(--opacity);
    position: relative;
    .feedback-container {
        width: 400px;
        height: 990px;
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        align-items: flex-end;
        .item {
            width: 100px;
            height: 100px;
            position: relative;
            .icon-bg {
                opacity: 0.8;
                position: absolute;
                left: 0px;
                bottom: 0px;
                font-size: 100px;
            }
            .icon {
                position: absolute;
                left: 0px;
                bottom: 0px;
                font-size: 100px;
            }
            .badge {
                position: absolute;
                right: 0px;
                top: -4px;
                width: 30px;
                height: 30px;
                text-align: center;
                border-radius: 15px;
                padding-top: 0px;
                padding-left: 0px;
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                font-size: 16pt;
            }
            &.item-surprise {
                .icon-bg { color:            var(--surprisecolor1); }
                .icon    { color:            var(--surprisecolor2); }
                .badge   { background-color: var(--surprisecolor3);
                           color:            var(--surprisecolor4); }
            }
            &.item-smile {
                .icon-bg { color:            var(--smilecolor1); }
                .icon    { color:            var(--smilecolor2); }
                .badge   { background-color: var(--smilecolor3);
                           color:            var(--smilecolor4); }
            }
            &.item-frown {
                .icon-bg { color:            var(--frowncolor1); }
                .icon    { color:            var(--frowncolor2); }
                .badge   { background-color: var(--frowncolor3);
                           color:            var(--frowncolor4); }
            }
            &.item-sadness {
                .icon-bg { color:            var(--sadnesscolor1); }
                .icon    { color:            var(--sadnesscolor2); }
                .badge   { background-color: var(--sadnesscolor3);
                           color:            var(--sadnesscolor4); }
            }
            &.item-thumbsup {
                .icon-bg { color:            var(--thumbsupcolor1); }
                .icon    { color:            var(--thumbsupcolor2); font-size: 60px; left: 22px; top: 3px; }
                .badge   { background-color: var(--thumbsupcolor3);
                           color:            var(--thumbsupcolor4); }
            }
            &.item-thumbsdn {
                .icon-bg { color:            var(--thumbsdncolor1); }
                .icon    { color:            var(--thumbsdncolor2); font-size: 60px; left: 20px; top: 10px; }
                .badge   { background-color: var(--thumbsdncolor3);
                           color:            var(--thumbsdncolor4); }
            }
        }
    }
}
</style>

<script>
export default {
    name: "feedback",
    props: {
        opacity:        { type: Number, default: 1.0 },
        surprisecolor1: { type: String, default: "" },
        surprisecolor2: { type: String, default: "" },
        surprisecolor3: { type: String, default: "" },
        surprisecolor4: { type: String, default: "" },
        smilecolor1:    { type: String, default: "" },
        smilecolor2:    { type: String, default: "" },
        smilecolor3:    { type: String, default: "" },
        smilecolor4:    { type: String, default: "" },
        frowncolor1:    { type: String, default: "" },
        frowncolor2:    { type: String, default: "" },
        frowncolor3:    { type: String, default: "" },
        frowncolor4:    { type: String, default: "" },
        sadnesscolor1:  { type: String, default: "" },
        sadnesscolor2:  { type: String, default: "" },
        sadnesscolor3:  { type: String, default: "" },
        sadnesscolor4:  { type: String, default: "" },
        thumbsupcolor1: { type: String, default: "" },
        thumbsupcolor2: { type: String, default: "" },
        thumbsupcolor3: { type: String, default: "" },
        thumbsupcolor4: { type: String, default: "" },
        thumbsdncolor1: { type: String, default: "" },
        thumbsdncolor2: { type: String, default: "" },
        thumbsdncolor3: { type: String, default: "" },
        thumbsdncolor4: { type: String, default: "" }
    },
    data: () => ({
        feedbacks: {},
        shown:     false,
        items:     []
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    setup () {
        const itemEls = Vue.ref([])
        Vue.onBeforeUpdate(() => { itemEls.value = [] })
        return { itemEls }
    },
    methods: {
        /*  receive the feedback events  */
        event (data) {
            this.feedbacks[data.client] = {
                seen: (new Date()).getTime(),
                type: data.type
            }
        }
    },
    created () {
        /*  expire feedbacks  */
        this.timer = setInterval(() => {
            /*  expire or take over feedbacks  */
            const items = {}
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.feedbacks)) {
                const seen = this.feedbacks[client].seen
                if (seen + ((30 + 2) * 1000) < now)
                    delete this.feedbacks[client]
                else {
                    const type = this.feedbacks[client].type
                    if (items[type] === undefined)
                        items[type] = 0
                    items[type]++
                }
            }

            /*  merge items into data model and determine what is coming and going  */
            const coming = []
            const going  = []
            for (const type of Object.keys(items)) {
                let item = this.items.find((item) => item.type === type)
                if (item)
                    item.count = items[type]
                else {
                    let icon
                    if      (type === "surprise") icon = "surprise"
                    else if (type === "smile")    icon = "grin-wink"
                    else if (type === "frown")    icon = "angry"
                    else if (type === "sadness")  icon = "sad-tear"
                    else if (type === "thumbsup") icon = "thumbs-up"
                    else if (type === "thumbsdn") icon = "thumbs-down"
                    else                          icon = "smile"
                    item = { type, count: items[type], icon, coming: true }
                    this.items.push(item)
                    coming.push(item)
                }
            }
            for (const item of this.items) {
                if (!item.coming && !item.going && items[item.type] === undefined) {
                    item.going = true
                    item.count = 0
                    going.push(item)
                }
            }

            /*  determine whether widget should be shown at all  */
            this.shown = (this.items.length > 0)

            /*  animate items (once Vue has updated the DOM)  */
            this.$nextTick(() => {
                const findElement = (type) => {
                    const els = this.itemEls
                    for (let i = 0; i < els.length; i++)
                        if (els[i].getAttribute("data-type") === type)
                            return els[i]
                    return null
                }

                /*  animate coming items  */
                for (const item of coming) {
                    const el = findElement(item.type)
                    if (el !== null) {
                        soundfx.play("beep6")
                        const tl = anime.timeline({
                            targets:   el,
                            direction: "normal",
                            loop:      false,
                            autoplay:  true
                        })
                        tl.add({ duration: 5300, easing: "easeInOutSine", rotate: [ 0, 360 ] }, 0)
                        tl.add({ duration: 1000, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: [ -200, 700 ] }, 0)
                        tl.add({ duration: 1000, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 1000)
                        tl.add({ duration:  750, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 500 }, 2000)
                        tl.add({ duration:  750, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 2750)
                        tl.add({ duration:  500, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 300 }, 3500)
                        tl.add({ duration:  500, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 4000)
                        tl.add({ duration:  250, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 100 }, 4500)
                        tl.add({ duration:  250, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 4750)
                        tl.add({ duration:  150, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 25 }, 5000)
                        tl.add({ duration:  150, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 5150)
                        tl.finished.then(() => {
                            item.coming = false
                        })
                    }
                }

                /*  animate going items  */
                for (const item of going) {
                    const el = findElement(item.type)
                    if (el !== null) {
                        const tl = anime.timeline({
                            targets:   el,
                            direction: "normal",
                            loop:      false,
                            autoplay:  true
                        })
                        tl.add({ duration: 1500, easing: "easeInOutSine", rotate: [ 0, 360 ] }, 0)
                        tl.add({ duration:  500, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 300 }, 0)
                        tl.add({ duration:  500, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: 0 }, 500)
                        tl.add({ duration:  250, easing: "cubicBezier(0.0,0.5,0.3,1.0)", bottom: 100 }, 1000)
                        tl.add({ duration:  250, easing: "cubicBezier(0.5,0.0,1.0,0.3)", bottom: -200 }, 1250)
                        tl.finished.then(() => {
                            this.items = this.items.filter((x) => x !== item)
                        })
                    }
                }
            })
        }, 1 * 1000)
    }
}
</script>

