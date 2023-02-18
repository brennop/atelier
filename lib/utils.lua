local utils = {}

function utils.length(v)
  return math.sqrt(v[1] * v[1] + v[2] * v[2] + v[3] * v[3])
end

function utils.rotX(v, a)
  local c = math.cos(a)
  local s = math.sin(a)
  return { v[1], v[2] * c - v[3] * s, v[2] * s + v[3] * c }
end

function utils.rotY(v, a)
  local c = math.cos(a)
  local s = math.sin(a)
  return { v[1] * c + v[3] * s, v[2], -v[1] * s + v[3] * c }
end

function utils.rotZ(v, a)
  local c = math.cos(a)
  local s = math.sin(a)
  return { v[1] * c - v[2] * s, v[1] * s + v[2] * c, v[3] }
end

function utils.smoothstep(a, b, x)
  if x < a then return a end
  if x > b then return b end
  local y = (x - a) / (b - a)
  return y * y * (3 - 2 * y)
end

return utils
