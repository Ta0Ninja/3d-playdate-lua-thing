local pd <const> = playdate
local gfx <const> = pd.graphics

function maths()
    --lists
    calculationObjects =table.deepcopy(objects)
    --rotations
    --[put rotations here]
    
    --geting relitive camera coordinets
    for currentObject =1, #objects do
        local objectVertices <const> = calculationObjects[currentObject].vertices
        for currentVertex =1, #objectVertices do
            for currentAxis = 1, 3 do
                objectVertices[currentVertex][currentAxis] = objectVertices[currentVertex][currentAxis]-camera[currentAxis]
            end
        end
        --camera rotation
        for currentVertex =1, #objectVertices do
            rotatePoint(objectVertices[currentVertex],-cameraRotation[3],-cameraRotation[2], -cameraRotation[1])
        end
        --doing the calculations every frame
        for currentVertex = 1, #objectVertices do
            --
            for currentAxis = 1, 2 do
                objectVertices[currentVertex][currentAxis] = ((objectVertices[currentVertex][currentAxis])*FOV)/(objectVertices[currentVertex][3])
            end
        end
        for currentVertex = 1, #objectVertices do
            objectVertices[currentVertex][1] = screenCenterX+(objectVertices[currentVertex][1]*scale)
            objectVertices[currentVertex][2] = screenCenterY+(objectVertices[currentVertex][2]*scale)
        end
    end
    --drawing lines and dots on screen
    drawStuff()
end