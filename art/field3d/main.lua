package.path = package.path .. ";../lib/?.lua"
local utils = require "utils"
local save = require "save"

local rx, ry, rz = utils.rotX, utils.rotY, utils.rotZ

local size = 768
local padding = 32 * 6
local gap = 32
local h = size/2
local q = size/4
local from = padding - h
local to = size - padding - h

local k = 0.01
local l = 16

function draw(t)
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")

  for x = from, to, gap do
    for y = from, to, gap do
      for z = from, to, gap do
        for i = 1, 3 do
          local a = love.math.noise(x*k,y*k,z*k,t)*2

          local cx = x + (love.math.noise(y*k,z*k,t+i*0.25) - 0.5) * l
          local cy = y + (love.math.noise(z*k,x*k,t+i*0.25) - 0.5) * l
          local cz = z + (love.math.noise(x*k,y*k,t+i*0.25) - 0.5) * l

          local v = rx(ry(rz({cx, cy, cz}, t), t), 0)

          local color = {0,0,0}
          color[i] = 1

          love.graphics.setColor(color)
          love.graphics.circle("fill", v[1] + h, v[2] + h, v[3] / q + a + 2)
        end
      end
    end
  end
end

function love.load()
  save(function(f) draw(f/30*0.4) end, 360, "out1")
end

function love.draw()
  local t = love.timer.getTime() * 0.4
  draw(t)
end
