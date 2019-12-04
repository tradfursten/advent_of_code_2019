import os, strutils, sets

var lowerBoundStr = paramStr(1)
var lowerBound = lowerBoundStr.parseInt
var upperBoundStr = paramStr(2)
var upperBound = upperBoundStr.parseInt


proc isValid(i: int): bool =
  let p = intToStr(i)
  var double = false
  for i in 0..4:
    if p[i] > p[i+1]: return false
    if p[i] == p[i+1]: double = true
  result = double

proc isValid2(i: int): bool =
  let p = intToStr(i)
  var 
    double = false
    last = p[0]
    lastEquals = 0

  for i in 1..5:
    if last == p[i]: lastEquals.inc
    else:
      if lastEquals == 1:
        double = true
      lastEquals = 0
    if last > p[i]: return false
    last = p[i]
  result = double or lastEquals == 1


proc countValid(): int =
  result = 0
  var passwords = initHashSet[int]()
  for i in lowerBound..upperBound:
    if i.isValid(): passwords.incl(i)
  result = passwords.len


proc countValid2(): int =
  result = 0
  var passwords = initHashSet[int]()
  for i in lowerBound..upperBound:
    if i.isValid2(): passwords.incl(i)
  result = passwords.len

echo "Part1: ", countValid()
echo "Part2: ", countValid2()