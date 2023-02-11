local k = 0.007
local t = 0

function love.update(dt)
  t = t + dt * .5
end

function love.draw()
  love.graphics.clear(1, 1, 1, 1)
  love.graphics.setBlendMode("subtract")
  for x = 32*3, 224*3, 4*3 do
    for y = 32*3, 224*3, 4*3 do
      for i = 1, 3 do
        a = love.math.noise(x*k,y*k,t+i*0.05)*math.pi*2
        color = {0,0,0}
        color[i] = 1
        love.graphics.setColor(color)
        love.graphics.circle("fill", x-math.sin(a)*8, y+math.cos(a)*8, a)
      end
    end
  end
end
