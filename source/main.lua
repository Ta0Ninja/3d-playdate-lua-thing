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
spareTable = {4, 5,2,1}
--images
imagePath = gfx.image.new('images/seal')
imagewidth, imageheight = imagePath:getSize()
--objetcs =')

objects =
{
    shapes = {
        {
        name = "cueb 1 :']",
        --listing all the corners (vertices/vertexes) of a shape
        vertices = {
        {1,1,1},{-1, 1, 1},{1, -1,1},{-1, -1, 1},
        {1,1,-1},{-1, 1, -1},{1, -1,-1},{-1, -1, -1}
        },
        --listing all the lines (edges) that connect the vertices
        edges = {
        {1, 2},{1, 3},{1,5},
        {2, 4},{2,6},
        {3, 4},{3, 7},
        {4, 8},
        {5, 7},{5, 6},
        {6, 8},
        {7, 8}
        }
        },
        {
        name = "cueb 2 :'O",
        vertices = {    
        {4,4,4},{2, 4, 4},{4, 2,4},{2, 2, 4},
        {4,4,2},{2, 4, 2},{4, 2,2},{2, 2, 2}
        },
        edges = {
        {1, 2},{1, 3},{1,5},
        {2, 4},{2,6},
        {3, 4},{3, 7},
        {4, 8},
        {5, 7},{5, 6},
        {6, 8},
        {7, 8}
        }
        },
    },
    images = {
        {
        name = "image ['w']",
        image = imagePath,
        point = {1,1,6},
        scale = 0.8
        },
    },
}
--making a copy of objects that calculations are done on =^}'
calculationObjects = table.deepcopy(objects)

--variables
angle = 23
rotation = 0
screenScale = playdate.display.getScale()
screenWidth, screenHeight = 400/screenScale, 240/screenScale
screenCenterX, screenCenterY = screenWidth/2, screenHeight/2
local circlePoint = 0
--[[
FOV is your zoom level
usually you'll have a multiplier that
stays the same and is used as a tuning value
so 
u = (x * fovFactor) / z
v = (y * fovFactor) / z

will have the correct effect
--]]
FOV = 7/screenScale
--[[
"scale" is what im multiplying the finished x, y cordinte by, so it
looks bigger on the playdate screen
eg: 0.5, 0.25 --> 25, 12.5 
]]--
scale = 50
import 'functions'
import 'math'
--setup ;^}
addObject("sloep ;'/",
    {
    {5, 1, 4},{7, -1,4},{5, -1, 4},
    {5, 1, 2},{7, -1,2},{5, -1, 2}
    },
    {
    {1, 4}, {1, 3}, {1, 2},
    {2, 3}, {2, 5},
    {3, 6},
    {4, 5},{4, 6},
    {5, 6}
    }
)
--main loop
function pd.update()
    crankTicks = pd.getCrankTicks(12)
    crankPosition = pd.getCrankPosition()
    rotation = crankPosition/60
    cameraRotation[2] = rotation
    gfx.sprite.update()
    pd.timer.updateTimers()
    gfx.clear()
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
        camera[2]+=0.3
    end
    if pd.buttonIsPressed(pd.kButtonB) then
        camera[2]-=0.3
    end
    if pd.buttonJustPressed(pd.kButtonB) then
        local numberreturned = insertOrdered(spareTable, 1.5)
        print(numberreturned)
    end
    --
    circlePoint += 0.1
    if circlePoint == 360 then
        circlePoint = 0
    elseif circlePoint == -1 then
        circlePoint = 359
    end
    --objects.images[1].point[1]+=math.cos(circlePoint)
    objects.images[1].point[1]+=math.cos(circlePoint)
    objects.images[1].point[3]+=math.sin(circlePoint)
end
