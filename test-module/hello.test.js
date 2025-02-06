import { describe, it } from 'node:test'
import * as assert from 'node:assert'
import AoLoader from '@permaweb/ao-loader'
import fs from 'fs'

const wasm = fs.readFileSync('./process.wasm')  // or whatever your build produces
const options = { format: "wasm64-unknown-emscripten-draft_2024_02_15", applyMetering: true }

describe('hello test', async () => {
    const handle = await AoLoader(wasm, options)
    let Memory = null

    it('says hello', async () => {
        // Equivalent to "lua code" that calls our lhello module
        const result = await handle(
            Memory,
            {
                Target: "AOS",
                From: "FOOBAR",
                Owner: "FOOBAR",
                Module: "FOO",
                Id: "1",
                "Block-Height": "1000",
                Timestamp: Date.now(),
                Tags: [{ name: "Action", value: "Eval" }],
                Data: `
                    local hello = require('lhello')
                    hello.hello("World")
                    return ''
                `
            },
            {
                Process: {
                    Id: "AOS",
                    Owner: "FOOBAR",
                    Tags: [{ name: "Name", value: "TEST_PROCESS_OWNER" }]
                }
            }
        )

        Memory = result.Memory
        console.log("result")
        console.log(result.Output)   // The printed Lua output
        console.log(result.GasUsed)       // The 'gas' used
        assert.ok(true)
    })
})