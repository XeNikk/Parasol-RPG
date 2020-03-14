local x, y, z = getElementPosition(localPlayer)
local last_position = {x, y, z}

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	local mileage = getElementData(veh, "vehicle:mileage") or 0
	local fuel = getElementData(veh, "vehicle:fuel") or 0
	if not mileage then return end
	local x, y, z = getElementPosition(veh)
	local dist = getDistanceBetweenPoints3D(x, y, z, last_position[1], last_position[2], last_position[3])
	setElementData(veh, "vehicle:mileage", mileage + dist / 1000)
	last_position = {x, y, z}
	if fuel <= 0 then return end
	setElementData(veh, "vehicle:fuel", fuel - dist / 10000 )
	
end)

