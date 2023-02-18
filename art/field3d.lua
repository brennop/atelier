local rx, ry, rz = lib.utils.rotX, lib.utils.rotY, lib.utils.rotZ

local size = nil
local padding = 32 * 6
local gap = 64
local h = nil
local q = nil
local from = nil
local to = nil
local p = nil

local k = 0.005
local l = 0.5

local maxZ = -1000
local minZ = 1000

function draw(t)
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")

  for x = from, to, gap do
    for y = from, to, gap do
      for z = from, to, gap do
        for i = 1, 3 do
          -- local a = (love.math.noise(x*k,y*k,z*k,t+i*0.05) - 0.5) * l

          local v = rx(ry(rz({x, y, z}, t), t), 0)

          local dist = v[3] / p - 1

          local e = rz({dist * 1.5, 0, 0}, i * 2 * math.pi / 3)

          local color = {0,0,0, 1.8 + dist}
          color[i] = 1

          love.graphics.setColor(color)
          love.graphics.circle("fill", v[1] + h + e[1], v[2] + h + e[2], 2.5)
        end
      end
    end
  end
end

function love.load()
  size = love.graphics.getWidth()
  h = size / 2
  q = size / 4
  from = padding - h
  to = size - padding - h
  p = to * 2

  lib.save(function(f) draw(f * 0.4) end, 30 * 15, 30)
end

function love.draw()
  local t = love.timer.getTime() * 0.4
  draw(t)
end
