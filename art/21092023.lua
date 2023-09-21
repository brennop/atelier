local cos, sin, log, sqrt, abs = math.cos, math.sin, math.log, math.sqrt, math.abs
local tan, atan, atan2, pi = math.tan, math.atan, math.atan2, math.pi
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil
local exp = math.exp

local function sq(x) return x * x end

local hy = require "lib.utils".length
local fragment = require "lib.fragment"

local art = function(x, y, t)
  local n = love.math.noise(x*6, y*5, t/5) 
  local k = n + x*.5 + t * .2
  local c = sqrt(48 - sq(hy({ x-.5, y-.5, 0 }) * 16)) * .1

  local a = sin(max(tan(k + y - .5) * .25, 0)) * 1/c

  -- return a * c * 4
  return -abs(log(a) * c * 2)
end

function love.load()
end

function love.draw()
  fragment(art, 64, 768, love.timer.getTime() * 5)
end
