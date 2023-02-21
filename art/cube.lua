local _t = 0
local size = 0.6

local length, rx, ry, rz = lib.utils.length, lib.utils.rotX, lib.utils.rotY, lib.utils.rotZ

function vecSum(a, b)
  return { a[1] + b[1], a[2] + b[2], a[3] + b[3] }
end

function vecScale(a, b)
  return {a[1] * b, a[2] * b, a[3] * b}
end

function clamp(v)
  return math.max(0, math.min(1, v))
end

function dot(a, b)
  return a[1] * b[1] + a[2] * b[2] + a[3] * b[3]
end

function abs(v)
  return {math.abs(v[1]), math.abs(v[2]), math.abs(v[3])}
end

function max(a, b)
  return {math.max(a[1], b), math.max(a[2], b), math.max(a[3], b)}
end

function cube(q, k)
  local s = k or { -size, -size, -size }
  local p = vecSum(abs(q), s)
  return length(max(p, 0)) - 0.05
end

function frame(v)
  local e = 0.1
  local p = vecSum(abs(v), { -size, -size, -size })
  local q = vecSum(abs(v), { -e, -e, -e })
  return math.min(
    length(max({ p[1], q[2], q[3] }, 0)) + math.min(math.max(p[1], q[2], q[3]), 0),
    length(max({ q[1], p[2], q[3] }, 0)) + math.min(math.max(q[1], p[2], q[3]), 0),
    length(max({ q[1], q[2], p[3] }, 0)) + math.min(math.max(q[1], q[2], p[3]), 0)
  )
end

function oct(q)
  local p = abs(q)
  return (p[1] + p[2] + p[3] - 1) * 0.5
end

function torus(q, t)
  local p = { length({q[1], q[2], 0}) - t[1], q[3], 0 }
  return length(p) - t[2]
end

function twist(v, l)
  local k = math.sin(_t) * l
  local c = math.cos(k * v[2])
  local s = math.sin(k * v[2])
  local a = {v[1] * c - v[3] * s, v[1] * s + v[3] * c, v[2]}
  return a
end

function frame_approx(v)
  return math.max(cube(v), -cube(v, { -size * 2, -size * 0.8, -size * 0.8 }), -cube(v, { -size * 0.8, -size * 2, -size * 0.8 }), -cube(v, { -size * 0.8, -size * 0.8, -size * 2 }))
end

function sdf(q)
  local v = rx(ry(rz(q, _t), _t * 1), _t * 3)
  return length(v) - 0.9
end

function raycast(ro, rd)
  local a = 0

  for i = 1, 64 do
    local p = vecSum(ro, vecScale(rd, a))
    local d = sdf(p)

    if d < 0.0001 then
      break
    end

    a = a + d
  end

  return a
end

function normalize(v)
  local l = length(v)
  if l == 0 then
    return { 1000000, 1000000, 1000000 }
  end
  return {v[1] / l, v[2] / l, v[3] / l}
end

function normal(q)
  local e = 0.0001
  local n = {
    sdf({q[1] + e, q[2], q[3]}) - sdf({q[1] - e, q[2], q[3]}),
    sdf({q[1], q[2] + e, q[3]}) - sdf({q[1], q[2] - e, q[3]}),
    sdf({q[1], q[2], q[3] + e}) - sdf({q[1], q[2], q[3] - e}),
  }

  return normalize(n)
end

local function art(x,y,t)
  _t = t * 0.05

  local ro = { 0, 0, 4 }
  local rd = { (x - 0.5), (y - 0.5), -1 }

  local p = raycast(ro, rd)

  if p < 10 then
    local q = vecSum(ro, vecScale(rd, p))
    local n = normal(q)

    local light = ry(rz(rx({ 0, 0, 1 }, _t * 6), 2), _t * 0)
    local diffuse = clamp(dot(n, light))

    return diffuse
  end

  return 1
end

local canvasSize = 768

function love.load()
  canvasSize = love.graphics.getWidth()

  font = love.graphics.newFont("neodgm.ttf", 16, "mono")
  love.graphics.setFont(font)

  lib.save(function(f)
    lib.ascii(art, 96, canvasSize, f * 5)
  end, 30 * 10, 30)
end

function love.draw()
  -- lib.fragment(art, 64, canvasSize, love.timer.getTime() * 5)
  lib.ascii(art, 96, canvasSize, love.timer.getTime() * 5)
end
