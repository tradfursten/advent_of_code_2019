import os, strutils, sequtils, tables, sets, heapqueue
import "../goost"

type
  TileType = enum Open, Wall, Portal, None
  Tile = tuple
    t: TileType
    portalName: string
    portalTarget: Vec2

var
  input = readFile(paramStr(1)).splitLines()
  map = initTable[Vec2, Tile]()
  portals = initTable[string, seq[Vec2]]()
  origo = (x: 0, y: 0)

proc addPortal(p: var Table[string, seq[Vec2]], k: string, o: Vec2) =
  if not p.hasKey(k):
    p[k] = newSeq[Vec2]()
  p[k].add o

proc getOrEmpty(m: Table[Vec2, Tile], p: Vec2): Tile =
  result = m.getOrDefault(p, (t: None, portalName: "", portalTarget: origo))

proc getOrEmpty(m: Table[Vec2, Tile], x: int, y: int): Tile =
    result = m.getOrEmpty((x: x, y: y))

proc find(m: Table[Vec2, Tile], p: Table[string, seq[Vec2]], s: string, portalNr = 0): Vec2 =
  let aas = p[s]
  echo s, ' ', p[s], ' ', portalNr
  if aas[0 + portalNr].x == aas[1 + portalNr].x: 
    if m.getOrEmpty(aas[1 + portalNr] + (x: 0, y: 1)).t == Open:
      result = aas[1 + portalNr] + (x: 0, y: 1)
    else: 
      result = aas[0 + portalNr] + (x: 0, y: -1)
  elif aas[0 + portalNr].y == aas[1 + portalNr].y: 
    if m.getOrEmpty(aas[1 + portalNr] + (x: 1, y: 0)).t == Open:
      result = aas[1 + portalNr] + (x: 1, y: 0)
    else: 
      result = aas[0 + portalNr] + (x: -1, y: 0)

iterator neighbours(m: Table[Vec2, Tile], pos: Vec2, portals: Table[string, seq[Vec2]]): Vec2 =
  let x_min = m.getOrEmpty(pos - (x: -1, y: 0))
  if x_min.t == Open:
    yield(pos - (x: -1, y: 0))
  if x_min.t == Portal:
    yield(x_min.portalTarget)
  let x_plus = m.getOrEmpty(pos - (x: 1, y: 0))
  if x_plus.t == Open:
    yield(pos - (x: 1, y: 0))
  if x_plus.t == Portal:
    yield(x_plus.portalTarget)
  let y_min = m.getOrEmpty(pos - (x: 0, y: -1))
  if y_min.t == Open:
    yield(pos - (x: 0, y: -1))
  if y_min.t == Portal:
    yield(y_min.portalTarget)
  let y_plus = m.getOrEmpty(pos - (x: 0, y: 1))
  if y_plus.t == Open:
    yield(pos - (x: 0, y: 1))
  if y_plus.t == Portal:
    yield(y_plus.portalTarget)

#    Create map

var
  x = 0
  y = 0
  maxY = 0
  maxX = 0

for j in 0..input.high:
  let l = input[j]
  maxX = max(maxX, x)
  x = 0
  for i in 0..l.high:
    let c = l[i]
    case c:
      of '#': map[(x: x, y: y)] = (t: Wall, portalName: "", portalTarget: origo)
      of '.': map[(x: x, y: y)] = (t: Open, portalName: "", portalTarget: origo)
      else:
        if c.int in 65..90:
          if i > 0 and l[i-1].int in 65..90:
            map[(x:x, y:y)] = (t: Portal, portalName: l[i-1..i], portalTarget: origo)
            portals.addPortal(l[i-1..i], (x:x, y:y))
          elif i < l.high and l[i+1].int in 65..90:
            map[(x:x, y:y)] = (t: Portal, portalName: l[i..i+1], portalTarget: origo) 
            portals.addPortal(l[i..i+1], (x:x, y:y))
          elif j > 0 and input[j-1][i].int in 65..90:
            map[(x:x, y:y)] = (t: Portal, portalName: input[j-1][i] & l[i], portalTarget: origo) 
            portals.addPortal(input[j-1][i] & l[i], (x:x, y:y))
          elif j < input.high and input[j+1][i].int in 65..90:
            map[(x:x, y:y)] = (t: Portal, portalName: l[i] & input[j+1][i], portalTarget: origo) 
            portals.addPortal(l[i] & input[j+1][i], (x:x, y:y))
    x.inc
  y.inc

# Resolve portals

for t in portals.keys:
  if portals[t].len == 4:
    for i in 0..portals[t].high:
      let a = portals[t][i]
      if map[a].portalTarget != origo:
        for j in (i+1)..portals[t].high:
          if 




maxY = y
var output = newSeq[string]()
for i in 0..<maxY:
  var o = newString(maxX)
  for j in 0..<maxX:
    let pos = map.getOrEmpty(j, i)
    case pos.t:
      of Wall: o[j] = '#'
      of Open: o[j] = '.'
      of Portal:
        if map.getOrEmpty(j + 1, i).t == Portal:
          o[j] = pos.portalName[0]
        elif map.getOrEmpty(j, i + 1).t == Portal:
          o[j] = pos.portalName[0]
        else:
          o[j] = pos.portalName[1]
      else: o[j] = ' '
  output.add o


echo output.join("\n")

proc astar(map: Table[Vec2, Tile], portals: Table[string, seq[Vec2]]): seq[Vec2] =
  var start = map.find(portals, "AA")
  var goal = map.find(portals, "ZZ")
  echo "Initiate pathfinding..."
  echo "Starting position: ", start
  echo "Finding path to: ", goal
  var openSet = initHeapQueue[Vec2]()
  var closedSet = initHashSet[Vec2]()
  var meta = initTable[Vec2, Vec2]()
  var path = newSeq[Vec2]()
  openSet.push(start)
  while openSet.len > 0:
    var current = openSet.pop
    echo current
    if current == goal:
      path.add current
      while meta.hasKey(current):
        current = meta[current]
        path = @[current].concat(path)
      break
    
    for n in map.neighbours(current, portals):
      if closedSet.contains n:
        continue
      var contains = false
      for i in 0..<openSet.len:
        if openSet[i] == current:
          contains = true
          break
      if not contains:
        meta[n] = current
        openSet.push(n)

    closedSet.incl current
  result = path

proc djikstras(map: Table[Vec2, Tile], portals: Table[string, seq[Vec2]]): seq[Vec2] =
  result = @[]

var a_Star_path = astar(map, portals)

echo "Part 2: ", a_Star_path.len - 1
