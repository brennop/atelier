local atan = math.atan2
local band, bor, bxor = bit.band, bit.bor, bit.bxor

local renderer = require "lib.fragment"

local function art(x, y, t)
  x = x - 0.5
  y = y - 0.5
  local a = (atan(y, x) + math.pi) * (8 / math.pi)
  local b = 128 / math.sqrt(x * x + y * y + 1)
  return band(band(a + t, b + t / 4), 3)
end

function love.draw()
  renderer(art, 96, 768, love.timer.getTime() * 5)
end
