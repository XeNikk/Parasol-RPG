function showPlayerNotification(player, text, category, sound, time, icon)
	if isElement(player) then 
		triggerClientEvent(player, "onClientAddNotification", resourceRoot, text, category, sound, time, icon)
	end
end 

function showGlobalNotification(text, category, sound, time, icon)
	triggerClientEvent(root, "onClientAddNotification", resourceRoot, text, category, sound, time, icon)
end 

function showAdminNotification(text, category, sound, time, icon)
	for k,v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:rank") > 0 then
			triggerClientEvent(v, "onClientAddNotification", resourceRoot, text, category, sound, time, icon)
		end
	end
end 
