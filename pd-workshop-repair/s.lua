repairPlaces = {
	{864.04321289063, -1179.255859375, 17, 866.23370361328, -1181.1840820313, 17},
	{857.00427246094, -1179.2396240234, 17, 857.00427246094, -1179.2396240234, 17},
	{850.16937255859, -1178.8331298828, 17, 851.76068115234, -1180.8699951172, 17}
}

repairData = {
	["Przód"] = {fn=function(veh) setVehicleDoorState(veh, 0, 0) setVehiclePanelState(veh, 5, 0) setElementHealth(veh, 1000) setVehiclePanelState(veh, 4, 0) end},
	["Światło lewe"] = {fn=function(veh) setVehicleLightState(veh, 0, 0) end},
	["Światło prawe"] = {fn=function(veh) setVehicleLightState(veh, 1, 0) end},
	["Tył"] = {fn=function(veh) setVehicleDoorState(veh, 1, 0) setVehiclePanelState(veh, 6, 0) end},
	["Lewe drzwi"] = {fn=function(veh) setVehicleDoorState(veh, 2, 0) end},
	["Prawe drzwi"] = {fn=function(veh) setVehicleDoorState(veh, 3, 0) end},
	["Lewe drzwi tył"] = {fn=function(veh) setVehicleDoorState(veh, 4, 0) end},
	["Prawe drzwi tył"] = {fn=function(veh) setVehicleDoorState(veh, 5, 0) end},
}

local repairElements = {}

for k,v in pairs(repairPlaces) do
	text3d = createElement("3dtext")
	setElementPosition(text3d, v[1], v[2], v[3] - 0.5)
	setElementData(text3d, "3dtext", "Wolne stanowisko")

	col = createColSphere(v[1], v[2], v[3], 1)
	colRepair = createColSphere(v[4], v[5], v[6], 3)
	setElementData(col, "repairSphere", {colRepair, text3d})
	setElementData(col, "repair:owner", "Brak")
	table.insert(repairElements, {col, text3d})
end

addEvent("sendRepairOffert", true)
addEventHandler("sendRepairOffert", resourceRoot, function(plr, toRepair, vehicle)
	sendTo = getVehicleController(vehicle)
	if sendTo then
		local x, y, z = getElementPosition(plr)
		local sx, sy, sz = getElementPosition(sendTo)
		if getDistanceBetweenPoints3D(x, y, z, sx, sy, sz) < 5 then
			triggerClientEvent(sendTo, "sendOffer", sendTo, plr, toRepair)
		end
	end
	--triggerClientEvent(plr, "sendOffer", plr, plr, toRepair)
end)

addEvent("playSound3D", true)
addEventHandler("playSound3D", resourceRoot, function(x, y, z)
	triggerClientEvent(root, "playSound3D", root, x, y, z)
end)

addEvent("repairPart", true)
addEventHandler("repairPart", resourceRoot, function(plr, vehicle, element)
	if repairData[element] then
		repairData[element].fn(vehicle)
	end
end)

addEvent("setPedAnimation", true)
addEventHandler("setPedAnimation", resourceRoot, function(...)
	setPedAnimation(...)
end)

addEvent("cancelRepairOffer", true)
addEventHandler("cancelRepairOffer", resourceRoot, function(plr, sender)
	exports["pd-hud"]:showPlayerNotification(sender, getPlayerName(plr) .. " anulował twoją propozycję naprawy.", "error")
end)

addEvent("acceptRepairOffer", true)
addEventHandler("acceptRepairOffer", resourceRoot, function(plr, sender, repairTable, costofall)
	if getPlayerMoney(plr) > costofall then
		exports["pd-hud"]:showPlayerNotification(sender, getPlayerName(plr) .. " zaakceptował twoją ofertę, napraw mu pojazd.", "success")
		triggerClientEvent(sender, "createRepairPlaces", sender, getPedOccupiedVehicle(plr), repairTable)
		exports["pd-core"]:takeMoney(plr, costofall)
	else
		exports["pd-hud"]:showPlayerNotification(sender, "Masz za mało pieniędzy.", "error")
	end
end)

addEvent("reserveRepairPlace", true)
addEventHandler("reserveRepairPlace", resourceRoot, function(plr, place)
	if getElementData(plr, "player:workshop:duty") then
		if not getElementData(plr, "player:placeReserved") then
			local data = getElementData(place, "repairSphere")
			setElementData(data[2], "3dtext", "Stanowisko #ff00cc" .. getPlayerName(plr))
			setElementData(place, "repair:owner", getPlayerName(plr))
			exports["pd-hud"]:showPlayerNotification(plr, "Zajmujesz wolne stanowisko!", "success")
			setElementData(plr, "player:placeReserved", data[1])
		else
			exports["pd-hud"]:showPlayerNotification(plr, "Posiadasz już zajęte stanowisko!", "error")
		end
	else
		exports["pd-hud"]:showPlayerNotification(plr, "Nie jesteś na służbie mechanika!", "error")
	end
end)

setTimer(function()
	for k,v in pairs(repairElements) do
		local x, y, z = getElementPosition(v[1])
		local owner = getElementData(v[1], "repair:owner")
		if owner ~= "Brak" then
			local plr = getPlayerFromName(owner)
			if plr then
				local px, py, pz = getElementPosition(plr)
				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 10 then
					setElementData(v[1], "repair:owner", "Brak")
					setElementData(v[2], "3dtext", "Wolne stanowisko")
					setElementData(plr, "player:placeReserved", false)
					exports["pd-hud"]:showPlayerNotification(plr, "Opuściłeś swoje stanowisko!", "error")
				end
			else
				setElementData(v[1], "repair:owner", "Brak")
				setElementData(v[2], "3dtext", "Brak")
			end
		end
	end
end, 1000, 0)