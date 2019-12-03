import strutils, sequtils, os, tables, strformat

type
  Vec2 = tuple
    x: int
    y: int
  Step = tuple
    steps: int
    direction: Vec2
  Visit = tuple
    w0: int
    w1: int

template `+=`(a: var Vec2, b: Vec2)=
  a.x = a.x + b.x
  a.y = a.y + b.y

proc distance(a, b: Vec2): int = abs(a.x - b.x) + abs(a.y - b.y)

var visitedLocations = initTable[Vec2, Visit]()

proc getStep(step: string): Step =
  case step[0]:
    of 'R': result.direction = (x: 1, y: 0)
    of 'U': result.direction = (x: 0, y: 1)
    of 'D': result.direction = (x: 0, y: -1)
    of 'L': result.direction = (x: -1, y: 0)
    else: result.direction = (x: 0, y: 0)
  result.steps = parseInt(step[1..<step.len])


proc parseInput(input: string) =
  var
    wire0 = input.splitLines[0]
    wire1 = input.splitLines[1]
    location = (x: 0, y: 0)
    step: Step
    n = 1

  echo "Wire 1"
  for w0 in wire0.split(","):
    step = getStep(w0)
    echo step, " ", location
    for i in 1..step.steps:
      #echo location
      location += step.direction
      if not visitedLocations.hasKey(location):
        visitedLocations[location] = (w0: n, w1: 0)
      n.inc
  echo "Wire 2"
  n = 1
  location = (x: 0, y: 0)
  for w1 in wire1.split(","):
    step = getStep(w1)
    echo step, " ", location
    for i in 1..step.steps:
      location += step.direction
      if not visitedLocations.hasKey(location):
        visitedLocations[location] = (w0: 0, w1: n)
      else:
        echo "Allready visited ", location, " ", visitedLocations[location]
        var w1Steps = visitedLocations[location].w1
        if w1Steps == 0: w1Steps = n
        visitedLocations[location] = (w0: visitedLocations[location].w0, w1: w1Steps)
        echo w1Steps, ' ', visitedLocations[location]
      n.inc



var input = readFile(paramStr(1))

input.parseInput()



var 
  lowest = 10000000000
  origin = (x: 0, y: 0)
  shortest = 1000000000
for k, v in visitedLocations.pairs:
  if v.w0 != 0 and v.w1 != 0:
    echo fmt"Found a cross: {k} {v}"
    lowest = min(origin.distance(k), lowest)
    shortest = min(v.w0 + v.w1, shortest)
echo "Part1: ",lowest
echo "Part2: ",shortest