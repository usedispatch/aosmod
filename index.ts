import aos from "./aos";
import fs from "fs";
import path from "path";

async function main() {
  const luaSource = fs.readFileSync(path.join(__dirname, "process.lua"), "utf-8");

  const env = new aos(luaSource);
  await env.init();

  const result = await env.send({
    Action: "Eval",
    Data: "return 'Hello from Lua via WASM!'"
  });

  console.log("Result:", result.Output);
}

main().catch(console.error);