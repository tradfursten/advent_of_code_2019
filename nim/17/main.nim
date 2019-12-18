import "../intcode"
import os, strutils

var program = readFile(paramStr(1)).createProgram()

while program.status != HALT:
  program.runProgram

for i in program.output:
  if i < 255: stdout.write char(i)
  else: echo i

stdout.flushFile

program = readFile(paramStr(1)).createProgram()

proc reversed(s: string): string =
  result = newString(s.len)
  for i,c in s:
    result[s.high - i] = c

proc addInput(p:var Program, i: string)=
  program.input.add 10
  for c in i.reversed():
    program.input.add c.int

program.program[0] = 2


while program.status != HALT:
  program.runProgram
  var o = ""
  while program.output.len > 0:
    let i = program.output.pop
    if i < 255: o &= char(i)
    else: o &= $i
  for l in o.reversed().splitLines():
    echo l
    if l.startsWith("Main:"):
      program.addInput("n")
      program.addInput("L,6,R,6,L,12")
      program.addInput("R,8,L,12,L,12,R,8")
      program.addInput("L,12,R,8,L,6,R,8,L,6")
      program.addInput("A,B,A,A,B,C,B,C,C,B")


echo program.program[438]