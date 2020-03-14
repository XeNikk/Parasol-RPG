local startPosition = Vector3(1764.2387695313, -1097.1944580078, 24.085935592651)
local jobData = false
local jobPeds = {}
local openDoors = false
local leavePeds = 0
local currentSellingPed = false
local inbisibleJobVehicle = false
local jobType = false

function destroyInvVehicle()
	if invisibleJobVehicle then
		destroyElement(invisibleJobVehicle)
		invisibleJobVehicle = false
	end
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	customMarker, markerID = exports["pd-markers"]:createCustomMarker(startPosition.x, startPosition.y, startPosition.z - 1, 50, 255, 50, 155, "marker", 4.5)
	local col = createColSphere(startPosition.x, startPosition.y, startPosition.z, 4)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			if getElementData(localPlayer, "player:job") then 
				exports["pd-hud"]:showPlayerNotification("Już pracujesz!", "error")
				return
			end 
			showJobGUI()
		end
	end)
end)

function nextBusStop()
	if not jobData or not busStops[jobData[1]][jobData[3]] then return end
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if jobVehicle then
		local model = getElementModel(jobVehicle)
		openDoors = false
		playSound("sounds/close.wav")
		if model == 431 then
			for i = 2, 5 do
				setVehicleDoorOpenRatio(jobVehicle, i, 0, 2000)
			end
		else
			setVehicleDoorOpenRatio(jobVehicle, 3, 0, 2000)
		end
	end
	if happyLevel < 3 then
		happyLevel = happyLevel + 0.5
	end
	local data = busStops[jobData[1]][jobData[3]][jobData[2]]
	if jobSphere and isElement(jobSphere) then
		destroyElement(jobSphere)
		jobSphere = false
	end
	if jobBlip and isElement(jobBlip) then
		destroyElement(jobBlip)
		jobBlip = false
	end
	if data then
		exports["pd-markers"]:destroyCustomMarker(jobMarker)
		_, jobMarker = exports["pd-markers"]:createCustomMarker(data.x, data.y, data.z - 1, 255, 255, 50, 155, "marker", 4.5)
		nextBusStopName = getZoneName(data.x, data.y, data.z)
		jobSphere = createColSphere(data.x, data.y, data.z, 2)
		jobBlip = createBlip(data.x, data.y, data.z, 41)
		leftTime = leftTime + data.time
		
		leavePos = {z=data.px, y=data.py, x=data.pz}
		leavePeds = data.leave -- ile pedow wychodzi

		-- tworzenie pedow
		if data.enter > 0 then
			for i = 1, data.enter do
				local x, y, z = data.px + math.random(-50, 50)/100, data.py + math.random(-50, 50)/100, data.pz
				local rot = findRotation(x, y, data.x, data.y)
				local ped = createPed(skins[math.random(1, #skins)], x, y, z, rot)
				setElementData(ped, "in:vehicle", false)
				setElementFrozen(ped, true)
				table.insert(jobPeds, ped)
			end
		end

		jobData[2] = jobData[2] + 1
	else
		exports["pd-hud"]:addNotification("Zakończono trasę.", "success", "success", 5000, "success")
		endJob()
	end
end

ob = createObject(2000, 0, 0, 0)
addCommandHandler("attach", function(cmd, x, y, z)
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if not jobVehicle then return end
	attachElements(ob, jobVehicle, tonumber(x), tonumber(y), tonumber(z))
end)

function sellNextTicket()
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if not jobVehicle then return end
	showSellTickets()
	if currentSellingPed then
		setElementCollisionsEnabled(currentSellingPed, true)
		setElementFrozen(currentSellingPed, false)
		setElementData(currentSellingPed, "in:vehicle", true)
		setElementPosition(currentSellingPed, 0, 0, 0)
	end
	currentSellingPed = false
	for k,v in pairs(jobPeds) do
		if isElement(v) then
			if not getElementData(v, "in:vehicle") then
				setElementPosition(v, 0, 0, 0)
				if not currentSellingPed then
					currentSellingPed = v
				end
			elseif getElementData(v, "in:vehicle") == "wait" then
				destroyElement(v)
				v = false
			end
		end
	end
	if currentSellingPed then
		setElementFrozen(jobVehicle, true)
		local x, y, z = getPositionFromElementOffset(jobVehicle, -0.5, 5, 0.5)
		local px, py, pz = getPositionFromElementOffset(jobVehicle, 0.9, 5.1, 0)
		local rot = findRotation(px, py, x, y)
		setElementCollisionsEnabled(currentSellingPed, false)
		setElementPosition(currentSellingPed, px, py, pz)
		setElementFrozen(currentSellingPed, true)
		setPedControlState(currentSellingPed, "forwards", false)
		setPedControlState(currentSellingPed, "walk", false)
		setElementRotation(currentSellingPed, 0, 0, rot, "default", true)
		local model = getElementModel(jobVehicle)
		if model == 431 then
			lx, ly, lz = getPositionFromElementOffset(jobVehicle, 1, 5.5, 0.5)
		else
			lx, ly, lz = getPositionFromElementOffset(jobVehicle, 1, 5.55, 0.5)
		end
		setCameraMatrix(x, y, z, lx, ly, lz)
		ticketType = math.random(1, 2) == 1 and "#ff0077normalny" or "#00bbffulgowy"
	else
		hideSellTickets()
		nextBusStop()
		if jobType == "miastowy" then
			money = exports["pd-jobsettings"]:getJobData("bus", "city")
		else
			money = exports["pd-jobsettings"]:getJobData("bus", "countryside")
		end
		if happyLevel == 3 then
			money = money
		elseif happyLevel == 2 then
			money = math.floor(money * 0.9)
		else
			money = math.floor(money * 0.8)
		end
		if leftTime > 60 then
			money = math.floor(money * 0.9)
		elseif leftTime < -20 then
			money = math.floor(money * 0.9)
		else
			money = money
		end
		exports["pd-hud"]:addNotification("Wypłata za przystanek $" .. money, "success", "success", 5000, "success")
		exports["pd-core"]:giveMoney(tonumber(money))
		triggerServerEvent("giveJobPoints", resourceRoot, localPlayer)
		setElementFrozen(jobVehicle, false)
		setCameraTarget(localPlayer)
		toggleAllControls(true)
	end
end

function execNPCsRoutine()
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if not jobVehicle then return end
	local left = 0
	local dist = 0
	for k,v in pairs(jobPeds) do
		if isElement(v) then
			local x, y, z = getElementPosition(v)
			if not getElementData(v, "in:vehicle") then
				setElementFrozen(v, false)
				local model = getElementModel(jobVehicle)
				if model == 431 then
					lx, ly, lz = getPositionFromElementOffset(jobVehicle, 0, 5, 0)
				else
					lx, ly, lz = getPositionFromElementOffset(jobVehicle, 0, 6, 0)
				end
				local rot = findRotation(x, y, lx, ly)
				setElementRotation(v, 0, 0, rot, "default", true)
				dist = getDistanceBetweenPoints2D(x, y, lx, ly)
			else
				if left < leavePeds then
					local lx, ly, lz = getPositionFromElementOffset(jobVehicle, 2 + math.random(-50, 50)/100, -1 + math.random(-50, 50)/100, 0)
					local rot = findRotation(lx, ly, leavePos.x, leavePos.y)
					setElementPosition(v, lx, ly, lz)
					setElementRotation(v, 0, 0, rot, "default", true)
					setElementData(v, "in:vehicle", "wait")
					left = left + 1
					dist = getDistanceBetweenPoints2D(x, y, lx, ly)
				end
			end
			setPedControlState(v, "forwards", true)
			setPedControlState(v, "walk", true)
		end
	end
	setTimer(sellNextTicket, dist * 400, 1)
end

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "player:job") == "bus" then
		local jobVehicle = getPedOccupiedVehicle(localPlayer)
		if not jobVehicle then return end
		local vx, vy, vz = getElementVelocity(jobVehicle)
		local speed = math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161)
		if isElementWithinColShape(jobVehicle, jobSphere) and speed < 2 and not openDoors then
			playSound("sounds/open.wav")
			openDoors = true
			local model = getElementModel(jobVehicle)
			toggleAllControls(false)
			if model == 431 then
				for i = 2, 5 do
					setVehicleDoorOpenRatio(jobVehicle, i, 1, 2000)
				end
			else
				setVehicleDoorOpenRatio(jobVehicle, 3, 1, 2000)
			end
			setTimer(execNPCsRoutine, 2000, 1)
		end
	end
end)

