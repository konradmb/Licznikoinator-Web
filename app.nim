import jester, htmlgen
import asyncdispatch
import meterClient/meterClient

settings:
  port = Port(5000)
  # appName = "/foo"
  bindAddr = "127.0.0.1"

include main/router

routes:
  extend index, ""
