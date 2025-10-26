local pd <const> = playdate
local gfx <const> = pd.graphics

function maths()
    --lists
    calculationObjects =table.deepcopy(objects)
    ObjectList = {}
    --rotations
    --[put rotations here]
    
    --geting relitive camera coordinets
    for currentObject =1, #objects.shapes do
        local objectVertices <const> = calculationObjects.shapes[currentObject].vertices
        local origObjectVertices <const> = objects.shapes[currentObject].vertices
        for currentVertex =1, #objectVertices do
            for currentAxis = 1, 3 do
                objectVertices[currentVertex][currentAxis] = objectVertices[currentVertex][currentAxis]-camera[currentAxis]
            end
        --camera rotation
            rotatePoint(objectVertices[currentVertex],-cameraRotation[3],-cameraRotation[2], -cameraRotation[1])
        --doing the calculations every frame
            for currentAxis = 1, 2 do
                objectVertices[currentVertex][currentAxis] = ((objectVertices[currentVertex][currentAxis])*FOV)/(objectVertices[currentVertex][3])
            end
            objectVertices[currentVertex][1] = screenCenterX+(objectVertices[currentVertex][1]*scale)
            objectVertices[currentVertex][2] = screenCenterY+(objectVertices[currentVertex][2]*scale)
        end
        
    end
    --image point maths
    for currentObject = 1, #objects.images do
        local objectImage <const> = calculationObjects.images[currentObject]
        for currentAxis = 1, 3 do
            objectImage.point[currentAxis] = objectImage.point[currentAxis]-camera[currentAxis]
        end
        --camera rotation
        rotatePoint(objectImage.point,-cameraRotation[3],-cameraRotation[2], -cameraRotation[1])
        --doing the calculations every frame
        for currentAxis = 1, 2 do
            objectImage.point[currentAxis] = ((objectImage.point[currentAxis])*FOV)/(objectImage.point[3])
        end
        objectImage.point[1] = screenCenterX+(objectImage.point[1]*scale)
        objectImage.point[2] = screenCenterY+(objectImage.point[2]*scale)

    end
    --checking z index
    
    --drawing lines and dots on screen
    drawShapes()
    drawImages()
end