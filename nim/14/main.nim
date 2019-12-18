import os, strutils, tables, sequtils, strformat, re, math

type
  Material = tuple
    ammount: int
    chemical: string

  Recipie = tuple
    materials: seq[Material]
    result: string
    ammount: int

var reactions = initTable[string, Recipie]()

for line in readFile(paramStr(1)).splitLines:
  var matches = line.findAll(re"\d+ \w+")
  var r = matches[matches.high].split(" ")[1]
  let ammount =  matches[matches.high].split(" ")[0].parseInt()
  var rec : Recipie
  rec.ammount = ammount
  for i in 0..<matches.high:
    rec.materials.add((ammount: matches[i].split(" ")[0].parseInt(), chemical: matches[i].split(" ")[1]))
  reactions[r] = rec

var 
  materials = initTable[string, int]()
  storage = initTable[string, int]()
  queue = newSeq[string]()



var ore = 1000000000000
var
  step = 0
  part1: int

while ore > 0:
  materials["FUEL"] = 1
  queue.add "FUEL"
  while queue.len > 0:
    let current = queue.pop
    if current != "ORE":
      let current_reaction = reactions[current]
      if materials[current] > 0:
        let times = ceil(materials[current] / current_reaction.ammount).int
        #echo current, " ", materials, " ", times, " ", queue
        for cr in current_reaction.materials:
          materials[cr.chemical] = materials.getOrDefault(cr.chemical, 0) + (cr.ammount * times) - storage.getOrDefault(cr.chemical, 0)
          storage[cr.chemical] = 0
          queue.keepItIf(it != cr.chemical)
          queue.add cr.chemical
        materials[current] -= current_reaction.ammount * times
  if step == 0:
    part1 = materials["ORE"]
  ore -= materials["ORE"].int64
  for k in materials.keys:
    if materials[k] < 0:
      storage[k] = -materials[k]
    materials[k] = 0

  step.inc
echo "Part 1: ", part1
echo "Steps: ", step - 1

