local data
local width
local height
local scale = 0
local inscale = .5

function love.load()
  data = love.image.newImageData("butterfly.png")
  width = data:getWidth()
  height = data:getHeight()
  scale = love.graphics.getWidth() / width * inscale
end

function getY(r, g, b)
  return 0.299 * r + 0.587 * g + 0.114 * b
end

function love.draw()
  love.graphics.clear(220 / 255, 220 / 255, 220 / 255)
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

  love.graphics.setBlendMode("subtract")
  for i = 0, width - 1 do
    for j = 0, height - 1 do

      local r, g, b, a = data:getPixel(i, j)
      r,g,b = 1 - r, 1 - g, 1 - b

      -- local avg = (1 - getY(r, g, b)) ^ 1
      -- local s = (avg * scale)

      local x = (i - width/2) * scale
      local y = (j - height/2) * scale

      love.graphics.setColor(1, 0, 0, 1)
      love.graphics.rectangle("fill", x, y, r*scale, r * scale)

      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.rectangle("fill", x, y, g*scale, g * scale)
      
      love.graphics.setColor(0, 0, 1, 1)
      love.graphics.rectangle("fill", x, y, b*scale, b * scale)
    end
  end
end
