import "../intcode"
import "../goost"
import os, tables, strformat, sequtils
import osproc

type
  Tile = enum Empty, Wall, Block, HorizontalPaddle, Ball
  Map = tuple
    map: Table[Vec2, Tile]
    score: int



var program = readFile(paramStr(1)).createProgram()


proc draw(map: Map) =
  for y in 0..23:
    for x in 0..41:
      case map.map.getOrDefault((x: x, y: y), Empty):
        of Wall: stdout.write "|"
        of Block: stdout.write "#"
        of HorizontalPaddle: stdout.write "-"
        of Ball: stdout.write "o"
        else: stdout.write " "
    stdout.write "\n"
stdout.flushFile

proc createMap(program: Program, map:var Map)=
  map.map = initTable[Vec2, Tile]()
  var
    i = 0
  while i < program.output.len:
    if program.output[i] == -1:
      map.score = program.output[i+2]
    else:
      map.map[(x: program.output[i], y: program.output[i+1])] = Tile(program.output[i+2])
    i.inc(3)

proc getPosition(map: Map, tile: Tile): Vec2 =
  toSeq(map.map.pairs).filterIt(it[1] == tile)[0][0]

var
  startingBlocks = 0
  blocks = 0
  map: Map
map.score = 0

var steps = 0
program.program[0] = 2
while program.status != HALT:
  blocks = 0
  #discard execCmd "clear"
  program.runProgram()
  program.createMap(map)
  for k, v in map.map.pairs:
    if v == Block: blocks.inc
  map.draw

  let ball = map.getPosition(Ball)
  let paddle = map.getPosition(HorizontalPaddle)
  if ball.x < paddle.x: program.input.add -1
  elif ball.x > paddle.x: program.input.add 1
  else: program.input.add 0

  echo fmt"Step: {steps} Score: {map.score}"
  if steps == 0:
    startingBlocks = blocks
  steps.inc


echo "Part 1: ", startingBlocks