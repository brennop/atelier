local cos, sin, log, sqrt, abs = math.cos, math.sin, math.log, math.sqrt, math.abs
local tan, atan, atan2, pi = math.tan, math.atan, math.atan2, math.pi
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil
local exp = math.exp

local function sq(x) return x * x end

local hy = require "lib.utils".length
local fragment = require "lib.fragment"
local save = require "lib.save"

local function dot(a, b, c, d, e)
  return a * b + c * d + e * c
end

local art = function(x, y, t)
  local n = love.math.noise(x*6, y*5, t/5) 
  local k = n + x*.5 - t*.25
  local c = sqrt(48 - sq(hy({ x-.5, y-.5, 0 }) * 16)) * .1
  c = dot(x - .5, cos(t * .25) * 2, sin(t * .25) * 2, c, y + .5)

  local a = sin((cos(k + y - .5) * .25)) * 1/c

  -- return a * c * 4
  -- return -abs(log(a) * c * 2)
  -- return -sqrt(a)
  return abs(log(a)) * .5
end

function love.load()
  save(function(f)
    fragment(art, 64, 768, f * 5)
  end, 24 * 8, 24)
end

function love.draw()
  fragment(art, 64, 768, love.timer.getTime() * 5)
end
