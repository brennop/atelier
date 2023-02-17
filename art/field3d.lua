local rx, ry, rz = lib.utils.rotX, lib.utils.rotY, lib.utils.rotZ

local size = nil
local padding = 32 * 6
local gap = 32
local h = nil
local q = nil
local from = nil
local to = nil

local k = 0.005
local l = 0.5

function draw(t)
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")

  for x = from, to, gap do
    for y = from, to, gap do
      for z = from, to, gap do
        for i = 1, 3 do
          local a = (love.math.noise(x*k,y*k,z*k,t+i*0.05) - 0.5) * l

          local cx = x * (1 + a)
          local cy = y * (1 + a)
          local cz = z * (1 + a)

          local v = rx(ry(rz({cx, cy, cz}, t), t), 0)

          local color = {0,0,0}
          color[i] = 1

          love.graphics.setColor(color)
          love.graphics.circle("fill", v[1] + h, v[2] + h, v[3] / h + a + 2)
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
  -- save(function(f) draw(f/30*0.4) end, 360, "out1")
end

function love.draw()
  local t = love.timer.getTime() * 0.4
  draw(t)
end
