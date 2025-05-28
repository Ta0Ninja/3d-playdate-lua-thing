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
--listing all the corners (vertices/vertexes) of a shape
cubeVertices =
{
{1,2,1},{-1, 2, 1},{1, -1,1},{-1, -1, 1},
{1,2,-1},{-1, 2, -1},{1, -1,-1},{-1, -1, -1},
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
screenCenterX, screenCenterY = 100, 60
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

--calculations
for currentVertex = 1, #cubeVertices do
    for currentAxis = 1, 3 do
        --[[minusing the camera position from each vertex to get
        the relative vertex from the camera]]--
        cubeVertices[currentVertex][currentAxis] = cubeVertices[currentVertex][currentAxis]-camera[currentAxis]
    end
    for currentAxis = 1, 2 do
        --multiplying each vertex by the FOV before dividing the X Y by the Z
        --this gives you the 2d positions of the vertices
        cubeVertices[currentVertex][currentAxis] = ((cubeVertices[currentVertex][currentAxis])*FOV)/(cubeVertices[currentVertex][3])
    end
end
for currentVertex = 1, #cubeVertices do
    for currentAxis = 1, 2 do
        --making each vertice bigger (so it isnt like a 3x3 pixel cube)
        cubeVertices[currentVertex][currentAxis] = cubeVertices[currentVertex][currentAxis]*scale
    end
end
--printing the cordinates on the screen of the vertices
for currentVertex = 1, #cubeVertices do
    print(cubeVertices[currentVertex][1],cubeVertices[currentVertex][2])
    print()
end

--main loop
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    gfx.clear()
	crankTicks = pd.getCrankTicks(12)
    crankPosition = pd.getCrankPosition()
    --lists
    cubeVertices =
    {
    {1,1,1},{-1, 1, 1},{1, -1,1},{-1, -1, 1},
    {1,1,-1},{-1, 1, -1},{1, -1,-1},{-1, -1, -1},
    }
    
    --doing the calculations every frame
    for currentVertex = 1, #cubeVertices do
        for currentAxis = 1, 3 do
            cubeVertices[currentVertex][currentAxis] = cubeVertices[currentVertex][currentAxis]-camera[currentAxis]
        end
        --experiment
        angle = (crankPosition+0.02)/20
        cubeVertices[currentVertex][1] = cubeVertices[currentVertex][1]*-math.cos(angle)
        cubeVertices[currentVertex][2] = cubeVertices[currentVertex][2]*-math.sin(angle)
        cubeVertices[currentVertex][3] = cubeVertices[currentVertex][3]*math.tan(angle)
        --
        for currentAxis = 1, 2 do
            cubeVertices[currentVertex][currentAxis] = ((cubeVertices[currentVertex][currentAxis])*FOV)/(cubeVertices[currentVertex][3])
        end
        table.remove(cubeVertices[currentVertex], 3)
    end
    for currentVertex = 1, #cubeVertices do
        cubeVertices[currentVertex][1] = screenCenterX+(cubeVertices[currentVertex][1]*scale)
        cubeVertices[currentVertex][2] = screenCenterY+(cubeVertices[currentVertex][2]*scale)
    end
    --drawing dots
    for currentVertex = 1, #cubeVertices do
        gfx.fillCircleAtPoint(cubeVertices[currentVertex][1],cubeVertices[currentVertex][2],2)
    end

    --draw lines
    for currentEdge = 1, #cubeEdges do
        gfx.drawLine(cubeVertices[cubeEdges[currentEdge][1]][1],cubeVertices[cubeEdges[currentEdge][1]][2],cubeVertices[cubeEdges[currentEdge][2]][1],cubeVertices[cubeEdges[currentEdge][2]][2])
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
        camera[2]+=0.3
    end
    if pd.buttonIsPressed(pd.kButtonB) then
        camera[2]-=0.3
    end

end
