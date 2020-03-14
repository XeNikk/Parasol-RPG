virtual = {
    [1] = {
        hide = {279.49481201172, 1342.9560546875, 10.5859375},
    },
    [2] = {
        hide = {1675.7258300781, -1122.4180908203, 23.90625},
    },
    [3] = {
        hide = {1081.5009765625, -1759.4609375, 13.379904747009},
    },
}

cmarkers = {}
strefy = {}

for i,v in pairs(virtual) do 

    cmarkers[#cmarkers + 1] = exports["pd-markers"]:createCustomMarker(v.hide[1], v.hide[2], v.hide[3] - 0.2, 214, 10, 232, 155, "store_car", 3)
    col = createColSphere(v.hide[1], v.hide[2], v.hide[3], 3)
    setElementData(col, "virtual:parking", i)
    napis = createElement("3dtext")
    setElementPosition(napis, v.hide[1], v.hide[2], v.hide[3])
    setElementData(napis, "3dtext", "Parking wirtualny")
        
   -- strefy[#strefy + 1] = createColCuboid(v.col[1], v.col[2], v.col[3], v.col[4], v.col[5], v.col[6])

end

addEventHandler("onClientColShapeHit", resourceRoot, function(plr, dim)
    if plr == localPlayer then
    if not getElementData(source, "virtual:parking") then return end
    if not isPedInVehicle(localPlayer) then
    triggerServerEvent("virtualParking:getCars", localPlayer, localPlayer, getElementData(source, "virtual:parking"))
    else
    triggerServerEvent("virtualParking:warpVehicleToParking", localPlayer, getPedOccupiedVehicle(localPlayer), getElementData(source, "virtual:parking"))
    exports["pd-hud"]:addNotification("Schowałeś pojazd do parkingu wirtualnego.", "success", 5000, nil, "success")
    end
    end
end)


addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(cmarkers) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
	end
end)


addEvent("add:noti", true)
addEventHandler("add:noti", root, function(type, text)
    exports["pd-hud"]:addNotification(text, type, 5000, nil, type)
end)