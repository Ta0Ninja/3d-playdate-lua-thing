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
function drawStuff()
    for currentObject =1, #objects do
        local objectVertices <const> = calculationObjects[currentObject].vertices
        local objectEdges <const> = calculationObjects[currentObject].edges
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
                gfx.drawLine(objectVertices[objectEdges[currentEdge][1]][1],objectVertices[objectEdges[currentEdge][1]][2],objectVertices[objectEdges[currentEdge][2]][1],objectVertices[objectEdges[currentEdge][2]][2])
            
            end
        end
    end
end
