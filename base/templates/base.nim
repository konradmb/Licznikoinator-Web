import emerald

template renderTemplate*(name: untyped, body: untyped): untyped =
  var
    s = newStringStream()
    t {.inject.} = `name`()
  body
  t.render(s)
  s.data

proc base(title: string) {.html_templ.} =
  title = if title == "": "Licznikoinator"
          else: title
  html(lang = "pl"):
    head:
      meta(charset = "UTF-8")
      title: title

      link(rel = "stylesheet", href = "/static/bower_components/bootstrap/dist/css/bootstrap.min.css")
    body:
      # {.filters = nil.}
      nav(class = "navbar navbar-expand-md navbar-dark bg-dark fixed-top"):
        a(class = "navbar-brand", href = "#"): "Licznikoinator"
        button(class = "navbar-toggler", type = "button",
        data = {"toggle": "collapse", "target": "#navbarsExampleDefault"},
        aria = {"controls": "navbarsExampleDefault", "expanded": "false",
            "label": "Toggle navigation"}):
          span(class = "navbar-toggler-icon")

        d(class = "collapse navbar-collapse", id = "navbarsExampleDefault"):

          ul(class = "navbar-nav mr-auto"):
            li(class = "nav-item active"):
              a(class = "nav-link", href = "#"):
                "Przegląd"
                span(class = "sr-only"): "(current)"
            li(class = "nav-item"):
              a(class = "nav-link", href = "#"): "Historia"
            li(class = "nav-item"):
              a(class = "nav-link disabled", href = "#"): "Disabled"
            li(class = "nav-item dropdown"):
              a(class = "nav-link dropdown-toggle", href = "#",
                  id = "dropdown01", data = {"toggle": "dropdown"}, aria = {
                  "haspopup": "true", "expanded": "false"}): "Dropdown"
              d(class = "dropdown-menu", aria = {"labelledby": "dropdown01"}):
                a(class = "dropdown-item", href = "#"): "Action"
                a(class = "dropdown-item", href = "#"): "Another action"
                a(class = "dropdown-item", href = "#"): "Something else here"


      main(role="main", class="container"):
        d(style = "padding-top: 5rem;"):
          block content: discard

      #[ <div class="starter-template">
        <h1>Bootstrap starter template</h1>
        <p class="lead">Use this document as a way to quickly start any new project.<br> All you get is this text and a mostly barebones HTML document.</p>
      </div> ]#

      block scripts:
        script(src = "/static/bower_components/bootstrap.native/dist/bootstrap-native-v4.js")
