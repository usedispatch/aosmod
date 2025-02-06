local process = { _version = "0.0.1" }
ao = require('.ao')
json = require("json")


print("ao")
print(ao)
print("---")

-- function listvalues(s)
--   for k,v in ipairs(s) do
--       print(k)
--       print(v)
--   end
-- end

function process.handle(msg, env) 
  
  print("msg")
  print(msg.Action)
  print("---")
  print("msg data")
  print(msg.Data)
  print("msg action")
  print(msg.Action)
  print("---")
  print("env")
  print(env)
  print("+++")
  -- print('data: ', msg.Data)
  if (msg.Data == "ping") then
    print("**********************")
    ao.send({ Target = msg.From, Data = "pong" })
  end
  -- print(msg.Code)
  
  return ao.result({
    Output = json.encode({apple="orange"})
  })

end

return process