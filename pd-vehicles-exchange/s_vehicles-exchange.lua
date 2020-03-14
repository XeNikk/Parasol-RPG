freeSlots = {
    ["Los Santos"] = {
        {2327.4, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2324.5, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2321.6, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2318.7, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2315.8, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2312.9, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2310.0, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2307.1, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2304.2, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2301.3, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2298.4, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2295.5, -1998.65312321, 13.42168712616, 0, 0, 180},

        {2278.1, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2275.2, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2272.3, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2269.4, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2266.5, -1998.65312321, 13.42168712616, 0, 0, 180},

        {2249.1, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2246.2, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2243.3, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2240.4, -1998.65312321, 13.42168712616, 0, 0, 180},
        {2237.5, -1998.65312321, 13.42168712616, 0, 0, 180},

        {2327.4, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2324.5, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2321.6, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2318.7, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2315.8, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2312.9, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2310.0, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2307.1, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2304.2, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2301.3, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2298.4, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2295.5, -1992.3572998047, 13.42168712616, 0, 0, 0},

        {2278.1, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2275.2, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2272.3, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2269.4, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2266.5, -1992.3572998047, 13.42168712616, 0, 0, 0},

        {2249.1, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2246.2, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2243.3, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2240.4, -1992.3572998047, 13.42168712616, 0, 0, 0},
        {2237.5, -1992.3572998047, 13.42168712616, 0, 0, 0},
    }
}

colshapes = {}
texts = {}

function freezeVehicle(vehicle)
    setElementFrozen(vehicle, true)
end

addEvent("exchange:addVehicle", true)
addEventHandler("exchange:addVehicle", root, function(plr,owner, vehicle, exchange, price, vehicle, sprzedajacy)
    freeSlot = false
    for k,v in pairs(freeSlots[exchange]) do
        isFree = true
        for _,veh in pairs(getElementsByType("vehicle")) do
            x, y, z = getElementPosition(veh)
            if getDistanceBetweenPoints3D(v[1], v[2], v[3], x, y, z) < 2 then
                if isFree then
                    isFree = false
                end
            end
        end
        if isFree then
            freeSlot = v
        end
    end
    if freeSlot then
        setElementPosition(vehicle, freeSlot[1], freeSlot[2], freeSlot[3])
        setElementRotation(vehicle, freeSlot[4], freeSlot[5], freeSlot[6])
        setTimer(freezeVehicle, 1000, 1, vehicle)
        removePedFromVehicle(plr)
        colshapes[getElementData(vehicle, "vehicle:vid")] = createColSphere(freeSlot[1], freeSlot[2], freeSlot[3], 3.5)
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:vid", getElementData(vehicle, "vehicle:vid"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:model", getElementModel(vehicle))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:mileage", getElementData(vehicle, "vehicle:mileage"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:dm", getElementData(vehicle, "vehicle:dm"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:fuel:type", getElementData(vehicle, "vehicle:fuel:type"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:naped", getElementData(vehicle, "vehicle:naped"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:class", exports["pd-vehicles"]:getModelClass(getElementModel(vehicle)))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:price", price)
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:owner", owner)
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:owner:uid", getElementData(owner, "player:uid"))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:sprzedajacy", getPlayerName(sprzedajacy))
        setElementData(colshapes[getElementData(vehicle, "vehicle:vid")], "exchange:vehicle", vehicle)
        setElementData(vehicle, "vehicle:exchange", true)

        texts[getElementData(vehicle, "vehicle:vid")] = createElement("3dtext")
    	setElementPosition(texts[getElementData(vehicle, "vehicle:vid")], freeSlot[1], freeSlot[2], freeSlot[3]+1.5)
        setElementData(texts[getElementData(vehicle, "vehicle:vid")], "3dtext", "#0090ff" .. getVehicleNameFromModel(getElementModel(vehicle)) .. " (ID: "..getElementData(vehicle, "vehicle:vid")..")  \n#ff00ff$" .. tonumber(price) .. "\n#ffffffWłaściciel: " .. getPlayerName(owner) .. "")
        triggerClientEvent(plr, "exchange:noti", plr, plr, "success", "Wystawiłeś pojazd na giełdę pomyślnie!")
    else
        triggerClientEvent(plr, "exchange:noti", plr, plr, "error", "Nie ma wolnych miejsc na giełdzie!")
    end
