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
    <div v-show="show" v-bind:style="style" class="votes">
        <div v-show="quiz >= 0 && type === 'quiz'" class="quiz">
            <div class="quiz-id">{{ quizzes[quiz].id }}</div>
            <div class="quiz-question">{{ quizzes[quiz].question }}</div>
        </div>
        <div v-for="choice in choices" v-bind:key="choice.i" v-bind:data-i="choice.i" class="choice">
            <div v-show="(type === 'quiz' || (choice.voters > 0 && reveal)) || (choice.total && !reveal)"
                class="name" v-bind:class="{ win: choice.win && disclose, max: choice.max && reveal,
                    abstain: choice.abstain, invalid: choice.invalid, total: choice.total }">
                {{ choice.name }}
                <div v-if="choice.similars > 0" class="similars">
                    +{{ choice.similars }}
                </div>
            </div>
            <div v-show="(type === 'quiz' || (choice.voters > 0 && reveal)) || (choice.total && !reveal)"
                class="bar-container">
                <div v-show="reveal || (choice.total && !reveal)" v-bind:ref="(el) => bar.push(el)" class="bar" v-bind:data-i="choice.i"
                    v-bind:class="{ win: choice.win && disclose, max: choice.max && reveal,
                        abstain: choice.abstain, invalid: choice.invalid, total: choice.total }">
                    <div class="voters">
                        {{ choice.max ? `${choice.voters}/${Object.keys(votes).length} (${Math.round(choice.voters/Object.keys(votes).length * 100)}%)` : choice.voters }}
                    </div>
                </div>
            </div>
        </div>
        <div v-if="choices.length === 0 || (type === 'quiz' && !reveal)" class="hint">
            <div v-show="type === 'judge'"    v-html="hintjudge"></div>
            <div v-show="type === 'evaluate'" v-html="hintevaluate"></div>
            <div v-show="type === 'quiz'"     v-html="hintquiz"></div>
            <div v-show="type === 'choose'"   v-html="hintchoose"></div>
            <div v-show="type === 'propose'"  v-html="hintpropose"></div>
        </div>
    </div>
</template>

