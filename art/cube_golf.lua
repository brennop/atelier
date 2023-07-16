local _t = 0
local size = 0.6

local utils = require "lib.utils"
local renderer = require "lib.fragment"
local length, rx, ry, rz = utils.length, utils.rotX, utils.rotY, utils.rotZ

function s(a, b)
  return { a[1] + b[1], a[2] + b[2], a[3] + b[3] }
end

function m(a, b)
  return {a[1] * b, a[2] * b, a[3] * b}
end

function clamp(v)
  return math.max(0, math.min(1, v))
end

function dot(a, b)
  return a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

function abs(v)
  return {math.abs(v[1]), math.abs(v[2]), math.abs(v[3])}
end

function max(a, b)
  return {math.max(a[1], b), math.max(a[2], b), math.max(a[3], b)}
end

function cube(q, k)
  local p = s(abs(q), { -1, -1, -1 })
  return length(max(p, 0))
end

function sdf(q)
  local q = rx(ry(q, _t * 2.5), _t * 1.5)
  return cube(q)
end

local function art(x,y,t)
  _t = t * 0.05

  local ro = { 0, 0, 5 }
  local rd = { (x - 0.5), (y - 0.5), -1 }

  local a = 0

  for i = 1, 128 do
    a = a + sdf(s(ro, m(rd, a)))
  end

  return utils.smoothstep(0, 12, a)
  -- return math.sqrt(a)
end

function love.draw()
  renderer(art, 96, 768, love.timer.getTime() * 5)
end

