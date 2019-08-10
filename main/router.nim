import jester, htmlgen
import times
import nativesockets, httpbeast

include templates/index


template renderTemplate(name: untyped, body: untyped): untyped =
  var
    s = newStringStream()
    t {.inject.} = `name`()
  body
  t.render(s)
  s.data

router index:
  get "/":
    var tpl = renderTemplate(newIndex):
      discard
    resp tpl
  get "/time":
    let data = 
      "retry: 3000\n" &
      "data: {time: \'" & getClockStr() & "\'} \n\n"
    resp(data, "text/event-stream")
  get "/time-live":
    enableRawMode()
    request.sendHeaders(Http200,@({"Content-Type": "text/event-stream"}))
    for i in 0 .. 10:
      let data = 
        "retry: 3000\n" &
        "data: {time: \'" & getClockStr() & "\'} \n\n"
      request.send(data)
      await sleepAsync(1000)
    let nativeReq = request.getNativeReq()
    nativeReq.forget()
    nativeReq.client.close()