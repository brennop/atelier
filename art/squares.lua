local data
local width
local height
local scale = 0
local inscale = .5

function love.load()
  data = love.image.newImageData("skull.png")
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
  for i = 0, width - 1 do
    for j = 0, height - 1 do

      local r, g, b, a = data:getPixel(i, j)

      -- local avg = (1 - getY(r, g, b)) ^ 1 + .05
      local avg = love.math.noise(i/8, j/8, love.timer.getTime() * .5) * 2
      local s = (avg * scale)

      local noise = love.math.noise(i/8, j/8, love.timer.getTime() * .5) * 2

      local x = (i - width/2) * scale + noise * s * .5
      local y = (j - height/2) * scale + noise * s * .5


      s = s + noise * s * .5

      love.graphics.setColor(0.15, 0.15, 0.15, 1)
      love.graphics.rectangle("fill", x, y, s, s)
    end
  end
end
