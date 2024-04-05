<!--
/*
**  HUDS ~~ Head-Up-Display Server (HUDS)
**  Copyright (c) 2020-2024 Dr. Ralf S. Engelschall <rse@engelschall.com>
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
    <div ref="raisehand" v-bind:style="style" class="raisehand">
        <div v-show="raised" ref="box" class="box">
            <div class="badge">
                <div class="badge-num">{{ badge }}</div>
            </div>
            <div class="icon">
                <i class="fas fa-hand"></i>
            </div>
            <div class="name">
                {{ name }}
            </div>
            <div v-show="text !== ''" class="text">
                {{ text }}
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.raisehand {
    opacity: var(--opacity);
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: flex-end;
    .box {
        opacity: 0;
        font-family: "TypoPRO Fira Sans";
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        background-color: var(--background);
        position: relative;
        bottom: 120px;
        height: auto;
        border-radius: 20px;
        padding: 20px 20px 20px 20px;
        border: 4px solid var(--badgebackground);
        .badge {
            position: absolute;
            top: -2px;
            right: -2px;
            border-top-right-radius: 20px;
            border-bottom-left-radius: 20px;
            width: 40px;
            height: 40px;
            background-color: var(--badgebackground);
            color: var(--badgeforeground);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        .badge .badge-num {
            font-size: 30px;
        }
        .icon {
            font-size: 50px;
            color: var(--iconforeground);
        }
        .name {
            margin-top: 10px;
            font-size: 25px;
            font-weight: bold;
            width: 280px;
            text-align: center;
            text-wrap: nowrap;
            text-overflow: ellipsis;
            overflow: hidden;
            color: var(--nameforeground);
        }
        .text {
            margin-top: 10px;
            width: 280px;
            text-overflow: ellipsis;
            font-size: 25px;
            font-weight: normal;
            text-align: center;
            color: var(--textforeground);
        }
    }
}
</style>

<script>
let queue = Promise.resolve()
let timer = null
export default {
    name: "raisehand",
    props: {
        opacity:         { type: Number, default: 1.0 },
        background:      { type: String, default: "" },
        iconforeground:  { type: String, default: "" },
        nameforeground:  { type: String, default: "" },
        textforeground:  { type: String, default: "" },
        badgebackground: { type: String, default: "" },
        badgeforeground: { type: String, default: "" }
    },
    data: () => ({
        raisedhands: [],
        raised: false,
        badge: 0,
        name: "",
        text: ""
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        async raiseUp () {
            return (queue = queue.then(() => {
                this.animateStop()
                soundfx.play("chime3")
                this.raised = true
                const tl = anime.timeline({ targets: this.$refs.box, autoplay: true })
                tl.add({ easing: "easeOutSine", opacity: [ 0.0, 1.0 ], duration: 1000 })
                return tl.finished.then(() => {
                    this.animateStart()
                })
            }))
        },
        async raiseDown () {
            return (queue = queue.then(() => {
                this.animateStop()
                soundfx.play("whoosh2")
                const tl = anime.timeline({ targets: this.$refs.box, autoplay: true })
                tl.add({ easing: "easeInSine", opacity: [ 1.0, 0.0 ], duration: 1000 })
                return tl.finished.then(() => {
                    this.raised = false
                })
            }))
        },
        async animateOnce () {
            return (queue = queue.then(() => {
                const tl = anime.timeline({
                    targets:  this.$refs.box,
                    autoplay: true
                })
                tl.add({ easing: "easeInSine",  scale: [ 1.0, 1.2 ], duration: 400 })
                tl.add({ easing: "easeOutSine", scale: [ 1.2, 1.0 ], duration: 800 })
                return tl.finished
            }))
        },
        animateStart () {
            this.animateStop()
            this.animateOnce()
            timer = setInterval(() => {
                this.animateOnce()
            }, 2000)
        },
        animateStop () {
            if (timer !== null) {
                clearTimeout(timer)
                timer = null
            }
        },
        updateDisplay () {
            if (this.raisedhands.length > 0) {
                if (this.badge !== this.raisedhands.length)
                    this.badge = this.raisedhands.length
                if (this.name !== this.raisedhands[0].name)
                    this.name  = this.raisedhands[0].name
                if (this.text !== this.raisedhands[0].text)
                    this.text  = this.raisedhands[0].text
            }
        },
        async event (data) {
            if (data.raised) {
                let entry = this.raisedhands.find((entry) => entry.client === data.client)
                if (entry) {
                    /*  update existing hand  */
                    entry.seen = (new Date()).getTime()
                    entry.name = data.name
                    entry.mood = data.mood
                    this.updateDisplay()
                }
                else {
                    /*  raise a new hand  */
                    entry = {
                        client:    data.client,
                        seen:      (new Date()).getTime(),
                        name:      data.name,
                        text:      data.text
                    }
                    this.raisedhands.push(entry)
                    this.updateDisplay()
                    if (this.raisedhands.length === 1)
                        this.raiseUp()
                }
            }
            else {
                const idx = this.raisedhands.findIndex((entry) => entry.client === data.client)
                if (idx !== -1) {
                    /*  tear down hand  */
                    this.raisedhands.splice(idx, 1)
                    this.updateDisplay()
                    if (this.raisedhands.length === 0)
                        this.raiseDown()
                }
            }
        },
        async teardown () {
            if (this.raisedhands.length > 0) {
                /*  tear down hand  */
                const client = this.raisedhands[0].client
                this.raisedhands.shift()
                this.updateDisplay()
                huds.send("raisehand-teardown", { client }, huds.config().id.peer)
                if (this.raisedhands.length === 0)
                    this.raiseDown()
            }
        }
    }
}
</script>

