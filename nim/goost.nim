import math
type 
  Vec2* = tuple
    x: int
    y: int

  Vec3* = tuple
    x: int
    y: int
    z: int

template `-`*(a, b: Vec2): Vec2 = (x: a.x - b.x, y: a.y - b.y)
template `-`*(a, b: Vec3): Vec3 = (x: a.x - b.x, y: a.y - b.y, z: a.z - b.z)

template `*`*(a: Vec2, c: int): Vec2 = (x: a.x * c, y: a.y * c)
template `+`*(a: Vec2, b: Vec2): Vec2 = (x: a.x + b.x, y: a.y + b.y)

template `+=`*(a:var Vec2, b: Vec2) =
  a.x = a.x + b.x
  a.y = a.y + b.y
  
template `+=`*(a:var Vec3, b: Vec3) =
  a.x = a.x + b.x
  a.y = a.y + b.y
  a.z = a.z + b.z

template `-=`*(a:var Vec3, b: Vec3) =
  a.x = a.x - b.x
  a.y = a.y - b.y
  a.z = a.z - b.z

proc len*(a: Vec2): float64 = sqrt(float(a.x*a.x + a.y*a.y))

#proc unit*(a: Vec2): Vec2 = (x: a.x/a.amp, y: a.y/a.amp)

proc dot*(a, b: Vec2): int = (a.x * b.x + a.y * b.y)

#proc ang*(a, b: Vec2): float64 = arccos(a.dot(b) / (a.amp * b.amp))


proc sgn*(a: Vec3): Vec3 = (x: sgn(a.x), y: sgn(a.y), z: sgn(a.z))
