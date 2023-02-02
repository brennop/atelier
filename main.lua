local art = require "art.cube"
local moonshine = require "lib.moonshine"

local palette = {
  { 0x1A / 0x100, 0x1C / 0x100, 0x2C / 0x100 },
  { 0x5D / 0x100, 0x27 / 0x100, 0x5D / 0x100 },
  { 0xB1 / 0x100, 0x3E / 0x100, 0x53 / 0x100 },
  { 0xEF / 0x100, 0x7D / 0x100, 0x57 / 0x100 },
  { 0xFF / 0x100, 0xCD / 0x100, 0x75 / 0x100 },
  { 0xA7 / 0x100, 0xF0 / 0x100, 0x70 / 0x100 },
  { 0x38 / 0x100, 0xB7 / 0x100, 0x64 / 0x100 },
  { 0x25 / 0x100, 0x71 / 0x100, 0x79 / 0x100 },
  { 0x29 / 0x100, 0x36 / 0x100, 0x6F / 0x100 },
  { 0x3B / 0x100, 0x5D / 0x100, 0xC9 / 0x100 },
  { 0x41 / 0x100, 0xA6 / 0x100, 0xF6 / 0x100 },
  { 0x73 / 0x100, 0xEF / 0x100, 0xF7 / 0x100 },
  { 0xF4 / 0x100, 0xF4 / 0x100, 0xF4 / 0x100 },
  { 0x94 / 0x100, 0xB0 / 0x100, 0xC2 / 0x100 },
  { 0x56 / 0x100, 0x6C / 0x100, 0x86 / 0x100 },
  { 0x33 / 0x100, 0x3C / 0x100, 0x57 / 0x100 },
}

local bayer = {
  {  0,  8,  2, 10 },
  { 12,  4, 14,  6 },
  {  3, 11,  1,  9 },
  { 15,  7, 13,  5 },
}

local SIZE = 64
local CANVAS_SIZE = 256
local SCALE = CANVAS_SIZE / SIZE
local TIMESCALE = 5

local t = 0
local effect = nil

function love.load()
  effect = moonshine(moonshine.effects.glow).chain(moonshine.effects.filmgrain)

  effect.glow.min_luma = 0.5
end

function love.update(dt)
  t = t + dt * TIMESCALE
end

function love.draw()
  effect(function()
    for i = 1, SIZE do
      for j = 1, SIZE do
        local x = (i - 1)
        local y = (j - 1)

        local value = art(x / SIZE, y / SIZE, t)

        for k = 1, 4 do
          for l = 1, 4 do
            local index = math.floor(value + bayer[k][l] / 16) % #palette + 1

            if index ~= index then
              index = 1
            end

            local color = palette[index]
            love.graphics.setColor(color)
            love.graphics.rectangle(
              "fill",
              (i - 1) * SCALE + (k - 1) * SCALE / 4,
              (j - 1) * SCALE + (l - 1) * SCALE / 4,
              SCALE / 4,
              SCALE / 4
            )
          end
        end
      end
    end
  end)
end
