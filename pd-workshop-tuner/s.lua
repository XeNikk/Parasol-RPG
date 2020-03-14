local tuneElements = {}
local tuning = {}
local neons = {}
local tunePlaces = {
	{878.47479248047, -1179.2130126953, 17, 880.43328857422, -1181.1225585938, 17},
	{871.46728515625, -1179.2368164063, 17, 873.25689697266, -1181.3693847656, 17},
}

for k,v in pairs(tunePlaces) do
	text3d = createElement("3dtext")
	setElementPosition(text3d, v[1], v[2], v[3] - 0.5)
	setElementData(text3d, "3dtext", "Wolne stanowisko")

	col = createColSphere(v[1], v[2], v[3], 1)
	colTune = createColSphere(v[4], v[5], v[6], 3)
	setElementData(col, "tuneSphere", {colTune, text3d})
	setElementData(col, "tune:owner", "Brak")
	table.insert(tuneElements, {col, text3d})
end

setTimer(function()
	for k,v in pairs(tuneElements) do
		local x, y, z = getElementPosition(v[1])
		local owner = getElementData(v[1], "tune:owner")
		if owner ~= "Brak" then
			local plr = getPlayerFromName(owner)
			if plr then
				local px, py, pz = getElementPosition(plr)
				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 10 then
					setElementData(v[1], "tune:owner", "Brak")
					setElementData(v[2], "3dtext", "Wolne stanowisko")
					setElementData(plr, "player:placeReserved", false)
					exports["pd-hud"]:showPlayerNotification(plr, "Opuściłeś swoje stanowisko!", "error")
				end
			else
				setElementData(v[1], "tune:owner", "Brak")
				setElementData(v[2], "3dtext", "Wolne stanowisko")
			end
		end
	end
end, 1000, 0)

addEvent("reserveTunePlace", true)
addEventHandler("reserveTunePlace", resourceRoot, function(plr, place)
	if getElementData(plr, "player:workshop:duty") then
		if not getElementData(plr, "player:placeReserved") then
			local data = getElementData(place, "tuneSphere")
			setElementData(data[2], "3dtext", "Stanowisko #ff00cc" .. getPlayerName(plr))
			setElementData(place, "tune:owner", getPlayerName(plr))
			exports["pd-hud"]:showPlayerNotification(plr, "Zajmujesz wolne stanowisko!", "success")
			setElementData(plr, "player:placeReserved", data[1])
		else
			exports["pd-hud"]:showPlayerNotification(plr, "Posiadasz już zajęte stanowisko!", "error")
		end
	else
		exports["pd-hud"]:showPlayerNotification(plr, "Nie jesteś na służbie tunera!", "error")
	end
end)

addEvent("setNeon", true)
addEventHandler("setNeon", resourceRoot, function(vehicle, color, save)
	if vehicle and isElement(vehicle) then
		if color then
			if save then
				neons[vehicle] = getElementData(vehicle, "vehicle:neon")
			end
			setElementData(vehicle, "vehicle:neon", {left=true, right=true, front=true, rear=true, color=color})
		else
			setElementData(vehicle, "vehicle:neon", neons[vehicle] or false)
		end
	end
end)

addEvent("deleteNeon", true)
addEventHandler("deleteNeon", resourceRoot, function(vehicle)
	if vehicle and isElement(vehicle) then
		setElementData(vehicle, "vehicle:neon", false)
	end
end)

addEvent("sendOfferTune", true)
addEventHandler("sendOfferTune", resourceRoot, function(player, vehicle, selected)
	local sendTo = getVehicleController(vehicle)
	if not sendTo then return end
	local x, y, z = getElementPosition(player)
	local sx, sy, sz = getElementPosition(sendTo)
	if getDistanceBetweenPoints3D(x, y, z, sx, sy, sz) < 10 then
		triggerClientEvent(sendTo, "sendOfferTune", sendTo, player, selected)
	end
end)

addEvent("cancelOfferTune", true)
addEventHandler("cancelOfferTune", resourceRoot, function(sender, plr)
	exports["pd-hud"]:showPlayerNotification(plr, "" .. getPlayerName(sender) .. " anulował twoją propozycję tuningu.", "error")
end)

