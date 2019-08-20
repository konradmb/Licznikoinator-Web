import jester, htmlgen
import times
import strformat, json, random

include templates/index

router index:
  get "/":
    let initData = {"currentConsumption": "brak danych"}.toTable
    var tpl = renderTemplate(newIndex):
      t.initData = initData
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
    for i in 0 .. 30:
      let time = %*{"time": i.toFloat * 0.1}
      let data = 
        "retry: 3000\n" &
        &"data: {time} \n\n"
      request.send(data)
      await sleepAsync(3000)
    request.close()