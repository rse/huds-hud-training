/*
**  HUDS -- Head-Up-Display Server (HUDS)
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

import js                  from "@eslint/js"
import globals             from "globals"
import pluginVue           from "eslint-plugin-vue"
import pluginImport        from "eslint-plugin-import"
import pluginN             from "eslint-plugin-n"

export default [
    /*  base recommended rules  */
    js.configs.recommended,

    /*  Vue plugin configs  */
    ...pluginVue.configs["flat/recommended"],

    /*  global configuration  */
    {
        files: [ "**/*.js", "**/*.vue" ],

        plugins: {
            import:  pluginImport,
            n:       pluginN
        },

        languageOptions: {
            ecmaVersion: 12,
            sourceType:  "module",
            parserOptions: {
                ecmaFeatures: {
                    jsx: false
                }
            },
            globals: {
                ...globals.browser,
                ...globals.commonjs,
                process:                   "readonly",
                HUDS:                      "readonly",
                huds:                      "readonly",
                anime:                     "readonly",
                soundfx:                   "readonly",
                soundlp:                   "readonly",
                SVG:                       "readonly",
                Mousetrap:                 "readonly",
                hashTagSimilarity:         "readonly",
                moment:                    "readonly",
                Audio:                     "readonly",
                AudioContext:              "readonly",
                fetch:                     "readonly",
                confetti:                  "readonly",
                requestAnimationFrame:     "readonly",
                Vue:                       "readonly",
                fitty:                     "readonly"
            }
        },

        rules: {
            /*  modified rules  */
            "indent":                                      [ "error", 4, { "SwitchCase": 1 } ],
            "linebreak-style":                             [ "error", "unix" ],
            "semi":                                        [ "error", "never" ],
            "operator-linebreak":                          [ "error", "after", { "overrides": { "&&": "before", "||": "before", ":": "after" } } ],
            "brace-style":                                 [ "error", "stroustrup", { "allowSingleLine": true } ],
            "quotes":                                      [ "error", "double" ],
            "no-unused-vars":                              [ "error", { "args": "none" } ],

            /*  disabled rules  */
            "no-multi-spaces":                             "off",
            "no-multiple-empty-lines":                     "off",
            "key-spacing":                                 "off",
            "object-property-newline":                     "off",
            "curly":                                       "off",
            "space-in-parens":                             "off",
            "array-bracket-spacing":                       "off",
            "require-atomic-updates":                      "off",
            "quote-props":                                 "off",
            "lines-between-class-members":                 "off",

            "vue/html-indent":                             "off",
            "vue/v-bind-style":                            [ "error", "longform" ],
            "vue/no-undef-properties":                     "off",
            "vue/max-attributes-per-line":                 "off",
            "vue/html-self-closing":                       "off",
            "vue/no-multi-spaces":                         "off",
            "vue/html-closing-bracket-newline":            "off",
            "vue/singleline-html-element-content-newline": "off",
            "vue/no-v-html":                               "off",
            "vue/v-on-style":                              "off",
            "vue/component-tags-order":                    "off",
            "vue/first-attribute-linebreak":               "off",
            "vue/no-v-text-v-html-on-component":           "off",
            "vue/multi-word-component-names":              "off",
            "vue/component-definition-name-casing":        "off",
            "vue/order-in-components":                     "off",
            "vue/no-reserved-component-names":             "off",
            "vue/block-order":                             "off"
        }
    }
]
