import os, strutils, algorithm, deques
import "../intcode"

type
  Package = tuple
    dest: int
    x: int
    y: int

proc createPackage(a, b, c: int): Package = (dest: a, x: b, y: c)

proc sendPackage(p:var Program, package: Package) =
  p.input.addLast(package.x)
  p.input.addLast(package.y)

var code = readFile(paramStr(1))

var programs = newSeq[Program]()
for i in 0..49:
  var program = code.createProgram
  program.input.addLast i
  program.input.addLast -1 
  programs.add program



var 
  done = false
  p: Program
  nat_x: int
  nat_y: int
  part_2: int
  # Set to true to get part 1
  part_1 = false
while not done:
  for i in 0..programs.high:
    p = programs[i]
    p.runProgram(false)
    
    while p.output.len > 0:
      var package = createPackage(p.output.popFirst, p.output.popFirst, p.output.popFirst)
      if package.dest == 255:
        if part_1:
          echo "Part 1: ", package.y
          done = true
        echo i, " Message to NAT", package
        nat_x = package.x
        nat_y = package.y
      else:
        programs[package.dest].sendPackage(package)
  var allIdle = true
  for i in 0..programs.high:
    p = programs[i]
    if p.input.len == 0:
      p.input.addLast -1
    else:
      allIdle = false
  if allIdle:
    if part_2 == nat_y:
      echo "Part 2: ", nat_y
      done = true
    part_2 = nat_y
    programs[0].input.addLast nat_x
    programs[0].input.addLast nat_y



