template renderTemplate*(name: untyped, body: untyped): untyped =
  var
    s = newStringStream()
    t {.inject.} = `name`()
  body
  t.render(s)
  s.data
  
template echoIfDebug*(args: varargs[untyped, `$`]) =
  when not defined(release):
    echo args