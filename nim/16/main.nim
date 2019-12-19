import os, strutils, sequtils, strformat, math, tables
import algorithm

var base = @[0, 1, 0, -1]
var signal = readFile(paramStr(1)).mapIt(parseInt($it))

var
  nr_phases = paramStr(2).parseInt
  phases = newSeq[seq[int]]()

phases.add signal

proc getPattern(i, reps: int): int =
  result = base[floor(((i + 1) mod (4 * reps)) / reps).int]

proc compute(signal: seq[int], rep: int, last: int, lazy: bool): int =
  var sum = 0
  if rep > signal.high div 2 or lazy:
    sum = signal[rep] + last
  else:
    var i = rep
    while i < signal.len:
      let pattern = getPattern(i, rep + 1)
      if pattern == 1 or pattern == -1:
        for j in 0..rep:
          case pattern:
            of 1: sum += signal[i]
            of -1: sum -= signal[i]
            else: discard
          i.inc
          if i >= signal.len: break
      else: i.inc(rep+1)
  result = sum mod 10

proc phase(signal:seq[int], lazy = false): seq[int] =
  result = newSeq[int](signal.len)
  var last = 0
  for i in countdown(signal.high,0):
    last = compute(signal, i, last, lazy)
    result[i] =  last

for i in 0..<nr_phases:
  #echo phases[phases.high].join("").substr(0, 7)
  phases.add phase(phases[phases.high])

echo "Part 1: ", phases[phases.high].join("").substr(0, 7)

signal = readFile(paramStr(1)).repeat(10000).mapIt(parseInt($it))


phases = newSeq[seq[int]]()

phases.add signal
var offset = phases[phases.high][0..6].join().parseInt
echo "Offset: ", offset


for i in 0..<nr_phases:
  #echo "Lap ", i, ": ", phases[phases.high].join("").substr(0, 7)
  phases.add phase(phases[phases.high], true)

var value = phases[phases.high][offset..(offset+7)]
echo "Part 2: ", offset, " ", value.join("")