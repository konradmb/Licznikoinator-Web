import jester, htmlgen
import asyncdispatch
import meterClient/meterClient
import domoticzClient/domoticzClient
import parseopt

var p = initOptParser()
while true:
  p.next()
  case p.kind
  of cmdEnd: break
  of cmdShortOption, cmdLongOption:
    case p.key
    of "d", "domoticz":
      startDomoticzClient()
      quit(0)
  of cmdArgument:
    discard

settings:
  port = Port(5000)
  # appName = "/foo"
  bindAddr = "127.0.0.1"

addTimer(20000, false, readMeterRegularly)
discard readMeterRegularly(AsyncFd(0))
when defined(test):
  import test/test
  import threadpool
  spawn startMockMeterDataServer()

include main/router
routes:
  extend index, ""
  get "/read-meter":
    resp(currentRawMeterInfo, "text/plain")
