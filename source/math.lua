local pd <const> = playdate
local gfx <const> = pd.graphics

function maths()
    --lists
    cubeVertices =
    {
    {1,1,1},{-1, 1, 1},{1, -1,1},{-1, -1, 1},
    {1,1,-1},{-1, 1, -1},{1, -1,-1},{-1, -1, -1},

    {4,4,4},{2, 4, 4},{4, 2,4},{2, 2, 4},
    {4,4,2},{2, 4, 2},{4, 2,2},{2, 2, 2},
    }
    --rotations
    --[put rotations here]
    
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
    --drawing lines and dots on screen
    drawStuff()
end