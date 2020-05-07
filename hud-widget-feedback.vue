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
    <div v-bind:style="style" class="feedback">
        <div ref="bar" class="bar">
            <div v-show="smiles > 0" class="feedback-item">
                <div class="icon">
                    <i class="fa fa-smile"></i>
                </div>
                <div class="badge">
                    {{ smiles }}
                </div>
            </div>
            <div v-show="frowns > 0" class="feedback-item">
                <div class="icon">
                    <i class="fa fa-angry"></i>
                </div>
                <div class="badge">
                    {{ frowns }}
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.feedback {
    opacity: var(--opacity);
    .bar {
        position: absolute;
        bottom: 0;
        opacity: 0;
        width: 120px;
        height: 54px;
        margin: 20px;
        border-radius: 8px;
        padding: 5px 10px 3px 10px;
        background-color: var(--background);
        display: flex;
        flex-direction: row;
        justify-content: center;
        .feedback-item {
            width: 50px;
            height: 50px;
            position: relative;
            .icon {
                position: absolute;
                left: 0px;
                bottom: 0px;
                color: var(--iconcolor);
                font-size: 30pt;
            }
            .badge {
                position: absolute;
                right: 0px;
                top: 0px;
                width: 20px;
                text-align: center;
                border-radius: 5px;
                padding-top: 0px;
                padding-left: 0px;
                font-family: "TypoPRO Fira Sans";
                font-weight: normal;
                font-size: 14pt;
                background-color: var(--badgecolor);
                color: var(--textcolor);
            }
        }
    }
}
</style>

<script>
module.exports = {
    name: "feedback",
    props: {
        opacity:    { type: Number, default: 1.0 },
        background: { type: String, default: "" },
        iconcolor:  { type: String, default: "" },
        badgecolor: { type: String, default: "" },
        textcolor:  { type: String, default: "" }
    },
    data: () => ({
        feedbacks: {},
        smiles:    0,
        frowns:    0,
        shown:     false
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    created () {
        /*  receive the feedback events  */
        this.$on("event", (data) => {
            this.feedbacks[data.client] = { seen: (new Date()).getTime(), type: data.type }
        })

        /*  expire feedbacks  */
        this.timer = setInterval(() => {
            /*  expire feedbacks not seen recently  */
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.feedbacks)) {
                const seen = this.feedbacks[client].seen
                if (seen + ((30 + 4) * 1000) < now)
                    delete this.feedbacks[client]
            }

            /*  determine particular feedbacks  */
            let smiles = 0
            let frowns = 0
            for (const client of Object.keys(this.feedbacks)) {
                if (this.feedbacks[client].type === "smile")
                    smiles++
                else if (this.feedbacks[client].type === "frown")
                    frowns++
            }

            /*  animate the bar  */
            const bar = this.$refs.bar
            if ((smiles > 0 || frowns > 0) && !this.shown) {
                /*  raise the bar  */
                this.smiles = smiles
                this.frowns = frowns
                soundfx.play("beep6")
                anime({
                    targets:   bar,
                    duration:  1000,
                    autoplay:  true,
                    direction: "normal",
                    easing:    "easeOutBounce",
                    opacity:   [ 0.0, 1.0 ],
                    bottom:    [ -50, 0 ]
                })
                this.shown = true
            }
            else if ((smiles === 0 && frowns === 0) && this.shown) {
                /*  drop the bar  */
                this.shown = false
                soundfx.play("beep6")
                anime({
                    targets:   bar,
                    duration:  500,
                    autoplay:  true,
                    direction: "normal",
                    easing:    "easeInBounce",
                    opacity:   [ 1.0, 0.0 ],
                    bottom:    [ 0, -50 ]
                }).finished.then(() => {
                    this.smiles = 0
                    this.frowns = 0
                })
            }
            else {
                /*  update the bar  */
                this.smiles = smiles
                this.frowns = frowns
            }
        }, 2 * 1000)
    }
}
</script>

