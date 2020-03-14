function destroyVehicle(plr, vehicle, cost)
givePlayerMoney(plr, cost)
exports["pd-mysql"]:query("DELETE FROM `pd-vehicles` WHERE `vid`=?", getElementData(vehicle, "vehicle:vid"))
destroyElement(vehicle) 
end
addEvent("vehicleDestroy:onClientAccept", true)
addEventHandler("vehicleDestroy:onClientAccept", root, destroyVehicle)