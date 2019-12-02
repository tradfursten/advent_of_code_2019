import strutils, os, re, sequtils, strformat

proc runProgram(input:var seq[int]):int=
  var
    done = false
    pos = 0

  while not done:
    case input[pos]:
      of 1:
        #echo fmt"ADD {pos}, {input[input[pos + 1]]} + {input[input[pos + 2]]}"
        input[input[pos+3]] = input[input[pos + 1]] + input[input[pos + 2]]
      of 2:
        #echo fmt"MUL {pos}, {input[input[pos + 1]]} * {input[input[pos + 2]]}"
        input[input[pos+3]] = input[input[pos + 1]] * input[input[pos + 2]]
      of 99:
        done = true
      else:
        echo fmt"ERROR: unknown operator {input[pos]} at position {pos}"
    #echo input
    pos.inc(4)

  #echo input
  result = input[0]

proc part2(input:var seq[int]): int =
  var
    program = newSeq[int](input.len)
    output = 0

  for noun in 0..99:
    for verb in 0..99:
      program = input.deepCopy()
      program[1] = noun
      program[2] = verb

      echo program

      output = program.runProgram()
      echo fmt"Run with noun {noun} and verb {verb} output {output}"
      if output == 19690720:
        result = 100 * noun + verb
        break
    
  


  
  


var input = readFile(paramStr(1)).findAll(re"\d+").map(parseInt)

input[1] = 12
input[2] = 2

echo runProgram(input)

input = readFile(paramStr(1)).findAll(re"\d+").map(parseInt)

echo part2(input)



