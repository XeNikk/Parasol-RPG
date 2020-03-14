exports["pd-mysql"]:query("CREATE TABLE IF NOT EXISTS `pd-bans` (`id` int NOT NULL AUTO_INCREMENT, `nick` text NOT NULL, `serial` text NOT NULL, `ip` text NOT NULL, `admin` text NOT NULL, `timeout` date NOT NULL, `date` date NOT NULL, `active` int NOT NULL, PRIMARY KEY (`id`))") 



function spec(plr, cmd, target)
if not getElementData(plr, "player:admin", true) then return end
if not target then return end
local fromNick = findPlayer(plr, target)
if not fromNick then return end

setCameraTarget(plr, fromNick)


end
addCommandHandler("spec", spec)

function specoff(plr, cmd)
    if not getElementData(plr, "player:admin", true) then return end

    setCameraTarget(plr, plr)
    
    
end
addCommandHandler("specoff", specoff)


function teleportto(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end

    if not target then return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then return end
    if isPedInVehicle(plr) then
        removePedFromVehicle(plr)
    end
    if isPedInVehicle(fromNick) then 
        warpPedIntoVehicle(plr, getPedOccupiedVehicle(fromNick), 1)
        triggerClientEvent(fromNick, "admin:addNoti", fromNick, "Gracz "..getPlayerName(plr).." teleportował się do ciebie.", "success")
    else
        local x,y,z = getElementPosition(fromNick)
        setElementPosition(plr, x,y,z)
        setElementDimension(plr, getElementDimension(fromNick))
        triggerClientEvent(fromNick, "admin:addNoti", fromNick, "Gracz "..getPlayerName(plr).." teleportował się do ciebie.", "success")
    end   
end
addCommandHandler("tt", teleportto)

function teleportplayerto(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end

    if not target then return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then return end
    if isPedInVehicle(fromNick) then removePedFromVehicle(fromNick) end
    if isPedInVehicle(plr) then 
        warpPedIntoVehicle(fromNick, getPedOccupiedVehicle(plr), 1)
        triggerClientEvent(fromNick, "admin:addNoti", fromNick, "Gracz "..getPlayerName(plr).." teleportował Cię do siebie.", "success")
    else
        local x,y,z = getElementPosition(plr)
        setElementPosition(fromNick, x,y,z)
        setElementDimension(fromNick, getElementDimension(plr))
        triggerClientEvent(fromNick, "admin:addNoti", fromNick, "Gracz "..getPlayerName(plr).." teleportował Cię do siebie.", "success")
    end   
end
addCommandHandler("th", teleportplayerto)


function fix(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then target = getPlayerName(plr) end
    local fromNick = findPlayer(plr, target)
    if not fromNick then return end
    if not getPedOccupiedVehicle(fromNick) then return end

    fixVehicle(getPedOccupiedVehicle(fromNick))
    triggerClientEvent(fromNick, "admin:addNoti", fromNick, "Twój samochód zostal naprawiony.", "success")
end
addCommandHandler("fix", fix)

function flip(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then target = getPlayerName(plr) end
    local fromNick = findPlayer(plr, target)
    if not fromNick then return end
    if not getPedOccupiedVehicle(fromNick) then return end

    local rx, ry, rz = getElementRotation(getPedOccupiedVehicle(fromNick))

     setElementRotation(getPedOccupiedVehicle(fromNick), 0,0,rz)

end
addCommandHandler("flip", flip)


function createvehicle(plr, cmd, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if (not ...) then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie /cv [Nazwa pojazdu/ID pojazdu].", "error")]]  return end
    if isPedInVehicle(plr) then return end
    local model = table.concat ( { ... }, " " )
    if tonumber(model) ~= nil then
        local dim = getElementDimension(plr)
        local x,y,z = getElementPosition(plr)
        local r1,r2,r3 = getElementRotation(plr)
        veh = createVehicle(model, x,y,z,r1,r2,r3)
        setElementPosition(plr,x, y, z+1.5)
        setElementDimension(veh, getElementDimension(plr))
        setElementData(veh, "vehicle:spawned", true)

        addEventHandler("onVehicleExit", veh, function(plr,seat)
            if seat ~= 0 then return end
            setVehicleEngineState(source, false)
            setTimer(destroyElement, 50, 1, source)
            
            end)

    return end
    
    local model  = string.lower(model)
    local dim = getElementDimension(plr)
    local x,y,z = getElementPosition(plr)
    local r1,r2,r3 = getElementRotation(plr)
    local model = getVehicleModelFromName(model)
    if not model then return end
    
     veh = createVehicle(model, x,y,z,r1,r2,r3)
     setElementPosition(plr,x, y, z+1.5)
     setElementDimension(veh, getElementDimension(plr))
     setElementData(veh, "vehicle:spawned", true)

     addEventHandler("onVehicleExit", veh, function(plr,seat)
        if seat ~= 0 then return end
        setVehicleEngineState(source, false)
        setTimer(destroyElement, 50, 1, source)
        
        end)

end
addCommandHandler("cv", createvehicle)


function kick(plr, cmd, target, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /kick [Nick] [Powód].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    if getElementData(fromNick, "player:admin") then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie możesz wyrzucić administracji.", "error")]] return end
    local reason = table.concat ( { ... }, " " )
    if string.len(reason) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód.", "error")]] return end
    triggerClientEvent(root, "admin:addPunishment", root, "Wyrzucenie", "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
    kickPlayer(fromNick, getPlayerName(plr), reason)


end
addCommandHandler("kick", kick)
addCommandHandler("k", kick)

function ban(plr, cmd, target, number, typedate, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not target or not tonumber(number) or not typedate then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/tban [Nick] [Czas] [m/h/d] [Powód].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    if getElementData(fromNick, "player:admin") then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie możesz zbanować administracji.", "error")]] return end
    local reason = table.concat ( { ... }, " " )
    if string.len(reason) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód.", "error")]] return end

    local check = exports["pd-mysql"]:query("SELECT * from `pd-bans` WHERE `serial`=? AND `timeout`>NOW() LIMIT 1", getPlayerSerial(fromNick))
    if check and #check > 0 then 
        --[[triggerClientEvent(plr, "admin:addNoti", plr, "Ten gracz posiada już bana.", "error")]]
        return 
    end
    if typedate == "m" then
        exports["pd-mysql"]:query("INSERT INTO `pd-bans` (`nick`, `serial`, `ip`, `admin`, `timeout`, `reason`, `active`) VALUES (?,?,?,?,NOW() + INTERVAL ? minute, ?, 1)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerIP(fromNick), getPlayerName(plr), tonumber(number), reason)
    elseif typedate == "h" then
        exports["pd-mysql"]:query("INSERT INTO `pd-bans` (`nick`, `serial`, `ip`, `admin`, `timeout`, `reason`, `active`) VALUES (?,?,?,?,NOW() + INTERVAL ? hour, ?, 1)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerIP(fromNick), getPlayerName(plr), tonumber(number), reason)
    elseif typedate == "d" then
        exports["pd-mysql"]:query("INSERT INTO `pd-bans` (`nick`, `serial`, `ip`, `admin`, `timeout`, `reason`, `active`) VALUES (?,?,?,?,NOW() + INTERVAL ? day, ?, 1)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerIP(fromNick), getPlayerName(plr), tonumber(number), reason)
    end
    triggerClientEvent(root, "admin:addPunishment", root, "Ban na "..number..""..typedate, "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
    kickPlayer(fromNick, getPlayerName(plr), "Zostałeś zbanowany na tym serwerze.\nPołącz się ponownie, aby poznać szczegóły.")


end
addCommandHandler("zbanuj", ban)

function warn(plr, cmd, target, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/warn [Nick] [Powód].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    if getElementData(fromNick, "player:admin") then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie możesz warnować administracji.", "error")]] return end
    local reason = table.concat ( { ... }, " " )
    if string.len(reason) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód.", "error")]] return end
    local actualWarns = getElementData(fromNick, "player:warns")
    triggerClientEvent(fromNick, "admin:initPunish", fromNick, "Ostrzeżenie "..(getElementData(fromNick, "player:warns")+1).."/5", "Otrzymałeś ostrzeżenie od "..getPlayerName(plr).." z powodu: "..reason)
    if actualWarns + 1 == 5 then 
        setElementData(fromNick, "player:warns", actualWarns+1)
        triggerClientEvent(root, "admin:addPunishment", root, "Ban na 24h [Warn]", "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
        exports["pd-mysql"]:query("INSERT INTO `pd-bans` (`nick`, `serial`, `ip`, `admin`, `timeout`, `reason`, `active`) VALUES (?,?,?,?,NOW() + INTERVAL ? hour, ?, 1)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerIP(fromNick), getPlayerName(plr), "24", reason)
        kickPlayer(fromNick, getPlayerName(plr), "Zostałeś zbanowany na tym serwerze.\nPołącz się ponownie, aby poznać szczegóły." )
    return end

    setElementData(fromNick, "player:warns", actualWarns+1)
    triggerClientEvent(root, "admin:addPunishment", root, "Ostrzeżenie "..getElementData(fromNick, "player:warns").."/5", "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
    
end
addCommandHandler("warn", warn)

function announce(plr, cmd, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if getPlayerRank(plr) == "Administrator RCON" then
    text = table.concat ( { ... }, " " )
    if string.len(text) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj dłuższą wiadomość.", "error")]] return end
    triggerClientEvent(root, "admin:addAnnounce", root, text)
    end
end
addCommandHandler("ann", announce)


function warpVehicle(plr, cmd, id)
    if not getElementData(plr, "player:admin", true) then return end
    if not tonumber(id) then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /vehth [id]", "error")]] return end

    for i,v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle:vid") == tonumber(id) then 
            x,y,z = getElementPosition(plr)
            setElementPosition(v, x,y,z)
            setElementPosition(plr, x,y,z+1)
        end
    end
end
addCommandHandler("vehth", warpVehicle)

function warpToVehicle(plr, cmd, id)
    if not getElementData(plr, "player:admin", true) then return end
    if not tonumber(id) then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /vehth [id]", "error")]] return end

    for i,v in ipairs(getElementsByType("vehicle")) do
        if getElementData(v, "vehicle:vid") == tonumber(id) then 
            x,y,z = getElementPosition(v)
            setElementPosition(plr, x,y,z+1)
        end
    end
end
addCommandHandler("vehtt", warpToVehicle)


function jetpack(plr, cmd)
if not getElementData(plr, "player:admin", true) then return end

setPedWearingJetpack(plr, not isPedWearingJetpack(plr))

end
addCommandHandler("jp", jetpack)

function setDimension(plr, cmd, dim)
    if not getElementData(plr, "player:admin", true) then return end
    if not dim then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /dim [ID].", "error")]] return end
    if tonumber(dim) > 65535 or tonumber(dim) < 0 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Dimension musi być podanyw przedziale od 0 do 65535.", "error")]] return end
    if isPedInVehicle(plr) then 
        setElementDimension(plr, dim)
        setElementDimension(getPedOccupiedVehicle(plr), dim)
    else
        setElementDimension(plr, dim)
    end
end
addCommandHandler("dim", setDimension)

function mute(plr, cmd, target, number, typedate, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not target or not tonumber(number) or not typedate then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/tmute [Nick] [Czas] [m/h/d] [Powód].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    
    local reason = table.concat ( { ... }, " " )
    if string.len(reason) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód.", "error")]] return end

    if getElementData(fromNick, "player:mute") == true then 
        --[[triggerClientEvent(plr, "admin:addNoti", plr, "Ten gracz posiada już mute.", "error")]]
        return 
    end
    if typedate == "m" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? minute, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number), "mute")
    elseif typedate == "h" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? hour, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number),"mute")
    elseif typedate == "d" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? day, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number), "mute")
    end
    triggerClientEvent(root, "admin:addPunishment", root, "Wyciszenie na "..number..""..typedate, "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
    setElementData(fromNick, "player:mute", true)
    triggerClientEvent(fromNick, "admin:initPunish", fromNick, "Wyciszenie na "..number..""..typedate, "Zostałeś wyciszony przez "..getPlayerName(plr).." z powodu: "..reason)

end
addCommandHandler("tmute", mute)

function unmute(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/unmute [Nick].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    if getElementData(fromNick, "player:mute") == false then 
        --[[triggerClientEvent(plr, "admin:addNoti", plr, "Ten gracz nie posiada mute.", "error")]]
        return 
    end
    exports["pd-mysql"]:query("UPDATE `pd-punishments` SET `active`=0 WHERE `serial`=? AND `active`=1 AND `type`=?",getPlayerSerial(fromNick), "mute")
    setElementData(fromNick, "player:mute", false)

end
addCommandHandler("unmute", unmute)

function prawko(plr, cmd, target, number, typedate, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not target or not tonumber(number) or not typedate then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/zp [Nick] [Czas] [m/h/d] [Powód].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    
    local reason = table.concat ( { ... }, " " )
    if string.len(reason) < 1 then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód.", "error")]] return end

    local check = exports["pd-mysql"]:query("SELECT * from `pd-punishments` WHERE `serial`=? AND `type`=? AND `active`=1 AND `timeout`>NOW() LIMIT 1", getPlayerSerial(fromNick), "Prawo jazdy")
    if check and #check > 0 then 
        --[[triggerClientEvent(plr, "admin:addNoti", plr, "Ten gracz posiada już zabrane prawo jazdy.", "error")]]
        return 
    end
    if typedate == "m" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? minute, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number), "Prawo jazdy")
    elseif typedate == "h" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? hour, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number),"Prawo jazdy")
    elseif typedate == "d" then
        exports["pd-mysql"]:query("INSERT INTO `pd-punishments` (`nick`, `serial`, `admin`, `reason`, `timeout`, `type`) VALUES (?,?,?,?,NOW() + INTERVAL ? day, ?)", getPlayerName(fromNick), getPlayerSerial(fromNick), getPlayerName(plr), reason, tonumber(number), "Prawo jazdy")
    end
    if isPedInVehicle(fromNick) then 
    removePedFromVehicle(fromNick)
    end
    triggerClientEvent(root, "admin:addPunishment", root, "Prawo jazdy na "..number..""..typedate, "Karający: "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]\nUkarany: "..getPlayerName(fromNick).." ["..getElementData(fromNick, "player:id").."]\nPowód: "..reason)
    triggerClientEvent(fromNick, "admin:initPunish", fromNick, "Prawo jazdy na "..number..""..typedate, "Otrzymujesz zakaz prowadzenia od "..getPlayerName(plr).." z powodu: "..reason)

end
addCommandHandler("zp", prawko)

function backprawko(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/op [Nick].", "error")]] return end
    local fromNick = findPlayer(plr, target)
    if not fromNick then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")]] return end
    local check = exports["pd-mysql"]:query("SELECT * from `pd-punishments` WHERE `serial`=? AND `type`=? AND `active`=1 AND `timeout`>NOW() LIMIT 1", getPlayerSerial(fromNick), "Prawo jazdy")
    if check and #check == 0 then 
        --[[triggerClientEvent(plr, "admin:addNoti", plr, "Ten gracz nie posiada zabranego prawa jazdy.", "error")]]
        return 
    end
    exports["pd-mysql"]:query("UPDATE `pd-punishments` SET `active`=0 WHERE `serial`=? AND `active`=1 AND `type`=?",getPlayerSerial(fromNick), "Prawo jazdy")

end
addCommandHandler("op", backprawko)


function globalchat(plr, cmd, ...)
    if not getElementData(plr, "player:admin", true) then return end
    if not getElementData(plr, "player:admin:rank") == "Administrator RCON" then return end
    if not ... then --[[triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie:\n/gc [Treść].", "error")]] return end
    if getElementData(plr, "player:admin:rank") == "Administrator RCON" then hex = "#910000" elseif getElementData(plr, "player:admin:rank") == "Administrator" then hex = "#e80000" elseif getElementData(plr, "player:admin:rank") == "Moderator" then hex = "#009127" elseif getElementData(plr, "player:admin:rank") == "Support" then hex = "#00d4f5" end
    local text = table.concat({...}, " " )
    outputChatBox(hex..""..text.."#b3b3b3 << "..getPlayerName(plr), root, 255,255,255, true)
end
addCommandHandler("gc", globalchat)