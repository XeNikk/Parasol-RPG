function destroyVehicle(el)

    exports["pd-vehicles"]:saveVehicle(getElementData(el, "vehicle:vid"), true)

end
addEvent("interaction:vehiclePrzecho", true)
addEventHandler("interaction:vehiclePrzecho", root, destroyVehicle)

function fixVehicle(el)

    fixVehicle(el)
    
end
addEvent("interaction:fixVehicle", true)
addEventHandler("interaction:fixVehicle", root, fixVehicle)

function flipVehicle(el)
    local rx, ry, rz = getElementRotation(el)
    setElementRotation(el, 0,0,rz)
    
end
addEvent("interaction:flipVehicle", true)
addEventHandler("interaction:flipVehicle", root, flipVehicle)


function vehicleOpenDoor(el, door, state)
if door == "trunk" then 
    if state == "close" then 
        setVehicleDoorOpenRatio(el, 1, 0, 3000)
    else 
        setVehicleDoorOpenRatio(el, 1, 1, 3000)
    end
elseif door == "hood" then 
    if state == "close" then 
        setVehicleDoorOpenRatio(el, 0, 0, 3000)
    else
        setVehicleDoorOpenRatio(el, 0, 1, 3000)
    end
elseif door == "car" then 
    if state == "close" then 
        setVehicleLocked(el, true)
    else
        setVehicleLocked(el, false)
    end
end
end
addEvent("interaction:vehicleOpenDoor", true)
addEventHandler("interaction:vehicleOpenDoor", root, vehicleOpenDoor)