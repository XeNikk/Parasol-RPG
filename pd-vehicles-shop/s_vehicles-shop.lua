local salonVehicles = {}
local salons = {
	[1] = {
		model = 478,
		x=-64.56, y=-1575.62, z=2.6, rx=0, ry=0, rz=274.56,
		r=255, g=150, b=255,
		cost = 3750,
		mileage = math.random(30000, 40000),
		quantity = 5,
		dm = 1.5,
		wheels = "awd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "cygan_01"
	},
	[2] = {
		model = 418,
		x=-92.06, y=-1555.87, z=2.7, rx=0, ry=0, rz=313,
		r=150, g=150, b=255,
		cost = 4067,
		mileage = math.random(30000, 40000),
		quantity = 5,
		dm = 1.5,
		wheels = "awd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "cygan_01"
	},
	[3] = {
		model = 404,
		x=-88.53, y=-1602.48, z=2.35, rx=0, ry=0, rz=312.7,
		r=150, g=255, b=150,
		cost = 4323,
		mileage = math.random(30000, 40000),
		quantity = 5,
		dm = 1.5,
		wheels = "awd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "cygan_01"
	},
	[3] = {
		model = 419,
		x=-52.01, y=-1560.93, z=2.4, rx=0, ry=0, rz=220.7,
		r=150, g=255, b=150,
		cost = 7654,
		mileage = math.random(30000, 40000),
		quantity = 5,
		dm = 1.5,
		wheels = "awd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "cygan_01"
	},
	[4] = {
		model = 562,
		x=2512.1616210938, y=-1755.673095, z=13.304, rx=0, ry=0, rz=39,
		r=150, g=0, b=150,
		cost = 500000,
		mileage = 0,
		quantity = 5,
		dm = 1.8,
		wheels = "rwd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
	[5] = {
		model = 541,
		x=2512.9663, y=-1747.66125, z=13.692, rx=0, ry=0, rz=131,
		r=0, g=0, b=150,
		cost = 800000,
		mileage = 0,
		quantity = 5,
		dm = 1.8,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
	[6] = {
		model = 451,
		x=2482.20312, y=-1764.11755, z=13.434, rx=0, ry=0, rz=39,
		r=150, g=150, b=150,
		cost = 1500000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "awd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
	[7] = {
		model = 560,
		x=2463.3857, y=-1764.9715, z=18.94340, rx=0, ry=0, rz=324,
		r=0, g=150, b=150,
		cost = 750000,
		mileage = 0,
		quantity = 5,
		dm = 1.8,
		wheels = "rwd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
	[8] = {
		model = 542,
		x = 1107.0247802734, y = -320.87109375, z= 73.735000610352, rx = 0, ry = 0, rz = 0,
		r = 100, g = 150, b = 100,
		cost = 21250,
		mileage = 21231,
		quantity = 5,
		dm = 1.6,
		wheels = "fwd",
		vtype = "Osobowy",
		fuel_type = "Benzyna",
		spawn = "cygan_02"
	},
	[9] = {
		model = 411,
		x = 2463.4255371094, y = -1746.1311035156, z= 13.600487709045, rx = 0, ry = 0, rz = 220,
		r = 100, g = 150, b = 100,
		cost = 2000000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "awd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},

	[10] = {
		model = 506,
		x = 2482.2846679688, y = -1764.5006103516, z= 18.878002166748, rx = 0, ry = 0, rz = 220-180,
		r = 100, g = 150, b = 100,
		cost = 400000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},

	[11] = {
		model = 559,
		x = 2512.9353027344, y = -1755.7598876953, z= 18.82967376709, rx = 0, ry = 0, rz = 220-180,
		r = 100, g = 150, b = 100,
		cost = 250000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},

	[12] = {
		model = 415,
		x = 2463.166015625, y = -1752.9644775391, z= 18.943822860718, rx = 0, ry = 0, rz = 230,
		r = 100, g = 150, b = 100,
		cost = 600000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
	[13] = {
		model = 429,
		x = 2464.0607910156, y = -1764.5091552734, z= 13.59531211853, rx = 0, ry = 0, rz = 320,
		r = 100, g = 150, b = 100,
		cost = 1250000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},

	[13] = {
		model = 402,
		x = 2505.8120117188, y = -1756.1164550781, z= 19.17343711853, rx = 0, ry = 0, rz = 220-180,
		r = 100, g = 150, b = 100,
		cost = 250000,
		mileage = 0,
		quantity = 5,
		dm = 2.0,
		wheels = "rwd",
		vtype = "Sportowy",
		fuel_type = "Benzyna",
		spawn = "salon_grove"
	},
}
local spawnPositions = {
	["cygan_01"] = {-68.10546875, -1590.931640625, 2.7179988384247, 359.33532714844, 359.82971191406, 223.43994140625},
	["cygan_02"] = {1098.6376953125, -306.55825805664, 73.735763549805, 359.33532714844, 359.82971191406, -90},
	["salon_grove"] = {2454.9389648438, -1764.6142578125, 13.238087654114, 0,0,90}
}

for k,v in pairs(spawnPositions) do
	createBlip(v[1], v[2], v[3], 55, 2, 255, 255, 255, 255, 0, 250)
end

for k,v in pairs(salons) do
	local id = #salonVehicles+1
	salonVehicles[id] = createVehicle(v.model, v.x, v.y, v.z, v.rx, v.ry, v.rz)
	local handling = getModelHandling(v.model)
	setElementData(salonVehicles[id], "vehicle:salon", true)
	setElementFrozen(salonVehicles[id], true)
	setVehicleDamageProof(salonVehicles[id], true)
	setVehicleColor(salonVehicles[id], v.r, v.g, v.b)
	local text = createElement("3dtext")
	setElementPosition(text, v.x, v.y, v.z+1.5)
	setElementData(text, "3dtext", "#0090ff" .. getVehicleNameFromModel(v.model) .. "\n#ff00ff$" .. v.cost .. "\n#ffffffPrzebieg: " .. v.mileage .. "km\nPozostałych sztuk: " .. v.quantity)
	local marker = createColSphere(v.x, v.y, v.z, 4)
	setElementData(marker, "vehicle:buy", id)
	setElementData(marker, "vehicle:buy:dm", v.dm)
	setElementData(marker, "vehicle:buy:name", getVehicleNameFromModel(v.model))
	setElementData(marker, "vehicle:buy:cost", v.cost)
	setElementData(marker, "vehicle:buy:text", text)
	setElementData(marker, "vehicle:buy:class", exports["pd-vehicles"]:getModelClass(v.model))
	setElementData(marker, "vehicle:buy:type", v.vtype)
	setElementData(marker, "vehicle:buy:model", v.model)
	setElementData(marker, "vehicle:buy:wheels", string.upper(v.wheels))
	setElementData(marker, "vehicle:buy:fuel_type", v.fuel_type)
	setElementData(marker, "vehicle:buy:max_velocity", math.floor(handling["maxVelocity"]))
	setElementData(marker, "vehicle:buy:spawn_position", spawnPositions[v.spawn])
	setElementData(marker, "vehicle:buy:color", {v.r, v.g, v.b})
	setElementData(marker, "vehicle:buy:mileage", v.mileage)
	setElementData(marker, "vehicle:buy:quantity", v.quantity)
	setElementData(salonVehicles[id], "marker:info", marker)
end

setTimer(function()
	for k,v in pairs(salonVehicles) do
		local marker = getElementData(v, "marker:info")
		local q = getElementData(marker, "vehicle:buy:quantity") + 1
		if q < 5 then
			local model = getElementData(marker, "vehicle:buy:model")
			local cost = getElementData(marker, "vehicle:buy:cost")
			local mileage = getElementData(marker, "vehicle:buy:mileage")
			setElementData(marker, "vehicle:buy:quantity", q)
			setElementData(getElementData(marker, "vehicle:buy:text"), "3dtext", "#0090ff" .. getVehicleNameFromModel(model) .. "\n#ff00ff$" .. cost .. "\n#ffffffPrzebieg: " .. mileage .. "km\nPozostałych sztuk: " .. q)
		end
	end
end, 1000 * 60 * 10, 0)

addEventHandler("onVehicleStartEnter", root, function()
	if getElementData(source, "vehicle:salon") then
		cancelEvent()
	end
end)

buyTick = {}

addEvent("buyCar", true)
addEventHandler("buyCar", resourceRoot, function(plr, data)
	if not buyTick[plr] then buyTick[plr] = getTickCount() - 100 end
	if buyTick[plr] < getTickCount() then
		buyTick[plr] = getTickCount() + 10000
		exports["pd-hud"]:showPlayerNotification(plr, "Zakupiłeś pojazd " .. data.name .. "!", "success", 5000, nil, "success")
		exports["pd-core"]:takeMoney(plr, data.cost)
		result, rows, last_id = exports["pd-mysql"]:query("INSERT INTO `pd-vehicles`(`model`, `owner`, `color`, `variant`, `position`, `damage`, `last_driver`, `fuel_type`, `fuel`, `dm`, `mileage`, `tuning`, `addTuning`, `paintjob`, `spawned`, `wheels`, `buyCost`) VALUES (?, ?, ?, ?, ?, ?, 0, ?, 10, ?, ?, ?, ?, ?, 1, ?, ?)", data.model, getElementData(plr, "player:uid"), getStringFromTable(data.color), "0 0", getStringFromTable(data.spawnPosition), "1000", data.fuel_type, data.dm, data.mileage, "", "", 3, data.wheels, data.cost)
		q = exports["pd-mysql"]:query('SELECT * FROM `pd-vehicles` WHERE `vid`=' .. last_id)
		data2 = q[1]
		id, veh = exports["pd-vehicles"]:loadVehicle(data2)
		warpPedIntoVehicle(plr, veh)
		setElementData(data.marker, "vehicle:buy:quantity", data.quantity - 1)
		setElementData(data.text, "3dtext", "#0090ff" .. getVehicleNameFromModel(data.model) .. "\n#ff00ff$" .. data.cost .. "\n#ffffffPrzebieg: " .. data.mileage .. "km\nPozostałych sztuk: " .. data.quantity-1)
		exports["pd-mysql"]:query("INSERT INTO `pd_logs_sell`(`type`, `from`, `to`, `value`) VALUES (?,?,?,?)","Pojazd (Salon)", "Salon Samochodowy", getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", "$"..data.cost )
	end
end)

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