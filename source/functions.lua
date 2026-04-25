local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry
--rotation
function rotatePoint(vertex, rx, ry, rz)
    local cosX, sinX = math.cos(rx), math.sin(rx)
    local y1 = vertex[2] * cosX - vertex[3] * sinX
    local z1 = vertex[2] * sinX + vertex[3] * cosX
    
    local cosY, sinY = math.cos(ry), math.sin(ry)
    local x2 = vertex[1] * cosY + z1 * sinY
    local z2 = -vertex[1] * sinY + z1 * cosY
    
    local cosZ, sinZ = math.cos(rz), math.sin(rz)
    local x3 = x2 * cosZ - y1 * sinZ
    local y3 = x2 * sinZ + y1 * cosZ

    vertex[1] = x3
    vertex[2] = y3
    vertex[3] = z2
end
--maths operations
function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

--3d operations
function addObject(name, vertices, edges)
    objects.shapes[#objects.shapes+1] = 
    {
    name = name,
    vertices = table.deepcopy(vertices),
    edges = table.deepcopy(edges),
    faces = {}
    }
end

function fillPolygonOutlined(polygon)
    gfx.setPattern({0x55, 0xFF, 0x55, 0xFF, 0x55, 0xFF, 0x55, 0xFF})
    gfx.fillPolygon(polygon)
    gfx.setColor(gfx.kColorBlack)
    gfx.drawPolygon(polygon)
end

function drawShape(objectNumber)
    local objectVertices <const> = calculationObjects.shapes[objectNumber].vertices
    local objectEdges <const> = calculationObjects.shapes[objectNumber].edges
    local objectFaces <const> = calculationObjects.shapes[objectNumber].faces
    --drawing dots
    for currentVertex = 1, #objectVertices do
        if (objectVertices[currentVertex][1] <= screenWidth or objectVertices[currentVertex][1] >= 0) or (objectVertices[currentVertex][2] <= screenHeight or objectVertices[currentVertex][2] >= 0) then
            if objectVertices[currentVertex][3] < 0 then
                gfx.fillCircleAtPoint(objectVertices[currentVertex][1],objectVertices[currentVertex][2],2)
            end
        end
    end
    
    if #objectFaces == 0 then
        --draw lines
        for currentEdge = 1, #objectEdges do
            if (objectVertices[objectEdges[currentEdge][1]][3] < 0) then
                local lineX1 = objectVertices[objectEdges[currentEdge][1]][1]
                local lineY1 = objectVertices[objectEdges[currentEdge][1]][2]

                local lineX2 = objectVertices[objectEdges[currentEdge][2]][1]
                local lineY2 = objectVertices[objectEdges[currentEdge][2]][2]

                local pointX3 = objectVertices[3][1]
                local pointY3 = objectVertices[3][2]

                if not(math.max(lineX1,lineX2)-math.min(lineX1,lineX2) >= screenWidth) then
                    --print('POINT1: '..lineX1..''..lineY1, 'POINT2: '..lineX2..''..lineY2)
                    gfx.drawLine(lineX1,lineY1,lineX2,lineY2)
                    --gfx.setColor(gfx.kColorXOR)
                    --gfx.fillPolygon(geo.polygon.new(lineX1, lineY1, lineX2, lineY2, pointX3, pointY3, lineX1, lineY1))
                end
            end
        end
    else
        --draw faces
        for currentFace = 1, #objectFaces do
            if (objectVertices[objectFaces[currentFace][1]][3] < 0) then
                --points = {}

                --for currentPoint = 1, #objectFaces[currentFace] do
                local pointX1 = objectVertices[objectFaces[currentFace][1]][1]
                local pointY1 = objectVertices[objectFaces[currentFace][1]][2]

                local pointX2 = objectVertices[objectFaces[currentFace][2]][1]
                local pointY2 = objectVertices[objectFaces[currentFace][2]][2]

                local pointX3 = objectVertices[objectFaces[currentFace][3]][1]
                local pointY3= objectVertices[objectFaces[currentFace][3]][2]

                local pointX4 = objectVertices[objectFaces[currentFace][4]][1]
                local pointY4= objectVertices[objectFaces[currentFace][4]][2]

                if not(math.max(pointX1,pointX2,pointX3,pointX4)-math.min(pointX1,pointX2,pointX3,pointX4) >= screenWidth) then

                    fillPolygonOutlined(geo.polygon.new(pointX1,pointY1,pointX2,pointY2,pointX3,pointY3,pointX4,pointY4,pointX1,pointY1))
                end
            end
        end
    end
end

function drawImage(objectNumber)
    local objectImage <const> = calculationObjects.images[objectNumber]
    local ZCalculation = (((objectImage.point[3]+14)/scale)+1)*(FOV/1.75)
    if objectImage.point[3] < 0 then
        if ZCalculation >= 0 then
            local scaleImage = objectImage.image:scaledImage(ZCalculation*objectImage.scale)
            scaleImage:drawCentered(objectImage.point[1],objectImage.point[2])
            --gfx.drawCircleAtPoint(objectImage.point[1], objectImage.point[2], 2)
        end
    end
    --
end
--draws all the images at once
function drawImages()
    for currentObject =1, #objects.images do
        --draw
        local objectImage <const> = calculationObjects.images[currentObject]
        local ZCalculation = (((objectImage.point[3]+14)/scale)+1)*(FOV/1.75)
        if objectImage.point[3] < 0 then
            if ZCalculation >= 0 then
                local scaleImage = objectImage.image:scaledImage(ZCalculation*objectImage.scale)
                scaleImage:drawCentered(objectImage.point[1],objectImage.point[2])
                --gfx.drawCircleAtPoint(objectImage.point[1], objectImage.point[2], 2)
            end
        end
    end
end

--Z index calculation

--[[function OrderObjects(array)
    local list = {}
    local sortedArray = table.shallowcopy(array)
    --for i = 1, #sortedArray do
		--for j = 1, #sortedArray - i do
			--if sortedArray[j] > sortedArray[j + 1] then
				--sortedArray[j], sortedArray[j + 1] = sortedArray[j + 1], sortedArray[j]
			--end
		--end
	--end
    
    table.sort(sortedArray)
    for i = 1, #sortedArray do
        for j = 1, #array do
            if sortedArray[i]==array[j] then
                list[#list+1] = j
                break
            end
        end
	end
    return list
end]]

function OrderObjects(array1, array2)
    local placesList = {}
    local objectTypeList = {}

    sortedArray = table.shallowcopy(array1)
    --merge table
    for currentPlace =1, #array2 do
        table.insert(sortedArray, #sortedArray+1, array2[currentPlace])
    end
    
    --sort table
    table.sort(sortedArray)
    --find
    --[[for i = 1, #sortedArray do
        for j = 1, #array1 do
            if sortedArray[i]==array1[j] then
                array1[j]-=0.001
                placesList[#placesList+1] = j
                objectTypeList[#objectTypeList+1] = "image"
                break
            end
        end
        
        for j = 1, #array2 do
            if sortedArray[i]==array2[j] then
                array2[j]-=0.001
                placesList[#placesList+1] = j
                objectTypeList[#objectTypeList+1] = "shape"
                break
            end
        end
    end]]
    
    for i = 1, #sortedArray do
        local imageIndex = table.indexOfElement(array1, sortedArray[i])
        --print('found image'..i..':',imageIndex)
        if imageIndex ~= nil then
            array1[imageIndex]-=0.001
            placesList[#placesList+1] = imageIndex
            objectTypeList[#objectTypeList+1] = "image"
        end

        local shapeIndex = table.indexOfElement(array2, sortedArray[i])
        --print('found shape'..i..':',shapeIndex)
        if shapeIndex ~= nil then
            array2[shapeIndex]-=0.001
            placesList[#placesList+1] = shapeIndex
            objectTypeList[#objectTypeList+1] = "shape"
        end
    end

    --printTable(placesList)
    --printTable(objectTypeList)

    return placesList, objectTypeList
end

--debug function
function printList(array, name)
    if name == nil then
        name = ""
    end
    print('<--')
    for currentNumber =1, #array do
        print(array[currentNumber])
    end
    print('--objects in list '..name..': '..#array..'>')
    
end