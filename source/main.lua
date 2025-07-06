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
    
{4,4,4},{2, 4, 4},{4, 2,4},{2, 2, 4},
{4,4,2},{2, 4, 2},{4, 2,2},{2, 2, 2},
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

{9, 10},{9, 11},{9,13},
{10, 12},{10,14},
{11, 12},{11, 15},
{12, 16},
{13, 15},{13, 14},
{14, 16},
{15, 16},

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
import 'math'
--main loop
function pd.update()
    gfx.sprite.update()
    pd.timer.updateTimers()
    gfx.clear()
	crankTicks = pd.getCrankTicks(12)
    crankPosition = pd.getCrankPosition()
    rotation = crankPosition/60
    maths()
    --input
    local angleX = (math.cos(cameraRotation[2]))/3
    local angleY = (math.sin(cameraRotation[2]))/3
    if pd.buttonIsPressed(pd.kButtonLeft) then
        camera[3]-=angleY
        camera[1]+=angleX
    end
    if pd.buttonIsPressed(pd.kButtonRight) then
        camera[3]+=angleY
        camera[1]-=angleX
    end

    if pd.buttonIsPressed(pd.kButtonUp) then
        camera[3]-=angleX
        camera[1]-=angleY
    end
    if pd.buttonIsPressed(pd.kButtonDown) then
        camera[3]+=angleX
        camera[1]+=angleY
    end

    if pd.buttonIsPressed(pd.kButtonA) then
        --camera[2]+=0.3
        cameraRotation[2]+=0.03
    end
    if pd.buttonIsPressed(pd.kButtonB) then
        --camera[2]-=0.3
        cameraRotation[2]-=0.03
    end
    
end
