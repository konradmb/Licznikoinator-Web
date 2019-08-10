import emerald
include base/base

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

    