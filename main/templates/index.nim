import emerald
include base/base

proc index() {.html_templ: base .} =
  replace content:
    h2: "Hello World!"
    ul(id="list")
    script(`type` = "text/javascript"): 
      """
        var evtSource = new EventSource("/time-live");
        evtSource.onmessage = function(e){
          console.log(e);
          var newElement = document.createElement("li");
          var eventList = document.getElementById('list');

          newElement.innerHTML = "message: " + e.data;
          eventList.appendChild(newElement);
        }
      """

    