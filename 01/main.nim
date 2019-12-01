import strutils, os, math, sequtils

proc requiredFuel(m: int): int =
  var fuel = m
  while fuel >= 0:
    #echo fuel, ' ', result
    fuel = int(floor(float(fuel) / 3)) - 2
    if fuel > 0:
      result.inc(fuel)



echo readFile(paramStr(1))
  .splitLines()
  .map(parseInt)
  .map(requiredFuel)
  .foldl(a + b)