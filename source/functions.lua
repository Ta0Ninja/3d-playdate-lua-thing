local pd <const> = playdate
local gfx <const> = pd.graphics

function drawStuff()
    --drawing dots
    for currentVertex = 1, #cubeVertices do
        if (cubeVertices[currentVertex][1] <= screenWidth or cubeVertices[currentVertex][1] >= 0) or (cubeVertices[currentVertex][2] <= screenHeight or cubeVertices[currentVertex][2] >= 0) then
            if cubeVertices[currentVertex][3] < 0 then
                gfx.fillCircleAtPoint(cubeVertices[currentVertex][1],cubeVertices[currentVertex][2],2)
            end
        end
    end

    --draw lines
    for currentEdge = 1, #cubeEdges do
        if (cubeVertices[cubeEdges[currentEdge][1]][3] < 0) then
            gfx.drawLine(cubeVertices[cubeEdges[currentEdge][1]][1],cubeVertices[cubeEdges[currentEdge][1]][2],cubeVertices[cubeEdges[currentEdge][2]][1],cubeVertices[cubeEdges[currentEdge][2]][2])
        
        end
    end
end

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