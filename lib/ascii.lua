-- local density = [[ .:-=+*#%@]]
local density = [[@#%*+=-:. ]]
-- local density = [[_.,-=+:;cba!?0123456789$W#@]]
-- local density = [[_.,-=+:;cba]]
-- local density = [[ .,-=+*:;!?0$#%@]]

local utils = require "lib.utils"
local rz = utils.rotZ

return function(art, size, canvasSize, t)
  love.graphics.clear(.9, .9, .9, 1)
  love.graphics.setBlendMode("subtract")

  local scale = canvasSize / size
  for i = 1, size do
    for j = 1, size do
      local x = (i - 1)
      local y = (j - 1)

      local value = art(x / size, y / size, t)

      local index = math.floor(value * #density) + 1
      local char = density:sub(index, index) or ' '

      for c = 1, 3 do
        local color = {0, 0, 0, 1}
        color[c] = 1
        love.graphics.setColor(color)
        local blur = (1-value) ^ (1/3)
        local v = rz({ blur * .9, 0, 0 }, (c - 1) * math.pi * 2 / 3)
        local ex = v[1]
        local ey = v[2]
        love.graphics.print(char, x * scale + ex, y * scale + ey - 4, 0, 1, 1)
      end
    end
  end
end

