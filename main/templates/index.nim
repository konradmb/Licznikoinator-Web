import emerald
include ../../base/templates/base

proc index() {.html_templ: base .} =
  replace content:
    h2: "Hello World!"
    h3(id="time")
    script(`type` = "text/javascript"): 
      """
        var evtSource = new EventSource("/time-live");
        evtSource.onmessage = function(e){
          console.log(e);
          var timeElement = document.getElementById('time');
          timeElement.innerText = e.data;
        }
      """
  append scripts:
    script(src = "/static/bower_components/moment/min/moment-with-locales.min.js")
    script(src = "/static/bower_components/chart.js/dist/Chart.min.js")
    script(src = "/static/bower_components/chartjs-plugin-streaming/dist/chartjs-plugin-streaming.min.js")