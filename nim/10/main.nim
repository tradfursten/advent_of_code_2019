import "../goost"
import os, strutils, tables, algorithm, math, strformat

proc ang*(a: Vec2): float = 
  result = arctan2(float(a.y), float(a.x)) + PI/2
  if result < 0: result += 2 * PI

let unit = (x: 0.0, y: -1.0)
var astroids = newSeq[Vec2]()
var 
  x = 0
  y = 0

for l in readFile(paramStr(1)).splitLines:
  x = 0
  for c in l:
    if c == '#':
      let a = (x: x, y: y)
      astroids.add(a)
    x.inc
  y.inc


var 
  best: Vec2
  seen = 0

for a in astroids:
  var in_view = newSeq[float]()
  for b in astroids:
    if a != b:
      let ang = (a - b).ang
      if not in_view.contains(ang):
        in_view.add(ang)
  
  if in_view.len > seen:
    seen = in_view.len
    best = a

echo "Part 1: ", seen, " found: ", best

var
  target_map = initTable[float, Vec2]()
  targets = newSeq[float]()

for b in astroids:
  if b != best:
    let direction = b - best
    if not target_map.hasKey(direction.ang):
      targets.add(direction.ang)
      target_map[direction.ang] = b
    else:
      #echo "target exists check if closer"
      if (target_map[direction.ang] - best).len >  (b - best).len:
        #echo "It is closer, change from ", target_map[unit_vector] * 2, " to ", b * 2, " unit ", unit_vector
        target_map[direction.ang] = b

var kill = 0
targets.sort()

#kill = 1
#for t in targets:
#  echo kill, ": ", target_map[t], ' ', t#, ' ', t.sortTargets(unit)
#  kill.inc
  

if paramCount() >= 2:
  let answer = target_map[targets[paramStr(2).parseInt - 1]]
  echo "Part 2: ", answer.x * 100 + answer.y

