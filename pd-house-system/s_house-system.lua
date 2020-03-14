
houses = {}
exits = {}
pickup = {}
texts = {}

function getHousePaid(id)
    query = exports["pd-mysql"]:query("SELECT * FROM `house` WHERE `id`=? AND `date`>NOW() LIMIT 1", id)
    if query and #query > 0 then 
        return true 
    else
        return false
    end
end


function getHouseFromID(id)
    return houses[id] 
end

function loadHouses()
    q = exports["pd-mysql"]:query("SELECT * FROM `house`")
    if q and #q > 0 then 
        for i,v in pairs(q) do

        local entpos = split(v["entrance"], ",")
        if getHousePaid(v["id"]) == true then 
            pickupmodel = 1272
            text = "Dom gracza #ff00ff "..v["ownername"].. ""
        else 
            pickupmodel = 1273
            text = "Wolny dom"
        end

        pickup[v["id"]] = createPickup(entpos[1], entpos[2], entpos[3], 3, pickupmodel, 0)
        houses[v["id"]] = createColSphere(entpos[1], entpos[2], entpos[3], 1)
        texts[v["id"]] = createElement("3dtext")
        setElementPosition(texts[v["id"]], entpos[1], entpos[2], entpos[3]+0.5)
        setElementData(texts[v["id"]], "3dtext", text)
        
        if getHousePaid(v["id"]) == true then 
            free = false
        else 
            free = true
        end

        data = {
            ["id"] = v["id"],
            ["name"] = v["name"],
            ["owner"] = v["owner"],
            ["occupants"] = v["occupants"],
            ["ownername"] = v["ownername"],
            ["paid"] = v["date"],
            ["free"] = free,
            ["state"] = v["open"],
            ["price"] = v["price"],
            ["pricePP"] = v["pricePP"],
            ["interior"] = v["interior"],
            ["entrance"] = v["entrance"],
            ["entranceTP"] = v["warpEntrance"]
            }
        setElementData(houses[v["id"]], "house:data", data)   

        local exitpos = split(v["exithouse"], ",")
        exits[v["id"]] = createMarker(exitpos[1], exitpos[2], exitpos[3]-0.95, "cylinder", 1)
        setElementInterior(exits[v["id"]], v["interior"])
        setElementDimension(exits[v["id"]], v["id"])

        exit_data = {
            ["id"] = v["id"],
            ["exitpos"] = v["entrance"]
        }
        setElementData(exits[v["id"]], "house:dataExit", exit_data)   
        end
    end
    outputDebugString("Załadowano "..#q.." domków.")
end

loadHouses()


function reloadHouse(id)
    q = exports["pd-mysql"]:query("SELECT * FROM `house` WHERE `id`=?", id)
    for i,v in pairs(q) do

        if isElement(pickup[id]) then 
            destroyElement(pickup[id])
            destroyElement(texts[id])
        end
        if getHousePaid(v["id"]) == true then 
            pickupmodel = 1272
            text = "Dom gracza #ff00ff "..v["ownername"].. ""
        else 
            pickupmodel = 1273
            text = "Wolny dom"
        end
        local entpos = split(v["entrance"], ",")
        pickup[v["id"]] = createPickup(entpos[1], entpos[2], entpos[3], 3, pickupmodel, 0)
        texts[v["id"]] = createElement("3dtext")
        setElementPosition(texts[v["id"]], entpos[1], entpos[2], entpos[3]+0.5)
        setElementData(texts[v["id"]], "3dtext", text)

        if getHousePaid(v["id"]) == true then 
            free = false
        else 
            free = true
        end

        newdata = {
            ["id"] = v["id"],
            ["name"] = v["name"],
            ["owner"] = v["owner"],
            ["ownername"] = v["ownername"],
            ["occupants"] = v["occupants"],
            ["paid"] = v["date"],
            ["free"] = free,
            ["state"] = v["open"],
            ["price"] = v["price"],
            ["pricePP"] = v["pricePP"],
            ["interior"] = v["interior"],
            ["entrance"] = v["entrance"],
            ["entranceTP"] = v["warpEntrance"]
            }
            setElementData(houses[v["id"]], "house:data", newdata)  
    end
end

function checkHouseAffiliation(plr, id)
    if getHousePaid(id) then 
        triggerClientEvent(plr, "house:openGUI", plr, "main")
    else
        triggerClientEvent(plr, "house:openGUI", plr, "free")
    end
end


function enterHouse(plr, x,y,z, dim, int)
    setElementPosition(plr, x,y,z) 
    setElementInterior(plr, int)
    setElementDimension(plr, dim)
end

function setHouseClosed(id, state)
    exports["pd-mysql"]:query("UPDATE `house` SET `open`=? WHERE `id`=?", state, id)
end

function validityUpdate(id, owner, price, payment)
    if payment == "PP" then
        setElementData(owner, "player:saldoPP", getElementData(owner, "player:saldoPP")-price) 
        exports["pd-mysql"]:query("UPDATE `house` SET `owner`=?, `ownername`=?, date=date + interval 7 day WHERE `id`=?", getElementData(owner, "player:uid"), getPlayerName(owner), id)
    else
        takePlayerMoney(owner, price)
        exports["pd-mysql"]:query("UPDATE `house` SET `owner`=?, `ownername`=?, date=date + interval 7 day WHERE `id`=?", getElementData(owner, "player:uid"), getPlayerName(owner), id)
    end
end

function buyHouse(id, owner, price, payment)
    if payment == "PP" then
        setElementData(owner, "player:saldoPP", getElementData(owner, "player:saldoPP")-price) 
        exports["pd-mysql"]:query("UPDATE `house` SET `owner`=?, `ownername`=?, date=NOW() + interval 7 day WHERE `id`=?", getElementData(owner, "player:uid"), getPlayerName(owner), id)
    else
        takePlayerMoney(owner, price)
        exports["pd-mysql"]:query("UPDATE `house` SET `owner`=?, `ownername`=?, date=NOW() + interval 7 day WHERE `id`=?", getElementData(owner, "player:uid"), getPlayerName(owner), id)
    end
end

function sellHouse(id, owner, price)
    givePlayerMoney(owner, price)
    exports["pd-mysql"]:query("UPDATE `house` SET date=date - interval 999 day WHERE `id`=?", id)
    reloadHouse(id)
end

function editOccupants(id, table)
    exports["pd-mysql"]:query("UPDATE `house` SET `occupants`=? WHERE `id`=?", table, id)
    reloadHouse(id)
end

addEventHandler("onMarkerHit", resourceRoot, function(plr, md)
    if getElementDimension(source) == getElementDimension(plr) then
    data = getElementData(source, "house:dataExit")
    exitpos = split(data["exitpos"], ",")
    fadeCamera(plr, false)

    setTimer(function()
        setElementPosition(plr, exitpos[1], exitpos[2], exitpos[3])
        setElementInterior(plr, 0)
        setElementDimension(plr, 0)
        fadeCamera(plr, true)
    end, 2000, 1)
end
end)

--Sprawdza czy dom jest opłacony
addEvent("house:getHousePaid", true)
addEventHandler("house:getHousePaid", root, getHousePaid)
--Odświeża dane o domku
addEvent("house:reloadHouse", true)
addEventHandler("house:reloadHouse", root, reloadHouse)
--Wchodzi do domku
addEvent("house:enterHouse", true)
addEventHandler("house:enterHouse", root, enterHouse)
--Ustawia stan zamka w domu
addEvent("house:setHouseClosed", true)
addEventHandler("house:setHouseClosed", root, setHouseClosed)
--Przedłużenie ważności domu
addEvent("house:validityUpdate", true)
addEventHandler("house:validityUpdate", root, validityUpdate)
--Sprzedaż domku
addEvent("house:sellHouse", true)
addEventHandler("house:sellHouse", root, sellHouse)
--Sprawdza przynależność domu
addEvent("house:checkHouseAffiliation", true)
addEventHandler("house:checkHouseAffiliation", root, checkHouseAffiliation)
--Wykup domku
addEvent("house:buyHouse", true)
addEventHandler("house:buyHouse", root, buyHouse)
--Edycja lokatorów
addEvent("house:editOccupants", true)
addEventHandler("house:editOccupants", root, editOccupants)

setTimer(function()
    q = exports["pd-mysql"]:query("SELECT * FROM `house`")
    for i=1, #q do 
        reloadHouse(i)
    end
end, 300000, 0)