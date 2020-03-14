function isPlayerAchievementGet(player, achievement)
	data = getElementData(player, "player:achievements")
	if data[achievement] then
		return true
	else
		return false
	end
end

function addPlayerAchievement(player, achievement, rp)
	if isPlayerAchievementGet(player, achievement) then return end
	data = getElementData(player, "player:achievements")
	data[achievement] = true
	setElementData(player, "player:achievements", data)
	setElementData(player, "player:rp", tonumber(getElementData(player, "player:rp")) + rp)
	triggerEvent("achievements:draw",player, achievement, rp)
end
addEvent("ach:addPlayerAchievement", true)
addEventHandler("ach:addPlayerAchievement", root, addPlayerAchievement)

addCommandHandler("hania", function(cmd)
	addPlayerAchievement(localPlayer, "Haker pseudoli", 5)
end)

addCommandHandler("walisz", function(cmd)
	addPlayerAchievement(localPlayer, "Udobruchaj barabasza", 5)
end)