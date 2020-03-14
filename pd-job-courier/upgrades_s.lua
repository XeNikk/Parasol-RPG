--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Virelox <virelox@gmail.com>
	# @filename: c.lua
	# @description: Praca kuriera - dodawanie ulepszeń
	# All rights reserved.
	##########################################################
--]]

addEvent("onPlayerBuyUpgrade", true)
addEventHandler("onPlayerBuyUpgrade", resourceRoot, function(id, cost)
	if exports["pd-jobsettings"]:addPlayerJobUpgrade(client, "courier", id, cost) then 
		if id == "shotgun" then 
			giveWeapon(client, 25, 9999)
		elseif id == "infrared" then 
			giveWeapon(client, 45, 1)
		elseif id == "stealth" then 
			setElementModel(client, 29)
		end 
		
		exports["pd-hud"]:showPlayerNotification(client, "Zakupiono ulepszenie pomyślnie.", "success")
	else 
		exports["pd-hud"]:showPlayerNotification(client, "Nie stać cię na to ulepszenie.", "error")
	end
end)