import emerald
include ../../base/templates/base

proc index() {.html_templ: base .} =
  replace content:
    h2: "Hello World!"
    d.row:
      d(class="col-6 d-flex flex-column text-center justify-content-center"):
        h3(id="time")
        h6(class="text-secondary"): "Bieżące zużycie"
      d(class="col-6 d-flex flex-column text-center justify-content-center"):
        h3(id="time2")
        h6(class="text-secondary"): "Bieżące zużycie"
    canvas(id = "myChart")
    
  append scripts:
    script(src = "/static/bower_components/moment/min/moment-with-locales.min.js")
    script(src = "/static/bower_components/chart.js/dist/Chart.min.js")
    script(src = "/static/bower_components/chartjs-plugin-streaming/dist/chartjs-plugin-streaming.min.js")

    script(`type` = "text/javascript"): 
      """
        var evtSource = new EventSource("/time-live");
        evtSource.onmessage = function(e){
          var json = JSON.parse(e.data);
          console.log(json);
          var timeElement = document.getElementById('time');
          timeElement.innerText = json.time;
          var timeElement2 = document.getElementById('time2');
          timeElement2.innerText = json.time;
        }
      """
    script(`type` = "text/javascript"): 
      """
      var ctx = document.getElementById('myChart').getContext('2d');
          var chart = new Chart(ctx, {
            type: 'line',
            data: {
              datasets: [{
                data: []
              }, {
                data: []
              }]
            },
            options: {
              scales: {
                xAxes: [{
                  type: 'realtime'
                }]
              }
            }
          });
        """