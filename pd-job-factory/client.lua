local buildingCar = false
local buildingPart = false
local partObject = false
local carryMarker = false
local buildMarker = false
local currentCarry = false
local vehiclePosition = {339.20593261719, 43.7, 990.15374755859, 90}
local avaibleVehicles = {
	-- model, wysokosc na podnosniku, wysokosc drzwi
	{421, 0.25, -0.2},
	{426, 0.1, 0.1},
	{445, 0.2, -0.1},
	{466, 0.1, -0.25},
	{529, 0, 0.15},
	{547, 0.1, -0.12}
}
local needParts = {
	["boot_dummy"] = {
		["conveyor"] = {-1, 0, -0.85, 0, 0, 90},
		["carry"] = {0, -0.3, -0.6, 0, 0, 180},
		["position"] = {1.5, 0, 0},
	},
	["bonnet_dummy"] = {
		["conveyor"] = {2, 0, -0.85, 0, 0, 90},
		["carry"] = {0, -0.2, -0.6, 0, 0, 0},
		["position"] = {-2.5, 0, 0},
	},
	["door_lf_dummy"] = {
		["conveyor"] = {-1, -0.2, -0.8, 0, 85, 90},
		["carry"] = {0.6, 0, -0.2, 0, 0, -90},
		["position"] = {0.5, -0.6, 0},
	},
	["door_rf_dummy"] = {
		["conveyor"] = {-1, 0.2, -0.8, 0, -85, 90},
		["carry"] = {-0.6, 0, -0.2, 0, 0, 90},
		["position"] = {0.5, 0.6, 0},
	},
	["door_lr_dummy"] = {
		["conveyor"] = {-1, -0.2, -0.8, 0, 85, 90},
		["carry"] = {0.6, 0, -0.2, 0, 0, -90},
		["position"] = {0.5, -0.6, 0},
	},
	["door_rr_dummy"] = {
		["conveyor"] = {-1, 0.2, -0.8, 0, -85, 90},
		["carry"] = {-0.6, 0, -0.2, 0, 0, 90},
		["position"] = {0.5, 0.6, 0},
	},
	["wheel_lf_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, -0.6, 0},
	},
	["wheel_rf_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, 0.6, 0},
	},
	["wheel_lb_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, -0.6, 0},
	},
	["wheel_rb_dummy"] = {
		["conveyor"] = {0, 0, 0, 0, 0, 0},
		["carry"] = {0, 0, 0, 0, 0, 0},
		["position"] = {0, 0.6, 0},
	},
}
local components = {
	"boot_dummy","ug_nitro","wheel_rf_dummy","wheel_lb_dummy","wheel_rb_dummy",
	"chassis_vlo","door_lr_dummy","wheel_lf_dummy","door_rf_dummy",
	"misc_b","chassis_dummy","misc_a","bonnet_dummy","bump_front_dummy", "chassis",
	"windscreen_dummy","exhaust_ok","door_lf_dummy","door_rr_dummy","bump_rear_dummy"
}

function getNextBuildPart()
	if not buildingCar then return end
	local nextPart = false
	for k in pairs(needParts) do
		if not getVehicleComponentVisible(buildingCar, k) then
			nextPart = k
			break
		end
	end
	return nextPart
end

function takePart(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) and not isPedDucked(el) then 
		if componentPosTimer then killTimer(componentPosTimer) end
		carringPart = true
		toggleControl("sprint", false)
		toggleControl("crouch", false)
		toggleControl("jump", false)
		exports["pd-markers"]:destroyCustomMarker(carryMarker)
		removeEventHandler("onClientColShapeHit", col, takePart)
		destroyElement(col)
		col = false
		carryPos = needParts[currentCarry]["carry"]
		moveZ = 0
		if string.find(currentCarry, "door") then
			for k,v in pairs(avaibleVehicles) do
				if v[1] == getElementModel(buildingPart) then
					moveZ = v[3]
				end
			end
		end
		attachElements(buildingPart, localPlayer, 0, 0.4, 1 + moveZ)
		setVehicleComponentPosition(buildingPart, currentCarry, carryPos[1], carryPos[2], carryPos[3])
		setVehicleComponentRotation(buildingPart, currentCarry, carryPos[4], carryPos[5], carryPos[6])
		setPedAnimation(localPlayer, "CARRY", "liftup105", -1, false, true, false, false)
		setTimer(function(player)
			setPedAnimation(localPlayer, "CARRY", "crry_prtial", 1, false, true)
		end, 500, 1, client)
		createBuildMarker(currentCarry)
	end
end

