local pd <const> = playdate
local gfx <const> = pd.graphics
local geo <const> = pd.geometry


--draws every shape at once
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
                if not(math.max(lineX1,lineX2)-math.min(lineX1,lineX2) >= screenWidth) then
                    --print('POINT1: '..lineX1..''..lineY1, 'POINT2: '..lineX2..''..lineY2)
                    gfx.drawLine(lineX1,lineY1,lineX2,lineY2)
                end
            end
        end

    end
end