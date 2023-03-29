local Vector = {}
Vector.__index = Vector

local cos, sin = math.cos, math.sin

function Vector:new(x, y, z)
  local self = setmetatable({}, Vector)

  self.x = x or 0
  self.y = y or 0
  self.z = z or 0

  return self
end

function Vector:__tostring()
  return string.format("Vector(%.2f, %.2f, %.2f)", self.x, self.y, self.z)
end

function Vector:__add(other)
  return Vector(self.x + other.x, self.y + other.y, self.z + other.z)
end

function Vector:__sub(other)
  return Vector(self.x - other.x, self.y - other.y, self.z - other.z)
end

function Vector:__mul(other)
  return Vector(self.x * other, self.y * other, self.z * other)
end

function Vector:__div(other)
  return Vector(self.x / other, self.y / other, self.z / other)
end

function Vector:__unm()
  return Vector(-self.x, -self.y, -self.z)
end

function Vector:__eq(other)
  return self.x == other.x and self.y == other.y and self.z == other.z
end

function Vector:__lt(other)
  return self.x < other.x and self.y < other.y and self.z < other.z
end

function Vector:__le(other)
  return self.x <= other.x and self.y <= other.y and self.z <= other.z
end

function Vector:length()
  return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector:clone()
  return Vector(self.x, self.y, self.z)
end

function Vector:unpack()
  return self.x, self.y, self.z
end

function Vector:dot(other)
  return self.x * other.x + self.y * other.y + self.z * other.z
end

function Vector:cross(other)
  return Vector(
    self.y * other.z - self.z * other.y,
    self.z * other.x - self.x * other.z,
    self.x * other.y - self.y * other.x
  )
end

function Vector:normalize()
  local length = self:length()
  self.x = self.x / length
  self.y = self.y / length
  self.z = self.z / length
end

function Vector:normalized()
  local length = self:length()
  if length == 0 then return Vector(0, 0, 0) end
  return Vector(self.x / length, self.y / length, self.z / length)
end

function Vector:floored()
  return Vector(math.floor(self.x), math.floor(self.y), math.floor(self.z))
end

function Vector:rotatedY(angle)
  local c, s = cos(angle), sin(angle)
  return Vector(self.x * c + self.z * s, self.y, self.x * s - self.z * c)
end

function Vector:rotatedX(angle)
  local c, s = cos(angle), sin(angle)
  return Vector(self.x, self.y * c + self.z * s, self.y * s - self.z * c)
end

function Vector:rotatedZ(angle)
  local c, s = cos(angle), sin(angle)
  return Vector(self.x * c - self.y * s, self.x * s + self.y * c, self.z)
end

function Vector:abs()
  return Vector(math.abs(self.x), math.abs(self.y), math.abs(self.z))
end

function Vector:max(m)
  return Vector(math.max(self.x, m), math.max(self.y, m), math.max(self.z, m))
end

function Vector:table()
  return {self.x, self.y, self.z}
end

setmetatable(Vector, { __call = Vector.new })
return Vector
