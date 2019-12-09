import strutils, strformat, re, strutils, sequtils, strformat

type
  Status* = enum RUN, PAUS, HALT, CRASH
  Program* = ref object
    program*: seq[int]
    p: int
    input*: seq[int]
    output: seq[int]
    status: Status
    relative_base: int

template A():int = 
  var access = case a.program[a.p] div 100 mod 10:
    of 1: a.p + 1
    of 2: a.relative_base + a.program[a.p + 1]
    else: a.program[a.p + 1]
  if access >= a.program.len:
    for i in a.program.len..access: a.program.add(0)
  a.program[access]
template B():int = 
  var access = case a.program[a.p] div 1000 mod 10:
    of 1: a.p + 2
    of 2: a.relative_base + a.program[a.p + 2]
    else: a.program[a.p + 2]
  if access >= a.program.len:
    for i in a.program.len..access: a.program.add(0)
  a.program[access]
template C():int = 
  var access = case a.program[a.p] div 10000 mod 10:
    of 1: a.p + 3
    of 2: a.relative_base + a.program[a.p + 3]
    else: a.program[a.p + 3]
  if access >= a.program.len:
    for i in a.program.len..access: a.program.add(0)
  a.program[access]

proc exec(a:var Program) =
  var op = a.program[a.p] mod 100
  case op:
    of 1:
      C = A + B
      a.p.inc(4)
    of 2: 
      C = A * B
      a.p.inc(4)
    of 3:
      if a.input.len == 0:
        a.status = PAUS
        return
      A = a.input.pop
      a.p.inc(2)
    of 4:
      a.output.add(A)
      echo A
      a.p.inc(2)
    of 5: a.p = if A != 0: B else: a.p + 3
    of 6: a.p = if A == 0: B else: a.p + 3
    of 7: 
      C = (A < B).int
      a.p.inc(4)
    of 8:
      C = (A == B).int
      a.p.inc(4)
    of 9:
      a.relative_base = a.relative_base + A
      a.p = a.p + 2
    of 99: 
      a.status = HALT
    else: 
      a.status = CRASH
      echo fmt"Should not occure op {op} pos {a.p}"
    
proc runProgram*(a:var Program) =
  if a.status == PAUS and a.input.len > 0: a.status = RUN
  while a.status == RUN:
    a.exec()

proc createProgram*(code: string): Program =
  result = Program()
  result.input = newSeq[int]()
  result.output = newSeq[int]()
  result.program = code.findAll(re"-?\d+").map(parseInt)
  result.p = 0
  result.relative_base = 0
