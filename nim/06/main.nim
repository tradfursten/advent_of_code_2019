import os, strutils, tables

proc readOrbits(filename: string): Table[string, seq[string]] =
  var orbits = initTable[string, seq[string]]()
  var inputLines = readFile(filename).strip(trailing = true).splitLines()
  for l in inputLines:
    var pair = l.split(")")
    if not orbits.hasKey(pair[0]): orbits[pair[0]] = newSeq[string]()
    orbits[pair[0]].add(pair[1])
  result = orbits

proc countOrbitsAndFindSanta(orbits: Table[string, seq[string]]): tuple[part1: int, part2: int] = 
  var 
    paths = initTable[string, seq[string]]()
    queue = newSeq[string]()
    current: string
    count = 0

  queue.add("COM")
  paths["COM"] = @[]
  while queue.len > 0:
    current = queue.pop
    let currentPath = paths[current]
    count.inc currentPath.len
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
  result = (part1: count, part2: you[i..you.high].len + san[i..san.high].len)

var orbits = readOrbits(paramStr(1))
var result = orbits.countOrbitsAndFindSanta
echo "Part 1: ", result.part1, " Part 2: ", result.part2