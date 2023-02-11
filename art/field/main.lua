local size = 32
local scale = nil
local r = math.random()
local k = 100
local t = 0

function rotate(x, y, a)
  return x * math.cos(a) - y * math.sin(a), x * math.sin(a) + y * math.cos(a)
end

function love.load()
  scale = love.graphics.getWidth() / size
end

function love.update(dt)
  t = t + dt * 0.5
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  for i = 1, size do
    for j = 1, size do
      love.graphics.setColor(0, 0, 0)
      local x = (i - .5) * scale
      local y = (j - .5) * scale
      local n = love.math.noise(x / k, y / k, t)
      local ex, ey = rotate(0, 4, n * math.pi * 2)
      love.graphics.circle("fill", x + ex, y + ey, 1 + n * 3)
    end
  end
end
