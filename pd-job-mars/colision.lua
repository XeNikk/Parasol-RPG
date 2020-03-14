colShapes = {}
col2 = createColCuboid(5591.00928, 288.68939, 0, 844.90906, 315, 10000)
colisionTexture = dxCreateTexture("images/block.png")
basePosition = Vector3(5359.5532226563, 318.93063354492, 845.99237060547)

colisions = {
	{3724.0786132813, -435.147464752197, 2000, 1500, "on"},
}

for k,v in pairs(colisions) do
	id = #colShapes + 1
	colShapes[id] = createColCuboid(v[1], v[2], 0, v[3], v[4], 10000)
	setElementData(colShapes[id], "offoron", v[6])
end

lastPosition = {}

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "player:job") ~= "astronaut" then return end
	for k,v in ipairs(colisions) do
		x, y, z = getElementPosition(localPlayer)
		z = z + 2
		if x < v[1]+1.5 then x = v[1]+1.5 end
		if x > v[1]+v[3]-1.5 then x = v[1]+v[3]-1.5 end
		if y < v[2]+1.5 then y = v[2]+1.5 end
		if y > v[2]+v[4]-1.5 then y = v[2]+v[4]-1.5 end
		dist = getDistanceBetweenPoints3D(x, v[2], z, Vector3(getElementPosition(localPlayer)))
		if dist < 10 then
			alpha = (10 - dist) * 25.5
			dxDrawMaterialLine3D(x-10, v[2], z, x+10, v[2], z, colisionTexture, 20, tocolor(255, 255, 255, alpha), false, x-10, v[2]-1, z)
		end
		dist = getDistanceBetweenPoints3D(x, v[2]+v[4], z, Vector3(getElementPosition(localPlayer)))
		if dist < 10 then
			alpha = (10 - dist) * 25.5
			dxDrawMaterialLine3D(x-10, v[2]+v[4], z, colisionTexture, 20, tocolor(255, 255, 255, alpha), false, x-10, v[2]-1, z)
		end
		dist = getDistanceBetweenPoints3D(v[1], y, z, Vector3(getElementPosition(localPlayer)))
		if dist < 10 then
			alpha = (10 - dist) * 25.5
			dxDrawMaterialLine3D(v[1], y-10, z, v[1], y+10, z, colisionTexture, 20, tocolor(255, 255, 255, alpha), false, v[1]-1, y-10, z)
		end
		dist = getDistanceBetweenPoints3D(v[1]+v[3], y, z, Vector3(getElementPosition(localPlayer)))
		if dist < 10 then
			alpha = (10 - dist) * 25.5
			dxDrawMaterialLine3D(v[1]+v[3], y-10, z, v[1]+v[3], y+10, z, colisionTexture, 20, tocolor(255, 255, 255, alpha), false, v[1]-1, y-10, z)
		end
	end
end)

setTimer(function()
	if getElementData(localPlayer, "player:job") ~= "astronaut" then return end
	isInArea = false
	for k,e in ipairs(colShapes) do
		inside = getElementsWithinColShape(e, "player")
		for k,v in ipairs(inside) do
			if v == localPlayer then
				isInArea = true
				break
			end
		end
	end
	if isInArea then
		inside = getElementsWithinColShape(col2, "player")
		for k,v in ipairs(inside) do
			if v == localPlayer then
				if lastPosition[1] then
					setElementPosition(localPlayer, unpack(lastPosition))
					setTimer(function()
						triggerServerEvent("giveJetpack", resourceRoot, localPlayer)
					end, 150, 1)
				end
			end
		end
		x, y, z = getElementPosition(localPlayer)
		lastPosition = {x, y, z}
	else
		if lastPosition[1] then
			setElementPosition(localPlayer, unpack(lastPosition))
			setTimer(function()
				triggerServerEvent("giveJetpack", resourceRoot, localPlayer)
			end, 150, 1)
		end
	end
end, 50, 0)