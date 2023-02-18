local hy, st = lib.utils.length, lib.utils.smoothstep
local abs, cos, max = math.abs, math.cos, math.max

local art = function(x, y, t)
  local h = 0.5
  return max(cos(hy({x-h,abs(x-h)+y-.55,0})*20-t)*3, 0)
end

function love.load()
  lib.save(function(f)
    lib.fragment(art, 64, 768, f * 5)
  end, 24 * 8, 24)
end

function love.draw()
  lib.fragment(art, 64, 768, love.timer.getTime() * 5)
end
