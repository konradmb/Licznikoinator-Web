import httpclient, asyncdispatch
import strutils
import ../utils
import data

var currentRawMeterInfo*{.threadvar.}: string
var currentMeterInfo*{.threadvar.}: MeterData
const meterAddress* = when defined(test): "http://127.0.0.1:8081/"
  else: "http://esp8266.local/"

proc readMeterRegularly*(fd: AsyncFD): bool {.gcsafe.} =
  var asyncHttpClient = newAsyncHttpClient()
  echoIfDebug "Reading meter"
  let meterInfo = asyncHttpClient.getContent(meterAddress & "read-meter")
  echoIfDebug "AddCallback"
  meterInfo.addCallback(proc () {.gcsafe.} =
    try:
      echoIfDebug "Meter read"
      let receivedMessage = meterInfo.read()
      currentRawMeterInfo = receivedMessage
      if receivedMessage.contains("Error"):
        return
      currentMeterInfo = parse(receivedMessage)
    except:
      discard
  )
  echoIfDebug "return"
  return false
