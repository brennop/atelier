local frag = require "lib.fragment"

local function art(x, y, t)
  local circle = ((x-.5)^2 + (y-.5)^2) * 16
  local wave = math.cos((x-.5) * 16) + (y - .5) * 8
  return circle + wave
end

function love.draw()
  frag(art, 64, 768, love.timer.getTime())
end
