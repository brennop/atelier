local cos = math.cos
local sin = math.sin

function hy(v)
  return math.sqrt(v[1] * v[1] + v[2] * v[2])
end

local art = function(x, y, t)
  local len = 0

  x = x * 4
  y = y * 4

  for i = 1, 8 do
    len = hy({x, y})

    x = x - cos(y + sin(len)) + cos(t / 12)
    y = y + sin(x + cos(len)) + sin(t / 15)
  end

  return math.max(cos(len) * 3, 0)
end

function love.draw()
  lib.fragment(art, 64, 512, love.timer.getTime() * 5)
end
