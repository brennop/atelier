local data, size, scale
local padding = 128

function love.load()
  data = love.image.newImageData("eye.png")
  size = data:getWidth()
  scale = (love.graphics.getWidth() - padding * 2) / size
end

function getY(r, g, b)
  return 0.299 * r + 0.587 * g + 0.114 * b
end

function love.draw()
  love.graphics.clear(220 / 255, 220 / 255, 220 / 255)
  for i = 1, size do
    for j = 1, size do
      local x = (i - 1) * scale + padding
      local y = (j - 1) * scale + padding

      local r, g, b, a = data:getPixel(i - 1, j - 1)

      local avg = 1 - getY(r, g, b)
      local s = (avg * scale)

      love.graphics.setColor(0.1, 0.1, 0.1, 1)
      love.graphics.rectangle("fill", x, y, s, s)
    end
  end
end
