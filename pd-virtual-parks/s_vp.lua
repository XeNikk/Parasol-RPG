virtualSpawn = {
    [1] = {285.52691650391, 1355.5383300781, 10.5859375,0,0,90},
    [2] = {1657.9019775391, -1111.6082763672, 23.90625, 0,0, 270},
    [3] = {1098.4149169922, -1754.9718017578, 13.353574752808, 0,0, 90},
}


function getCarsInParking(plr, id)
	local q = exports['pd-mysql']:query("SELECT * FROM `pd-vehicles` WHERE `owner`=? and `spawned`=0 and `virtualparking`=? LIMIT 1", getElementData(plr, "player:uid"), id)
	if #q == 0	then triggerClientEvent(plr, "add:noti", plr, "info", "Nie posiadasz pojazdów w tym parkingu wirtualnym.") return end
    for i = 1, #q do
        for k,v in pairs(getElementsByType("vehicle")) do
        if getDistanceBetweenPoints3D(virtualSpawn[id][1], virtualSpawn[id][2], virtualSpawn[id][3], Vector3(getElementPosition(v))) < 5 then
            triggerClientEvent(plr, "add:noti", plr, "error", "Respawn parkingu wirtualnego jest zajęty.")
            return end
        end
        local veh = exports["pd-vehicles"]:spawnCar(q[i]["vid"], unpack(virtualSpawn[id]))
        warpPedIntoVehicle(plr, veh)
        triggerClientEvent(plr, "add:noti", plr, "success", "Wyciągasz pojazd z wirtualnego parkingu.")
        exports['pd-mysql']:query("UPDATE `pd-vehicles` SET `virtualparking`=0 WHERE vid=?", q[i]["vid"])
	end
end
addEvent("virtualParking:getCars", true)
addEventHandler("virtualParking:getCars", root, getCarsInParking)

function warpVehicleToParking(veh, id)
    exports['pd-mysql']:query("UPDATE `pd-vehicles` SET `virtualparking`=? WHERE vid=?", id, getElementData(veh, "vehicle:vid"))
    exports["pd-vehicles"]:saveVehicle(getElementData(veh, "vehicle:vid"), true)
end
addEvent("virtualParking:warpVehicleToParking", true)
addEventHandler("virtualParking:warpVehicleToParking", root, warpVehicleToParking)

