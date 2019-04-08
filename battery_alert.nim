import os
import strutils

const warning_level = 0.05

# deal with ctrl-c
proc handler() {.noconv.} =
  writeFile("/sys/class/leds/tpacpi::power/brightness", "1")
  quit 0

setControlCHook(handler)


while true:
  # need to check if we're plugged in or not. Short Circuit everything else if we are.
  let pluggedin = strutils.parseInt(strutils.strip(readFile("/sys/class/power_supply/AC/online")))
  if pluggedin == 0:
    sleep(2000)
    continue

  # get the battery capacity. You may need to change these depending on your hardware.
  let bat0_capacity = strutils.parseInt(strutils.strip(readFile("/sys/class/power_supply/BAT0/energy_full")))
  let bat0_now      = strutils.parseInt(strutils.strip(readFile("/sys/class/power_supply/BAT0/energy_now")))
  let bat1_capacity = strutils.parseInt(strutils.strip(readFile("/sys/class/power_supply/BAT1/energy_full")))
  let bat1_now      = strutils.parseInt(strutils.strip(readFile("/sys/class/power_supply/BAT1/energy_now")))

  # add the batteries together.
  let total_capacity = bat0_capacity + bat1_capacity
  let total_now = bat0_now + bat1_now

  # make it a percent
  let capacity = total_now / total_capacity

  if capacity < warning_level:
    # do this for 2 seconds
    for i in 1..10:
      writeFile("/sys/class/leds/tpacpi::power/brightness", "0")
      os.sleep(200)
      writeFile("/sys/class/leds/tpacpi::power/brightness", "1")
      os.sleep(200)
  else:
    # check everything again in 10s.
    os.sleep(10000)
