import "../intcode"
import "../goost"
import os, strutils, tables

var code = readFile(paramStr(1))



var effected = 0
for y in 0..49:
  for x in 0..49:
    var program = code.createProgram()
    program.input.add y
    program.input.add x
    program.runProgram
    case program.output.pop:
      of 0: stdout.write "."
      of 1: 
        stdout.write "#"
        effected.inc
      else: discard
  stdout.write "\n"

stdout.flushFile

echo "Part 1: ", effected

proc checkPoint(x, y: int): int = 
  var program = code.createProgram()
  program.input.add y
  program.input.add x
  program.runProgram
  result = program.output.pop

var
  firstOnLast = 0
  newRow = true

let santa_size = 99

for y in 10..10000:
  newRow = true
  for x in (firstOnLast)..10000:
    if checkPoint(x, y) == 1 and newRow:
      newRow = false
      firstOnLast = x
    elif newRow: continue

    if checkPoint(x + santa_size, y) == 0: break

    if checkPoint(x, y + santa_size) == 1:
      echo checkPoint(x, y), " ", checkPoint(x + santa_size, y)
      echo checkPoint(x, y + santa_size), " ", checkPoint(x + santa_size, y + santa_size)
      echo "Found point: ", x, ", ", y
      echo "Part 2: ", x * 10000 + y
      quit()

# wrong to low 7261018
# to low 7341029