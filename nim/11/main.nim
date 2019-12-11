import "../intcode"
import "../goost"
import os, tables

type
  Direction = enum UP, RIGHT, DOWN, LEFT
  Robot = tuple
    position: Vec2
    direction: Direction

var track = initTable[Vec2, int]()
var robot: Robot
robot.position = (x: 0, y: 0)
robot.direction = UP

proc turn(r:var Robot, command: int) =
  case command:
    of 1: r.direction = Direction((r.direction.int + 1) mod 4)
    of 0:
      var newDirInt = (r.direction.int - 1)
      if newDirInt < 0: newDirInt = 3
      r.direction = Direction(newDirInt mod 4)
    else: discard

proc walk(r:var Robot) =
  case r.direction:
    of UP: r.position.y += 1
    of RIGHT: r.position.x += 1
    of DOWN: r.position.y -= 1
    of LEFT: r.position.x -= 1

var code = readFile(paramStr(1))

var program = code.createProgram()

echo "Run program"
var i = 0

# Comment to get part 1
track[(x: 0, y: 0)] = 1
while program.status != HALT:
  program.input.add(track.getOrDefault(robot.position, 0))
  program.runProgram()
  #echo i, ": ", program.status, " ", program.output, " ", robot.position, " ", robot.direction
  robot.turn program.output.pop
  track[robot.position] = program.output.pop
  robot.walk
  #echo robot.position, " ", robot.direction
  i.inc

echo "Part 1: ", track.len

var
  u_x = 0
  u_y = 0
  l_x = 0
  l_y = 0

for k, v in track.mpairs:
  if k.x < u_x: u_x = k.x
  if k.y > u_y: u_y = k.y
  if k.x > l_x: l_x = k.x
  if k.y < u_y: l_y = k.y
echo u_x, ",", u_y, " ", l_x, ",", l_y

var
  y = u_y
  x = u_x
while y >= (l_y-1):
  x = u_x
  while x <= (l_x+1):
    case track.getOrDefault((x: x, y: y), 0):
      of 1: stdout.write "#"
      else: stdout.write " "
    x.inc
  y.dec
  stdout.write "\n"
stdout.flushFile