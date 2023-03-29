function love.keypressed(key)
  if key == "c" then
    love.graphics.captureScreenshot(os.time() .. ".png")
  end
end

-- require art next
-- require "art.march"

function love.draw()
  require "lib.voxels"()
  love.graphics.setColor(1, 1, 1)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 10, 10)
end