function startJob(type)
	if (isPedInVehicle(localPlayer)) then
		exports["pd-hud"]:showPlayerNotification("Wysiądź z pojazdu!", "error")
		return
	end
	if type == "miastowy" then
		model = 431
	else
		model = 437
	end
	jobData = {type, 1, math.random(1, #busStops[type])}
	random = math.random(1, #busPositions)
	triggerServerEvent("startJob", resourceRoot, model, busPositions[random])
	jobType = type
	jobSound = playSound("sounds/background.mp3", true)
	setSoundVolume(jobSound, 5)
	setElementData(localPlayer, "player:job", "bus")
	nextBusStop()
end

function endJob()
	for k,v in pairs(jobPeds) do
		if isElement(v) then
			destroyElement(v)
		end
	end
	if jobSound then stopSound(jobSound) end
	triggerServerEvent("endJob", resourceRoot)
	exports["pd-markers"]:destroyCustomMarker(jobMarker)
	if jobSphere and isElement(jobSphere) then
		destroyElement(jobSphere)
		jobSphere = false
	end
	if jobBlip and isElement(jobBlip) then
		destroyElement(jobBlip)
		jobBlip = false
	end
	jobData = false
	jobPeds = {}
	toggleAllControls(true)
	showChat(true)
	setCameraTarget(localPlayer)
	setElementData(localPlayer, "player:job", false)
	setTimer(function()
		setElementPosition(localPlayer, startPosition.x, startPosition.y, startPosition.z)
	end, 1000, 1)
end

addEventHandler("onClientVehicleStartExit", root, function(plr)
	if plr == localPlayer and getElementData(plr, "player:job") == "bus" then
		endJob()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "player:job") == "bus" then
		endJob()
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports["pd-markers"]:destroyCustomMarker(jobMarker)
	exports["pd-markers"]:destroyCustomMarker(markerID)
end)

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix ( element )
    local x, y, z = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1], offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2], offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end