local pd <const> = playdate
local gfx <const> = pd.graphics
local menu = playdate.getSystemMenu()

import 'CoreLibs/object'
import 'CoreLibs/graphics'
import 'CoreLibs/crank'
pd.setCrankSoundsDisabled(true)
pd.display.setScale(2)
--pd.setCollectsGarbage(false)
--settings
accelerometerMode = false
--lists
camera = {3,2,20}
cameraRotation = {0,0,0}
--images
sealImage = gfx.image.new('images/seal')
bugloImage = gfx.image.new('images/buglo')
sleepySquareImage = gfx.image.new('images/slewppy square pd')

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
        },
        faces = {
        {2, 6, 8},
        {4, 2, 8},

        {1, 5, 7},
        {3, 1, 7},

        {1, 5, 6},
        {2, 1, 6},

        {4, 3, 8},
        {3, 7, 8},

        {1, 3, 4},
        {2, 1, 4},

        {5, 7, 8},
        {6, 5, 8},
        }
        },
        
        
        {
        name = "cueb 2 :'O",
        vertices = {    
        {4,4,4},{2, 4, 4},{4, 2,4},{2, 2, 4},
        {4,4,2},{2, 4, 2},{4, 2,2},{2, 2, 2},
        },
        edges = {
        {1, 2},{1, 3},{1,5},
        {2, 4},{2,6},
        {3, 4},{3, 7},
        {4, 8},
        {5, 7},{5, 6},
        {6, 8},
        {7, 8}
        },
        faces = {
        {2, 6, 8},
        {4, 2, 8},

        {1, 5, 7},
        {3, 1, 7},

        {1, 5, 6},
        {2, 1, 6},

        {4, 3, 8},
        {3, 7, 8},

        {1, 3, 4},
        {2, 1, 4},

        {5, 7, 8},
        {6, 5, 8},
        }
        },
    },
    images = {
        {
        name = "seal ['w']",
        image = sealImage,
        point = {-2,0,6},
        scale = 0.55
        },
        {
        name = "sleppy sqaure [-<-]",
        image = sleepySquareImage,
        point = {-2,0,10},
        scale = 0.7
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

--gfx.setColor(gfx.kColorBlack)

if accelerometerMode == true then
    player = {x = screenCenterX, y = screenCenterY}
    movementMultiplyer = 0.25
    tilt = 0.7
    rotationScalerX = screenCenterX/45
    rotationScalerY = screenCenterY/30
    -- turn the accelerometer on
    pd.startAccelerometer()

    pd.getSystemMenu():addOptionsMenuItem('sensitivity', {'1', '2', '3', '4', '5',}, '4', function(choice)
        movementMultiplyer = 1/choice
    end)
end
--main loop
function pd.update()
    local crankTicks = pd.getCrankTicks(12)
    local crankPosition = pd.getCrankPosition()
    local rotation = math.rad(crankPosition)
    cameraRotation[2] = rotation
    gfx.clear()

-- read the accelerometer
    if accelerometerMode == true then
        tilt_x, tilt_y, tilt_z = pd.readAccelerometer()
        
        -- change player position based on x axis tilt
        player.x += ((((tilt_x * ((screenWidth/2)/movementMultiplyer))+screenCenterX)-player.x))/(2.5/movementMultiplyer)
        player.y += (((((tilt_y-tilt) * ((screenHeight/2)/movementMultiplyer))+screenCenterY)-player.y))/(2.5/movementMultiplyer)
        if player.x < 0 then
            player.x = 0
        end
        if player.y < 0 then
            player.y = 0
        end
        if player.x > screenWidth then
            player.x = screenWidth
        end
        if player.y > screenHeight then
            player.y = screenHeight
        end

        accelerometerRotationX=-(player.x-screenCenterX)/rotationScalerX
        accelerometerRotationY=(player.y-screenCenterY)/rotationScalerY
    end
    maths()
    --input
    --print(cameraRotation[2])
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
end