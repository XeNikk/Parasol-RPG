addEvent("onPlayerGetTopData", true)
addEventHandler("onPlayerGetTopData", resourceRoot, function()
	if client and source == resourceRoot then 
		local data = exports["pd-jobsettings"]:getTopJobData("fabric")
		triggerClientEvent(client, "onClientGetTopData", resourceRoot, data)
	end
end)

function setComponentVisible(vehicle, part, boolean)
	triggerClientEvent(root, "setComponentVisible", root, vehicle, part, boolean)
end

function setVehicleVisibleTo(vehicle, player)
	setElementData(vehicle, "vehicle:build:owner", player)
	triggerClientEvent(root, "loadPlayerVehicle", root, vehicle)
end

addEvent("giveJobPoints", true)
addEventHandler("giveJobPoints", resourceRoot, function(plr)
	exports["pd-jobsettings"]:addPlayerTopData(client, "fabric", 1)
end)

addEvent("setSkin", true)
addEventHandler("setSkin", resourceRoot, function(plr, skin)
	setElementModel(plr, skin)
end)

addEvent("startJob", true)
addEventHandler("startJob", resourceRoot, function(plr)
	exports["pd-core"]:toggleElementGhostmode(plr, true)
end)

addEvent("endJob", true)
addEventHandler("endJob", resourceRoot, function(plr)
	exports["pd-core"]:toggleElementGhostmode(plr, false)
end)