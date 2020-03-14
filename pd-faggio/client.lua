setElementData(localPlayer, "player:rent:public:car", false)

addEventHandler("onClientVehicleStartEnter", root, function(player, seat, door)
	if seat == 0 and player == localPlayer and getElementData(source, "vehicle:public") then
		owner = getElementData(source, "vehicle:public:owner")
		if owner and owner ~= player then
			cancelEvent()
		end
		rented = getElementData(player, "player:rent:public:car")
		if rented and rented ~= source then
			cancelEvent()
		end
	end
end)

addEventHandler("onClientVehicleExit", root, function(player, seat)
	if seat == 0 and player == localPlayer and getElementData(source, "vehicle:public") then
		exports["pd-hud"]:addNotification("Wyszedłeś z publicznego pojazdu, jeśli do niego nie wrócisz w ciągu 60 sekund, zniknie.", "info", nil, 5000, "info")
	end
end)