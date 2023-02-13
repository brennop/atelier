local size = 512
local radius = 96
local n = 12

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

function love.draw()
  local h = 0
  local s = 1
  local l = 0.5

  love.graphics.clear(1,1,1)
  for i = 1, n do
    local r, g, b = hsl(interpolate(0, 0.2, i/n), s, l)
    love.graphics.setColor(r, g, b)
    local t = love.timer.getTime()
    local x = 64 * math.sin(t*2+i) + size/2
    love.graphics.circle("fill", x, size/n * (i-0.5), radius)
  end
end
