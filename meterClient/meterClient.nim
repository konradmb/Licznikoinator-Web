import httpclient, asyncdispatch
import ../utils

var currentMeterInfo*{.threadvar.}: string
const meterAddress = when defined(test): "http://127.0.0.1:8080/"
  else: "http://esp8266.local/"

proc readMeterRegularly*(fd: AsyncFD): bool {.gcsafe.} =
  var asyncHttpClient = newAsyncHttpClient()
  echoIfDebug "Reading meter"
  let meterInfo = asyncHttpClient.getContent(meterAddress & "read-meter")
  echoIfDebug "AddCallback"
  meterInfo.addCallback(proc () {.gcsafe.} =
    try:
      echoIfDebug "Meter read"
      currentMeterInfo = meterInfo.read()
    except:
      discard
  )
  echoIfDebug "return"
  return false