function vehiclePickup()
	if buildPed then destroyElement(buildPed) end
	buildPed = createPed(50, 338.71884155273, 39.476722717285, 990.55627441406)
	setPedControlState(buildPed, "forwards", true)
	setPedControlState(buildPed, "walk", true)
	local money = tonumber(exports["pd-jobsettings"]:getJobData("fabric", "carbuild"))
	setTimer(function()
		warpPedIntoVehicle(buildPed, buildingCar)
		setElementFrozen(buildingCar, false)
		alpha = 250
		speed = 0
		setTimer(function()
			if buildingCar then
				alpha = alpha - 10
				speed = speed + 1
				setElementAlpha(buildingCar, alpha)
				setElementAlpha(buildPed, alpha)
				setElementVelocity(buildingCar, -speed / 100, 0, 0)
			end
		end, 50, 25)
		setTimer(function()
			createBuildCar()
			exports["pd-core"]:giveMoney(money)
			triggerServerEvent("giveJobPoints", resourceRoot, localPlayer)
			exports["pd-hud"]:showPlayerNotification("Za złożenie pojazdu otrzymujesz $" .. money .. ".", "success", "info", 5000, "success")
			destroyElement(buildPed)
			buildPed = false
			setTimer(function()
				createBuildPart(getNextBuildPart())
			end, 1000, 1)
		end, 1500, 1)
	end, 1500, 1)
end

function addPart(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) then
		carringPart = false
		toggleControl("sprint", true)
		toggleControl("crouch", true)
		toggleControl("jump", true)
		setPedControlState(localPlayer, "walk", false)
		removeEventHandler("onClientColShapeHit", colAdd, addPart)
		exports["pd-markers"]:destroyCustomMarker(buildMarker)
		addingActive = getTickCount()
		playSound("sounds/repair.mp3")
		setPedAnimation(localPlayer, "bomber","bom_plant")
		setVehicleComponentVisible(buildingCar, currentCarry, true)
		local nextPart = getNextBuildPart()
		if nextPart then
			destroyBuildPart()
			setTimer(function()
				createBuildPart(nextPart)
			end, 2000, 1)
		else
			destroyBuildPart()
			setTimer(function()
				vehiclePickup()
			end, 2000, 1)
		end
		setTimer(function()
			addingActive = false
			setPedAnimation(localPlayer)
		end, 2000, 1)
	end
end

sx, sy = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local progressSize = {w=math.floor((1074/zoom)*0.5), h=math.floor((74/zoom)*0.5)}
local progressTextures = {normal=dxCreateTexture(":pd-hud/images/download/progressbar.png"), active=dxCreateTexture(":pd-hud/images/download/progressbar_active.png")}
local normal_small = exports["pd-gui"]:getGUIFont("normal_small")

addEventHandler("onClientRender", root, function()
	if carringPart then
		setPedControlState(localPlayer, "walk", true)
	end
	if addingActive then
		local tick = getTickCount()
		local progress = (tick-addingActive)/2000
		dxDrawImage(sx/2 - progressSize.w/2, sy - 150/zoom, progressSize.w, progressSize.h, progressTextures.normal)
		dxDrawImageSection(sx/2 - progressSize.w/2, sy - 150/zoom, progressSize.w*progress, progressSize.h, 0, 0, 1074*progress, 74, progressTextures.active)
		dxDrawText("Montaż części", sx/2, sy - 150/zoom, sx/2, sy - 150/zoom + progressSize.h, white, 1/zoom, normal_small, "center", "center")
	end
end)

function createBuildMarker(part)
	if not buildingCar then return end
	x, y, z = getVehicleComponentPosition(buildingCar, part)
	x, y, z = vehiclePosition[1] - y + needParts[part]["position"][1], vehiclePosition[2] + x + needParts[part]["position"][2], vehiclePosition[3] + z + needParts[part]["position"][3]
	z = getGroundPosition(x, y, z + 1) + 1
	exports["pd-markers"]:destroyCustomMarker(buildMarker)
	_, buildMarker = exports["pd-markers"]:createCustomMarker(x, y, z-1, 255, 0, 155, 155, "repair", 1)
	colAdd = createColSphere(x, y, z, 1)
	addEventHandler("onClientColShapeHit", colAdd, addPart)
end

function destroyBuildPart()
	if not buildingCar then return end
	if partObject then detachElements(partObject, localPlayer) end
	if buildingPart then destroyElement(buildingPart) buildingPart = false end
	if col then destroyElement(col) col = false end
	if colAdd then destroyElement(colAdd) colAdd = false end
	if functionTimer then killTimer(functionTimer) functionTimer = false end
end

function showOneComponent(part)
	if carringPart then return end
	if not buildingPart then return end
	for k, v in pairs(components) do
		setVehicleComponentVisible(buildingPart, v, false)
	end
	setVehicleComponentVisible(buildingPart, part, true)
	setVehicleComponentPosition(buildingPart, part, partsData[1], partsData[2], partsData[3])
	setVehicleComponentRotation(buildingPart, part, partsData[4], partsData[5], partsData[6])
