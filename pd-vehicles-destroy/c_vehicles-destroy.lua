zlomy = {
    {2188.060546875, -1985.7674560547, 13.550609588623},
}
for i,v in pairs(zlomy) do 
	zlomy[i] = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3]-0.2, 169, 97, 0, 200, "store_car", 2)
	marker = createMarker(v[1], v[2], v[3]-0.95, "cylinder", 5, 0,0,0,0)
	createBlip(v[1], v[2], v[3], 44,0,0,0,0,0,0,250)
end

function confirmation()

exports["pd-gui"]:renderConfirmationWindow(okienko)

end

addEventHandler("onClientMarkerHit", resourceRoot, function(plr, dim)
    if plr == localPlayer then 
        if isPedInVehicle(localPlayer) then 
            if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:owner") == getElementData(localPlayer, "player:uid") then 
                local vehicle = getPedOccupiedVehicle(localPlayer)
                local money = getElementData(vehicle, "vehicle:buyCost")*0.1
            addEventHandler("onClientRender", root, confirmation)
            showCursor(true)
            okienko = exports["pd-gui"]:createConfirmationWindow("Czy chcesz zezłomować ten pojazd za\n$"..math.floor(money).."?")
            addEventHandler("onClientAcceptConfirmation", okienko, function()
                exports["pd-gui"]:destroyConfirmationWindow(okienko)
                exports["pd-hud"]:addNotification("Zezłomowałeś pojazd. Otrzymujesz $"..math.floor(money).."", "info", 5000, nil, "info")
                triggerServerEvent("vehicleDestroy:onClientAccept", localPlayer, localPlayer, vehicle, math.floor(money))
                showCursor(false)
                removeEventHandler("onClientRender", root, confirmation)
			end)
			addEventHandler("onClientDenyConfirmation", okienko, function()
                exports["pd-gui"]:destroyConfirmationWindow(okienko)
                showCursor(false)
                removeEventHandler("onClientRender", root, confirmation)
			end)


            end
        end
    end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(plr, dim)
if localPlayer == plr then 
    exports["pd-gui"]:destroyConfirmationWindow(okienko)
    showCursor(false)
    removeEventHandler("onClientRender", root, confirmation)
end
end)


addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in ipairs(zlomy) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
    end
    exports["pd-gui"]:destroyConfirmationWindow(okienko)
end)

