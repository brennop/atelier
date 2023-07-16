local length = 25
local size = 20
local noise_scale = 1.5

local w = length * size
local h = length * size
local l = length * length

local Vector = require "lib.vector"

local colors = {
  {0.9, 0.0, 0.0},
  {0.0, 0.9, 0.0},
  {0.0, 0.0, 0.9},
  {0.9, 0.9, 0.9},
}

local vectors = {}

local function gen()
  -- load qr-code.png
  local img = love.image.newImageData("qr-code.png")

  for c = 1, 3 do
    for i = 0, length - 1 do
      for j = 0, length - 1 do
        if img:getPixel(i, j) == 0 then
          local n = love.math.noise(i / noise_scale, j / noise_scale, c)
          table.insert(vectors, { Vector(i, j, n * length), c })
        end
      end
    end
  end
end

function love.load()
  gen()
end

function love.draw()
  love.graphics.clear(0.9, 0.9, 0.9)
  love.graphics.setBlendMode("subtract")

  local t = love.timer.getTime() * 0.6

  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 2 - h / 2)
  local center = Vector(w / 2, h / 2, h / 2)

  for i, k in ipairs(vectors) do
    local v = k[1]
    local a = math.cos(t * 0.9) * math.pi/2 + math.pi/2
    local _v = ((v * size) - center):rotatedY(a) + center

    local c = colors[k[2]]

    love.graphics.setColor(c)
    love.graphics.rectangle("fill", _v.x, _v.y, size, size)
  end

  love.graphics.pop()
end
