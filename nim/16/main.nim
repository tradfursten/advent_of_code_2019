import os, strutils, sequtils, strformat, math, tables
import algorithm

var base = @[0, 1, 0, -1]
var signal = readFile(paramStr(1)).mapIt(parseInt($it))

var
  nr_phases = paramStr(2).parseInt
  phases = newSeq[seq[int]]()

var pattern_tables = newSeq[seq[int]]()

phases.add signal

proc getPattern(i, reps: int): int =
  #echo i, " ", reps
  base[floor(((i + 1) mod (4 * reps)) / reps).int]

proc pattern(reps = 1): seq[int] =
  for i in 0..signal.high:
    result.add base[floor(((i + 1) mod (4 * reps)) / reps).int]

proc compute(signal: seq[int], p: seq[int]): int =
  var sum = 0
  for a in zip(signal, p):
    sum += a.a * a.b
  result = abs(sum) mod 10

proc compute(signal: seq[int], rep: int, last: int): int =
  var sum = 0
  if rep > signal.high div 2:
    sum = signal[rep] + last
  else:
    for i in countdown(signal.high, rep):
      sum += signal[i] * getPattern(i, rep + 1)




for i, c in signal:
  #echo "create pattern: ", c, " ", i
  pattern_tables.add pattern(i + 1)
  #echo pattern_tables[pattern_tables.high]

proc phase(signal:seq[int]): seq[int] =
  for i in countdown(signal.high,0):
    if result.len > 0:
      result.add compute(signal, i, result[result.high])
    else:
      result.add compute(signal, i, 0)
  result.reverse
  result.mapIt(abs(it) mod 10)


proc phase(signal:seq[int], pattern_tables: seq[seq[int]]): seq[int] =
  for i in 0..
  for i, val in signal:
    result.add compute(signal, pattern_tables[i])

for i in 0..<nr_phases:
  #echo phases[phases.high].join("").substr(0, 7)
  phases.add phase(phases[phases.high], pattern_tables)

echo "Part 1: ", phases[phases.high].join("").substr(0, 7)

signal = readFile(paramStr(1)).repeat(10000).mapIt(parseInt($it)) 

phases = newSeq[seq[int]]()

  

phases.add signal
for i in 0..<nr_phases:
  echo "Lap ", i, ": ", phases[phases.high].join("").substr(0, 7)
  phases.add phase(phases[phases.high])

var offset = phases[phases.high][0..9]
echo "Part 2: ", offset