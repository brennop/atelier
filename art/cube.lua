local _t = 0
local size = 0.6

local utils = require "lib.utils"
local renderer = require "lib.fragment"

local length, rx, ry, rz = utils.length, utils.rotX, utils.rotY, utils.rotZ

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

function heart(v)
  local x, y, z = v[1], v[2], v[3]
  local r = 0.8 -- + math.sin(_t * 12) ^ 4 * 0.1
  z = z * (1.36 + y * .4)
  x = math.abs(x)
  y = y + x * math.sqrt((10-x)/20)
  return length({ x, y, z }) - r
end

function cyl(v)
  local q = rz(ry(rx(v, -0.5), -0.5), -0.5)
  return length({ q[1], q[2], 0 }) - 0.1
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
  return (p[1] + p[2] + p[3] - 1) * 0.1
end

function torus(q, t)
  local p = { length({q[1], q[2], 0}) - t[1], q[3], 0 }
  return length(p) - t[2]
end

function twist(v, l)
  local k = math.cos(_t) * l
  local c = math.cos(k * v[2])
  local s = math.sin(k * v[2])
  local a = {v[1] * c - v[3] * s, v[1] * s + v[3] * c, v[2]}
  return a
end

function frame_approx(v)
  return math.max(cube(v), -cube(v, { -size * 2, -size * 0.8, -size * 0.8 }), -cube(v, { -size * 0.8, -size * 2, -size * 0.8 }), -cube(v, { -size * 0.8, -size * 0.8, -size * 2 }))
end

function icosahedron(q)
  local G = 0.5 + 0.5 * math.sqrt(5)
  local n = normalize({ G, 1/G, 0 })
  local d = normalize({ 1, 1, 1 })
  local p = abs(q)
  return math.max(
    dot(p, n),
    dot(p, { n[3], n[1], n[2] }),
    dot(p, { n[2], n[3], n[1] }),
    dot(p, d)
  ) - 0.7
end

function dodecahedron(q)
  local G = 0.5 + 0.5 * math.sqrt(5)
  local n = normalize({ G, 1, 0 })
  local p = abs(q)
  return math.max(
    dot(p, n),
    dot(p, { n[3], n[1], n[2] }),
    dot(p, { n[2], n[3], n[1] })
  ) - 0.7
end

function weirdedron(q)
  local G = 0.5 + 0.5 * math.sqrt(5)
  local n = normalize({ G, 1/G, 0 })
  local d = normalize({ 1, 1, 1 })
  local p = abs(q)
  return math.max(
    -- dot(p, n),
    dot(p, { n[3], n[1], n[2] }),
    dot(p, { n[2], n[3], n[1] }),
    dot(p, d)
  ) - 0.6
end

function crystal(q)
  local c = math.cos(math.pi/5)
  local s = math.sqrt(0.75 - c*c)
  local n = { -0.5, -c, s }

  local p = abs(q)

  for i = 1, 3 do
    p = abs(p)
    p = vecSum(p, vecScale(n, -2 * math.min(0, dot(p, n))))
  end

  return p[3] - 0.7
end

function sdf(q)
  local v = rx(ry(q, _t), _t)
  return oct(v)
end

function raycast(ro, rd)
  local a = 0

  for i = 1, 48 do
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
  _t = t * 0.2

  local ro = { 0, 0, 5 }
  local rd = { (x - 0.5), (y - 0.5), -1 }

  -- local __t = _t * 0.1 * -1
  -- ro = rotX(rotY(ro, __t), __t)
  -- rd = rotX(rotY(rd, __t), __t)

  local p = raycast(ro, rd)

  if p < 4.5 then
    local q = vecSum(ro, vecScale(rd, p))
    local n = normal(q)

    local light = { .577, -.577, -.577 }
    local diffuse = clamp(dot(n, light))
    local ambient = 0.5 + 0.5 * dot(n, {0, -1, 0})

    return p * p
  end

  return 0
end

function love.draw()
  renderer(art, 96, 768, love.timer.getTime() * 5)
end
