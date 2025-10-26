local pd <const> = playdate
local gfx <const> = pd.graphics
--
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
--
function addObject(name, vertices, edges)
    objects.shapes[#objects.shapes+1] =
    {
    name = name,
    vertices = table.deepcopy(vertices),
    edges = table.deepcopy(edges)
    }
end
function drawShape(objectNumber)
    local objectVertices <const> = calculationObjects.shapes[objectNumber].vertices
    local objectEdges <const> = calculationObjects.shapes[objectNumber].edges
    --drawing dots
    for currentVertex = 1, #objectVertices do
        if (objectVertices[currentVertex][1] <= screenWidth or objectVertices[currentVertex][1] >= 0) or (objectVertices[currentVertex][2] <= screenHeight or objectVertices[currentVertex][2] >= 0) then
            if objectVertices[currentVertex][3] < 0 then
                gfx.fillCircleAtPoint(objectVertices[currentVertex][1],objectVertices[currentVertex][2],2)
            end
        end
    end

    --draw lines
    for currentEdge = 1, #objectEdges do
        if (objectVertices[objectEdges[currentEdge][1]][3] < 0) then
            local lineX1 = objectVertices[objectEdges[currentEdge][1]][1]
            local lineY1 = objectVertices[objectEdges[currentEdge][1]][2]

            local lineX2 = objectVertices[objectEdges[currentEdge][2]][1]
            local lineY2 = objectVertices[objectEdges[currentEdge][2]][2]
            if not(math.max(lineX1,lineX2)-math.min(lineX1,lineX2) >= screenWidth*FOV*2) then
                --print('POINT1: '..lineX1..''..lineY1, 'POINT2: '..lineX2..''..lineY2)
                gfx.drawLine(lineX1,lineY1,lineX2,lineY2)
            end
        end
    end
end
function drawShapes()
    for currentObject =1, #objects.shapes do
        local objectVertices <const> = calculationObjects.shapes[currentObject].vertices
        local objectEdges <const> = calculationObjects.shapes[currentObject].edges
        --drawing dots
        for currentVertex = 1, #objectVertices do
            if (objectVertices[currentVertex][1] <= screenWidth or objectVertices[currentVertex][1] >= 0) or (objectVertices[currentVertex][2] <= screenHeight or objectVertices[currentVertex][2] >= 0) then
                if objectVertices[currentVertex][3] < 0 then
                    gfx.fillCircleAtPoint(objectVertices[currentVertex][1],objectVertices[currentVertex][2],2)
                end
            end
        end

        --draw lines
        for currentEdge = 1, #objectEdges do
            if (objectVertices[objectEdges[currentEdge][1]][3] < 0) then
                local lineX1 = objectVertices[objectEdges[currentEdge][1]][1]
                local lineY1 = objectVertices[objectEdges[currentEdge][1]][2]

                local lineX2 = objectVertices[objectEdges[currentEdge][2]][1]
                local lineY2 = objectVertices[objectEdges[currentEdge][2]][2]
                if not(math.max(lineX1,lineX2)-math.min(lineX1,lineX2) >= screenWidth*FOV*2) then
                    --print('POINT1: '..lineX1..''..lineY1, 'POINT2: '..lineX2..''..lineY2)
                    gfx.drawLine(lineX1,lineY1,lineX2,lineY2)
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
            gfx.drawCircleAtPoint(objectImage.point[1], objectImage.point[2], 2)
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

--[[function insertOrdered(array, number)
    array[#array+1] = number
    for i = 1, #array do
		for j = 1, #array - i do
			if array[j] > array[j + 1] then
				array[j], array[j + 1] = array[j + 1], array[j]
			end
		end
	end
    print('[array]')
    for i =1, #array do
        print(array[i])
    end
    print('--')
    for i = 1, #array do
		if array[i]==number then
            return i
        end
	end
end]]
function quickSort(array)
    local function partition(low, high)
		local pivot = array[high]
		local i = low - 1

		for j = low, high - 1 do
			if array[j] <= pivot then
				i = i + 1
				array[i], array[j] = array[j], array[i]
			end
		end

		array[i + 1], array[high] = array[high], array[i + 1]

		return i + 1
	end

	local function sort(low, high)
		if low < high then
			local pivot = partition(low, high)
			sort(low, pivot - 1)
			sort(pivot + 1, high)
		end

        return array
	end

	return sort(1, #array)
end