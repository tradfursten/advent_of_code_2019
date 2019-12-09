import intcode, os, strutils

var program = readFile(paramStr(1))

var p = createProgram(program)

echo "Run program"
if paramCount() >= 2:
  p.input.add(paramStr(2).parseInt)
p.runProgram()
