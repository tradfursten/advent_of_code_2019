import math
type 
  Vec2* = tuple
    x: int
    y: int

template `-`*(a, b: Vec2): Vec2 = (x: a.x - b.x, y: a.y - b.y)
template `*`*(a: Vec2, c: int): Vec2 = (x: a.x * c, y: a.y * c)
template `+=`*(a:var Vec2, b: Vec2) =
  a.x = a.x + b.x
  a.y = a.y + b.y

proc len*(a: Vec2): float64 = sqrt(float(a.x*a.x + a.y*a.y))

#proc unit*(a: Vec2): Vec2 = (x: a.x/a.amp, y: a.y/a.amp)

proc dot*(a, b: Vec2): int = (a.x * b.x + a.y * b.y)

#proc ang*(a, b: Vec2): float64 = arccos(a.dot(b) / (a.amp * b.amp))

proc ang*(a: Vec2): float = 
  result = arctan2(float(a.y), float(a.x)) + PI/2
  if result < 0: result += 2 * PI