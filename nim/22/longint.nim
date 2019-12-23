# Longint.nim -- 128 bit integers for Nimrod
#
# Written in 2014 by Reimer Behrends <behrends@gmail.com>
#
# To the extent possible under law, the author(s) have dedicated all
# copyright and related and neighboring rights to this software to the
# public domain worldwide. This software is distributed without any
# warranty.
#
# You should have received a copy of the CC0 Public Domain Dedication
# along with this software in the file COPYING. If not, see
# <http://creativecommons.org/publicdomain/zero/1.0/>.

# ----------------------------------------------------------------------

# This is a non-portable implementation of 128 bit integers for Nimrod,
# relying on the C compiler to support an __int128 integer type. 

# ----------------------------------------------------------------------

{.emit: """
__int128 toInt128(long x) { return (__int128) x; }
__int128 toInt128u(unsigned long x) { return (__int128) x; }
NI toNimInt(__int128 x) { return (NI) x; }
__int128 addInt128(__int128 x, __int128 y) { return x + y; }
__int128 subInt128(__int128 x, __int128 y) { return x - y; }
__int128 negInt128(__int128 x) { return -x; }
__int128 mulInt128(__int128 x, __int128 y) { return x * y; }
__int128 divInt128(__int128 x, __int128 y) { return x / y; }
__int128 modInt128(__int128 x, __int128 y) { return x % y; }
__int128 andInt128(__int128 x, __int128 y) { return x & y; }
__int128 orInt128(__int128 x, __int128 y) { return x | y; }
__int128 xorInt128(__int128 x, __int128 y) { return x ^ y; }
__int128 notInt128(__int128 x) { return ~x; }
__int128 shlInt128(__int128 x, __int128 y) { return x << y; }
__int128 shrInt128(__int128 x, __int128 y) { return x >> y; }
NIM_BOOL eqInt128(__int128 x, __int128 y) { return x == y; }
NIM_BOOL ltInt128(__int128 x, __int128 y) { return x < y; }
NIM_BOOL leInt128(__int128 x, __int128 y) { return x <= y; }
""".}

type int128* {.importc: "__int128".} = object
proc c_toInt128(x: clong): int128 {.importc: "toInt128", cdecl.}
proc c_toInt128u(x: culong): int128 {.importc: "toInt128u", cdecl.}
converter toInt128*(x: int): int128 = c_toInt128(clong(x))
converter toInt128*(x: uint): int128 = c_toInt128u(culong(x))
converter toInt128*(x: int64): int128 = c_toInt128(clong(x))
converter toInt128*(x: uint64): int128 = c_toInt128u(culong(x))
converter toInt128*(x: int32): int128 = c_toInt128(clong(x))
converter toInt128*(x: uint32): int128 = c_toInt128u(culong(x))
proc toInt*(x: int128): int {.importc: "toNimInt", cdecl.}
proc `+`*(x, y: int128): int128 {.importc: "addInt128", cdecl.}
proc `-`*(x, y: int128): int128 {.importc: "subInt128", cdecl.}
proc `-`*(x: int128): int128 {.importc: "negInt128", cdecl.}
proc `*`*(x, y: int128): int128 {.importc: "mulInt128", cdecl.}
proc `div`*(x, y: int128): int128 {.importc: "divInt128", cdecl.}
proc `mod`*(x, y: int128): int128 {.importc: "modInt128", cdecl.}
proc `and`*(x: int128, y: int128): int128 {.importc: "andInt128", cdecl.}
proc `or`*(x: int128, y: int128): int128 {.importc: "orInt128", cdecl.}
proc `xor`*(x: int128, y: int128): int128 {.importc: "xorInt128", cdecl.}
proc `not`*(x: int128): int128 {.importc: "notInt128", cdecl.}
proc `shl`*(x: int128, y: int128): int128 {.importc: "shlInt128", cdecl.}
proc `shr`*(x: int128, y: int128): int128 {.importc: "shrInt128", cdecl.}
proc `==`*(x, y: int128): bool {.importc: "eqInt128", cdecl.}
proc `<`*(x, y: int128): bool {.importc: "ltInt128", cdecl.}
proc `<=`*(x, y: int128): bool {.importc: "leInt128", cdecl.}
proc `$`*(x: int128): string =
  result = ""
  var t = x
  let neg = t < 0
  if neg: t = -t
  while t > 0:
    let d = toInt(t mod 10.toInt128)
    t = t div 10.toInt128
    add(result, char(int('0')+d))
  if neg: add(result, "-")
  elif len(result) == 0: add(result, "0")
  for i in 0..result.high div 2: swap(result[i], result[result.high-i])