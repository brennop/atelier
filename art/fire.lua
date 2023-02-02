local noise = love.math.noise
local max = math.max

return function(x, y, t)
  return max((y - .2) * 4 + noise(x * 4, y * 2 + t), 0)
end

