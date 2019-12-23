import os, strutils, algorithm, deques
import "../intcode"



proc addInput(p:var Program, i: string)=
  for c in i:
    p.input.addLast c.int

var springBot1 = """
NOT C T
NOT A J
OR T J
AND D J
WALK

"""
#!C OR !A && D

#while program.status != HALT:
var program = readFile(paramStr(1)).createProgram
program.addInput springBot1
program.runProgram
var o = ""
while program.output.len > 0:
  let i = program.output.popFirst
  if i < 255: o &= char(i)
  else: o &= $i
for l in o.splitLines():
  echo l

echo "Part 2"
# !A OR !B OR !C AND D AND (H OR E)
var springBot2 = """
NOT A J
NOT B T
OR T J
NOT C T
OR T J
AND D J
NOT E T
NOT T T
OR H T
AND T J
RUN

"""
program = readFile(paramStr(1)).createProgram
program.addInput springBot2
program.runProgram
o = ""
while program.output.len > 0:
  let i = program.output.popFirst
  if i < 255: o &= char(i)
  else: o &= $i
for l in o.splitLines():
  echo l