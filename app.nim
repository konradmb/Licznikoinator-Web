import jester, htmlgen

settings:
  port = Port(5000)
  # appName = "/foo"
  bindAddr = "127.0.0.1"

include main/router

routes:
  extend index, ""
  #[ get "/live":
    await response.sendHeaders()
    for i in 0 .. 10:
      await response.send("The number is: " & $i & "</br>")
      await sleepAsync(1000)
    response.client.close() ]#
