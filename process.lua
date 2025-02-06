local process = { _version = "0.0.1" }
ao = require('.ao')
json = require("json")

function process.handle(msg, env) 
  if (msg.Data == "ping") then
    ao.send({ Target = msg.From, Data = "pong" })
  end
  return ao.result({
    Output = json.encode({apple="orange"})
  })
end
return process