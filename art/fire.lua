local noise = love.math.noise
local max, sin, cos = math.max, math.sin, math.cos

local function art(x, y, t)
  local d = sin(sin(y*20 + t*1.5) + x * 30 + cos(t)) * 0.6
  return max((y - .2) * 4 + noise(x * 10, y * 2 + t) + d, 0)
end

function love.load()
  lib.save(function(f)
    lib.fragment(art, 64, 768, f * 5)
  end, 24 * 8, 24)
end

function love.draw()
  lib.fragment(art, 64, 768, love.timer.getTime() * 5)
end

