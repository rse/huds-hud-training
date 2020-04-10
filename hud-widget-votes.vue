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
        <div v-for="choice in choices" ref="choice" v-bind:key="choice.i" v-bind:data-i="choice.i" class="choice">
            <div class="name" v-bind:class="{ max: choice.max, invalid: choice.invalid }">
                {{ choice.name }}
            </div>
            <div class="bar-container">
                <div class="bar" v-bind:style="{ width: choice.width }"
                    v-bind:class="{ max: choice.max, invalid: choice.invalid }">
                    <div class="voters">
                        {{ choice.voters }}
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
            width: 180px;
            height: 50px;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
            padding: 10px 20px 10px 20px;
            overflow: hidden;
            background-color: var(--stdnamecolorbg);
            color:            var(--stdnamecolorfg);
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
        stdvotecolorfg:  { type: String, default: "" }
    },
    data: () => ({
        show:    false,
        choices: [],
        votes:   {}
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    methods: {
        recalc () {
            /*  determine choices and types  */
            const choices = {}
            const found = { bool: 0, digit: 0, alpha: 0, other: 0 }
            for (const person of Object.keys(this.votes)) {
                const choice = this.votes[person]
                if (choices[choice] === undefined)
                    choices[choice] = 0
                choices[choice]++
                if (choice.match(/^(?:YES|NO)$/))
                    found.bool++
                else if (choice.match(/^\d+$/))
                    found.digit++
                else if (choice.match(/^[A-Z]$/))
                    found.alpha++
                else
                    found.other++
            }

            const most = Object.keys(this.votes).length > 0 ?
                Object.keys(found).sort((a, b) => found[b] - found[a])[0] : ""
            for (const type of Object.keys(found)) {
                if (type !== most) {
                    found[most] += found[type]
                    found[type] = 0
                }
            }

            if (most === "bool") {
                const choices = { yes: 0, no: 0, invalid: 0 }
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choice === "YES")
                        choices.yes++
                    else if (choice === "NO")
                        choices.no++
                    else
                        choices.invalid++
                }
                this.choices = []
                if (choices.yes > 0)
                    this.choices.push({ name: "Yes", voters: choices.yes })
                if (choices.no > 0)
                    this.choices.push({ name: "No",  voters: choices.no })
                if (choices.invalid > 0)
                    this.choices.push({ name: "(Invalid)", voters: choices.invalid })
            }
            else if (most === "digit") {
                const choices = {}
                let invalid = 0
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choice.match(/^\d+$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else
                        invalid++
                }
                this.choices = []
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b)))
                    this.choices.push({ name: choice, voters: choices[choice] })
                if (invalid > 0)
                    this.choices.push({ name: "(Invalid)", voters: invalid })
            }
            else if (most === "alpha") {
                const choices = {}
                let invalid = 0
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choice.match(/^[A-Z]$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else
                        invalid++
                }
                this.choices = []
                for (const choice of Object.keys(choices).sort((a, b) => a.localeCompare(b)))
                    this.choices.push({ name: choice, voters: choices[choice] })
                if (invalid > 0)
                    this.choices.push({ name: "(Invalid)", voters: invalid })
            }
            else {
                const choices = {}
                for (const person of Object.keys(this.votes)) {
                    const choice = this.votes[person]
                    if (choices[choice] === undefined)
                        choices[choice] = 0
                    choices[choice]++
                }
                this.choices = []
                for (const choice of Object.keys(choices).sort((a, b) => a.localeCompare(b)))
                    this.choices.push({ name: choice, voters: choices[choice] })
            }

            let max = 0
            for (const choice of this.choices) {
                if (max < choice.voters)
                    max = choice.voters
            }
            for (const choice of this.choices) {
                choice.width = `calc(${Math.ceil((choice.voters / max) * 100) + "%"} - 40px)`
                if (choice.voters === max)
                    choice.max = true
                if (choice.name === "(Invalid)")
                    choice.invalid = true
            }
        }
    },
    created () {
        this.$on("votes-toggle", () => {
            this.show = !this.show
            if (this.show) {
                audio.bling.play()
                this.choices = []
                this.votes   = {}
            }
            else
                audio.error1.play()
        })
        this.$on("votes-receive", ({ person, choice }) => {
            choice = choice.toUpperCase()
            if (this.votes[person] === undefined)
                this.votes[person] = choice
            this.recalc()
        })
    }
}
</script>

