return function(x, y, t)
  return love.math.noise(x * 2, y * 2, t / 16) * 4
end
