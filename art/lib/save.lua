return function(draw, frames, folder)
  love.filesystem.setIdentity(folder)
  local canvas = love.graphics.newCanvas()
  for f = 1, frames do
    love.graphics.setCanvas(canvas)
    draw(f)
    love.graphics.setCanvas()
    local data = canvas:newImageData()
    data:encode("png", string.format("%05d.png", f))

    print(string.format("Saved frame %d", f))
  end
end
