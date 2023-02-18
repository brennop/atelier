require "lib"

function love.keypressed(key)
  if key == "c" then
    love.graphics.captureScreenshot(os.time() .. ".png")
  end
end

-- require art next
require "art.cube"

function love.load()
  font = love.graphics.newFont("neodgm.ttf", 16, "mono")
  love.graphics.setFont(font)
end
