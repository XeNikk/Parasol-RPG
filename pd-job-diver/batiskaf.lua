local batiskafEnabled = false
local object = createObject(2000, 0, 0, 0)
local batiskafSpeed = 0
setElementAlpha(object, 0)

engineImportTXD(engineLoadTXD("batiskaf/batiskaf.txd"), 493)
engineReplaceModel(engineLoadDFF("batiskaf/batiskaf.dff"), 493)

addEvent("setBatiskafPropertyEnabled", true)
addEventHandler("setBatiskafPropertyEnabled", localPlayer, function(enabled)
	batiskafEnabled = enabled
end)

addEventHandler("onClientRender", root, function()
	if batiskafEnabled then
		local keys = getBoundKeys("accelerate")
		for k,v in pairs(keys) do
			if getKeyState(k) then
				batiskafSpeed = math.min(batiskafSpeed + 0.002, 0.2)
			end
		end

		batiskafSpeed = math.max(batiskafSpeed - 0.001, 0)
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if not vehicle then return end
		if getElementModel(vehicle) ~= 493 then return end

		local rx, ry, rz = getElementRotation(vehicle)
		local vx, vy, vz = getElementVelocity(vehicle)
		local speed = math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161) / 200
		if getKeyState("arrow_u") then
			if rx > 350 then rx = rx - speed end
			if rx < 50 then rx = rx - speed end
		end
		if getKeyState("arrow_d") then
			if rx < 20 then rx = rx + speed end
			if rx > 300 then rx = rx + speed end
		end
		if getKeyState("arrow_r") or getKeyState("D") then
			rz = rz - speed
		end
		if getKeyState("arrow_l") or getKeyState("A") then
			rz = rz + speed
		end
		setElementRotation(vehicle, rx, ry, rz)
		if isElementInWater(vehicle) then
			lbtSetVehicleSpeed(vehicle, batiskafSpeed)
		end
	end
end)

function lbtSetVehicleSpeed(vehicle, speed)
	local rx, ry, rz = getElementRotation(vehicle)
	setElementRotation(object, rx, ry, rz)
	local vx, vy, vz = getPositionFromElementOffset(object, 0, speed, 0)
	setElementVelocity(vehicle, vx, vy, vz)
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix (element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end