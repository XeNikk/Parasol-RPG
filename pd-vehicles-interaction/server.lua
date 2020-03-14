function playClientSound(player, sound)
	triggerClientEvent(player, "playClientSound", player, sound)
end

function getElementSpeed(element)
    local vx, vy, vz = getElementVelocity(element)
    local speed = math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161)
    return speed, vx, vy, vz
end

interactions = {
	["engine"] = {func=function(veh, plr)
		if fail == true then exports["pd-hud"]:showPlayerNotification(plr, "Poczekaj chwilę przed kolejną próbą uruchomienia silnika.", "error", 5000, nil, "error") return end
		if getVehicleEngineState(veh) then
			setVehicleEngineState(veh, false)
			playClientSound(plr, "sounds/light.mp3")
		else
			if getElementHealth(veh) > 350 then
				setVehicleEngineState(veh, true)
				playClientSound(plr, "sounds/engine.mp3")
			else
				engineStarts = math.random(1, 20)
				if engineStarts >= 3 and engineStarts <= 5 then
					setVehicleEngineState(veh, true)
					playClientSound(plr, "sounds/engine.mp3")
				else
					exports["pd-achievements"]:exportAchievement(plr, "Niszczyciel", 5)
					playClientSound(plr, "sounds/engine_fail.mp3")
					exports["pd-hud"]:showPlayerNotification(plr, "Nie udało się uruchomić pojazdu z powodu złego stanu. Spróbuj ponownie.", "error", 5000, nil, "error")
					fail = true
					setTimer(function()
					fail = false
					end ,3000, 1)
				end
			end
		end
	end},
	["light"] = {func=function(veh, plr) 
		if getVehicleOverrideLights(veh) == 1 then 
			setVehicleOverrideLights(veh, 2)
			playClientSound(plr, "sounds/light.mp3")
		else 
			setVehicleOverrideLights(veh, 1)
			playClientSound(plr, "sounds/light.mp3")
		end 
	end},
	["brake"] = {func=function(veh, plr)
		speed = getElementSpeed(veh)
		if speed < 5 then
			if isElementFrozen(veh) then 
				setElementFrozen(veh, false)
				playClientSound(plr, "sounds/light.mp3")
			else
				setElementFrozen(veh, true)
				playClientSound(plr, "sounds/brake.mp3")
			end
		end
	end},
	["lock"] = {func=function(veh, plr)
		if isVehicleLocked(veh) then
			setVehicleLocked(veh, false)
			playClientSound(plr, "sounds/lock.mp3")
		else
			setVehicleLocked(veh, true)
			playClientSound(plr, "sounds/lock.mp3")
		end
	end},
	["passengers"] = {func=function(veh, plr) 
		for k,v in pairs(getVehicleOccupants(veh)) do
			if getVehicleController(veh) ~= v then
				removePedFromVehicle(v)
			end
		end
	end},
	["neon"] = {func=function(veh, plr) end}
}

addEvent("vehicleInteraction", true)
addEventHandler("vehicleInteraction", resourceRoot, function(veh, interaction, plr)
	interactions[interaction].func(veh, plr)
end)