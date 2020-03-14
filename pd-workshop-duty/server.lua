skinPickup = createPickup(894.58929443359, -1175.2818603516, 17, 3, 1275, 1)

addEventHandler("onPlayerPickupHit", root, function(pickup)
	if pickup == skinPickup then
		if getElementData(source, "player:workshop:duty") then
			local minutes = getElementData(source, "player:workshop:duty")
			if tonumber(minutes) then
				exports["pd-core"]:giveMoney(source, minutes * 60)
				exports["pd-hud"]:showPlayerNotification(source, "Za " .. minutes .. " minut służby otrzymujesz $" .. minutes * 60, "success")
			end
			setElementData(source, "player:workshop:duty", false)
			setElementModel(source, getElementData(source, "player:skin"))
		else
			setElementModel(source, 129)
			setElementData(source, "player:workshop:duty", 0)
		end
	end
end)

setTimer(function()
	for k,v in pairs(getElementsByType("player")) do
		if getElementData(v, "player:workshop:duty") and not getElementData(v, "player:afk") then
			local x, y, z = getElementPosition(v)
			if getDistanceBetweenPoints3D(x, y, z, 894.58929443359, -1175.2818603516, 17, 3, 1275) < 100 then
				setElementData(v, "player:workshop:duty", getElementData(v, "player:workshop:duty") + 1)
			end
		end
	end
end, 60 * 1000, 0)