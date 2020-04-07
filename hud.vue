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
    <div v-bind:style="style" class="hud">
        <title-bar ref="titleBar" class="title"
            v-bind:opacity="config.title.opacity"
            v-bind:background="config.title.background"
            v-bind:iconname="config.title.iconname"
            v-bind:iconcolor="config.title.iconcolor"
            v-bind:nametext="config.title.nametext"
            v-bind:namecolor="config.title.namecolor"
            v-bind:titletext="config.title.titletext"
            v-bind:titlecolor="config.title.titlecolor"
        ></title-bar>
        <progress-bar ref="progressBar" class="progress"
            v-bind:opacity="config.progress.opacity"
            v-bind:slots="config.progress.slots"
            v-bind:donecolorbg="config.progress.donecolorbg"
            v-bind:donecolorfg="config.progress.donecolorfg"
            v-bind:currcolorbg="config.progress.currcolorbg"
            v-bind:currcolorfg="config.progress.currcolorfg"
            v-bind:todocolorbg="config.progress.todocolorbg"
            v-bind:todocolorfg="config.progress.todocolorfg"
        ></progress-bar>
        <banner class="banner"
            v-bind:opacity="config.banner.opacity"
            v-bind:background="config.banner.background"
            v-for="banner in config.banner.banner"
            v-bind:ref="'banner-' + banner.name"
            v-bind:iconname="banner.iconname"
            v-bind:iconcolor="banner.iconcolor"
            v-bind:titletext="banner.titletext"
            v-bind:titlecolor="banner.titlecolor"
        ></banner>
        <logo ref="logo" class="logo"
            v-bind:opacity="config.logo.opacity"
            v-html="config.logo.svg"
        ></logo>
        <agenda ref="agenda" class="agenda"
            v-bind:opacity="config.agenda.opacity"
            v-bind:donecolorbg="config.agenda.donecolorbg"
            v-bind:donecolorfg="config.agenda.donecolorfg"
            v-bind:currcolorbg="config.agenda.currcolorbg"
            v-bind:currcolorfg="config.agenda.currcolorfg"
            v-bind:todocolorbg="config.agenda.todocolorbg"
            v-bind:todocolorfg="config.agenda.todocolorfg"
            v-bind:slotlist="config.agenda.slots"
        ></agenda>
        <closure ref="closure" class="closure"
            v-bind:opacity="config.closure.opacity"
            v-bind:background="config.closure.background"
            v-bind:beginiconname="config.closure.beginiconname"
            v-bind:beginiconcolor="config.closure.beginiconcolor"
            v-bind:beginhinttext="config.closure.beginhinttext"
            v-bind:beginhintcolor="config.closure.beginhintcolor"
            v-bind:pauseiconname="config.closure.pauseiconname"
            v-bind:pauseiconcolor="config.closure.pauseiconcolor"
            v-bind:pausehinttext="config.closure.pausehinttext"
            v-bind:pausehintcolor="config.closure.pausehintcolor"
            v-bind:endiconname="config.closure.endiconname"
            v-bind:endiconcolor="config.closure.endiconcolor"
            v-bind:endhinttext="config.closure.endhinttext"
            v-bind:endhintcolor="config.closure.endhintcolor"
        ></closure>
        <popup ref="popup" class="popup"
            v-bind:opacity="config.popup.opacity"
            v-bind:background="config.popup.background"
            v-bind:titlecolor="config.popup.titlecolor"
            v-bind:messagecolor="config.popup.messagecolor"
        ></popup>
    </div>
</template>

<style lang="less" scoped>
body {
    background-color: var(--background);
}
.hud {
    width: 100vw;
    height: 100vh;
    position: relative;
    font-family: sans-serif;
    font-size: 22pt;
    overflow: hidden;
    > .title {
        position: absolute;
        right: 10px;
        bottom: 10px;
        width: 30%;
    }
    > .progress {
        position: absolute;
        bottom: 10px;
        left: 10px;
        width: 70%;
        height: 100px;
    }
    > .logo {
        position: absolute;
        top: 30px;
        right: 30px;
        width: 150px;
        height: auto;
    }
    > .agenda {
        position: absolute;
        top: 10px;
        left: 10px;
        width: auto;
        height: calc(100% - 60px - 100px);
    }
    > .closure {
        position: absolute;
        top: 0;
        left: 0;
    }
    > .popup {
        position: absolute;
        bottom: 120px;
        left: 30px;
    }
}
</style>

