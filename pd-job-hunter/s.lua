DISTANCE_BONUS = 50 -- od kiedy liczymy bonus za dystans
ANIMAL_RESPAWN_TIME = 60000*1
ANIMAL_DETECT_RADIUS = 17.5
ANIMAL_SPAWNS = {
	{-690.91, -2190.23, 20.62},
	{-711.41, -2223.73, 26.48},
	{-735.56, -2181.71, 36.01},
	{-743.43, -2244.95, 28.53},
	{-791.13, -2250.42, 37.88},
	{-799.3, -2299.8, 31.7},
	{-899.19, -2281.19, 45.59},
	{-925.47, -2251.94, 43.86},
	{-908.47, -2213.9, 36.57},
	{ -862.84, -2182.29, 26.06},
	{-844.09, -2224.36, 22.62},
	{-796.15, -2173.19, 22.32},
	{ -783.31, -2121.3, 25.29},
	{-744.36, -2084.05, 11.56},
	{-704.28, -2220.31, 25.04},
	{-768.48, -2213.95, 20.8},
	{-809.96, -2246.8, 38.72},
	{-834.38, -2292.99, 22.31},
	{-871.22, -2265.07, 28.28},
	{-916.5, -2243.34, 39.57},
	{-917.38, -2298.38, 50.11},
	{-860.82, -2333.16, 40.71},
	{-799.24, -2083.22, 24.63},
	{-818.77, -2047.77, 25.39},
	{-840.57, -2022.95, 22.49},
	{-837.58, -1976, 14.87},
	{ -861.05, -1960.44, 15.37},
	{-896.17, -1970.99, 30.18},
	{-925.77, -1963.3, 43.19},
	{-889.27, -1935.89, 28},
	{-840.88, -1918.98, 13.1},
	{-808.44, -1922.02, 6.95},
	{-779.71, -1896.5, 7.24},
	{-788.98, -1877.04, 11.56},
	{-776.04, -1860.55, 11.95},
	{-719.7, -1865.39, 10.53},
	{-663.96, -1844.41, 19.21},
	{-620.44, -2033.1, 35.9},
	{-572.36, -1972.61, 43.17},
	{-635.24, -1949.45, 27.01},
	{-607.78, -1914.8, 15.99},
	{-548.57, -1928.26, 19.49},
	{ -466.72, -1939.79, 16.02},
	{ -485.16, -1972.08, 38.93},
	{-453.28, -1997.72, 36.03},
	{-550.97, -2067.75, 56.69},
	{-560.97, -2020.45, 49.71},
	{-622.19, -1849.54, 23.92},
	{-560.21, -1849.49, 22.27},
	{-517.44, -1831.38, 21.26},
	{-471.91, -1837.48, 12.09},
	{-496.87, -2024.63, 49.71},
	{-605.44, -2029.27, 39.98},
	{-676.72, -1981.85, 24.31},
}
local animals = {} 

addEvent("onPlayerGetTopData", true)
addEvent("onPlayerStartJob", true)
addEvent("onPlayerEndJob", true)

addEvent("onPlayerStartSkinning", true)
addEvent("onPlayerSkinAnimal", true)

local function doAnimalMovement(ped)
	if not isElement(ped) or isPedDead(ped) then return end 
	
	if animals[ped].task == "idle" then
		local function getPositionInFrontOf( element, distance, rotation )
			local x, y, z = getElementPosition( element )
			_, _, rz = getElementRotation( element )
			rz = rz + ( rotation or 90 )
			return x + ( ( math.cos ( math.rad ( rz ) ) ) * ( distance or 3 ) ), y + ( ( math.sin ( math.rad ( rz ) ) ) * ( distance or 3 ) ), z, rz
		end
		
		local px, py, pz = getElementPosition(ped)
		local tx, ty, tz = 0, 0, 0
		if getDistanceBetweenPoints3D(px, py, pz, animals[ped].spawn.x, animals[ped].spawn.y, animals[ped].spawn.z) > 25 then 
			tx, ty, tz = animals[ped].spawn.x, animals[ped].spawn.y, animals[ped].spawn.z
		else 
			tx, ty, tz = getPositionInFrontOf(ped, 3, math.random(0, 360))
		end
		
		exports["npc_hlc"]:setNPCWalkSpeed(ped, "walk")
		exports["npc_hlc"]:setNPCTask(ped, {"walkToPos", tx, ty, tz, 1})
	end 
	
	setTimer(doAnimalMovement, math.random(1,10)*1000, 1, ped)
end 

