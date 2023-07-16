local length = 25
local size = 20
local noise_scale = 1.5

local w = length * size
local h = length * size

local colors = {
  {0.9, 0.0, 0.0},
  {0.0, 0.9, 0.0},
  {0.0, 0.0, 0.9}
}

local finder_pattern = {
  {1, 1, 1, 1, 1, 1, 1},
  {1, 0, 0, 0, 0, 0, 1},
  {1, 0, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 0, 1},
  {1, 0, 1, 1, 1, 0, 1},
  {1, 0, 0, 0, 0, 0, 1},
  {1, 1, 1, 1, 1, 1, 1}
}

local alignment_pattern = {
  {1, 1, 1, 1, 1},
  {1, 0, 0, 0, 1},
  {1, 0, 1, 0, 1},
  {1, 0, 0, 0, 1},
  {1, 1, 1, 1, 1}
}

local function deceive(def)
  -- add spacing around finders
  for i = 0, 7 do
    for j = 0, 7 do
      def[i][j] = 0
      def[i][length - j - 1] = 0
      def[length - i - 1][j] = 0
    end
  end

  -- add finders
  for i = 0, 6 do
    for j = 0, 6 do
      def[i][j] = finder_pattern[i + 1][j + 1]
      def[i][length - j - 1] = finder_pattern[i + 1][j + 1]
      def[length - i - 1][j] = finder_pattern[i + 1][j + 1]
    end
  end


  -- add single alignment pattern
  for i = 0, 4 do
    for j = 0, 4 do
      def[i + 16][j + 16] = alignment_pattern[i + 1][j + 1]
    end
  end
end

function love.draw()
  love.graphics.clear(0.9, 0.9, 0.9)
  love.graphics.setBlendMode("subtract")

  local t = love.timer.getTime() * 5

  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 2 - h / 2)

  for c = 1, 3 do
    local def = {}
    for i = 0, length - 1 do
      def[i] = {}
      for j = 0, length - 1 do
        def[i][j] = 0
      end
    end


    for i = 0, length - 1 do
      for j = 0, length - 1 do
        def[i][j] = love.math.noise(i / noise_scale, j / noise_scale, t / 2, c / 10) > 0.5 and 1 or 0

        deceive(def)

        if def[i][j] == 1 then
          love.graphics.setColor(colors[c])
          love.graphics.rectangle("fill", i * size, j * size, size, size)
        end
      end
    end
  end

  love.graphics.pop()
end
