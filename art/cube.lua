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

function sdf(q)
  local v = rotY(rotX(q, _t), _t)
  local p = vecSum(abs(v), {-size, -size, -size})
  return length(max(p, 0)) - 0.07
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

return function(x,y,t)
  _t = t * 0.25

  local ro = { 0, 0, 3 }
  local rd = { (x - 0.5), (y - 0.5), -1 }

  local p = raycast(ro, rd)

  if p < 5 then
    local q = vecSum(ro, vecScale(rd, p))
    local n = normal(q)

    local light = { 0, 0, 0.9 }
    local diffuse = clamp(dot(n, light))

    return 16 - diffuse * 4
  end

  return 15.99
end
