import times
import strscans

type EnergyUsage = object
  total*: float
  tariff*: array[1..4, float]

type MeterData* = object
  clientAccount*: string
  deviceAddress*: string
  time*: Time
  # date: DateTime
  errorRegister*: string
  firmwareVersion*: string
  energyUsage*: EnergyUsage
  tariffId*: string

template match(pattern: string, vars: varargs[untyped]): bool =
  var discardString: string
  scanf(input, ("$*"&pattern), discardString, vars)

func parse*(input: string): MeterData =
  result = MeterData()
  discard match("0.0.0($*)", result.clientAccount)
  discard match("0.0.1($*)", result.deviceAddress)
  discard match("0.2.0($*)", result.firmwareVersion)
  discard match("F.8.0*00($f)", result.energyUsage.total)
  discard match("F.8.1*00($f)", result.energyUsage.tariff[1])
  discard match("F.8.2*00($f)", result.energyUsage.tariff[2])
  discard match("F.8.3*00($f)", result.energyUsage.tariff[3])
  discard match("F.8.4*00($f)", result.energyUsage.tariff[4])
  discard match("0.2.2($*)", result.tariffId)


when isMainModule:
  let message = """
    0.0.0(61403025)
    0.0.1(PAF)
    0.9.1(00:45:00)
    0.9.2(19-08-28)
    F.F(00)
    0.2.0(1.25)
    C.5(10002)
    F.8.0*00(000001.32)
    F.8.1*00(000001.29)
    F.8.2*00(000000.07)
    F.8.3*00(000000.14)
    F.8.4*00(000000.28)
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
  let parsedMessage = parse(message)
  assert parsedMessage.clientAccount == "61403025"
  assert parsedMessage.deviceAddress == "PAF"
  assert parsedMessage.firmwareVersion == "1.25"
  assert parsedMessage.energyUsage.total == 1.32
  assert parsedMessage.energyUsage.tariff[1] == 1.29
  assert parsedMessage.energyUsage.tariff[2] == 0.07
  assert parsedMessage.energyUsage.tariff[3] == 0.14
  assert parsedMessage.energyUsage.tariff[4] == 0.28