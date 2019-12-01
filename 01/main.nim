import strutils, os, math, sequtils

proc computeFuel(mass: int): int = 
  result = int(floor(float(mass) / 3)) - 2

proc requiredFuel(m: int): int =
  result = computeFuel(m)
  var fuel = result
  while (fuel = computeFuel(fuel); fuel) > 0: 
    result.inc(fuel)

var input = readFile(paramStr(1))

echo "Part 1: ", input
  .splitLines()
  .map(parseInt)
  .map(computeFuel)
  .foldl(a + b)

echo "Part 2: ", input
  .splitLines()
  .map(parseInt)
  .map(requiredFuel)
  .foldl(a + b)