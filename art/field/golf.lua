k,g,l,m,love.draw=0.01,love.graphics,.4,math,loadstring"g.clear(1,1,1,1)g.setBlendMode('subtract') for j=0,9215,4 do x,y=(j%192)+32,(j/48)+32 for i=1,3 do a,c=love.math.noise(x*k,y*k,love.timer.getTime()*l+i*0.05)*m.pi*2,{0,0,0}c[i]=1 g.setColor(c)g.circle('fill',x-m.sin(a)*8,y+m.cos(a)*8,a*l)end end"