end

function createBuildPart(part)
	destroyBuildPart()
	currentCarry = part
	if not buildingPart then
		buildingPart = createVehicle(getElementModel(buildingCar), 0, 0, 0)
		setElementCollisionsEnabled(buildingPart, false)
		setElementCollidableWith(getCamera(), buildingPart, false)
		setElementCollidableWith(buildingPart, getCamera(), false)
		setElementData(buildingPart, "vehicle:ghost:off", true)
	end
	if not partObject then
		partObject = createObject(2000, 0, 0, 0)
		setElementCollisionsEnabled(partObject, false)
	end
	partsData = needParts[part]["conveyor"]
	movetoZ = 0
	if partsData[3] == 0 then
		movetoZ = -0.1
	end
	if showingTimer then
		killTimer(showingTimer)
	end
	exports["pd-markers"]:destroyCustomMarker(carryMarker)
	setElementModel(buildingPart, getElementModel(buildingCar))
	r, g, b = getVehicleColor(buildingCar, true)
	setVehicleColor(buildingPart, r, g, b)
	attachElements(buildingPart, partObject)
	setElementPosition(partObject, 353.63305664063, 43.683124542236, 985.32788085938 + movetoZ)
	setElementAlpha(partObject, 0)
	showingTimer = setTimer(showOneComponent, 1000, 10, part)
	functionTimer = setTimer(function()
		functionTimer = false
		setElementPosition(partObject, 353.63305664063, 43.683124542236, 991.32788085938)
		setElementAlpha(partObject, 255)
		setElementAlpha(partObject, 0)
		moveObject(partObject, 3000, 349.14828491211, 43.618270874023, 991.33227539063 + movetoZ)
		functionTimer = setTimer(function()
			functionTimer = false
			_, carryMarker = exports["pd-markers"]:createCustomMarker(346.86895751953, 43.608123779297, 989.55627441406, 50, 155, 50, 155, "marker", 1)
			col = createColSphere(346.86895751953, 43.608123779297, 989.55627441406, 1.5)
			addEventHandler("onClientColShapeHit", col, takePart)
		end, 3000, 1)
	end, 1000, 1)
end

function createBuildCar()
	fadeCamera(false, 0.1)
	if buildingCar then
		destroyElement(buildingCar)
		buildingCar = false
	end
	-- tworzenie auta
	setTimer(function()
		local random = avaibleVehicles[math.random(1, #avaibleVehicles)]
		buildingCar = createVehicle(random[1], vehiclePosition[1], vehiclePosition[2], vehiclePosition[3] + random[2], 0, 0, vehiclePosition[4])
		setElementFrozen(buildingCar, true)
		setElementData(buildingCar, "vehicle:ghost:off", true)
	end, 100, 1)
	-- usuwanie czesci
	setTimer(function()
		for k, v in pairs(components) do
			if v ~= "chassis" then
				setVehicleComponentVisible(buildingCar, v, false)
			end
		end
		fadeCamera(true, 1)
	end, 1000, 1)
end

addCommandHandler("next", function()
	createBuildCar()
	setTimer(function()
		createBuildPart(getNextBuildPart())
	end, 1000, 1)
end)

function endJob()
	destroyBuildPart()
	carringPart = false
	toggleControl("sprint", true)
	toggleControl("crouch", true)
	toggleControl("jump", true)
	setElementData(localPlayer, "player:job", false)
	setElementPosition(localPlayer, 1109.1519775391, -1797.1179199219, 16.59375)
	triggerServerEvent("endJob", resourceRoot, localPlayer)
	triggerServerEvent("setSkin", resourceRoot, localPlayer, getElementData(localPlayer, "player:skin"))
	if ambient then
		stopSound(ambient)
	end
end

function startJob()
	if (isPedInVehicle(localPlayer)) then
		exports["pd-hud"]:showPlayerNotification("Wysiądź z pojazdu!", "error")
		return
	end
	exports["pd-achievements"]:addPlayerAchievement(localPlayer, "Pierwsza fucha", 5)
	ambient = playSound("sounds/ambient.mp3", true)
	setElementData(localPlayer, "player:job", "factory")
	triggerServerEvent("startJob", resourceRoot, localPlayer)
	exports["pd-loading"]:showLoading("Wczytywanie obiektów", 3000)
	setTimer(function()
		setElementPosition(localPlayer, 324.48361206055, 37.769248962402, 990.55627441406)
		triggerServerEvent("setSkin", resourceRoot, localPlayer, 50)
		createBuildCar()
		setTimer(function()
			createBuildPart(getNextBuildPart())
		end, 2000, 1)
	end, 2000, 1)
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports["pd-markers"]:destroyCustomMarker(carryMarker)
	exports["pd-markers"]:destroyCustomMarker(buildMarker)
end)