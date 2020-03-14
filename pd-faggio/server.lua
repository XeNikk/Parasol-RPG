publicFaggios = {
	{1437.931640625, -1677.11328125, 13.141610145569, 0, 0, 90},
	{1437.9521484375, -1673.1943359375, 13.121290206909, 0, 0, 90},
	{1437.7666015625, -1668.11328125, 13.144384384155, 0, 0, 90},
	{1437.9208984375, -1662.5205078125, 13.145256996155, 0, 0, 90},
	{1767.19140625, -2040.8310546875, 13.124570846558, 359.26391601563, 359.68688964844, 266.2646484375},
	{784.462890625, -1387.0556640625, 13.272909164429, 357.76977539062, 0.076904296875, 180.13732910156},
}

setModelHandling(462, "maxVelocity", 50)

function respawnFaggios()
	for k,v in pairs(publicFaggios) do
		canSpawn = true
		for k,veh in pairs(getElementsByType("vehicle")) do
			if getDistanceBetweenPoints2D(Vector2(getElementPosition(veh)), v[1], v[2], v[3]) < 3 then
				canSpawn = false
			end
		end
		if canSpawn then
			veh = createVehicle(462, v[1], v[2], v[3], v[4], v[5], v[6])
			setVehicleColor(veh, 255, 255, 255)
			exports["pd-3dtext"]:setVehicle3DText(veh, "Pojazd publiczny")
			setElementData(veh, "vehicle:public", true)
			setElementFrozen(veh, true)
			setVehicleHandling(veh, "engineAcceleration", 10)
		end
	end
end

destroyTimers = {}

function deletePublicVehicle(vehicle)
	if vehicle and isElement(vehicle) then
		plr = getElementData(vehicle, "vehicle:public:owner")
		if plr and isElement(plr) then
			setElementData(plr, "player:rent:public:car", false)
		end
		destroyTimers[vehicle] = nil
		destroyElement(vehicle)
	end
end

setTimer(respawnFaggios, 10000, 0)
respawnFaggios()

addEventHandler("onVehicleEnter", root, function(plr, seat)
	if getElementData(source, "vehicle:public") and seat == 0 then
		setElementData(plr, "player:rent:public:car", source)
		setElementData(source, "vehicle:public:owner", plr)
		exports["pd-3dtext"]:setVehicle3DText(source, "Pojazd publiczny\nZajęty przez: #ff0067" .. getPlayerName(plr))
		if destroyTimers[source] and getTimerDetails(destroyTimers[source]) then
			killTimer(destroyTimers[source])
			destroyTimers[source] = nil
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	veh = getElementData(source, "player:rent:public:car")
	if veh then
		deletePublicVehicle(veh)
	end
end)

addEventHandler("onVehicleExit", root, function(player, seat)
	if seat == 0 and getElementData(source, "vehicle:public") then
		destroyTimers[source] = setTimer(deletePublicVehicle, 60000, 1, source)
	end
end)
