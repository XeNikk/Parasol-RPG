exports["pd-mysql"]:query("CREATE TABLE IF NOT EXISTS `pd-vehicles`(`vid` int NOT NULL AUTO_INCREMENT,`model` int NOT NULL,`owner` text NOT NULL,`color` text NOT NULL,`variant` text NOT NULL,`position` text NOT NULL,`damage` text NOT NULL,`last_driver` int NOT NULL,`fuel_type` text NOT NULL,`fuel` int NOT NULL,`dm` text NOT NULL,`mileage` int NOT NULL,`tuning` text NOT NULL,`addTuning` text NOT NULL, `paintjob` int NOT NULL, `neons` text NOT NULL, `spawned` int NOT NULL, `buyCost` int NOT NULL, `wheels` text NOT NULL, PRIMARY KEY (`vid`))")

spawnedCars = {}

function getTableFromString(s)
	local t = {}
		for w in string.gmatch(s, "%S+") do
			table.insert(t, w)
		end
	return t
end

function getStringFromTable(t)
	local s = ""
	for k,v in ipairs(t) do
		s = s .. v .. " "
	end
	return s
end

for i = 400, 612 do
	local handling = getModelHandling(i)
	if handling then
		setModelHandling(i, "maxVelocity", handling["maxVelocity"]*0.9)
	end
end

function loadVehicle(data)
	if tonumber(data["spawned"]) == 1 then
		local vid = tonumber(data["vid"])
		local pos = getTableFromString(data["position"])
		local color = getTableFromString(data["color"])
		local damage = getTableFromString(data["damage"])
		local variant = getTableFromString(data["variant"])
		local tuning = getTableFromString(data["tuning"])
		local additionalTuning = data["addTuning"]
		spawnedCars[vid] = createVehicle(data["model"], unpack(pos))
		local handling = getVehicleHandling(spawnedCars[vid])
		setVehicleColor(spawnedCars[vid], unpack(color))
		setVehicleVariant(spawnedCars[vid], unpack(variant))
		setVehiclePaintjob(spawnedCars[vid], tonumber(data["paintjob"]))
		setElementHealth(spawnedCars[vid], damage[1])
		for i = 0, 6 do
			if damage[1 + i] then
				setVehiclePanelState(spawnedCars[vid], i, tonumber(damage[1 + i]))
			end
		end
		for i = 0, 5 do
			if damage[7 + i] then
				setVehicleDoorState(spawnedCars[vid], i, tonumber(damage[7 + i]))
			end
		end
		setVehicleHandling(spawnedCars[vid], "driveType", data["wheels"])
		setElementData(spawnedCars[vid], "vehicle:vid", data["vid"])
		setElementData(spawnedCars[vid], "vehicle:owner", tonumber(data["owner"]))
		setElementData(spawnedCars[vid], "vehicle:fuel", tonumber(data["fuel"]))
		setElementData(spawnedCars[vid], "vehicle:fuel:type", data["fuel_type"])
		setElementData(spawnedCars[vid], "vehicle:wheels", data["wheels"])
		setElementData(spawnedCars[vid], "vehicle:mileage", tonumber(data["mileage"]))
		setElementData(spawnedCars[vid], "vehicle:dm", tonumber(data["dm"]))
		setElementData(spawnedCars[vid], "vehicle:buyCost", tonumber(data["buyCost"]))
		setVehiclePlateText(spawnedCars[vid], "SA "..string.format('%05d', data["vid"]))
		upgrades = {turbo=false, als=false}
		for k,v in pairs(tuning) do
			addVehicleUpgrade(spawnedCars[vid], tonumber(v))
		end
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
			setElementData(spawnedCars[vid], "vehicle:upgrades", {turbo=true, als=true})
			upgrades.als = true
		end
		if string.find(additionalTuning, "turbo") then
			handling["engineAcceleration"] = handling["engineAcceleration"] * 1.1
			handling["maxVelocity"] = handling["maxVelocity"] * 1.1
			upgrades.turbo = true
		end
		setElementData(spawnedCars[vid], "vehicle:upgrades", upgrades)
		setVehicleHandling(spawnedCars[vid], "engineAcceleration", handling["engineAcceleration"])
		setVehicleHandling(spawnedCars[vid], "maxVelocity", handling["maxVelocity"])
		setElementFrozen(spawnedCars[vid], true)
		return vid, spawnedCars[vid]
	end
end

