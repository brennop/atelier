package.path = package.path .. ";../?.lua"
local renderer = require "lib.fragment"
local save = require "lib.save"

local _t = 0
local size = 0.6

function length(v)
  return math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
end

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

function rotX(v, a)
  local c = math.cos(a)
  local s = math.sin(a)
  return { v[1], v[2] * c - v[3] * s, v[2] * s + v[3] * c }
end

function rotY(v, a)
  local c = math.cos(a)
  local s = math.sin(a)
  return { v[1] * c + v[3] * s, v[2], -v[1] * s + v[3] * c }
end

function cube(q, k)
  local s = k or { -size, -size, -size }
  local p = vecSum(abs(q), s)
  return length(max(p, 0)) - 0.15
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
  local v = rotX(rotY(q, _t ), _t)
  return crystal(v)
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
  _t = t * 0.25

  local ro = { 0, 0, 3 }
  local rd = { (x - 0.5), (y - 0.5), -1 }

  -- local __t = _t * 0.1 * -1
  -- ro = rotX(rotY(ro, __t), __t)
  -- rd = rotX(rotY(rd, __t), __t)

  local p = raycast(ro, rd)

  if p < 3 then
    local q = vecSum(ro, vecScale(rd, p))
    local n = normal(q)

    local light = { 0, 0, 0.9 }
    local diffuse = clamp(dot(n, light))

    -- return diffuse * 4 + n[1] --+ (8 - p) * 8 + 8
    return 16 - diffuse * p * 1.7
  end

  return 16
end

function love.load()
  -- save(function(f)
  --   renderer(art, 64, 756, f * 0.2)
  -- end, 24 * 10, "hollow")
end

function love.draw()
  renderer(art, 96, 768, love.timer.getTime() * 5)
end
