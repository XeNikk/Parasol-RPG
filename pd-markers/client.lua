customMarkers = {}
markerTextures = {
	["clothes"] = dxCreateTexture("images/clothes.png"),
	["get_car"] = dxCreateTexture("images/get_car.png"),
	["marker"] = dxCreateTexture("images/marker.png"),
	["repair"] = dxCreateTexture("images/repair.png"),
	["station_lpg"] = dxCreateTexture("images/station_lpg.png"),
	["store_car"] = dxCreateTexture("images/store_car.png")
}

setAnimation("marker", 0, 0, 1, "OutQuad")

setTimer(function()
	setTimer(function()
		setAnimation("marker", a["marker"], -0.25, 3000, "InOutQuad")
	end, 6000, 0)
end, 3000, 1)

setTimer(function()
	setAnimation("marker", a["marker"], 0.1, 3000, "InOutQuad")
end, 6000, 0)

function findFreeValue(table)
	free = false
	for i = 1, 9999 do
		if not table[i] then
			free = i
			break
		end
	end
	return free
end

function createCustomMarker(x, y, z, r, g, b, a, icon, size)
	id = findFreeValue(customMarkers)
	customMarkers[id] = {}
	customMarkers[id]["marker"] = exports["pd-dynamic-light"]:createPointLight(x, y, z, r / 255, g / 255, b / 255, a / 255, size)
	if not icon then icon = "marker" end
	customMarkers[id]["data"] = {x=x, y=y, z=z, r=r, g=g, b=b, a=a, icon=icon, size=size}
	customMarkers[id]["normal"] = createMarker(x, y, z, "cylinder", size, 0, 0, 0, 0)
	setElementData(customMarkers[id]["normal"], "marker:id", id)
	return customMarkers[id]["normal"], id
end

function attachCustomMarker(id, element, x, y, z)
	if not customMarkers[id] then return end
	exports["pd-dynamic-light"]:destroyLight(customMarkers[id]["marker"])
	customMarkers[id]["data"].attach = {element, x, y, z}
end

function destroyCustomMarker(id)
	if not customMarkers[id] then return end
	destroyElement(customMarkers[id]["normal"])
	exports["pd-dynamic-light"]:destroyLight(customMarkers[id]["marker"])
	customMarkers[id]["data"] = nil
	customMarkers[id]["normal"] = nil
	customMarkers[id]["marker"] = nil
	customMarkers[id] = nil
end
--createCustomMarker(1747.25, -2057.41, 14.2, 255, 255, 0, 255, "marker", 1.5)

addEventHandler("onClientRender", root, function()
	for k,v in pairs(customMarkers) do
		d = v["data"]
		if d.attach then
			if d.attach[1] and isElement(d.attach[1]) then
				d.x, d.y, d.z = getPositionFromElementOffset(d.attach[1], d.attach[2], d.attach[3], d.attach[4])
			end
		end
		if d.x and d.y and d.z then
			dxDrawMaterialLine3D(d.x, d.y, d.z + 1.2/3 + 1 + a["marker"], d.x, d.y, d.z - 1.2/3 + 1 + a["marker"], markerTextures[d.icon], 1.2/1.5, tocolor(d.r, d.g, d.b, 255))
		end
	end
end)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	for k,v in pairs(customMarkers) do
		exports["pd-dynamic-light"]:destroyLight(v["marker"])
	end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end