local cos = math.cos
local sin = math.sin

local hy = lib.utils.length

local art = function(x, y, t)
  local len = 0

  x = x * 4
  y = y * 4

  for i = 1, 8 do
    len = hy({x, y, 0})

    x = x - cos(y + sin(len)) - cos(t / 21)
    y = y + sin(x + cos(len)) + sin(t / 15)
  end

  return math.max(cos(len) * 3, 0) 
end

function love.load()
  -- lib.save(function(f)
  --   lib.fragment(art, 64, 768, f * 5)
  -- end, 30 * 10, 30)
end

function love.draw()
  lib.fragment(art, 64, 768, love.timer.getTime() * 5)
end