<style lang="less" scoped>
.votes {
    opacity: var(--opacity);
    display: flex;
    flex-direction: column;
    justify-content: flex-end;
    .quiz {
        width: calc(100% - 60px);
        font-family: "TypoPRO Fira Sans";
        font-size: 32px;
        border-radius: 10px;
        padding: 15px 30px 15px 30px;
        background-color: var(--quiztxtcolorbg);
        color:            var(--quiztxtcolorfg);
        position: relative;
        .quiz-id {
            position: absolute;
            top: 0;
            right: 0;
            padding: 10px 20px 10px 20px;
            font-size: 20px;
            font-weight: normal;
            background-color: var(--quizidcolorbg);
            color:            var(--quizidcolorfg);
            border-top-right-radius: 10px;
            border-bottom-left-radius: 10px;
        }
        .quiz-question {
            width: calc(100% - 130px);
        }
    }
    .hint {
        width: calc(100% - 60px);
        font-family: "TypoPRO Fira Sans";
        font-size: 32px;
        border-radius: 10px;
        margin-top: 5px;
        padding: 10px 30px 10px 30px;
        background-color: var(--hintcolorbg);
        color:            var(--hintcolorfg);
        kbd {
            border-radius: 4px;
            border: 1px solid var(--hintcolorfg);
            padding: 0 8px 0 8px;
            margin: 0 2px 0 2px;
        }
    }
    .choice {
        width: 100%;
        margin-top: 5px;
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        font-family: "TypoPRO Fira Sans";
        font-size: 32px;
        .name {
            flex-grow: 0;
            flex-shrink: 0;
            display: block;
            width: 600px;
            height: 40px;
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
            padding: 10px 30px 10px 30px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            border: 2px solid var(--stdnamecolorbg);
            background-color: var(--stdnamecolorbg);
            color:            var(--stdnamecolorfg);
            font-size: 32px;
            font-weight: normal;
            position: relative;
            &.max {
                border: 2px solid var(--maxnamecolorbg);
                background-color: var(--maxnamecolorbg);
                color:            var(--maxnamecolorfg);
            }
            &.win {
                border: 2px solid var(--winnamecolorbg);
                background-color: var(--winnamecolorbg);
                color:            var(--winnamecolorfg);
            }
            &.abstain, &.invalid, &.total {
                font-style: italic;
                font-weight: 300;
                border: 2px solid var(--xtrnamecolorbg);
                background-color: var(--xtrnamecolorbg);
                color:            var(--xtrnamecolorfg);
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
            display: block;
            flex-grow: 1;
            flex-shrink: 1;
            display: block;
            padding: 0;
            margin: 0;
            border-top:    2px solid var(--allvotecolorbd);
            border-bottom: 2px solid var(--allvotecolorbd);
            border-right:  2px solid var(--allvotecolorbd);
            background-color: var(--allvotecolorbg);
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
            position: relative;
            height: 60px;
            width: 100%;
            .bar {
                position: absolute;
                top: 0;
                left: 0;
                display: block;
                width: 0;
                height: 60px;
                padding: 0;
                border-top-right-radius:    10px;
                border-bottom-right-radius: 10px;
                overflow: hidden;
                background-color: var(--stdvotecolorbg);
                color:            var(--stdvotecolorfg);
                &.max {
                    background-color: var(--maxvotecolorbg);
                    color:            var(--maxvotecolorfg);
                }
                &.win {
                    background-color: var(--winvotecolorbg);
                    color:            var(--winvotecolorfg);
                }
                &.abstain, &.invalid, &.total {
                    background-color: var(--xtrvotecolorbg);
                    color:            var(--xtrvotecolorfg);
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
export default {
    name: "title-bar",
    props: {
        opacity:         { type: Number, default: 1.0 },
        winnamecolorbg:  { type: String, default: "" },
        winnamecolorfg:  { type: String, default: "" },
        maxnamecolorbg:  { type: String, default: "" },
        maxnamecolorfg:  { type: String, default: "" },
        stdnamecolorbg:  { type: String, default: "" },
        stdnamecolorfg:  { type: String, default: "" },
        xtrnamecolorbg:  { type: String, default: "" },
        xtrnamecolorfg:  { type: String, default: "" },
        winvotecolorbg:  { type: String, default: "" },
        winvotecolorfg:  { type: String, default: "" },
        maxvotecolorbg:  { type: String, default: "" },
        maxvotecolorfg:  { type: String, default: "" },
        stdvotecolorbg:  { type: String, default: "" },
        stdvotecolorfg:  { type: String, default: "" },
        xtrvotecolorbg:  { type: String, default: "" },
        xtrvotecolorfg:  { type: String, default: "" },
        allvotecolorbg:  { type: String, default: "" },
        allvotecolorbd:  { type: String, default: "" },
        quizidcolorbg:   { type: String, default: "" },
        quizidcolorfg:   { type: String, default: "" },
        quiztxtcolorbg:  { type: String, default: "" },
        quiztxtcolorfg:  { type: String, default: "" },
        hintcolorbg:     { type: String, default: "" },
        hintcolorfg:     { type: String, default: "" },
        hintjudge:       { type: String, default: "" },
        hintevaluate:    { type: String, default: "" },
        hintquiz:        { type: String, default: "" },
        hintchoose:      { type: String, default: "" },
        hintpropose:     { type: String, default: "" },
        quizzes:         { type: Object, default: [] }
    },
    data: () => ({
        show:       false,
        choices:    [],
        votes:      {},
        type:       "propose",
        timer:      null,
        quiz:       -1,
        attendance: {},
        attendees:  0,
        reveal:     true,
        disclose:   true,
        timer2:     null
    }),
    computed: {
        style: HUDS.vueprop2cssvar()
    },
    setup () {
        const bar = Vue.ref([])
        Vue.onBeforeUpdate(() => { bar.value = [] })
        return { bar }
    },
    methods: {
        /*  recalculate the scenario  */
        recalc () {
            const result = []

            /*  dispatch according to type  */
            if (this.type === "judge") {
                /*  handle judge/boolean choices only  */
                const choices = { yes: 0, no: 0, abstain: 0, invalid: 0 }
                for (const client of Object.keys(this.votes)) {
                    const choice = this.votes[client]
                    if      (choice === "YES")     choices.yes++
                    else if (choice === "NO")      choices.no++
                    else if (choice === "ABSTAIN") choices.abstain++
                    else                           choices.invalid++
                }
                if (choices.yes > 0)      result.push({ name: "Yes",        voters: choices.yes })
                if (choices.no > 0)       result.push({ name: "No",         voters: choices.no })
                if (choices.abstain > 0)  result.push({ name: "(abstain)",  voters: choices.abstain })
                if (choices.invalid > 0)  result.push({ name: "(invalid)",  voters: choices.invalid })
            }
            else if (this.type === "evaluate") {
                /*  handle evaluate/numeric choices only  */
                const choices = {}
                let abstain = 0
                let invalid = 0
                for (const client of Object.keys(this.votes)) {
                    const choice = this.votes[client]
                    if (choice.match(/^(?:-2|-1|0|\+1|\+2)$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else if (choice === "ABSTAIN")
                        abstain++
                    else
                        invalid++
                }
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b)))
                    result.push({ name: choice, voters: choices[choice] })
                if (abstain > 0) result.push({ name: "(abstain)", voters: abstain })
                if (invalid > 0) result.push({ name: "(invalid)", voters: invalid })
            }
            else if (this.type === "quiz" && this.quiz >= 0) {
                /*  handle quiz/numeric choices only  */
                const quiz = this.quizzes[this.quiz]

                /*  determine answers  */
                const answers = quiz.wrong.map((text) => ({ name: text }))
                let k = 0
                for (let i = 0; i < quiz.question.length; i++)
                    k = (k + quiz.question.charCodeAt(i)) % answers.length
                answers.splice(k, 0, { name: quiz.right, win: true })

                /*  file votings into choices  */
                const choices = {}
                for (let i = 0; i < answers.length; i++)
                    choices[String(i + 1)] = 0
                let abstain = 0
                let invalid = 0
                for (const client of Object.keys(this.votes)) {
                    const choice = this.votes[client]
                    if (choice.match(/^[1-9]$/)) {
                        if (choices[choice] === undefined)
                            invalid++
                        else
                            choices[choice]++
                    }
                    else if (choice === "ABSTAIN")
                        abstain++
                    else
                        invalid++
                }

                /*  create result  */
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b))) {
                    const i = parseInt(choice) - 1
                    const item = { name: `${choice}: ${answers[i].name}`, voters: choices[choice] }
                    if (answers[i].win)
                        item.win = true
                    result.push(item)
                }
                if (abstain > 0) result.push({ name: "(abstain)", voters: abstain })
                if (invalid > 0) result.push({ name: "(invalid)", voters: invalid })
            }
            else if (this.type === "choose") {
                /*  handle choose/numeric choices only  */
                const choices = {}
                let abstain = 0
                let invalid = 0
                for (const client of Object.keys(this.votes)) {
                    const choice = this.votes[client]
                    if (choice.match(/^[1-9]$/)) {
                        if (choices[choice] === undefined)
                            choices[choice] = 0
                        choices[choice]++
                    }
                    else if (choice === "ABSTAIN")
                        abstain++
                    else
                        invalid++
                }
                for (const choice of Object.keys(choices).sort((a, b) => parseInt(a) - parseInt(b)))
                    result.push({ name: choice, voters: choices[choice] })
                if (abstain > 0) result.push({ name: "(abstain)", voters: abstain })
                if (invalid > 0) result.push({ name: "(invalid)", voters: invalid })
            }
            else if (this.type === "propose") {
                /*  handle propose/textual choices  */

                /*  determine votes  */
                let votes = {}
                for (const client of Object.keys(this.votes)) {
                    const vote = this.votes[client]
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
            let total = 0
            for (const choice of result) {
                total += choice.voters
                if (max < choice.voters)
                    max = choice.voters
            }

            /*  post-processing PASS 2: enrich choices  */
            let i = 0
            for (const choice of result) {
                choice.i = i++
                choice.width = Math.ceil((choice.voters / max) * 100) + "%"
                if (choice.voters > 0 && choice.voters === max)
                    choice.max = true
                if (choice.name === "(abstain)") choice.abstain = true
                if (choice.name === "(invalid)") choice.invalid = true
            }

            /*  provide total votings  */
            if (!this.reveal) {
                result.push({
                    i:      i++,
                    name:   "(total)",
                    voters: total,
                    width:  this.attendees > 0 ? Math.ceil((total / this.attendees) * 100) + "%" : "0%",
                    total:  true
                })
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
                    const bars = this.bar
                    let changes = false
                    for (const bar of bars) {
                        if (bar === null)
                            continue
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
                            if (bar === null)
                                continue
                            const i = bar.getAttribute("data-i")
                            const width = this.choices[i].width
                            anime({
                                targets:   bar,
                                duration:  400,
                                autoplay:  true,
                                direction: "normal",
                                easing:    "easeOutSine",
                                width
                            })
                        }
                    }
                })
            }, 500)
        },

        /*  receive the attendee events  */
        attendanceEvent (data) {
            if (data.event === "begin")
                this.attendance[data.client] = { seen: (new Date()).getTime() }
            else if (data.event === "refresh") {
                if (this.attendance[data.client] !== undefined)
                    this.attendance[data.client].seen = (new Date()).getTime()
            }
            else if (data.event === "end")
                delete this.attendance[data.client]
            this.attendees = Object.keys(this.attendance).length
        },

        /*  toggle votes on/off  */
        toggle () {
            this.show = !this.show
            if (this.show) {
                /*  toggle on  */
                soundfx.play("beep3")
                this.choices  = []
                this.votes    = {}
                this.type     = "propose"
                this.reveal   = true
                this.disclose = true
            }
            else {
                /*  toggle off  */
                soundfx.play("whoosh2")
                if (this.type === "quiz")
                    this.quizNext()
            }
        },

        /*  force a voting type  */
        setType (type) {
            this.type = type
            if (type === "quiz") {
                this.reveal   = false
                this.disclose = false
            }
            else {
                this.reveal   = true
                this.disclose = true
            }
            this.update()
        },

        /*  reveal individual votings  */
        doReveal () {
            this.reveal = !this.reveal
            if (this.reveal)
                soundfx.play("scale1")
            this.update()
        },

        /*  disclose results of (quiz) votings  */
        doDisclose () {
            this.disclose = !this.disclose
            if (this.disclose) {
                soundfx.play("scale1")
                this.reveal = true
            }
            this.update()
        },

        /*  receive a single vote  */
        receive ({ client, choice }) {
            choice = choice.toUpperCase()
            if (this.votes[client] === undefined) {
                this.votes[client] = choice
                soundfx.play("beep1")
            }
            else
                soundfx.play("error4")
            this.update()
        },

        quizPrev () {
            if (this.quiz > 0) {
                this.quiz--
                this.reveal   = false
                this.disclose = false
                this.choices  = []
                this.votes    = {}
                this.update()
            }
        },

        quizNext () {
            if (this.quiz < this.quizzes.length - 1) {
                this.quiz++
                this.reveal   = false
                this.disclose = false
                this.choices  = []
                this.votes    = {}
                this.update()
            }
        }
    },
    created () {
        /*  track the attendees (similar to "attendance" widget to be in sync)  */
        this.timer2 = setInterval(() => {
            /*  expire attendees not seen recently
                (refresh usually every 10min, but we accept also up to 20min)  */
            const now = (new Date()).getTime()
            for (const client of Object.keys(this.attendance)) {
                const seen = this.attendance[client].seen
                if (seen + ((20 + 2) * 60 * 1000) < now)
                    delete this.attendance[client]
            }
        }, 2 * 1000)

        /*  determine selected quiz  */
        if (this.quizzes.length > 0)
            this.quiz = 0
    }
}
</script>

