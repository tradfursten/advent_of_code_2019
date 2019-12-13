import "../goost"
import os, re, strutils, sequtils, strformat


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
        let dif_p = (moons[m1].p - moons[m2].p).sgn
        moons[m1].v -= dif_p
        moons[m2].v += dif_p
  for m in 0..moons.high:
    moons[m].p += moons[m].v
  
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






