local canvasSize = 720
local size = 120
local radius = size / 8
local n = 40

-- interpolate between numbers
function interpolate(from, to, t)
  return from + (to - from) * t
end

local canvas = nil
local data = nil

function love.load()
  canvas = love.graphics.newCanvas(size, size)
  canvas:setFilter("nearest", "nearest")

  -- lib.save(draw, 20, 20)
end

function art(x,y,t)
  return data:getPixel(x*size, y*size)*4
  -- return 16 - data:getPixel(x*size, y*size)*4
  -- return 4 - data:getPixel(x*size, y*size)*4
  -- return data:getPixel(x*size, y*size)*8+12
end

function draw(t)
  love.graphics.setCanvas(canvas)
  local t = love.timer.getTime()

  love.graphics.clear(0, 0, 0, 1)
  for i = 1, n do
    local color = 1-interpolate(1, 0, i/n)
    love.graphics.setColor(color, color, color)
    local x = 8 * math.sin(t*2+i*0.5) + size/2
    love.graphics.circle("fill", x, size/n * i, radius)
  end
  love.graphics.setCanvas()
  data = canvas:newImageData()
  
  lib.fragment(art, 120, canvasSize, 0)
end

function love.draw()
  draw(love.timer.getTime())
end
