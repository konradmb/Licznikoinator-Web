import tables
import emerald
include ../../base/templates/base

proc dataWidget(id: string, description: string, value:string) {.html_mixin.}=
    d(class="col-6 d-flex flex-column text-center justify-content-center"):
      h3(id=id): value
      h6(class="text-secondary"): description

proc index(initData: Table[string,string]) {.html_templ: base .} =
  replace content:
    d.row:
      call_mixin dataWidget("time", "Bieżące zużycie", initData["currentConsumption"])
      call_mixin dataWidget("time2", "Bieżące zużycie", "NaNaNaNNaN")
    d.row:
      d(class="col-3")
      d(class="col-6"):
        canvas(id = "myChart")
      d(class="col-3")
    
  append scripts:
    script(src = "/static/bower_components/moment/min/moment-with-locales.min.js")
    script(src = "/static/bower_components/chart.js/dist/Chart.min.js")
    script(src = "/static/bower_components/chartjs-plugin-streaming/dist/chartjs-plugin-streaming.min.js")

    script(`type` = "text/javascript"): 
      """
        function makeEventSource(){
          var evtSource = new EventSource("/time-live");
          evtSource.onmessage = function(e){
            var json = JSON.parse(e.data);
            console.log(json);
            var timeElement = document.getElementById('time');
            timeElement.innerText = json.time.toLocaleString();
            var timeElement2 = document.getElementById('time2');
            timeElement2.innerText = json.time.toLocaleString();
            myChart.data.datasets[1].data.push({
                x: Date.now(),
                y: json.time
            });
            // update chart datasets keeping the current animation
            myChart.update({
                preservation: true
            });
          }
          //evtSource.onerror=function(e){document.getElementById("hello").innerText="Połączenie przerwane"};
          return evtSource;
        }
        var evtSource = makeEventSource();

      """
    script(`type` = "text/javascript"): 
      """
      moment.locale(window.navigator.userLanguage || window.navigator.language);
      var ctx = document.getElementById('myChart').getContext('2d');
          var myChart = new Chart(ctx, {
            type: 'line',
            data: {
              datasets: [{
                label: 'Dataset 1',
                borderColor: 'rgb(255, 99, 132)',
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                lineTension: 0,
                borderDash: [8, 4]
              }, {
                label: 'Dataset 2',
                borderColor: 'rgb(54, 162, 235)',
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                lineTension: 0
              }]
            },
            options: {
              scales: {
                xAxes: [{
                  type: 'realtime',
                  realtime: {
                    duration: 120000
                  },
                  time: {
                    displayFormats: {
                      hour:   'LTS',
                      minute: 'LTS',
                      second: 'LTS'
                    },
                    tooltipFormat: "LTS"
                  }
                }]
              },
              plugins: {
                streaming: {
                    delay: 5000,
                    frameRate: 30
                }
              }
            }
          });
        """