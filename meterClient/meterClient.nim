import httpclient, asyncdispatch

var currentMeterInfo*: string

proc readMeterRegularly*(): Future[bool] {.async.} =
    var httpClient = newAsyncHttpClient()
    let meterInfo = await httpClient.getContent("http://esp8266.local/read-meter")
    currentMeterInfo = meterInfo
    return true