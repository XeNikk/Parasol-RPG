--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Virelox <virelox@gmail.com>
	# @filename: s.lua
	# @description: Praca kuriera - strona serwera
	# All rights reserved.
	##########################################################
--]]
addEvent("onPlayerGetTopData", true)
addEvent("onPlayerStartJob", true)
addEvent("onPlayerEndJob", true)
addEvent("createCourierVehicle", true)
addEvent("destroyCourierVehicle", true)
addEvent("attachPackageToPlayer", true)
addEvent("giveRewardForCourier", true)
addEvent("startJobCourierServer", true)

vehicles = {}
packages = {}

local place = 1


addEventHandler("startJobCourierServer", resourceRoot, function()
	if client and source == resourceRoot then 
		if place == 1 then
			place = 2 
		else
			place = 1
		end
		triggerClientEvent(client, "startJobCourier", resourceRoot, place)
	end
end)

addEventHandler("attachPackageToPlayer", resourceRoot, function(delete)
	if client and source == resourceRoot then 
		if delete then
			setPedAnimation(client)
			if packages[client] then 
				destroyElement(packages[client])
				packages[client] = false
			end
			toggleControl(client, "jump", true)
			toggleControl(client,"walk", true)
			toggleControl(client, "crouch", true)
			return
		end
		
		if packages[client] then
			setPedAnimation(client)
			destroyElement(packages[client])
			packages[client] = false
			toggleControl(client, "jump", true)
			toggleControl(client,"walk", true)
			toggleControl(client, "crouch", true)
			setPedAnimation(client, "CARRY", "liftup105", -1, false, true, false, false)
			setTimer(function(player)
				setPedAnimation(player, "ped", "facanger", 50, true, true, true, true)
			end, 500, 1, client)
		else
			local x,y,z = getElementPosition(client)
			setPedAnimation(client, "CARRY", "liftup105", -1, false, true, false, false)
			setTimer(function(player)
				setPedAnimation(player, "CARRY", "crry_prtial", 0, true, true, false, true)
			end, 500, 1, client)
			packages[client] = createObject(3013, x, y, z)
			setElementCollisionsEnabled(packages[client], false)
			exports["bone_attach"]:attachElementToBone(packages[client], client,10, 0.1,0.2,0.3,-90,-10,0)
			toggleControl(client, "jump", false)
			toggleControl(client,"walk", false)
			toggleControl(client, "crouch", false)
		end
	end
end)

addEventHandler("giveRewardForCourier", resourceRoot, function(tip)
	if client and source == resourceRoot then 
		if tip then
			local reward = math.floor(exports["pd-jobsettings"]:getJobData("courier", "tip_reward")*exports["pd-jobsettings"]:getJobData("courier", "boost"))
			exports["pd-core"]:pd_givePlayerMoney(client, tonumber(reward), true)		
		else
			local reward = math.floor(exports["pd-jobsettings"]:getJobData("courier", "reward")*exports["pd-jobsettings"]:getJobData("courier", "boost"))
			exports["pd-core"]:giveMoney(client, tonumber(reward), true)
		end
		exports["pd-jobsettings"]:addPlayerTopData(client, "courier", 1)
		exports["pd-jobsettings"]:addPlayerJobUpgradePoints(client, "courier", 1)
	end
end)

addEventHandler("createCourierVehicle", resourceRoot, function(place)
	if client and source == resourceRoot then 
		fadeCamera(client, false, 1, 0, 0, 0)
		
		setTimer ( function(player)
			if place == 1 then
				vehicles[player] = createVehicle(498, 2176.3544921875, -2267.8232421875, 13.473161697388, 0, 0, 226)
			else
				vehicles[player] = createVehicle(498, 2162.5498046875, -2283.4951171875, 13.494827270508, 0, 0, 226)
			end
			addEventHandler("onVehicleStartEnter", vehicles[player], function(p)
				if p ~= player then 
					cancelEvent() 
				end
			end)
			
			exports["pd-core"]:toggleElementGhostmode(vehicles[player], true)
			setVehicleColor(vehicles[player], 245, 245, 245, 245, 245, 245)
			warpPedIntoVehicle(player, vehicles[player])
			setElementAlpha(vehicles[player], 255)
			triggerClientEvent(player, "prepareToDrive", resourceRoot, vehicles[player])
			fadeCamera(player, true, 1, 0, 0, 0)
		end, 2000, 1, client )
	end
end)

addEventHandler("destroyCourierVehicle", resourceRoot, function()
	if client and source == resourceRoot then 
		if isElement(vehicles[client]) then destroyElement(vehicles[client]) end
	end
end)

addEventHandler("onPlayerGetTopData", resourceRoot, function()
	if client and source == resourceRoot then 
		local data = exports["pd-jobsettings"]:getTopJobData("courier")
		triggerClientEvent(client, "onClientGetTopData", resourceRoot, data)
	end
end)

addEventHandler("onPlayerStartJob", resourceRoot, function()
	if client and source == resourceRoot then 		
		setElementData(client, "player:job", "courier")
		exports["pd-core"]:toggleElementGhostmode(client, true)
	end
end)

addEventHandler("onPlayerEndJob", resourceRoot, function()
	if client and source == resourceRoot then 
		setElementData(client, "player:job", false)
		setElementModel(client, getElementData(client, "player:skin"))
		exports["pd-core"]:toggleElementGhostmode(client, false)
		
		setTimer ( function(player)
			if getPedOccupiedVehicle(player) then
				removePedFromVehicle(player)
			end
			setElementPosition(player, 2145.5085449219, -2277.8713378906, 14.780630111694)
			setElementRotation(player, 0, 0, 42)
		end, 2000, 1, client)

	end
end)

addEventHandler("onResourceStart", resourceRoot, function()

end)

addEventHandler ( "onPlayerQuit", getRootElement(), function()
	if vehicles[source] and isElement(vehicles[source]) then destroyElement(vehicles[source]) end
	if packages[source] and isElement(packages[source]) then destroyElement(packages[source]) end
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:job") == "courier" then 
			setElementData(v, "player:job", false)
			setElementModel(v, getElementData(v, "player:skin"))
			exports["pd-core"]:toggleElementGhostmode(v, false)
			
			if getPedOccupiedVehicle(v) then
				removePedFromVehicle(v)
			end
			setElementPosition(v, 2145.5085449219, -2277.8713378906, 14.780630111694)
			setElementRotation(v, 0, 0, 42)
			exports["pd-hud"]:showPlayerNotification(v, "Praca w której pracowałeś została przeładowana przez administrację. Przepraszamy za utrudnienia.", "error", 15000)
		end
	end
end)