import asynchttpserver, asyncdispatch
import strformat

proc startMockMeterDataServer*() =
  var server = newAsyncHttpServer()
  var counter: float = 0

  proc cb(req: Request) {.async.} =
    var usage = counter * 0.1
    let message = fmt"""
  0.0.0(61403025)
  0.0.1(PAF)
  0.9.1(00:45:00)
  0.9.2(19-08-28)
  F.F(00)
  0.2.0(1.25)
  C.5(10002)
  F.8.0*00({counter:09.2f})
  F.8.1*00(000001.29)
  F.8.2*00(000000.07)
  F.8.3*00(000000.00)
  F.8.4*00(000000.00)
  F.8.1*01(000001.29)
  F.8.2*01(000000.07)
  F.8.3*01(000000.00)
  F.8.4*01(000000.00)
  F.8.1*02(000001.29)
  F.8.2*02(000000.07)
  F.8.3*02(000000.00)
  F.8.4*02(000000.00)
  F.6.0*00(00.0000)(00:00:00,00-00-00)
  F.6.0*01(00.0000)(00:00:00,00-00-00)
  0.1.2*01(00:00:00,19-08-01)
  F.35(00.0000)
  F.35.90*00(0000.0000)
  F.36.90*00(00000)(0000000000000000)
  F.36.90*01(00000)(0000000000000000)
  F.2.0(0005.1123)
  0.1.0(00007)
  C.2.1(090513082409)(----                                            )
  0.2.2(:::::G12)!
  """
    counter += 1
    await req.respond(Http200, message)
    echo "Meter data sent"

  echo "Meter data server start"
  waitFor server.serve(Port(8080), cb)

when isMainModule:
  startMockMeterDataServer()