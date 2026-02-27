local pd <const> = playdate
local gfx <const> = pd.graphics
local cubeRotation = 0
function maths()
    --lists
    calculationObjects =table.deepcopy(objects)
    --rotations
    --[put rotations here] 
    cubeRotation+=0.08
    for currentVertex =1, #calculationObjects.shapes[1].vertices do
        rotatePoint(calculationObjects.shapes[1].vertices[currentVertex],0, cubeRotation , 0)
    end
    --geting relitive camera coordinets
    shapeList= {}
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
        shapeList[#shapeList+1] = objectVertices[1][3]
    end
    --printList(shapeList)
    --image point maths
    imageList= {}
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
        imageList[#imageList+1] = objectImage.point[3]

    end
    --checking z index
    local placesList, objectTypeList = OrderObjects(imageList, shapeList)
    --drawing lines and dots on screen
    for currentObject =1, #placesList do
        if objectTypeList[currentObject] == "shape" then
            drawShape(placesList[currentObject])
        elseif objectTypeList[currentObject] == "image" then
            drawImage(placesList[currentObject])
        end
    end
end