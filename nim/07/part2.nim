import os, strformat, algorithm
import "../intcode"

proc part2()=
  var original = readFile(paramStr(1))
  var
    maxThurster = 0
    run = true
    i = @[5,6,7,8,9]
    cpus = newSeq[Program]()

  while run:
    cpus.setLen 0
    for k in 0..4:
      cpus.add(createProgram(original))
      cpus[k].input.add(i[k])
    cpus[0].input.insert(0, 0)
    
    echo fmt"Permutation: {i}"
    while cpus[cpus.high].status != HALT:
      for r in 0..<cpus.len:
        while cpus[r].output.len > 0:
          cpus[(r + 1) mod cpus.len].input.add(cpus[r].output.pop)
        cpus[r].runProgram
    
    maxThurster = max(maxThurster & cpus[cpus.high].output)
    run = i.nextPermutation()

  echo "Part 2: ", maxThurster

part2()