return function(draw, frames, framerate)
  local timestamp = tostring(os.time())
  love.filesystem.setIdentity(timestamp)
  local canvas = love.graphics.newCanvas()

  for f = 1, frames do
    love.graphics.setCanvas(canvas)
    draw(f  / framerate)
    love.graphics.setCanvas()

    canvas:newImageData():encode("png", string.format("%05d.png", f))

    -- collectgarbage()

    print(string.format("Saved frame %d", f))
  end

  local dir = love.filesystem.getSaveDirectory()

  os.execute(table.concat({
    "ffmpeg", 
    "-framerate", framerate, 
    "-i", dir .. "/%05d.png",
    "-c:v", "libx264",
    -- "-crf", "26",
    "-pix_fmt", "yuv420p", 
    "/tmp/" .. timestamp .. ".mp4"
  }, " "))

  os.execute("rm -rd " .. dir)
end
