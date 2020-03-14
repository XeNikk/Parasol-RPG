storeTable = {
	[1] = {1348.017578125, -1556.30078125, 13.53, 0,0,260},
	[2] = {760.171875, -1365.3828125, 13.53, 0.0, 0.0, 270.0},
	[3] = {738.7978515625, -1337.2783203125, 13.53, 0.0, 0.0, 270.0}
}

function getCars(plr)
	carsTable = {}
	local q = exports['pd-mysql']:query("SELECT * FROM `pd-vehicles` WHERE `owner`=? and `spawned`=0 and `virtualparking`=0", getElementData(plr, "player:uid"))
	if #q == 0	then return end
	for i = 1, #q do
		table.insert(carsTable, {model = q[i]["model"],	klasa = exports["pd-vehicles"]:getModelClass(q[i]["model"]), id = q[i]["vid"], przeb = q[i]["mileage"], poj = q[i]["dm"], typ = "sportowe", naped = q[i]["wheels"], typpaliwa = q[i]["fuel_type"], color = q[i]["color"], addTune = q[i]["addTuning"], tuning = q[i]["tuning"], up = 0})
	end
	triggerClientEvent(plr, "przecho:start", plr, carsTable)
end
addEvent("przecho:getCars", true)
addEventHandler("przecho:getCars", root, getCars)

function spawnCar(plr, vehid, id, model)
	local canSpawn = true
	for k,v in pairs(getElementsByType("vehicle")) do
		if getDistanceBetweenPoints3D(storeTable[id][1], storeTable[id][2], storeTable[id][3], Vector3(getElementPosition(v))) < 5 then
			canSpawn = false
		end
	end
	if not canSpawn then
		return triggerClientEvent(plr, "przecho:cantSpawn", plr)
	else
		local veh = exports["pd-vehicles"]:spawnCar(vehid, unpack(storeTable[id]))
		warpPedIntoVehicle(plr, veh)
		return triggerClientEvent(plr, "przecho:canSpawn", plr, model)
	end
end
addEvent("przecho:spawnCar", true)
addEventHandler("przecho:spawnCar", root, spawnCar)

function storeCar(plr, vehid)
	local veh = exports["pd-vehicles"]:saveVehicle(vehid, true)
end
addEvent("przecho:storeCar", true)
addEventHandler("przecho:storeCar", root, storeCar)