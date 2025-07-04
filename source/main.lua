local pd <const> = playdate
local gfx <const> = pd.graphics

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/sprites'
import 'CoreLibs/timer'
import 'CoreLibs/crank'
pd.setCrankSoundsDisabled(true)
pd.display.setScale(2)
--lists
camera = {3,2,20}
cameraRotation = {0,0,0}
--listing all the corners (vertices/vertexes) of a shape
cubeVertices =
{
{1,1,1},{-1, 1, 1},{1, -1,1},{-1, -1, 1},
{1,1,-1},{-1, 1, -1},{1, -1,-1},{-1, -1, -1},
}
--listing all the lines (edges) that connect the vertices
cubeEdges =
{
{1, 2},{1, 3},{1,5},
{2, 4},{2,6},
{3, 4},{3, 7},
{4, 8},
{5, 7},{5, 6},
{6, 8},
{7, 8},

}
--variables
angle = 23
rotation = 0
screenScale = playdate.display.getScale()
screenWidth, screenHeight = 400/screenScale, 240/screenScale
screenCenterX, screenCenterY = screenWidth/2, screenHeight/2
--[[
FOV is your zoom level
usually you'll have a multiplier that
stays the same and is used as a tuning value
so 
u = (x * fovFactor) / z
v = (y * fovFactor) / z

will have the correct effect
--]]
FOV = 3.5
--[[
"scale" is what im multiplying the finished x, y cordinte by, so it
looks bigger on the playdate screen
eg: 0.5, 0.25 --> 25, 12.5 
]]--
scale = 50
import 'functions'
--main loop
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    gfx.clear()
	crankTicks = pd.getCrankTicks(12)
    crankPosition = pd.getCrankPosition()
    rotation = crankPosition/60
    --lists
    cubeVertices =
    {
    {1,1,1},{-1, 1, 1},{1, -1,1},{-1, -1, 1},
    {1,1,-1},{-1, 1, -1},{1, -1,-1},{-1, -1, -1},
    }
    --rotations
    for currentVertex =1, #cubeVertices do
        rotatePoint(cubeVertices[currentVertex],0,rotation, 0)
    end
    --geting relitive camera coordinets
    for currentVertex =1, #cubeVertices do
        for currentAxis = 1, 3 do
            cubeVertices[currentVertex][currentAxis] = cubeVertices[currentVertex][currentAxis]-camera[currentAxis]
        end
    end
    --camera rotation
    for currentVertex =1, #cubeVertices do
        rotatePoint(cubeVertices[currentVertex],-cameraRotation[3],-cameraRotation[2], -cameraRotation[1])
    end
    --doing the calculations every frame
    for currentVertex = 1, #cubeVertices do
        --
        for currentAxis = 1, 2 do
            cubeVertices[currentVertex][currentAxis] = ((cubeVertices[currentVertex][currentAxis])*FOV)/(cubeVertices[currentVertex][3])
        end
    end
    for currentVertex = 1, #cubeVertices do
        cubeVertices[currentVertex][1] = screenCenterX+(cubeVertices[currentVertex][1]*scale)
        cubeVertices[currentVertex][2] = screenCenterY+(cubeVertices[currentVertex][2]*scale)
    end
    
    --drawing dots
    for currentVertex = 1, #cubeVertices do
        if (cubeVertices[currentVertex][1] <= screenWidth or cubeVertices[currentVertex][1] >= 0) or (cubeVertices[currentVertex][2] <= screenHeight or cubeVertices[currentVertex][2] >= 0) then
            if cubeVertices[currentVertex][3] < 0 then
                gfx.fillCircleAtPoint(cubeVertices[currentVertex][1],cubeVertices[currentVertex][2],2)
            end
        end
    end

    --draw lines
    for currentEdge = 1, #cubeEdges do
        if (cubeVertices[cubeEdges[currentEdge][1]][3] < 0) then
            gfx.drawLine(cubeVertices[cubeEdges[currentEdge][1]][1],cubeVertices[cubeEdges[currentEdge][1]][2],cubeVertices[cubeEdges[currentEdge][2]][1],cubeVertices[cubeEdges[currentEdge][2]][2])
        
        end
    end
    --input
    if pd.buttonIsPressed(pd.kButtonLeft) then
        camera[1]+=0.3
    end
    if pd.buttonIsPressed(pd.kButtonRight) then
        camera[1]-=0.3
    end

    if pd.buttonIsPressed(pd.kButtonUp) then
        camera[3]-=0.3
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        camera[3]+=0.3
    end

    if pd.buttonIsPressed(pd.kButtonA) then
        --camera[2]+=0.3
        cameraRotation[2]+=0.04
    end
    if pd.buttonIsPressed(pd.kButtonB) then
        --camera[2]-=0.3
        cameraRotation[2]-=0.04
    end
    --[[
    for currentAxis =1, 3 do
        print(cubeVertices[1][currentAxis])
    end
    print()
    --]]
end
