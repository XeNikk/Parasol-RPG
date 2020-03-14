local limiter = 400

bindKey("mouse2", "down", function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	if getPedOccupiedVehicleSeat(localPlayer) ~= 0 then return end
	if getElementData(localPlayer, "player:showingGUI") then return end
	local speed = getElementSpeed(veh)
	if speed < 5 then return end
	if limiter == 400 then
		limiter = speed
		exports["pd-hud"]:addNotification("Ogranicznik ustawiony na " .. math.floor(speed * 1.35) .. " km/h.", "info", 2000, nil, "info")
	else
		limiter = 400
		exports["pd-hud"]:addNotification("Ogranicznik wyłączony.", "info", 2000, nil, "info")
	end
end)

addEventHandler("onClientRender", root, function()
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	local speed = getElementSpeed(veh)
	if speed > limiter then
		setElementSpeed(veh, limiter)
	end
end)

function getElementSpeed(element)
	local vx, vy, vz = getElementVelocity(element)
	local speed = math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161)
	return speed, vx, vy, vz
end

function setElementSpeed(element, speed)
	local diff, vx, vy, vz = getElementSpeed(element)
	local diff = speed/diff
	setElementVelocity(element, vx * diff, vy * diff, vz * diff)
end