function updateAnimalFight(ped) 
	if animals[ped].task == "kill" and not isPedDead(ped) then 
		local attacker = animals[ped].attacker
		if isElement(attacker) and not isPedDead(attacker) then 
			local x, y, z = getElementPosition(ped)
			local x2, y2, z2 = getElementPosition(attacker)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if dist > 100 or z < 8 then -- jak dystans za duzy albo jest w wodzie xD
				animals[ped].attacker = nil
				animals[ped].task = "returning"
				
				local x, y, z = animals[ped].spawn.x, animals[ped].spawn.y, animals[ped].spawn.z
				exports["npc_hlc"]:setNPCTask(ped, {"walkToPos", x, y, z, 5})
			else
				if math.random(1, 20) == 1 then
					local x, y, z = getElementPosition(ped)
					local col = createColSphere(x, y, z, 30)
					for k, v in ipairs(getElementsWithinColShape(col, "player")) do
						triggerClientEvent(v, "onClientPlayAnimalSound", resourceRoot, getElementModel(ped), "attack", x, y, z)
					end 
					destroyElement(col)
				end 
				
				setTimer(updateAnimalFight, 200, 1, ped)
			end
		else 
			animals[ped].attacker = nil
			if animals[ped].task == "kill" then 
				animals[ped].task = "returning"
				
				local x, y, z = animals[ped].spawn.x, animals[ped].spawn.y, animals[ped].spawn.z
				exports["npc_hlc"]:setNPCTask(ped, {"walkToPos", x, y, z, 5})
			end
		end
	end
end 

addEventHandler("npc_hlc:onNPCTaskDone", root, function(task)
	if not animals[source] then return end
	if animals[source].task == "returning" and task[1] == "walkToPos" then
		animals[source].task = "idle"
	end
end)

local function animalAttack(ped, player, loss)
	if animals[ped] then
		for k, v in pairs(animals) do 
			if v.attacker == player and k ~= ped then  -- gracz już atakuje jakieś zwierzę
				return
			end
		end
		
		if animals[ped].attacker == player then
			local hp = getElementHealth(ped)-loss
			if hp < 1 then
				killPed(ped, player)
				return
			else
				setElementHealth(ped, hp)
			end

			local x, y, z = getElementPosition(ped)
			local col = createColSphere(x, y, z, 30)
			for k, v in ipairs(getElementsWithinColShape(col, "player")) do
				triggerClientEvent(v, "onClientPlayAnimalSound", resourceRoot, getElementModel(ped), "damage", x, y, z)
			end 
			destroyElement(col)			
		end 
		
		if animals[ped].task == "kill" then return end 
		exports["npc_hlc"]:clearNPCTasks(ped)
			
		setElementSyncer(ped, player)
		
		exports["npc_hlc"]:setNPCWalkSpeed(ped, "sprint")
		exports["npc_hlc"]:setNPCTask(ped, {"killPed", player, 3, 2})
		animals[ped].attacker = player
		animals[ped].task = "kill" 
		
		updateAnimalFight(ped)
	end
end 

addEvent("onPlayerAttackAnimal", true)
addEventHandler("onPlayerAttackAnimal", resourceRoot, function(ped, loss)
	animalAttack(ped, client, loss)
end)

local function detectEnemy(hitElement, md)
	if getElementType(hitElement) == "player" and md then 
		if getElementData(source, "upgrade") then 
			local animal = getElementData(source, "animal")
			if animals[animal].attacker ~= hitElement then
				animalAttack(animal, hitElement, 0)
			end
		else 
			-- jak ma ulepszenie to nie odpalamy 
			local upgrades = getElementData(hitElement, "player:job_upgrades") or {}
			if upgrades["hunter"] then 
				for k, v in ipairs(upgrades["hunter"].upgrades) do 
					if v == "stealth" then 
						return
					end
				end
			end 
			
			animalAttack(getElementData(source, "animal"), hitElement, 0)
		end
	end
end 

