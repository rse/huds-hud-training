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
    <div v-show="show" v-bind:style="style" class="votes">
        <div v-if="choices.length === 0" class="await">
            <div v-show="type === 'judge'"    v-html="hintjudge"></div>
            <div v-show="type === 'evaluate'" v-html="hintevaluate"></div>
            <div v-show="type === 'choose'"   v-html="hintchoose"></div>
            <div v-show="type === 'propose'"  v-html="hintpropose"></div>
        </div>
        <div v-for="choice in choices" ref="choice" v-bind:key="choice.i" v-bind:data-i="choice.i" class="choice">
            <div class="name" v-bind:class="{ max: choice.max, invalid: choice.invalid }">
                {{ choice.name }}
                <div v-if="choice.similars > 0" class="similars">
                    +{{ choice.similars }}
                </div>
            </div>
            <div class="bar-container">
                <div ref="bar" class="bar" v-bind:data-i="choice.i"
                    v-bind:class="{ max: choice.max, invalid: choice.invalid }">
                    <div class="voters">
                        {{ choice.max ? `${choice.voters}/${Object.keys(votes).length} (${Math.round(choice.voters/Object.keys(votes).length * 100)}%)` : choice.voters }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.votes {
    opacity: var(--opacity);
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    .await {
        width: 820px;
        font-family: "TypoPRO Fira Sans";
        font-size: 32px;
        border-radius: 10px;
        padding: 10px 30px 10px 30px;
        background-color: var(--maxnamecolorbg);
        color:            var(--maxnamecolorfg);
        kbd {
            border-radius: 4px;
            border: 1px solid var(--maxnamecolorfg);
            padding: 0 8px 0 8px;
            margin: 0 2px 0 2px;
        }
    }
    .choice {
        margin-top: 10px;
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        font-family: "TypoPRO Fira Sans";
        font-size: 40px;
        .name {
            flex-grow: 0;
            flex-shrink: 0;
            display: block;
            width: 350px;
            height: 50px;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
            padding: 10px 20px 10px 20px;
            overflow: hidden;
            background-color: var(--stdnamecolorbg);
            color:            var(--stdnamecolorfg);
            position: relative;
            &.max {
                background-color: var(--maxnamecolorbg);
                color:            var(--maxnamecolorfg);
            }
            font-weight: bold;
            &.invalid {
                font-size: 32px;
                font-weight: normal;
                font-style: italic;
            }
            .similars {
                position: absolute;
                top: 10px;
                right: 10px;
                font-size: 28px;
                font-weight: normal;
            }
        }
        .bar-container {
            flex-grow: 1;
            flex-shrink: 1;
            display: block;
            padding: 0;
            margin: 0;
            .bar {
                display: block;
                width: 0;
                height: 50px;
                position: relative;
                padding: 10px 20px 10px 20px;
                border-top-right-radius: 10px;
                border-bottom-right-radius: 10px;
                overflow: hidden;
                background-color: var(--stdvotecolorbg);
                color:            var(--stdvotecolorfg);
                &.max {
                    background-color: var(--maxvotecolorbg);
                    color:            var(--maxvotecolorfg);
                }
                .voters {
                    position: absolute;
                    top: 10px;
                    left: 24px;
                }
            }
        }
    }
}
</style>

<script>
module.exports = {
    name: "title-bar",
    props: {
        opacity:         { type: Number, default: 1.0 },
        maxnamecolorbg:  { type: String, default: "" },
        maxnamecolorfg:  { type: String, default: "" },
        stdnamecolorbg:  { type: String, default: "" },
        stdnamecolorfg:  { type: String, default: "" },
        maxvotecolorbg:  { type: String, default: "" },
        maxvotecolorfg:  { type: String, default: "" },
        stdvotecolorbg:  { type: String, default: "" },
        stdvotecolorfg:  { type: String, default: "" },
        hintjudge:       { type: String, default: "" },
        hintevaluate:    { type: String, default: "" },
        hintchoose:      { type: String, default: "" },
        hintpropose:     { type: String, default: "" }
    },
    data: () => ({
        show:    false,
        choices: [],
        votes:   {},
        type:    "propose",
        timer:   null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        /*  recalculate the scenario  */
        recalc () {
            const result = []

            /*  dispatch according to type  */
            if (this.type === "judge") {
                /*  handle judge/boolean choices only  */
                const choices = { yes: 0, no: 0, invalid: 0 }
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if      (choice === "YES") choices.yes++
                    else if (choice === "NO")  choices.no++
                    else                       choices.invalid++
                }
                if (choices.yes > 0)     result.push({ name: "Yes",       voters: choices.yes })
                if (choices.no > 0)      result.push({ name: "No",        voters: choices.no })
                if (choices.invalid > 0) result.push({ name: "(Invalid)", voters: choices.invalid })
            }
            else if (this.type === "evaluate") {
                /*  handle evaluate/numeric choices only  */
                const choices = {}
                let invalid = 0
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choice.match(/^(?:-2|-1|0|\+1|\+2)$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else
                        invalid++
                }
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b)))
                    result.push({ name: choice, voters: choices[choice] })
                if (invalid > 0)
                    result.push({ name: "(Invalid)", voters: invalid })
            }
            else if (this.type === "choose") {
                /*  handle choose/numeric choices only  */
                const choices = {}
                let invalid = 0
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choice.match(/^[1-9]$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else
                        invalid++
                }
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b)))
                    result.push({ name: choice, voters: choices[choice] })
                if (invalid > 0)
                    result.push({ name: "(Invalid)", voters: invalid })
            }
            else if (this.type === "propose") {
                /*  handle propose/textual choices  */

                /*  determine votes  */
                let votes = {}
                for (const person of Object.keys(this.votes)) {
                    const vote = this.votes[person]
                    if (votes[vote] === undefined)
                        votes[vote] = 0
                    votes[vote]++
                }
                votes = hashTagSimilarity(votes)
                votes = votes.sort((a, b) => {
                    const A = Object.keys(a).sort((x, y) => a[x] - a[y])[0]
                    const B = Object.keys(b).sort((x, y) => b[x] - b[y])[0]
                    return A.localeCompare(B)
                })

                for (const vote of votes) {
                    const name   = Object.keys(vote).sort((x, y) => vote[x] - vote[y])[0]
                    let voters   = 0
                    const similars = Object.keys(vote).length - 1
                    for (const choice of Object.keys(vote))
                        voters += vote[choice]
                    result.push({ name, voters, similars })
                }
            }

            /*  post-processing PASS 1: determine maximum-voted choice (winner)  */
            let max = 0
            for (const choice of result) {
                if (max < choice.voters)
                    max = choice.voters
            }

            /*  post-processing PASS 2: enrich choices  */
            let i = 0
            for (const choice of result) {
                choice.i = i++
                choice.width = Math.ceil((choice.voters / max) * 100) + "%"
                if (choice.voters === max)
                    choice.max = true
                if (choice.name === "(Invalid)")
                    choice.invalid = true
            }

            this.choices = result
        },

        /*  update the display  */
        update () {
            if (this.timer !== null)
                clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.recalc()
                this.$nextTick(() => {
                    const bars = this.$refs.bar
                    let changes = false
                    for (const bar of bars) {
                        const i = bar.getAttribute("data-i")
                        const width = this.choices[i].width
                        if (width !== bar.style.width) {
                            changes = true
                            break
                        }
                    }
                    if (changes) {
                        soundfx.play("slide1")
                        for (const bar of bars) {
                            const i = bar.getAttribute("data-i")
                            const width = this.choices[i].width
                            anime({
                                targets:   bar,
                                duration:  400,
                                autoplay:  true,
                                direction: "normal",
                                easing:    "easeOutSine",
                                width:     width
                            })
                        }
                    }
                })
            }, 500)
        }
    },
    created () {
        /*  toggle votes on/off  */
        this.$on("votes-toggle", () => {
            this.show = !this.show
            if (this.show) {
                soundfx.play("beep3")
                this.choices = []
                this.votes   = {}
                this.type    = "propose"
            }
            else
                soundfx.play("whoosh2")
        })

        /*  force a voting type  */
        this.$on("votes-type", (type) => {
            this.type = type
        })

        /*  receive a single vote  */
        this.$on("votes-receive", ({ person, choice }) => {
            choice = choice.toUpperCase()
            if (this.votes[person] === undefined) {
                this.votes[person] = choice
                soundfx.play("beep1")
            }
            else
                soundfx.play("error4")
            this.update()
        })
    }
}
</script>

