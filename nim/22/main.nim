import os, strutils, nre, sequtils, algorithm, currying, math
import "longint"

type
  f_proc = (proc(n: int, stack: seq[int]): seq[int])
  DealStep = ref object
    f: f_proc
    n: int

proc dealNewStack(n: int, stack: seq[int]): seq[int] {.curried.} =
  #echo "deal into new stack"
  result = stack.reversed

proc cutNCards(n: int, stack: seq[int]): seq[int] {.curried.} = 
  #echo "cut ", n
  if n > 0:
    result = stack[n..stack.high].concat(stack[0..<n])
  else:
    result = stack[stack.high + n + 1..stack.high].concat(stack[0..<stack.high + n + 1])

proc dealWithIncrementN(n: int, stack: seq[int]): seq[int] {.curried.} =
  #echo "deal with increment ", n
  result = newSeq[int](stack.len)
  var
    i = 0
    sp = 0
  while sp < stack.len:
    result[i] = stack[sp]
    sp.inc
    i.inc n
    if i > stack.high:
      i = i mod stack.len

var stackSize = paramStr(1).parseInt


var stack = newSeq[int](stackSize)
for i in 0..<stackSize:
  stack[i] = i

var 
  cards = 119315717514047
  times = 101741582076661


echo "Start shuffle"
var dealOrders = newSeq[DealStep]()
var dealNewStackPtr: f_proc = dealNewStack
var cutPtr: f_proc = cutNCards
var dealWithIncrementNPtr: f_proc = dealWithIncrementN
var offset_diff: int128 = 0
var increment_mul: int128 = 1
for l in readFile(paramStr(2)).splitLines:
  let newStack = l.match(re"deal into new stack")
  let cutRe = l.match(re"cut (-?\d+)")
  let dealNRe = l.match(re"deal with increment (\d+)")
  if newStack.isSome:
    let step = DealStep()
    step.f = dealNewStackPtr
    step.n = 0
    increment_mul = increment_mul * -1
    increment_mul = increment_mul mod cards
    offset_diff = offset_diff + increment_mul
    offset_diff = offset_diff mod cards
  if cutRe.isSome:
    let step = DealStep()
    step.f = cutPtr
    step.n = cutRe.get.captures[0].parseInt
    dealOrders.add(step)
    offset_diff = offset_diff + (step.n * increment_mul)
    offset_diff = offset_diff mod cards
  if dealNRe.isSome:
    let step = DealStep()
    step.f = dealWithIncrementNPtr
    step.n = dealNRe.get.captures[0].parseInt
    dealOrders.add(step)
    increment_mul = increment_mul * (pow(step.n.float, cards.float - 2).int mod cards)
    increment_mul = increment_mul mod cards




# part 1
for i in 0..dealOrders.high:
  #echo i, " ", stack
  let order = dealOrders[i]
  stack = order.f(order.n, stack)
#echo stack

echo "Part 1: ", stack.find(2019)

proc power(x, y: int128): int128 =
    var temp: int128 
    if y == 0:
      return 1
    temp = power(x, y div 2.toInt128)
    if y mod 2 == 0:
        return temp*temp; 
    else:
        if y > 0:
            return x*temp*temp
        else:
            return (temp*temp) div x

var increment: int128 = power(increment_mul, times)
var temp: int128 = power((1 - increment_mul), cards - 2)
increment = increment mod cards



var offset = offset_diff * (1 - increment) * (temp mod cards)
offset = offset mod cards

echo "Part 2: ", (offset + 2020 * increment) mod cards




