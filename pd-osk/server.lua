local licenseVehicles = {}
local licenseObjects = {}
local licensePeds = {}
local tickCount = {}

local spawnLocation = {
	["A"] = {586, 1820.9, -2035.75, 13, 0, 0, 180, 7},
	["B"] = {401, 1820.9, -2035.75, 13.15, 0, 0, 180, 3},
	["C"] = {498, 1820.9, -2035.75, 13.45, 0, 0, 180, 4},
	["D"] = {437, 1820.9, -2035.75, 13.55, 0, 0, 180, 4},
}

function startLicense(player, category, cost)
	if not tickCount[player] then tickCount[player] = getTickCount() - 1000 end
	if tickCount[player] < getTickCount() then
		exports["pd-core"]:takeMoney(cost)
		licenseVehicles[player] = createVehicle(unpack(spawnLocation[category]))
		licenseObjects[player] = createObject(8607, 0, 0, 0)
		licensePeds[player] = createPed(115, 0, 0, 0)
		if category == "A" then
			attachElements(licenseObjects[player], licenseVehicles[player], -0.2, -1.35, 0.55)
		elseif category == "B" then
			attachElements(licenseObjects[player], licenseVehicles[player], -0.2, -0.4, 0.7)
		elseif category == "C" then
			attachElements(licenseObjects[player], licenseVehicles[player], -0.27, 0.5, 2.06)
			setObjectScale(licenseObjects[player], 1.5)
		elseif category == "D" then
			attachElements(licenseObjects[player], licenseVehicles[player], -0.27, 0.5, 2)
			setObjectScale(licenseObjects[player], 1.5)
		end
		exports["pd-core"]:toggleElementGhostmode(licenseVehicles[player], true)
		warpPedIntoVehicle(player, licenseVehicles[player])
		warpPedIntoVehicle(licensePeds[player], licenseVehicles[player], 1)
		setElementFrozen(licenseVehicles[player], true)
		setVehicleOverrideLights(licenseVehicles[player], 1)
		setVehicleEngineState(licenseVehicles[player], false)
		setVehicleColor(licenseVehicles[player], 0, 183, 255, 0, 183, 255)
		setVehicleHandling(licenseVehicles[player], "engineAcceleration", spawnLocation[category][8])
		triggerClientEvent(player, "startLicenseTest", player, category)
		tickCount[player] = getTickCount() + 10000
	end
end
addEvent("startLicense", true)
addEventHandler("startLicense", resourceRoot, startLicense)

addEvent("stopLicenseTest", true)
addEventHandler("stopLicenseTest", resourceRoot, function(player)
	if licenseVehicles[player] then
		exports["pd-core"]:toggleElementGhostmode(licenseVehicles[player], false)
		removePedFromVehicle(player)
		destroyElement(licenseVehicles[player])
		destroyElement(licenseObjects[player])
		destroyElement(licensePeds[player])
		setElementPosition(player, 1715.6591796875, -2065.45703125, 3.8579692840576)
	end
end)

addEventHandler("onPlayerQuit", root, function()
	if licenseVehicles[source] then
		destroyElement(licenseVehicles[source])
		destroyElement(licenseObjects[player])
		destroyElement(licensePeds[player])
	end
end)