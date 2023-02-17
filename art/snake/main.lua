local canvasSize = 512
local size = 512
local radius = 96
local n = 32

-- hsl to rgb
function hsl(h, s, l, a)
	if s<=0 then return l,l,l,a end
	h, s, l = getH(h)*6, s, l
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

-- if int part of n is even, return n, else return 1-n
function getH(n)
  local int = math.floor(n)
  if int % 2 == 0 then
    return n - int
  else
    return 1 - (n - int)
  end
end

function love.load()
  canvas = love.graphics.newCanvas(size, size)
  canvas:setFilter("nearest", "nearest")
end

function love.draw()
  love.graphics.setCanvas(canvas)
  local t = love.timer.getTime()

  local T = (math.sin(t * 0.5) + 1) * 0.1
  local h = 0.2
  local s = 1
  local l = 0.5

  love.graphics.clear(0.95, 0.95, 0.95, 1)
  for i = 1, n do
    local a = h + T
    local b = h + 0.2 + T
    local r, g, b = hsl(interpolate(a, b, i/n), s, l)
    love.graphics.setColor(r, g, b)
    local x = 32 * math.sin(t*2+i*0.5) + size/2
    love.graphics.circle("fill", x, size/n * (i-.5), radius)
  end
  love.graphics.setCanvas()
  
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(canvas, 0, 0, 0, canvasSize/size, canvasSize/size)
end