end)

addEventHandler("onColShapeHit", resourceRoot, function(plr,dim)
    if getElementType(plr) == "player" then 
        if not isPedInVehicle(plr) then 
            triggerClientEvent(plr, "exchange:previewOpen", plr, plr, getElementData(source, "exchange:owner"), getElementData(source, "exchange:vid"), getElementData(source, "exchange:model"), getElementData(source, "exchange:mileage"), getElementData(source, "exchange:dm"), getElementData(source, "exchange:fuel:type"),getElementData(source, "exchange:naped"),getElementData(source, "exchange:class"), getElementData(source, "exchange:vehicle"), getElementData(source, "exchange:price"), getElementData(source, "exchange:sprzedajacy"), getElementData(source, "exchange:owner:uid"))
        end
    end
end)

addEventHandler("onColShapeLeave", resourceRoot, function(plr,dim)
    if getElementType(plr) == "player" then 
    if not isPedInVehicle(plr) then 
        triggerClientEvent(plr, "exchange:previewClose", plr, plr)
    end
    end
end)

addEvent("exchange:removeVehicle", true)
addEventHandler("exchange:removeVehicle", root, function(plr,vehicle)
    for i,v in pairs(getElementsWithinColShape(colshapes[getElementData(vehicle, "vehicle:vid")])) do 
        if i == 0 then return end
        triggerClientEvent(v, "exchange:previewClose", v, v)
    end

    warpPedIntoVehicle(plr, vehicle)
    setElementFrozen(vehicle, false)
    setElementData(vehicle, "vehicle:exchange", false)
    destroyElement(colshapes[getElementData(vehicle, "vehicle:vid")])
    destroyElement(texts[getElementData(vehicle, "vehicle:vid")])
    triggerClientEvent(plr, "exchange:previewClose", plr, plr)
end)

addEvent("exchange:buyVehicle", true)
addEventHandler("exchange:buyVehicle", root, function(plr,vehicle, price, sprzedawca)
    takePlayerMoney(plr, price)
    exports["pd-mysql"]:query("UPDATE `pd-vehicles` SET `owner`=? WHERE `vid`=?",getElementData(plr, "player:uid"), getElementData(vehicle, "vehicle:vid"))
    exports["pd-mysql"]:query("INSERT INTO `pd_logs_sell`(`type`, `from`, `to`, `value`) VALUES (?,?,?,?)","Pojazd (Giełda)", sprzedawca, getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", "$"..price )
    setElementData(vehicle, "vehicle:owner", getElementData(plr, "player:uid"))

    if getPlayerFromName(sprzedawca) then 
        givePlayerMoney(getPlayerFromName(sprzedawca), price)
        triggerClientEvent(getPlayerFromName(sprzedawca), "exchange:noti", getPlayerFromName(sprzedawca), getPlayerFromName(sprzedawca), "success", "Ktoś wykupił twój pojazd "..getVehicleName(vehicle)..".\nOtrzymujesz $"..tonumber(price).."! ")
        triggerClientEvent(plr, "exchange:noti", plr, plr, "success", "Zakupiłeś pojazd "..getVehicleName(vehicle).." za cenę $"..tonumber(price)..".")
    else
        exports["pd-mysql"]:query("UPDATE `pd-players` SET `bank_money`=`bank_money`+? WHERE `nick`=?", price, sprzedawca)
        triggerClientEvent(plr, "exchange:noti", plr, plr, "success", "Zakupiłeś pojazd "..getVehicleName(vehicle).." za cenę $"..tonumber(price)..".")
    end
end)

addEventHandler("onVehicleStartEnter", root, function()
    if getElementData(source, "vehicle:exchange") == true then
        cancelEvent(true)
    end
end)
