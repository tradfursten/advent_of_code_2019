import strutils, os, re, sequtils, strformat, algorithm
import "../intcode"

proc part2()=
  var original = readFile(paramStr(1))
  var
    maxThurster = 0
    current = 0
    maxInput: seq[int]
    run = true
    i = @[5,6,7,8,9]
    cpus = newSeq[Program]()

  while run:
    cpus.setLen 0
    cpus.add(createProgram(original))
    cpus[0].input.add(@[0, i[0]])
    cpus.add(createProgram(original))
    cpus[1].input.add(i[1])
    cpus.add(createProgram(original))
    cpus[2].input.add(i[2])
    cpus.add(createProgram(original))
    cpus[3].input.add(i[3])
    cpus.add(createProgram(original))
    cpus[4].input.add(i[4])
    
    echo fmt"Permutation: {i}"
    while cpus[cpus.high].status != HALT:
      for r in 0..<cpus.len:
        #echo fmt"CPU {r} output {cpus[r].output} input {cpus[r].input}"
        while cpus[r].output.len > 0:
          let o = cpus[r].output.pop
          #echo "Move output to input, CPU ", r, " value ", o, " to cpu ", ((r + 1) mod cpus.len)
          cpus[(r + 1) mod cpus.len].input.add(o)
        cpus[r].runProgram
    
    maxThurster = max(maxThurster & cpus[cpus.high].output)
    run = i.nextPermutation()

  echo "Part 2: ", maxThurster

part2()