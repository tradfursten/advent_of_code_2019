import os, strutils, tables

proc readOrbits(filename: string): Table[string, seq[string]] =
  var orbits = initTable[string, seq[string]]()
  var inputLines = readFile(filename).strip(trailing = true).splitLines()
  for l in inputLines:
    var pair = l.split(")")
    if not orbits.hasKey(pair[0]): orbits[pair[0]] = newSeq[string]()
    orbits[pair[0]].add(pair[1])
  
  result = orbits

proc countOrbits(orbits: Table[string, seq[string]]): int = 
  var 
    current: string
    count = 0
    queue: seq[string]
    cach = initTable[string, int]()
  cach["COM"] = 0
  queue = newSeq[string]()
  queue.add("COM")
  while queue.len > 0:
    current = queue.pop
    let currentCount = cach[current]
    if orbits.hasKey(current):
      for n in orbits[current]:
        queue.add(n)
        cach[n] = currentCount + 1
    count.inc(currentCount)
  result = count

proc findSanta(orbits: Table[string, seq[string]]): int =
  var 
    paths = initTable[string, seq[string]]()
    queue = newSeq[string]()
    current: string

  queue.add("COM")
  paths["COM"] = @[]
  while queue.len > 0:
    current = queue.pop
    let currentPath = paths[current]
    if orbits.hasKey(current):
      for n in orbits[current]:
        queue.add(n)
        var tmp: seq[string]
        deepCopy(tmp, currentPath)
        tmp.add(current)
        paths[n] = tmp
  
  var
    i = 0
    found = false
    you = paths["YOU"]
    san = paths["SAN"]
  while not found:
    if you[i] == san[i]:
      i.inc
    else: found = true

  result = you[i..you.high].len + san[i..san.high].len


var orbits = readOrbits(paramStr(1))

echo "Part1: ", orbits.countOrbits

echo "Part2: ", orbits.findSanta