addEvent("acceptOfferTune", true)
addEventHandler("acceptOfferTune", resourceRoot, function(sender, plr, todo)
	exports["pd-hud"]:showPlayerNotification(plr, "" .. getPlayerName(sender) .. " zaakceptował twoją propozycję tuningu.", "success")
	veh = getPedOccupiedVehicle(sender)
	local additionalTuning = getElementData(veh, "vehicle:addTuning")
	if not additionalTuning then additionalTuning = "" end
	for k,v in pairs(todo) do
		if v.action == "demontage" then
			removeVehicleUpgrade(veh, v.id)
			table.remove(todo, k)
		end
	end
	local upg = {}
	for w in additionalTuning:gmatch("%S+") do
		upg[w] = true	
	end
	for k,v in pairs(todo) do
		if v.action == "deus" then
			upg["us" .. v.code] = false
		end
	end
	for k,v in pairs(todo) do
		if v.action == "deturbo" then
			upg["turbo"] = false
		end
	end
	local additionalTuning = ""
	for k,v in pairs(upg) do
		if v then
			additionalTuning = additionalTuning .. " " .. k
		end
	end
	for k,v in pairs(todo) do
		if v.action == "montage" then
			addVehicleUpgrade(veh, v.id)
			table.remove(todo, k)
		end
	end
	for k,v in pairs(todo) do
		if v.action == "montage_neon" then
			setElementData(veh, "vehicle:neon", {left=true, right=true, front=true, rear=true, color=v.color})
			table.remove(todo, k)
		end
	end
	for k,v in pairs(todo) do
		if v.action == "demontage_neon" then
			setElementData(veh, "vehicle:neon", false)
		end
	end
	for i = 1, 5 do
		for k,v in pairs(todo) do
			if v.action == "us" .. i then
				additionalTuning = additionalTuning .. " us" .. i
				table.remove(todo, k)
			end
		end
	end
	for k,v in pairs(todo) do
		if v.action == "turbo" then
			additionalTuning = additionalTuning .. " turbo"
			table.remove(todo, k)
		end
	end
	local upgrades = getElementData(veh, "vehicle:upgrades") or {}
	local handling = getVehicleHandling(veh)
	if string.find(additionalTuning, "us1") then
		handling["engineAcceleration"] = handling["engineAcceleration"] * 1.1
	end
	if string.find(additionalTuning, "us2") then
		handling["engineAcceleration"] = handling["engineAcceleration"] * 1.2
	end
	if string.find(additionalTuning, "us3") then
		handling["maxVelocity"] = handling["maxVelocity"] * 1.05
	end
	if string.find(additionalTuning, "us4") then
		handling["engineAcceleration"] = handling["engineAcceleration"] * 1.1
		handling["maxVelocity"] = handling["maxVelocity"] * 1.05
	end
	if string.find(additionalTuning, "us5") then
		handling["engineAcceleration"] = handling["engineAcceleration"] * 1.1
		handling["maxVelocity"] = handling["maxVelocity"] * 1.1
		setElementData(veh, "vehicle:upgrades", {turbo=true, als=true})
		upgrades.als = true
	end
	if string.find(additionalTuning, "turbo") then
		handling["engineAcceleration"] = handling["engineAcceleration"] * 1.1
		handling["maxVelocity"] = handling["maxVelocity"] * 1.1
		upgrades.turbo = true
	end
	setElementData(veh, "vehicle:upgrades", upgrades)
	setVehicleHandling(veh, "engineAcceleration", handling["engineAcceleration"])
	setVehicleHandling(veh, "maxVelocity", handling["maxVelocity"])
	setElementData(veh, "vehicle:addTuning", additionalTuning)
end)

addEvent("montagePart", true)
addEventHandler("montagePart", resourceRoot, function(vehicle, part)
	if vehicle and isElement(vehicle) then
		addVehicleUpgrade(vehicle, part)
	end
end)

addEvent("demontagePart", true)
addEventHandler("demontagePart", resourceRoot, function(vehicle, part)
	if vehicle and isElement(vehicle) then
		removeVehicleUpgrade(vehicle, part)
	end
end)

function restoreTuning(vehicle)
	if vehicle and isElement(vehicle) and tuning[vehicle] then
		local actualTuning = getVehicleUpgrades(vehicle)
		for k,v in ipairs(actualTuning) do
			removeVehicleUpgrade(vehicle, v)
		end
		if tuning[vehicle].tune then
			for k,v in pairs(tuning[vehicle].tune) do
				addVehicleUpgrade(vehicle, v)
			end
		end
		setElementData(vehicle, "vehicle:neon", neons[vehicle] or false)
	end
end
addEvent("setVehicleTuning", true)
addEventHandler("setVehicleTuning", resourceRoot, restoreTuning)

addEvent("saveVehicleTuning", true)
addEventHandler("saveVehicleTuning", resourceRoot, function(vehicle, plr)
	if vehicle and isElement(vehicle) then
		tuning[vehicle] = {tune=getVehicleUpgrades(vehicle), player=plr, veh=vehicle}
		neons[vehicle] = getElementData(vehicle, "vehicle:neon")
	end
end)

addEvent("desaveVehicleTuning", true)
addEventHandler("desaveVehicleTuning", resourceRoot, function(vehicle, plr)
	if vehicle and isElement(vehicle) then
		tuning[vehicle] = {}
	end
	neons[vehicle] = false
end)

addEventHandler("onPlayerQuit", root, function()
	for k,v in pairs(tuning) do
		if v.player == source then
			restoreTuning(v.veh)
		end
	end
end)