<script>
module.exports = {
    name: "hud",
    data: () => ({
        config: huds.config(),
        banner: null,
        logo: null
    }),
    computed: {
        style: () => {
            return {
                background: huds.options.debug ? "#999999" : "transparent"
            }
        }
    },
    components: {
        "banner":       "url:hud-widget-banner.vue",
        "title-bar":    "url:hud-widget-title.vue",
        "progress-bar": "url:hud-widget-progress.vue",
        "agenda":       "url:hud-widget-agenda.vue",
        "logo":         "url:hud-widget-logo.vue",
        "closure":      "url:hud-widget-closure.vue",
        "popup":        "url:hud-widget-popup.vue"
    },
    created () {
        /*  interaction for logo */
        Mousetrap.bind("l", (e) => {
            huds.send("logo.animate")
        })
        huds.bind("logo.animate", (event, data) => {
            let logo = this.$refs.logo
            logo.$emit("animate")
        })

        /*  interaction for progress widget  */
        Mousetrap.bind("left", (e) => {
            huds.send("progress.jump", "prev")
        })
        Mousetrap.bind("right", (e) => {
            huds.send("progress.jump", "next")
        })
        huds.bind("progress.jump", (event, data) => {
            let pb = this.$refs.progressBar
            if (data === "prev" || data === "next")
                pb.$emit(data)
        })

        /*  interaction for closure  */
        Mousetrap.bind("up", (e) => {
            huds.send("closure.begin.toggle")
        })
        Mousetrap.bind("return", (e) => {
            huds.send("closure.pause.toggle")
        })
        Mousetrap.bind("down", (e) => {
            huds.send("closure.end.toggle")
        })
        huds.bind("closure.*", (event, data) => {
            let closure = this.$refs.closure
            if (event === "closure.begin.toggle")
                closure.$emit("begin-toggle")
            else if (event === "closure.pause.toggle")
                closure.$emit("pause-toggle")
            else if (event === "closure.end.toggle")
                closure.$emit("end-toggle")
        })

        /*  interaction for title widget  */
        Mousetrap.bind("space", (e) => {
            huds.send("title.bounce")
        })
        huds.bind("title.bounce", (event, data) => {
            let tb = this.$refs.titleBar
            tb.$emit("bounce")
        })

        /*  interaction for agenda widget  */
        Mousetrap.bind("a", (e) => {
            huds.send("agenda.toggle")
        })
        huds.bind("agenda.toggle", (event, data) => {
            let a = this.$refs.agenda
            a.$emit("toggle")
        })

        /*  interaction for popup widget  */
        huds.bind("popup", (event, data) => {
            let a = this.$refs.popup
            a.$emit("popup", data)
        })

        /*  interaction for progress widget  */
        let progress = false
        for (const banner of this.config.banner.banner) {
            Mousetrap.bind(banner.key, (e) => {
                huds.send(`banner.${banner.name}.toggle`)
            })
            huds.bind(`banner.${banner.name}.toggle`, (event, data) => {
                if (progress)
                    return
                let b = this.$refs[`banner-${banner.name}`][0]
                if (this.banner === b) {
                    /*  disable ourself  */
                    progress = true
                    this.banner.$emit("toggle")
                    setTimeout(() => {
                        this.banner = null
                        progress = false
                    }, 1000)
                }
                else if (this.banner !== null) {
                    /*  disable foreign, then enable ourself  */
                    progress = true
                    this.banner.$emit("toggle")
                    setTimeout(() => {
                        b.$emit("toggle")
                        setTimeout(() => {
                            this.banner = b
                            progress = false
                        }, 1000)
                    }, 1000)
                }
                else {
                    /*  enable ourself  */
                    progress = true
                    b.$emit("toggle")
                    setTimeout(() => {
                        this.banner = b
                        progress = false
                    }, 1000)
                }
            })
        }
    },
    mounted () {
        /*  forward progress position to agenda  */
        setTimeout(() => {
            let pb = this.$refs.progressBar
            let a  = this.$refs.agenda
            pb.$on("pos", (pos) => {
                a.$emit("pos", pos)
            })
        }, 500)
    }
}
</script>

