import strutils, os, re, sequtils, strformat

var program = readFile(paramStr(1)).findAll(re"-?\d+").map(parseInt)

var 
  input = paramStr(2).parseInt
  output: int

template A():int = program[program[p+1]]
template B():int = program[program[p+2]]
template C():int = program[program[p+3]]
template p_A(i: int):int = 
  if i == 0: A
  else: program[p + 1]
template p_B(i: int):int = 
  if i == 0: B
  else: program[p + 2]
template p_C(i: int):int = program[p + 3]

proc exec(p:int): int =
  var
    op = program[p] mod 100
    a_i = (program[p] div 100) mod 10
    b_i = (program[p] div 1000) mod 10
    c_i = (program[p] div 10000) mod 10

  case op:
    of 1: 
      C = p_A(a_i) + p_B(b_i)
      result = p + 4
    of 2: 
      C = p_A(a_i) * p_B(b_i)
      result = p + 4
    of 3:
      A = input
      result = p + 2
    of 4:
      output = A 
      result = p + 2
      echo output
    of 5:
      if p_A(a_i) != 0: result = p_B(b_i)
      else: result = p + 3
    of 6:
      if p_A(a_i) == 0: result = p_B(b_i)
      else: result = p + 3
    of 7: 
      C = (p_A(a_i) < p_B(b_i)).int
      result = p + 4
    of 8:
      C = (p_A(a_i) == p_B(b_i)).int
      result = p + 4 
    of 99: result = -1
    else: 
      echo fmt"Should not occure op {op} pos {p}"
      result = -1
    
var run = true
var p = 0
var last_p = 0
var i = 0

echo "Start execute"
while run:
  last_p = p
  p = exec(p)
  run = p > 0 and p < program.len

echo fmt"Last p: {last_p}"

echo fmt"Output: {output}"