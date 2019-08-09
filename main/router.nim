import jester, htmlgen
import times

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
  