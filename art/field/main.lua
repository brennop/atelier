local k = 0.01
local t = 0

function love.update(dt)
  t = t + dt * .5
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")
  for x = 32, 224, 4 do
    for y = 32, 224, 4 do
      for i = 1, 3 do
        local a = love.math.noise(x*k, y*k, t+i*0.05) * math.pi * 2
        local color = { 0, 0, 0 }
        color[i] = 1
        love.graphics.setColor(color)
        love.graphics.circle("fill", x-math.sin(a)*8, y+math.cos(a)*8, a*0.4)
      end
    end
  end
end
