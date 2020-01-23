import tables
import emerald
include ../../base/templates/base

proc dataWidget(id: string, description: string, value:string) {.html_mixin.}=
    d(class="col-6 d-flex flex-column text-center justify-content-center"):
      h3(id=id): value
      h6(class="text-secondary"): description

proc index(initData: Table[string,string], meterInfo: string) {.html_templ: base .} =
  replace content:
    d.row:
      call_mixin dataWidget("totalUsage", "Zużycie we wszystkich taryfach", initData["energyUsage.total"])
      call_mixin dataWidget("tariffUsage", "Zużycie w bieżącej taryfie", initData["energyUsage.tariff[1]"])
    d.row:
      d(class="col-3")
      d(class="col-6"):
        canvas(id = "myChart")
      d(class="col-3")
    d.row:
      h2: "Informacje o liczniku:"
    d.row:
      pre(id="meterInfo"):
        {. preserve_whitespace = true .}
        meterInfo
    
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
            var totalUsageElement = document.getElementById('totalUsage');
            totalUsageElement.innerText = json.meterData.energyUsage.total.toLocaleString();
            var tariffUsageElement = document.getElementById('tariffUsage');
            tariffUsageElement.innerText = json.meterData.energyUsage.tariff[0].toLocaleString();
            var meterInfoElement = document.getElementById('meterInfo');
            meterInfoElement.innerText = json.rawMeterData;
            myChart.data.datasets[0].data.push({
                x: Date.now(),
                y: json.meterData.energyUsage.total
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
                label: 'Zużycie we wszystkich taryfach',
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
                    duration: 240000
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