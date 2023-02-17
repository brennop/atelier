local size = 512
local pad = 32
local imSize = 128
local rect = size - pad * 2
local gap = rect / imSize
local k = 0.01
local l = 0.2

return function(data)
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")
  for i = 1, imSize do
    for j = 1, imSize do
      local x = pad + i * gap
      local y = pad + j * gap
      local r,g,b = data:getPixel(i-1, j-1)
      local color = { r, g, b }
      for i = 1, 3 do
        local n = love.math.noise(x*k, y*k, t)
        local a = (1-color[i]) * math.pi * 2
        local ex, ey = -math.sin(a) * 4, math.cos(a) * 4
        local c = { 0, 0, 0 }
        c[i] = 1
        love.graphics.setColor(c)
        love.graphics.circle("fill", x + ex, y + ey, a * l)
      end
    end
  end
end
