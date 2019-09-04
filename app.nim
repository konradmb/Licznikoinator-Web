import jester, htmlgen
import asyncdispatch
import meterClient/meterClient


settings:
  port = Port(5000)
  # appName = "/foo"
  bindAddr = "127.0.0.1"

addTimer(5000, false, readMeterRegularly)
when defined(test):
  import test/test
  import threadpool
  spawn startMockMeterDataServer()

include main/router
routes:
  extend index, ""
  get "/read-meter":
    resp currentMeterInfo
