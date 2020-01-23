import jester, htmlgen
import times
import strformat, json, random
import ../utils
import ../meterClient/meterClient

include templates/index

router index:
  get "/":
    let initData = {"energyUsage.total": "brak danych", "energyUsage.tariff[1]": "brak danych"}.toTable
    var tpl = renderTemplate(newIndex):
      t.initData = initData
      t.meterInfo = currentRawMeterInfo
    resp tpl
  get "/time":
    let data = 
      "retry: 3000\n" &
      "data: {time: \'" & getClockStr() & "\'} \n\n"
    resp(data, "text/event-stream")
  get "/time-live":
    enableRawMode()
    request.sendHeaders(Http200,@({"Content-Type": "text/event-stream"}))
    randomize()
    for i in 0 .. 1000:
      when defined(fakeData): 
        currentMeterInfo.energyUsage.total = i/50
      let values = %*{"meterData": currentMeterInfo, "rawMeterData": currentRawMeterInfo}
      let data = 
        "retry: 3000\n" &
        &"data: {values} \n\n"
      request.send(data)
      await sleepAsync(3000)
    request.close()