local function spawnAnimal(x, y, z)
	local skin = math.random(1, 2) == 1 and 309 or 308
	local ped = createPed(skin, x, y, z+0.5)
	addEventHandler("onElementDestroy", ped, function()
		local attached = getAttachedElements(ped)
		for k, v in ipairs(attached) do 
			destroyElement(v)
		end 
		
		setTimer(spawnAnimal, ANIMAL_RESPAWN_TIME, 1, x, y, z)
	end)
	setElementDimension(ped, 1)
	
	local detectCol = createColSphere(x, y, z, ANIMAL_DETECT_RADIUS)
	setElementData(detectCol, "animal", ped)
	setElementDimension(detectCol, 1)
	addEventHandler("onColShapeHit", detectCol, detectEnemy)
	
	local upgradeDetectCol = createColSphere(x, y, z, ANIMAL_DETECT_RADIUS/2)
	setElementData(upgradeDetectCol, "upgrade", true)
	setElementData(upgradeDetectCol, "animal", ped)
	setElementDimension(upgradeDetectCol, 1)
	addEventHandler("onColShapeHit", upgradeDetectCol, detectEnemy)
	
	attachElements(detectCol, ped)
	attachElements(upgradeDetectCol, ped)
	
	exports["npc_hlc"]:enableHLCForNPC(ped)
	animals[ped] = {spawn=Vector3(x, y, z), task="idle"}
	
	doAnimalMovement(ped)
	addEventHandler("onPedWasted", ped, function(ammo, killer, killerWeapon, bodypart, stealth)
		setTimer(setElementData, 1250, 1, ped, "animal:killer", killer)
		if killer and getElementType(killer) == "player" then 
			 if getElementModel(ped) == 308 then 
				exports["pd-jobsettings"]:addPlayerJobUpgradePoints(killer, "hunter", 1)
			else 
				exports["pd-jobsettings"]:addPlayerJobUpgradePoints(killer, "hunter", 2)
			end
			
			local x, y, z = getElementPosition(ped)
			local x2, y2, z2 = getElementPosition(killer)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			animals[ped].distanceBonus = dist > DISTANCE_BONUS
			if animals[ped].distanceBonus then 
				local reward = exports["pd-jobsettings"]:getJobData("hunter", "distance_reward")
				exports["pd-hud"]:showPlayerNotification(killer, "Bonus za zestrzelenie z dystansu "..tostring(math.floor(dist)).." metrów\n$"..tostring(reward), "info")
				exports["pd-core"]:giveMoney(killer, tonumber(reward), true)
			end
		end 
		
		setTimer(function(ped)
			if isElement(ped) then 
				animals[ped] = nil
				destroyElement(ped)
			end
		end, ANIMAL_RESPAWN_TIME*2, 1, ped)
	end)
end 

addEvent("onPlayerSkinAnimal", true)
addEventHandler("onPlayerSkinAnimal", resourceRoot, function(ped, timeBonus)
	if animals[ped] then 
		animals[ped] = nil
		destroyElement(ped)
		
		setPedAnimation(client)
		exports["pd-jobsettings"]:addPlayerTopData(client, "hunter", 1)
		
		local reward = exports["pd-jobsettings"]:getJobData("hunter", "skin_reward")
		exports["pd-hud"]:showPlayerNotification(client, "Zarobek za skórę\n$"..tostring(reward), "info")
		exports["pd-core"]:giveMoney(client, tonumber(reward), true)
		
		if timeBonus then 
			local reward = exports["pd-jobsettings"]:getJobData("hunter", "fast_skin_reward")
			exports["pd-hud"]:showPlayerNotification(client, "Bonus za szybkie oskórowanie\n$"..tostring(reward), "info", false)
			exports["pd-core"]:giveMoney(client, tonumber(reward), true)
			
			exports["pd-jobsettings"]:addPlayerTopData(client, "hunter", 1)
		end
	end
end)

addEvent("onPlayerStartSkinning", true)
addEventHandler("onPlayerStartSkinning", resourceRoot, function()
	setPedAnimation(client, "BOMBER", "BOM_Plant_Loop", -1, true, false, false, false)
end)

addEventHandler("onPlayerGetTopData", resourceRoot, function()
	if client and source == resourceRoot then 
		local data = exports["pd-jobsettings"]:getTopJobData("hunter")
		triggerClientEvent(client, "onClientGetTopData", resourceRoot, data)
	end
end)

addEventHandler("onPlayerStartJob", resourceRoot, function()
	if client and source == resourceRoot then 
		local jobUpgrades = getElementData(client, "player:job_upgrades") or {}
		
		setElementData(client, "player:job", "hunter")
		setElementDimension(client, 1)
		setElementModel(client, 28)
		
		takeAllWeapons(client)
		giveWeapon(client, 33, 9999, true)
		if jobUpgrades["hunter"] then 
			for k, v in ipairs(jobUpgrades["hunter"].upgrades) do 
				if v == "shotgun" then 
					giveWeapon(client, 25, 9999, true)
				elseif v == "infrared" then 
					giveWeapon(client, 45, 1)
				elseif v == "stealth" then 
					setElementModel(client, 29)
				end
			end
		end
	end
end)

addEventHandler("onPlayerEndJob", resourceRoot, function()
	if client and source == resourceRoot then 
		setElementDimension(client, 0)
		setElementData(client, "player:job", false)
		setElementModel(client, getElementData(client, "player:skin"))
		
		takeAllWeapons(client)
	end
end)

addEventHandler("onResourceStart", resourceRoot, function()
	for k, v in ipairs(ANIMAL_SPAWNS) do 
		spawnAnimal(v[1], v[2], v[3])
	end
	
	setWeaponProperty("rifle", "poor", "target_range", getWeaponProperty("rifle", "poor", "target_range")*2)
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for k, v in ipairs(getElementsByType("player")) do 
		if getElementData(v, "player:job") == "hunter" then 
			setElementDimension(v, 0)
			setElementData(v, "player:job", false)
			setElementModel(v, getElementData(v, "player:skin"))
			
			exports["pd-hud"]:showPlayerNotification(v, "Praca w której pracowałeś została przeładowana przez administrację. Przepraszamy za utrudnienia.", "error", 15000)
		end
	end
end)