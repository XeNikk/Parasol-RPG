local jobVehicles = {}

-- HANDLING --
local handling = getModelHandling(431)
for k,v in pairs (handling) do 
	setModelHandling(437, k, v)
end

setModelHandling(431, "engineAcceleration", 4)
setModelHandling(437, "engineAcceleration", 5)
setModelHandling(431, "maxVelocity", 60)
setModelHandling(437, "maxVelocity", 60)
-- -- -- -- --

addEvent("onPlayerGetTopData", true)
addEventHandler("onPlayerGetTopData", resourceRoot, function()
	if client and source == resourceRoot then 
		local data = exports["pd-jobsettings"]:getTopJobData("bus")
		triggerClientEvent(client, "onClientGetTopData", resourceRoot, data)
	end
end)

addEvent("onPlayerGetPoints", true)
addEventHandler("onPlayerGetPoints", resourceRoot, function()
	if client and source == resourceRoot then 
		local data = exports["pd-jobsettings"]:getPlayerTopData(client, "bus")
		triggerClientEvent(client, "onClientGetPoints", resourceRoot, data)
	end
end)

addEvent("startJob", true)
addEventHandler("startJob", resourceRoot, function(model, position)
	if client and source == resourceRoot then 
		jobVehicles[client] = createVehicle(model, position[1], position[2], position[3], position[4], position[5], position[6])
		setVehicleColor(jobVehicles[client], 72, 23, 25, 143, 110, 29)
		warpPedIntoVehicle(client, jobVehicles[client])
		exports["pd-core"]:toggleElementGhostmode(jobVehicles[client], true)
	end
end)

addEvent("giveJobPoints", true)
addEventHandler("giveJobPoints", resourceRoot, function(plr)
	exports["pd-jobsettings"]:addPlayerTopData(client, "bus", 1)
end)

function endJob(plr)
	if plr then client = plr end
	if client then 
		if jobVehicles[client] then
			destroyElement(jobVehicles[client])
			jobVehicles[client] = false
		end
	end
end
addEvent("endJob", true)
addEventHandler("endJob", resourceRoot, endJob)

addEventHandler("onResourceStop", resourceRoot, function()
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:job") == "bus" then 
			exports["pd-hud"]:showPlayerNotification(v, "Praca w której pracowałeś została przeładowana przez administrację. Przepraszamy za utrudnienia.", "error", 15000)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	endJob(source)
end)