local length = 25
local size = 20
local noise_scale = 1.5

local w = length * size
local h = length * size
local qr

local colors = {
  {0.9, 0.9, 0.9},
  {0.1, 0.1, 0.1}
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

local function gen()
  local def = {}
  for i = 0, length - 1 do
    def[i] = {}
    for j = 0, length - 1 do
      def[i][j] = 0
    end
  end

  for i = 0, length - 1 do
    for j = 0, length - 1 do
      def[i][j] = love.math.noise(i / noise_scale, j / noise_scale, t) > 0.5 and 1 or 0

      deceive(def)
    end
  end

  return def
end

local world = love.physics.newWorld(0, 0, false)

-- start with ground
local ground = love.physics.newBody(world, 0, h + 20, "static")
local ground_shape = love.physics.newRectangleShape(love.graphics.getWidth() * 2, 1)
local ground_fixture = love.physics.newFixture(ground, ground_shape)

local bodies = {
  ground
}


function love.load()
  qr = gen()

  for i = 0, length - 1 do
    for j = 0, length - 1 do
      if qr[i][j] == 1 then
        local body = love.physics.newBody(world, i * size, j * size, "dynamic")
        local shape = love.physics.newRectangleShape(size, size)
        local fixture = love.physics.newFixture(body, shape)
        table.insert(bodies, body)
      end
    end
  end

  -- gravity
  world:setGravity(0, 20)
end

local running = false
function love.update(dt)
  if running then
    world:update(dt)
  end
end

function love.keypressed(key)
  if key == "space" then
    running = not running
  end
end

function love.draw()
  love.graphics.clear(0.9, 0.9, 0.9)
  local t = love.timer.getTime() * 5

  love.graphics.push()
  love.graphics.translate(love.graphics.getWidth() / 2 - w / 2, love.graphics.getHeight() / 2 - h / 2)

  for b = 2, #bodies do
    local body = bodies[b]
    local x, y = body:getPosition()
    local angle = body:getAngle()

    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(angle)
    love.graphics.setColor(colors[2])
    love.graphics.rectangle("fill", -size / 2, -size / 2, size * 1.1, size * 1.1)
    love.graphics.pop()
  end

  love.graphics.pop()
end
