import "../goost"
import os, re, strutils, sequtils, strformat, math


type 
  Moon = tuple
    p: Vec3
    v: Vec3


var moons = newSeq[Moon]()
var input = readFile(paramStr(1))
echo "Loading moons"

for l in input.splitLines: 
  let ints = l.findAll(re"-?\d+").map(parseInt)
  if ints.len == 3:
    moons.add((p:(x: ints[0], y: ints[1], z: ints[2]), v: (x: 0, y: 0, z: 0)))

var steps = paramStr(2).parseInt

for step in 1..steps:
  echo "Step: ", step
  
  for m1 in 0..moons.high:
    for m2 in (m1+1)..moons.high:
        let moon1 = moons[m1].p
        let moon2 = moons[m2].p
        if moon1.x < moon2.x:
          moons[m1].v.x.inc
          moons[m2].v.x.dec
        elif moon1.x > moon2.x:
          moons[m1].v.x.dec
          moons[m2].v.x.inc

        if moon1.y < moon2.y:
          moons[m1].v.y.inc
          moons[m2].v.y.dec
        elif moon1.y > moon2.y:
          moons[m1].v.y.dec
          moons[m2].v.y.inc

        if moon1.z < moon2.z:
          moons[m1].v.z.inc
          moons[m2].v.z.dec
        elif moon1.z > moon2.z:
          moons[m1].v.z.dec
          moons[m2].v.z.inc


  for m in 0..moons.high:
    let m1 = moons[m]
    moons[m].p = (x: m1.p.x + m1.v.x, y: m1.p.y + m1.v.y, z: m1.p.z + m1.v.z)
  
  for m in moons:
    echo "pos: ", m.p, ",\tvel: ", m.v

var energy = 0
for m in moons:
    let pot = abs(m.p.x) + abs(m.p.y) + abs(m.p.z)
    let kin = abs(m.v.x) + abs(m.v.y) + abs(m.v.z)

    echo fmt"pot: {pot} kin: {kin} total: {pot*kin}"
    energy += pot * kin
echo fmt"Part 1: {energy}"


# 2094 to low
# 1992






