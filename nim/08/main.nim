import os, strutils, strformat


var
  w = paramStr(1).parseInt
  h = paramStr(2).parseInt
  data = readFile(paramStr(3))
  layers: seq[seq[char]]

layers = newSeq[seq[char]]()

var
  line = -1
  z = 0
for p in data:
  if z mod (w * h) == 0:
    layers.add(newSeq[char]())
    line.inc
  layers[line].add p
  z.inc

var
  zeros = 0
  ones = 0
  twos = 0
  checksum = 0
  fewestZeros =100000000
for l in layers:
  ones = 0
  twos = 0
  zeros = 0
  for p in l:
    case p:
      of '0': zeros.inc
      of '1': ones.inc
      of '2': twos.inc
      else: discard

  if fewestZeros > zeros: 
    fewestZeros = zeros
    checksum = ones * twos

echo "Part 1: ", checksum
echo layers
var image = ""
for y in 0..<h:
  echo "y: ", y
  for x in 0..<w:
    echo "x: ", x
    var pixel = ' '
    for l in layers:
      let layer_pixel = l[(w * y) + x]
      echo fmt"{x} {y} {layer_pixel}"
      case layer_pixel:
        of '0': 
          pixel = ' '
          break
        of '1':
          pixel = '1'
          break
        of '2': discard
        else: discard
    echo "Pixel: ", pixel
    image = image & pixel
  image = image & "\n"

echo image