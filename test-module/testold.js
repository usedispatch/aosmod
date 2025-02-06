const { describe, it } = require('node:test')
const assert = require('assert')
const fs = require('fs')
const pwasm = fs.readFileSync(__dirname + '/../process.wasm')
const pjs = require(__dirname + '/../process.js')

describe('our module tests', async () => {
  it('says hello', async () => {
    console.log("hello")
    console.log(pjs)
    console.log(pwasm)
  })
})
