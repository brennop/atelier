local size = 32
local radius = 8
local n = 24

function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = h*6, s, l
	local c = (1-math.abs(2*l-1))*s
	local x = (1-math.abs(h%2-1))*c
	local m,r,g,b = (l-.5*c), 0,0,0
	if h < 1     then r,g,b = c,x,0
	elseif h < 2 then r,g,b = x,c,0
	elseif h < 3 then r,g,b = 0,c,x
	elseif h < 4 then r,g,b = 0,x,c
	elseif h < 5 then r,g,b = x,0,c
	else              r,g,b = c,0,x
	end return r+m, g+m, b+m, a
end

-- interpolate between numbers
function interpolate(from, to, t)
  return from + (to - from) * t
end

local canvas = nil

function love.load()
  canvas = love.graphics.newCanvas(size, size)
  canvas:setFilter("nearest", "nearest")
end

function love.draw()
  love.graphics.setCanvas(canvas)
  local t = love.timer.getTime()

  local h = 0 + t * 0.05
  local s = 1
  local l = 0.5

  love.graphics.clear(0.95, 0.95, 0.95, 1)
  for i = 1, n do
    local r, g, b = hsl(interpolate(h, h + 0.2, i/n), s, l)
    love.graphics.setColor(r, g, b)
    local x = 6 * math.sin(t*2+i*0.5) + size/2
    love.graphics.circle("fill", x, size/n * (i-.5), radius)
  end
  love.graphics.setCanvas()
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(canvas, 0, 0, 0, 16, 16)
end
