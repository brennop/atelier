local Vector = require "lib.vector"
local fragment = require "lib.fragment"
local size = 1 / 3

local EPSILON = 0.0001

-- 3d map of where there are cubes
local map = { 
  {
    { 1, 0, 1 },
    { 0, 1, 0 },
    { 1, 0, 1 },
  },
  {
    { 0, 1, 0 },
    { 1, 0, 1 },
    { 0, 1, 0 },
  },
  {
    { 1, 0, 1 },
    { 0, 1, 0 },
    { 1, 0, 1 },
  },
}

function cube(p)
  local q = p:abs() - Vector(size, size, size)
  return q:max(0):length() - 0.05
end

function sdf(vec, t)
  local m = 0

  m = math.min(
    cube(vec - Vector(0, 0, 0)),
    cube(vec - Vector(0, 0, 1)),
    cube(vec - Vector(0, 1, 0)),
    cube(vec - Vector(0, 1, 1)),
    cube(vec - Vector(1, 0, 0)),
    cube(vec - Vector(1, 0, 1)),
    cube(vec - Vector(1, 1, 0)),
    cube(vec - Vector(1, 1, 1))
  )

  return m
end

function raycast(rayOrigin, rayDirection, t)
  local a = 0

  for i = 1, 64 do
    local p = rayOrigin + rayDirection * a
    local d = sdf(p, t)

    if d < EPSILON then
      return a
    end

    a = a + d
  end
  
  return 0
end

function art(x, y, t)
  local rayOrigin = Vector(0, 0, 5)
  local rayDirection = Vector(x - .5, y - .5, -1)

  local dist = raycast(rayOrigin, rayDirection, t)

  return dist
end

return function()
  fragment(art, 64, 768, love.timer.getTime() * 5)
end
