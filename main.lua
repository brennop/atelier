function love.keypressed(key)
  if key == "c" then
    love.graphics.captureScreenshot(os.time() .. ".png")
  end
end

-- require art next
require "art.21092023"