function saveVehicle(vid, despawn)
	if spawnedCars[vid] then
		local color = getStringFromTable({getVehicleColor(spawnedCars[vid], true)})
		local health = getElementHealth(spawnedCars[vid])
		local states = {}
		local doors = {}
		local x, y, z = getElementPosition(spawnedCars[vid])
		local rx, ry, rz = getElementRotation(spawnedCars[vid])
		local position = getStringFromTable({x, y, z, rx, ry, rz})
		local paintjob = getVehiclePaintjob(spawnedCars[vid])
		local fuel = getElementData(spawnedCars[vid], "vehicle:fuel") or 0
		local fuel_type = getElementData(spawnedCars[vid], "vehicle:fuel:type") or 0
		local mileage = getElementData(spawnedCars[vid], "vehicle:mileage") or 0
		local dm = getElementData(spawnedCars[vid], "vehicle:dm") or 0
		local addTuning = getElementData(spawnedCars[vid], "vehicle:addTuning")
		local owner = getElementData(spawnedCars[vid], "vehicle:owner")
		local wheels = getElementData(spawnedCars[vid], "vehicle:wheels")
		local v1, v2 = getVehicleVariant(spawnedCars[vid])
		local tuning = {}
		for i = 0, 16 do
			table.insert(tuning, getVehicleUpgradeOnSlot(spawnedCars[vid], i))
		end
		local tuning = getStringFromTable(tuning)
		local variant = v1 .. " " .. v2
		for i = 0, 6 do
			states[i] = getVehiclePanelState(spawnedCars[vid], i)
		end
		for i = 0, 5 do
			doors[i] = getVehicleDoorState(spawnedCars[vid], i)
		end
		local damage = health .. " " .. getStringFromTable(states) .. " " .. getStringFromTable(doors)
		if despawn then
			for k,v in ipairs(getElementsByType("player")) do
				triggerClientEvent(v, "deleteVehicleBlip", v, spawnedCars[vid])
			end
			spawned = 0
			destroyElement(spawnedCars[vid])
			spawnedCars[vid] = nil
		else
			spawned = 1
		end
		exports["pd-mysql"]:query("UPDATE `pd-vehicles` SET `spawned`=?, `color`=?, `damage`=?, `position`=?, `paintjob`=?, `fuel`=?, `mileage`=?, `fuel_type`=?, `dm`=?, `addTuning`=?, `variant`=?, `tuning`=?, `owner`=?, `wheels`=? WHERE `vid`=?", spawned, color, damage, position, paintjob, fuel, mileage, fuel_type, dm, addTuning, variant, tuning, owner, wheels, vid)
	end
end

function spawnCar(vid, x, y, z, rx, ry, rz)
	local q = exports["pd-mysql"]:query("SELECT * FROM `pd-vehicles` WHERE `vid`=?", vid)
	if #q < 0 then return end
	data = q[1]
	data["position"] = getStringFromTable({x, y, z, rx, ry, rz})
	data["spawned"] = 1
	exports["pd-mysql"]:query("UPDATE `pd-vehicles` SET `spawned`=1 WHERE `vid`=?", vid)
	id, vehicle = loadVehicle(data)
	for k,v in ipairs(getElementsByType("player")) do
		triggerClientEvent(v, "loadVehicleBlips", v, vehicle)
	end
	return vehicle
end


local queryData = exports["pd-mysql"]:query("SELECT * FROM `pd-vehicles` WHERE 1")
for k,v in ipairs(queryData) do
	id = loadVehicle(v)
end

addEventHandler("onResourceStop", root, function(stopped)
	if stopped == getThisResource() then
		for k,v in pairs(spawnedCars) do
			saveVehicle(k)
		end
	end
end)


addEventHandler("onPlayerVehicleEnter", root, function(veh, seat)
	if seat ~= 0 then return end
	setVehicleEngineState(veh, false)
end)

addEventHandler("onVehicleDamage", root, function(loss)
	if loss > 120 then
		setVehicleEngineState(source, false)
	end
end)

local noTeleportModels = {
	[493] = true,
	[513] = true,
}

setTimer(function()
	for _,source in pairs(getElementsByType("vehicle")) do
		hp = getElementHealth(source)
		x, y, z = getElementPosition(source)
		model = getElementModel(source)
		if not noTeleportModels[model] then
			if z < 0 then
				setElementPosition(source, x, y, -900)
			end
			if hp < 301 then
				setElementHealth(source, 301)
			end
		end
	end
end, 1000, 0)