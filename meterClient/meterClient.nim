import httpclient, asyncdispatch
import ../utils

var currentMeterInfo*: string

proc readMeterRegularly*(fd: AsyncFD): bool {.gcsafe.} =
  var asyncHttpClient = newAsyncHttpClient()
  echoIfDebug "Reading meter"
  let meterInfo = asyncHttpClient.getContent("http://esp8266.local/read-meter")
  echoIfDebug "AddCallback"
  meterInfo.addCallback(proc () {.gcsafe.} =
                          try:
                            echoIfDebug "Meter read"
                          except:
                            discard
                      )
  echo "return"
  return false