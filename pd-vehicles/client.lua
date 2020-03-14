function getElementSpeed(theElement, unit)
	-- Check arguments for errors
	assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
	local elementType = getElementType(theElement)
	assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
	assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
	-- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
	unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
	-- Setup our multiplier to convert the velocity to the specified unit
	local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
	-- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
	return (Vector3(getElementVelocity(theElement)) * mult).length
end

lastVehicleRPM = {}

function getVehicleRPM(vehicle) 
	if (vehicle) then   
		local velocityVec = Vector3(getElementVelocity(vehicle))
		local velocity = velocityVec.length * 180
					
		if (isVehicleOnGround(vehicle)) then
			if (getVehicleEngineState(vehicle) == true) then
				if(getVehicleCurrentGear(vehicle) > 0) then
					vehicleRPM = math.floor(((velocity/getVehicleCurrentGear(vehicle))*150) + 0.5)
					if (vehicleRPM < 650) then
						vehicleRPM = math.random(650, 750)
					elseif (vehicleRPM >= 8000) then
						vehicleRPM = 8000
					end
				else
					vehicleRPM = math.floor(((velocity/1)*220) + 0.5)
					if (vehicleRPM < 650) then
						vehicleRPM = math.random(650, 750)
					elseif (vehicleRPM >= 8000) then
						vehicleRPM = 8000
					end
				end
			else
				vehicleRPM = 0
			end
		else   
			if (getVehicleEngineState(vehicle) == true) then
				vehicleRPM = vehicleRPM - 150
				if (vehicleRPM < 650) then
					vehicleRPM = math.random(650, 750)
				elseif (vehicleRPM >= 8000) then
					vehicleRPM = 8000
				end
			else
				vehicleRPM = 0
			end
		end
		return tonumber(vehicleRPM)
	else
		return 0
	end
end

addEventHandler("onClientVehicleStartEnter", root, function(player,seat,door)
	if player == localPlayer and seat == 0 then
		local owner = getElementData(source, "vehicle:owner")
		local uid = getElementData(player, "player:uid")
		if owner and uid and owner ~= tonumber(uid) then
			cancelEvent()
			exports["pd-hud"]:addNotification("Nie posiadasz kluczy do tego pojazdu.", "error", nil, 5000, "error")
			return
		end
	end
end)

local vehicleBlips = {}

function loadVehicleBlips(veh)
	uid = getElementData(localPlayer, "player:uid")
	if getElementData(veh, "vehicle:owner") and getElementData(veh, "vehicle:owner") == uid then
		vehicleBlips[veh] = createBlip(0, 0, 0, 40, 2, 255, 0, 0, 255, 0, 250)
		attachElements(vehicleBlips[veh], veh)
	end
end
addEvent("loadVehicleBlips", true)
addEventHandler("loadVehicleBlips", localPlayer, loadVehicleBlips)

function deleteVehicleBlip(veh)
	if vehicleBlips[veh] then
		destroyElement(vehicleBlips[veh])
		vehicleBlips[veh] = nil
	end
end
addEvent("deleteVehicleBlip", true)
addEventHandler("deleteVehicleBlip", localPlayer, deleteVehicleBlip)

for k,v in ipairs(getElementsByType("vehicle")) do
	loadVehicleBlips(v)
end