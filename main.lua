local worldSize = 500
local wheight = 30
local worldSizeRatio =1 --x,y
local ps = 50
love.graphics.setDefaultFilter ("nearest", "nearest", 1)
local clock = os.clock
local RD = 175
math.randomseed(os.time())

local ssX,ssY = love.graphics:getWidth(), love.graphics:getHeight()
local world = {}
local characterPos = {0,0,0}
local cube = love.graphics.newImage("cube.png")
local tree = love.graphics.newImage("tree.png")
local grass = love.graphics.newImage("grass.png")
local sand = love.graphics.newImage("sand.png")
local water = love.graphics.newImage("water.png")
local seed = math.random(1,100000)

function genSettings(x,y,z)
  local texture
  local cx,cy,cz = 0,0,0
  local x,y,z = x+ seed,y+seed,z
  local a = .0075
  if z <= love.math.noise(x*a,y*a)*(wheight) then
    if z < 10 then
        texture = water
    elseif z < 14 then
        texture = sand
    elseif z < wheight then
        texture = grass
    else
        texture = cube
    end
    return {true,texture}--changex changey changez
  end
  
end

for x =1,worldSize do
  world[x] = {}
  for y = 1,worldSize*worldSizeRatio do
    world[x][y] = {}
    for z = 1,wheight do
      if genSettings(x,y,z) then
        world[x][y][z] = genSettings(x,y,z)[2]
      end
    end
  end
end

function test(v,w,x,y,z)
  if world[x+1] and world[x+1][y+1] and world[x+1][y+1][z+1] then
    return false
  else
    return true
  end
end

function love.draw()
  local CX,CY,CZ = unpack(characterPos)
  local CX2,CY2,CZ2 = math.floor(CX), math.floor(CY)
  local cX,cY=(CX-CY)*(ps/2), (CX+CY)*(ps/4)
   for z = 1,wheight do
    for x =-CX2,-CX2+ssX/4 do
      for y = -CY2,-CY2+ssY/2 do
        if world[x] and world[x][y] and world[x][y][z] then
          if test(true,3,x,y,z) then
            local X,Y=(x-y)*(ps/2), ((x+y)-(z*2.4))*(ps/4)
            --[[if Y+cY+(ssY/2) < 0 and Y+cY+(ssY/2) >= ssX then
                break
            end
            if X+cX+(ssX/2) < 0 and X+cX+(ssX/2) >= ssY then
                break
            end]]
            --if math.sqrt((x+CX2)^2+(y+CY2)^2) < 100 then
              if (x > -CX-RD) and (x < -CX+RD) and (y > -CY-RD) and (y < -CY+RD)  then
               local isx,isy = 32,32
                
                love.graphics.setColor(255,255,255)
                if -x == math.floor(characterPos[1]) and -y == math.floor(characterPos[2]) then
                  love.graphics.setColor(255,0,0)
                end
                    love.graphics.draw(
                  world[x][y][z]
                  ,X+cX+(ssX/2),Y+cY+(ssY/4),0,ps/isx,ps/isy)
            end
          end
        end
      end
    end
  end
end

function love.wheelmoved(x,y)
  ps = math.abs(ps + y)
end

function love.update()
  if love.keyboard.isDown("w") then
    characterPos = {characterPos[1]+0.1,characterPos[2]+0.1}
  end if love.keyboard.isDown("s") then
    characterPos = {characterPos[1]-0.1,characterPos[2]-0.1}
  end if love.keyboard.isDown("a") then
    characterPos = {characterPos[1]+0.1,characterPos[2]-0.1}
  end if love.keyboard.isDown("d") then
    characterPos = {characterPos[1]-0.1,characterPos[2]+0.1}
  end
end
