import { describe, it } from 'node:test'
import * as assert from 'node:assert'
import AoLoader from '@permaweb/ao-loader'
import fs from 'fs'
const wasm = fs.readFileSync('../process.wasm')
const options = { format: "wasm64-unknown-emscripten-draft_2024_02_15", applyMetering: true }
console.log(wasm)
console.log('hi')
describe('out module tests', async () => {
  const handle = await AoLoader(wasm, options)
  let Memory = null
  it('says hello', async () => {
    console.log("hello")
  })
  
  it('does something simple', async () => {
    const result = await handle(Memory, getEval(`
      print('hello lua')
    `), getEnv());
    Memory = result.Memory;
    console.log(result.Output.data)
    assert.ok(true)
  })

})

function getEval(expr) {
  return {
      Target: "AOS",
      From: "FOOBAR",
      Owner: "FOOBAR",

      Module: "FOO",
      Id: "1",

      "Block-Height": "1000",
      Timestamp: Date.now(),
      Tags: [{ name: "Action", value: "Eval" }],
      Data: expr,
  };
}

function getEnv() {
  return {
      Process: {
          Id: "AOS",
          Owner: "FOOBAR",

          Tags: [{ name: "Name", value: "TEST_PROCESS_OWNER" }],
      },
  };
}