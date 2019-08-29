import jester, htmlgen
import asyncdispatch
import meterClient/meterClient

settings:
  port = Port(5000)
  # appName = "/foo"
  bindAddr = "127.0.0.1"

include main/router

addTimer(5000, false, readMeterRegularly)

routes:
  extend index, ""
  get "/read-meter":
    resp currentMeterInfo
