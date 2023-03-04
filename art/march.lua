local size = 768
local res = 64
local scale = 768 / res
local n = 4

local p = lib.palette
local k = .5

function bool(n, threshold)
  return n > threshold and 1 or 0
end

function getIndex(tbl, i, j, threshold)
  return bool(tbl[i][j], threshold) + 
         bool(tbl[i + 1][j], threshold) * 2 + 
         bool(tbl[i + 1][j + 1], threshold) * 4 + 
         bool(tbl[i][j + 1], threshold) * 8
end

function drawLines(field, threshold, color)
  for i = 0, res - 1 do
    for j = 0, res - 1 do
      local x = (i+.5) * scale
      local y = (j+.5) * scale

      local ax, ay = x + scale * k, y
      local bx, by = x + scale, y + scale * k
      local cx, cy = x + scale * k, y + scale
      local dx, dy = x, y + scale * k

      local idx = getIndex(field, i, j, threshold)

      love.graphics.setColor(color)

      local lines = {
        { ax, ay, dx, dy }, -- 08
        { ax, ay, bx, by }, -- 04
        { bx, by, dx, dy }, -- 03
        { bx, by, cx, cy }, -- 02
        { ax, ay, dx, dy },  -- double
        { ax, ay, cx, cy }, -- 06
        { cx, cy, dx, dy }, -- 14
        { cx, cy, dx, dy }, -- 01
        { ax, ay, cx, cy }, -- 09
        { ax, ay, bx, by }, -- double
        { bx, by, cx, cy }, -- 13
        { bx, by, dx, dy }, -- 12
        { ax, ay, bx, by }, -- 11
        { ax, ay, dx, dy }, -- 07
      }

      if idx == 5 then
        love.graphics.line(bx, by, cx, cy)
      elseif idx == 10 then
        love.graphics.line(cx, cy, dx, dy)
      end

      if idx > 0 and idx < 15 then
        -- love.graphics.print(idx, x + scale * 2, y)
        -- love.graphics.setColor(1, 1, 1, 0.5)

        local line = lines[idx]
        love.graphics.line(line)
      end

    end
  end
end

function love.update(dt)
  -- n = n + dt * 0.5
end

function love.draw()
  local field = {}
  for i = 0, res do
    field[i] = {}
    for j = 0, res do
      local c = love.math.noise((i - res/2) / n, (j - res/2) / n, love.timer.getTime() / 4)
      field[i][j] = c * 2
    end
  end

  lib.fragment(function(x, y, t)
    local i = math.floor(x * res)
    local j = math.floor(y * res)
    return math.max(field[i][j] * 3 - 2, 0) + 0
  end, 64, 768, love.timer.getTime() * 5)

  love.graphics.setLineWidth(2)
  love.graphics.setLineStyle("rough")
  local ci = 2
  -- drawLines(field, 1.5, p[ci + 3])
  drawLines(field, 1.25, p[ci + 2])
  drawLines(field, 1, p[ci + 1])
  drawLines(field, 0.75, p[ci])
  -- drawLines(field, 1.5, { 0xF4 / 0x100, 0xF4 / 0x100, 0xF4 / 0x100 })
end
