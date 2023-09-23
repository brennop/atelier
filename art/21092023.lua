local cos, sin, log, sqrt, abs = math.cos, math.sin, math.log, math.sqrt, math.abs
local tan, atan, atan2, pi = math.tan, math.atan, math.atan2, math.pi
local max, min, floor, ceil = math.max, math.min, math.floor, math.ceil
local exp = math.exp
local noise = love.math.noise

local function sq(x) return x * x end

local hy = require "lib.utils".length
local st = require "lib.utils".smoothstep
local fragment = require "lib.fragment"
local save = require "lib.save"

local function dot(a, b, c, d, e)
  return a * b + c * d + e * c
end

local art = function(x, y, t)
  local n = love.math.noise(x*7, y*5, t/5) 
  local k = n + x*.5 - t*.20
  local c = sqrt(32 - sq(hy({ (x-.5), y-.57 + abs(x-.5), 0 }) * 16)) * .1
  c = dot(x - .5, cos(t * .20) * 2, sin(t * .20) * 2, c, y + .5)

  local a = sin((cos(k + y - .5) * .25)) * 1/c

  -- return a
  local d = sin(sin(y*20 + t*1.5) + x * 30 + cos(t)) * 0.6
  local f = max((y - .2) * 4 + noise(x * 10, y * 2 + t) + d, 0)

  local p = sqrt(abs(log(a) * c)) * 1

  if p ~= p then p = 2 end

  -- return st(p, 0 - f * 1.0, 1.5)
  return st(p, f * .7, 1)
end

function love.load()
  -- save(function(f)
  --   fragment(art, 64, 768, f * 5)
  -- end, 24 * 8, 24)
end

function love.draw()
  fragment(art, 64, 768, love.timer.getTime() * 5)
end
