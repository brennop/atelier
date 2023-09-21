local cos = math.cos
local sin = math.sin

local hy = require "lib.utils".length
local fragment = require "lib.fragment"

local art = function(x, y, t)
  local len = 0

  x = x * 3
  y = y * 4

  for i = 1, 6 do
    len = hy({x, y, 0})

    x = x - cos(y + sin(len)) - cos(t / 21)
    y = y + sin(x + cos(len)) + sin(t / 15)
  end

  return cos(len) * 3
end

function love.load()
end

function love.draw()
  fragment(art, 64, 768, love.timer.getTime() * 5)
end
