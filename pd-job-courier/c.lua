--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Virelox <virelox@gmail.com>
	# @filename: c.lua
	# @description: Praca kuriera - strona klienta
	# All rights reserved.
	##########################################################
--]]
local startPosition = Vector3(2145.5085449219, -2277.8713378906, 14.780630111694)

local textures = {}
local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local pack = false
local sound = false
local target_marker = false
local target_col = false
local client_ped = false
local blip = false
local client_marker = false
local client_col = false
local vehicle = false
local pack_count = 0
local pack_limit = 4
local ped = false
local packages_left = false
local order_id = false
local hold_package = false
local get_package_col = false
local speedy = false
local tips = false
local hud_active = false

local blips = {}
local peds = {}
local markers = {}
local colisions = {}

local pack_health = 100

local ped_selected = false

local place_id = 1

local packages_positions = {
	{0.4, -2, -0.1},
	{-0.4, -2, -0.1},
	{0.4, -2, 0.2},
	{-0.4, -2, 0.2},
	{0.4, -2, 0.5},
	{-0.4, -2, 0.5},
	{0.4, -2, 0.8},
	{-0.4, -2, 0.8},
	{0.4, -2, 1.1},
	{-0.4, -2, 1.1},
}

package_objects = {}






local clients_positions = {
	-- x,y,z, skin, rotacja
	{2790.2407226563, -1828.0161132813, 9.8509922027588, 55, 37.44356918335},
	{2693.634765625, -2009.3188476563, 13.5546875, 56, 180.61862182617},
	{2787.474609375, -1617.7741699219, 10.921875, 240, 261.03854370117},
	{2420.734375, -1229.9595947266, 24.74757194519, 174, 357.24588012695},
	{2717.3603515625, -1109.1551513672, 69.573463439941, 296, 86.015762329102},
	{2584.2502441406, -958.11437988281, 81.3515625, 237, 15.413966178894},
	{2071.78515625, -974.50463867188, 48.775703430176, 237, 349.82427978516},
	{2034.4675292969, -1408.9588623047, 17.1640625, 124, 2.9129297733307},
	{1828.4895019531, -1682.6186523438, 13.546875, 76, 270.97351074219},
	{1831.6634521484, -1759.6083984375, 13.546875, 178},
	{1545.2010498047, -1675.6278076172, 13.559899330139, 75, 271.53015136719},
	{1631.7255859375, -1166.6242675781, 24.078125, 232, 181.44738769531},
	{1461.9720458984, -1023.6936035156, 23.833103179932, 88, 358.08825683594},
	{1177.5025634766, -1068.4364013672, 28.876159667969, 220, 270.48132324219},
	{1199.8311767578, -921.26635742188, 43.100563049316, 48, 8.745644569397},
	{953.94769287109, -913.63555908203, 45.765625, 203, 0.36156034469604},
	{866.65997314453, -1255.6929931641, 14.951961517334, 85, 91.860038757324},
	{922.853515625, -1352.7620849609, 13.376600265503, 164, 264.48486328125},
	{877.61010742188, -1519.8702392578, 13.5546875, 69, 0.89805799722672},
	{803.07116699219, -1790.1875, 13.387446403503, 63, 177.61408996582},
	{315.62506103516, -1774.6451416016, 4.7537422180176, 163, 0.15773387253284},
	{481.73690795898, -1532.9722900391, 19.680076599121, 128, 113.43691253662},
	{383.12237548828, -1897.2729492188, 7.8359375, 26, 269.47076416016},
	{252.53332519531, -1221.5173339844, 75.448143005371, 141, 33.968425750732},
	{1330.7254638672, -629.09820556641, 109.1349029541, 81, 201.38230895996},
	{1497.1544189453, -692.54412841797, 94.75, 84, 3.0106902122498},
	{1280.8746337891, -1349.6550292969, 13.372113227844, 257, 269.28002929688},
	{1047.9757080078, -1269.8015136719, 13.636134147644, 54, 80.05460357666},
	{642.65686035156, -1360.8178710938, 13.589070320129, 157, 269.97985839844},
	{1108.7391357422, -742.08245849609, 100.13292694092, 198, 271.03750610352}
}


function fadeClientPed()
	if client_ped and fade_client then
		local now = getTickCount()
		local elapsedTime = now - startTime
		local duration =endTime - startTime
		local progress = elapsedTime / duration
		
		a, _, _ = interpolateBetween ( 
		255, 0, 0, 
		0, 0, 0, 
		progress, "Linear")
		
		
		setElementAlpha(ped_selected, a)
	end
end
addEventHandler ( "onClientRender", root, fadeClientPed )


function attachPackagesToVehicle(vehicle, count) 
	if not vehicle or not count then return end
	
	if #package_objects > 0 then
		for k,v in ipairs(package_objects) do
			if isElement(v) then destroyElement(v) end
		end
	end
	
	package_objects = {}
	
	if count ~= 0 then
		for k,v in ipairs(packages_positions) do
			local x,y,z = getElementPosition(vehicle)
			local object = createObject(3013, x, y, z)
			setElementCollisionsEnabled(object, false)
			table.insert(package_objects, object)
			attachElements(object, vehicle, v[1], v[2], v[3])
			if k == count then
				break
			end
		end
	end
end


function getPackageFromVehicle(element, md)
	if ( element == getLocalPlayer() ) then
		if not hold_package then
			hold_package = true 
			attachPackagesToVehicle(vehicle, packages_left-1)
			if isElement(get_package_col) then destroyElement(get_package_col) end
			exports["pd-markers"]:destroyCustomMarker(getPackageMarker)
			setVehicleDoorOpenRatio(vehicle, 4, 0, 2000)
			setVehicleDoorOpenRatio(vehicle, 5, 0, 2000)
		end
		
		triggerServerEvent("attachPackageToPlayer", resourceRoot)
	end
end


function givePackage(element, md)
	if ( element == getLocalPlayer() ) then
		if not hold_package then exports["pd-hud"]:showPlayerNotification("Najpierw wyciągnij paczkę z pojazdu!", "error") return end
		local id = getElementData(source, "id")
		
		packages_left = packages_left - 1
		
		fade_client = true
		startTime = getTickCount()
		endTime = getTickCount() +3000
		
		
		if packages_left == 0 then			
			setTimer ( function()
				endJob()
				exports["pd-hud"]:showPlayerNotification("Dowiozłeś już wszystkie zamówienia! Gratulacje!", "success")
				fade_client = false
			end, 3000, 1 )
		else
			setTimer ( function()
				if isElement(peds[id]) then destroyElement(peds[id]) end
				fade_client = false
			end, 3000, 1 )
		end
		
		ped_selected = peds[id]
		

		setElementFrozen(peds[id], false)
		setPedAnimation(peds[id])
		setPedControlState(peds[id], "forwards", true)
		setPedControlState(peds[id], "walk", true)
		setPedCameraRotation(peds[id], -(getPedCameraRotation(peds[id]) + 180))
		triggerServerEvent("attachPackageToPlayer", resourceRoot)
		hold_package = false
		attachPackagesToVehicle(vehicle, packages_left)
		
		if tips then 
			triggerServerEvent("giveRewardForCourier", resourceRoot, true)
		else
			triggerServerEvent("giveRewardForCourier", resourceRoot, false)
		end
		
		if packages_left == 0 then
			if tips then
				local reward = exports["pd-jobsettings"]:getJobData("courier", "tip_reward")
				exports["pd-hud"]:showPlayerNotification("Za dostarczenie przesyłki otrzymujesz ".. reward .."$ wraz z napiwkiem", "info")
			else
				local reward = exports["pd-jobsettings"]:getJobData("courier", "reward")
				exports["pd-hud"]:showPlayerNotification("Za dostarczenie przesyłki otrzymujesz ".. reward .."$", "info")
			end
		else
			if tips then
				local reward = exports["pd-jobsettings"]:getJobData("courier", "tip_reward")
				exports["pd-hud"]:showPlayerNotification("Za dostarczenie przesyłki otrzymujesz ".. reward .."$ wraz z napiwkiem. Udaj się do następnego klienta.", "info")
			else
				local reward = exports["pd-jobsettings"]:getJobData("courier", "reward")
				exports["pd-hud"]:showPlayerNotification("Za dostarczenie przesyłki otrzymujesz  ".. reward .."$. Udaj się do następnego klienta.", "info")
			end		
		end
		
		if isElement(blips[id]) then destroyElement(blips[id]) end
		if isElement(markers[id]) then destroyElement(markers[id]) end
		if isElement(colisions[id]) then destroyElement(colisions[id]) end
	end
end

function prepareToDrive(vehicle_data)
	vehicle = vehicle_data
	exports["pd-hud"]:showPlayerNotification("Zapakowałeś wszystkie paczki, udaj się teraz do miejsca zaznaczonego na mapie i dostarcz przesyłkę!", "info")
	packages_left = pack_limit
	attachPackagesToVehicle(vehicle, packages_left)
	
	createRoute(packages_left)
	toggleCourierHUD(true)
	
	addEventHandler("onClientVehicleDamage", vehicle, checkCourierVehicleDamage)
	
	addEventHandler("onClientVehicleEnter", vehicle,
    function(thePlayer, seat)
		toggleCourierHUD(true)
		if hold_package then
			triggerServerEvent("attachPackageToPlayer", resourceRoot)
			attachPackagesToVehicle(vehicle, packages_left)
			hold_package = false
		end
		
		if isElement(get_package_col) then destroyElement(get_package_col) end
		exports["pd-markers"]:destroyCustomMarker(getPackageMarker)
		setVehicleDoorOpenRatio(vehicle, 4, 0, 2000)
		setVehicleDoorOpenRatio(vehicle, 5, 0, 2000)
    end
	)
	
	addEventHandler("onClientVehicleExit", vehicle,
	function(thePlayer, seat)
		if thePlayer == localPlayer then
			local x,y,z = getElementPosition(vehicle)
			
			get_package_col = createColSphere(x,y,z, 1)
			_, getPackageMarker = exports["pd-markers"]:createCustomMarker(x, y, z - 1, 50, 255, 50, 155, "marker", 1.5)
			exports["pd-markers"]:attachCustomMarker(getPackageMarker, vehicle, 0, -5, -1)
			attachElements(get_package_col, vehicle, 0, -5, 0)
			addEventHandler("onClientColShapeHit", get_package_col, getPackageFromVehicle)
			setVehicleDoorOpenRatio(vehicle, 4, 1, 2000)
			setVehicleDoorOpenRatio(vehicle, 5, 1, 2000)
			toggleCourierHUD(false)
		end
    end
	)
end
addEvent("prepareToDrive", true)
addEventHandler("prepareToDrive", resourceRoot, prepareToDrive)



function createRoute(count)
	if count then 		
		local data = {} 
		repeat 
			local found = false 
			local rand = clients_positions[math.random(1, #clients_positions)]
			for k, v in ipairs(data) do 
				if v == rand then 
					found = true 
				end
			end
			
			if not found then 
				table.insert(data, rand)
			end
		until #data == count
	
	
		for i,v in ipairs(data) do
			blips[i] = createBlip(v[1], v[2], v[3], 41, 2, 255, 255, 255, 255, 0, 99999)
			peds[i] = createPed(v[4], v[1], v[2], v[3])
			setElementFrozen(peds[i], true)
			addEventHandler("onClientPedDamage", peds[i], function() cancelEvent() end)
			if not isElement(peds[i]) then
				outputConsole("Błąd tworzenia peda! (".. v[1] ..", ".. v[2] ..", ".. v[3] ..")")
			end
			setElementRotation(peds[i], 0, 0, v[5]-180)
			setPedAnimation(peds[i], "ped","XPRESSscratch")
			addEventHandler ( "onClientPedDamage", peds[i], function()
				cancelEvent()
			end)

			colisions[i] = createColSphere(v[1], v[2], v[3], 1)
			setElementData(colisions[i], "id", i)
			addEventHandler("onClientColShapeHit", colisions[i], givePackage)
		end
	end
end

function startJobCourier(place)
	if (isPedInVehicle(localPlayer)) then
		exports["pd-hud"]:showPlayerNotification("Wysiądź z pojazdu!", "error")
		return
	end
	if getElementData(localPlayer, "player:job") then 
		exports["pd-hud"]:showPlayerNotification("Już pracujesz!", "error")
		return
	end 
	
	local upgrades = getElementData(localPlayer, "player:job_upgrades") or {}
	if upgrades["courier"] then 
		for k, v in ipairs(upgrades["courier"].upgrades) do 
			if v == "speedy" then 
				pack_limit = 6
			end
			
			if v == "condition" then
				speedy = true
			end
			
			if v == "tip" then
				tips = true
			end
		end
	end 
	place_id = place
	
	if place_id == 1 then
		vehicle = createVehicle(498, 2170.2673339844, -2261.6997070313, 13.383547782898, 0, 0, 226)
	else
		vehicle = createVehicle(498, 2155.1518554688, -2275.703125, 13.381121635437, 0, 0, 226)
	end
	setElementFrozen(vehicle, true)
	setVehicleDamageProof(vehicle, true)
	setElementData(vehicle, "vehicle:static", true)
	setVehicleDoorOpenRatio(vehicle, 4, 1)
	setVehicleDoorOpenRatio(vehicle, 5, 1)
	setTimer ( function(vehicle)
			setVehicleColor(vehicle, 245, 245, 245, 245, 245, 245)
	end, 1000, 1, vehicle)
	triggerServerEvent("onPlayerStartJob", resourceRoot)
	createObjectPack()
	exports["pd-hud"]:showPlayerNotification("Pomyślnie rozpocząłeś pracę! Podejdź do taśmociągu który znajduje się obok i weź paczkę.",	"info")
	toggleControl("sprint", false)
end 
addEvent("startJobCourier", true)
addEventHandler("startJobCourier", resourceRoot, startJobCourier)

function putObjectPack(element, md)
	if ( element == getLocalPlayer() ) then
		triggerServerEvent("attachPackageToPlayer", resourceRoot)
		hold_package = false
		if isElement(target_marker) then destroyElement(target_marker) end
		if isElement(target_col) then destroyElement(target_col) end
		exports["pd-markers"]:destroyCustomMarker(targetMarker)
		
		pack_count = pack_count + 1
		attachPackagesToVehicle(vehicle, pack_count)
		
		local pack_left = pack_limit - pack_count
		
		if pack_left ~= 0 then
			exports["pd-hud"]:showPlayerNotification("Udało ci się donieść paczkę, weź następną. Ilość pozostałych paczek ".. pack_left .."", "success")
		end
		
		if pack_count < pack_limit then
			createObjectPack()
		else
			for k,v in ipairs(package_objects) do
				destroyElement(v)
			end
			destroyElement(vehicle)
			triggerServerEvent("createCourierVehicle", resourceRoot, place_id)
		end
	end
end

function getObjectPack(element, md)
	 if ( element == getLocalPlayer() ) then
		if isElement(sound) then destroyElement(sound) end
		if isElement(target_marker) then destroyElement(target_marker) end
		if isElement(target_col) then destroyElement(target_col) end
		exports["pd-markers"]:destroyCustomMarker(targetMarker)
		
		setElementFrozen(localPlayer, true)
		setTimer(function()
			destroyElement(pack)
			triggerServerEvent("attachPackageToPlayer", resourceRoot)
			hold_package = true
			setElementFrozen(localPlayer, false)
		end, 500, 1)

		if place_id == 1 then
			target_col = createColSphere(2167.68, -2259.2, 13.3, 1)
			_, targetMarker = exports["pd-markers"]:createCustomMarker(2167.68, -2259.2, 13.3 - 1, 50, 255, 50, 155, "marker", 1.5)
		else
			target_col = createColSphere(2152.56, -2273.2, 13.3, 1)
			_, targetMarker = exports["pd-markers"]:createCustomMarker(2152.56, -2273.2, 13.3 - 1, 50, 255, 50, 155, "marker", 1.5)
		end
		addEventHandler("onClientColShapeHit", target_col, putObjectPack)
		exports["pd-hud"]:showPlayerNotification("Zanieś teraz paczkę do pojazdu za tobą.", "info")
	end
end

function createObjectPack()
	if isElement(pack) then destroyElement(pack) end
	if isElement(sound) then destroyElement(sound) end
	if isElement(target_marker) then destroyElement(target_marker) end
	if isElement(target_col) then destroyElement(target_col) end
	exports["pd-markers"]:destroyCustomMarker(targetMarker)
	
	if place_id == 1 then
		pack = createObject(3013, 2153.1711425781, -2245.5026855469, 14.226576805115, 0, 0, 50)
		sound = playSound3D("sounds/machine.mp3", 2141.04, -2263.83, 13.3)
		moveObject(pack, 5000, 2157.6809082031, -2250.1037597656, 14.232870101929-0.85)
		setTimer ( function()
			stopSound(sound)
			target_col = createColSphere(2158.4724121094, -2250.94140625, 13.443864822388, 1)
			_, targetMarker = exports["pd-markers"]:createCustomMarker(2158.4724121094, -2250.94140625, 13.443864822388 - 1, 50, 255, 50, 155, "marker", 1.5)
			addEventHandler("onClientColShapeHit", target_col, getObjectPack)
		end, 5000, 1 )
	else
		pack = createObject(3013, 2138.5339355469, -2261.0014648438, 14.226576805115-0.85, 0, 0, 50)
		sound = playSound3D("sounds/machine.mp3", 2142.9758300781, -2265.4836425781, 14.13)
		moveObject(pack, 5000, 2142.9758300781, -2265.4836425781, 14.226576805115	-0.85)
		setTimer ( function()
			stopSound(sound)			
			target_col = createColSphere(2144.0383300781, -2266.40625, 13.438621520996, 1)
			_, targetMarker = exports["pd-markers"]:createCustomMarker(2144.0383300781, -2266.40625, 13.438621520996 - 1, 50, 255, 50, 155, "marker", 1.5)
			addEventHandler("onClientColShapeHit", target_col, getObjectPack)
		end, 5000, 1 )
	end
end


function endJob(instant)
	if isElement(pack) then destroyElement(pack) end
	if isElement(sound) then destroyElement(sound) end
	if isElement(target_marker) then destroyElement(target_marker) end
	if isElement(client_ped) then destroyElement(client_ped) end
	if isElement(blip) then destroyElement(blip) end
	if isElement(client_marker) then destroyElement(client_marker) end
	if isElement(client_col) then destroyElement(client_col) end
	if isElement(ped) then destroyElement(ped) end
	if isElement(get_package_col) then destroyElement(get_package_col) end
	exports["pd-markers"]:destroyCustomMarker(targetMarker)
	exports["pd-markers"]:destroyCustomMarker(getPackageMarker)

	
	pack_count = 0
	pack_limit = 4
	packages_left = false
	order_id = false
	hold_package = false
	pack_health = 100
	
	for k,v in ipairs(blips) do
		if isElement(v) then destroyElement(v) end
	end
	blips = {}
	
	for k,v in ipairs(peds) do
		if isElement(v) then destroyElement(v) end
	end
	peds = {}
	
	for k,v in ipairs(markers) do
		if isElement(v) then destroyElement(v) end
	end
	markers = {}
	
	for k,v in ipairs(colisions) do
		if isElement(v) then destroyElement(v) end
	end
	colisions = {}

	
	for k,v in ipairs(package_objects) do
		if isElement(v) then destroyElement(v) end
	end

	triggerServerEvent("onPlayerEndJob", resourceRoot)
	triggerServerEvent("destroyCourierVehicle", resourceRoot)
	triggerServerEvent("attachPackageToPlayer", resourceRoot, true)


	if not instant then
		fadeCamera(false, 1, 0, 0, 0)
	
		setTimer ( function()
			fadeCamera(true, 1, 0, 0, 0)
		end, 2000, 1 )
	end
	
	toggleControl("jump", true)
	toggleControl("sprint", true)
	toggleControl("walk", true)
	toggleControl("crouch", true)
	setControlState("walk", false)
	setPedAnimation(localPlayer, "ped", "facanger", 50, true, true, true, true)
	
	toggleCourierHUD(false)
end 


addEventHandler("onClientResourceStart", resourceRoot, function()
	
	-- start pracy
	local blip = createBlip(startPosition.x, startPosition.y, startPosition.z, 11)
	setBlipVisibleDistance(blip, 250)
	
	local col = createColSphere(startPosition.x, startPosition.y, startPosition.z, 2)
	_, startJobMarker = exports["pd-markers"]:createCustomMarker(startPosition.x, startPosition.y, startPosition.z - 1, 50, 255, 50, 155, "marker", 4.5)
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

addEventHandler("onClientResourceStop", resourceRoot, function()
	if getElementData(localPlayer, "player:job") == "courier" then 
		endJob(true)
	end
	exports["pd-markers"]:destroyCustomMarker(startJobMarker)
	exports["pd-markers"]:destroyCustomMarker(targetMarker)
	exports["pd-markers"]:destroyCustomMarker(getPackageMarker)
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if getElementData(localPlayer, "player:job") == "courier" then 
		endJob()
	end
end)


function antySprint()
	if getElementData(localPlayer, "player:job") == "courier" then
		if hold_package and not speedy then
			setControlState("walk", true)
		else
			setControlState("walk", false)
		end
	end
end
setTimer(antySprint, 500, 0)

local textures = {}
local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()

local backgroundPos = {w=math.floor(958/zoom/2.3), h=math.floor(257/zoom/2.3)}
backgroundPos.x = math.floor(screenW/2-backgroundPos.w/2)
backgroundPos.y = math.floor(50/zoom)

local progressPos = {w=math.floor(1074/zoom/3), h=math.floor(74/zoom/3)}
progressPos.x = math.floor(screenW/2-progressPos.w/2)
progressPos.y = math.floor(50/zoom)

function renderCourierHUD()
	local progress = pack_health / 100
	
	dxDrawImage(backgroundPos.x, backgroundPos.y, backgroundPos.w, backgroundPos.h, textures.background)
	dxDrawImage(progressPos.x, progressPos.y+60/zoom, progressPos.w, progressPos.h, textures.progress)
	dxSetRenderTarget(textures.progress_rt, true)
		dxDrawImage(0, 0, progressPos.w, progressPos.h, textures.progress_active, 0, 0, 0, tocolor(255, 255, 255, 255))
	dxSetRenderTarget()
	dxDrawImageSection(math.floor(progressPos.x-(progressPos.w-(progressPos.w*progress))), progressPos.y+60/zoom, progressPos.w, progressPos.h, math.floor(progressPos.w+(progressPos.w*progress)), 0, progressPos.w, progressPos.h, textures.progress_rt, 0, 0, 0, tocolor(255, 255, 255, 255), true)
	dxDrawText("Stan towaru:", backgroundPos.x, backgroundPos.y+20/zoom, backgroundPos.x+backgroundPos.w, backgroundPos.h, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
end

function toggleCourierHUD(toggle)
	
	if toggle then
		if hud_active then return end
		if vehicle ~= getPedOccupiedVehicle(localPlayer) then return end
		textures.background = dxCreateTexture("images/hud_background.png")
		textures.progress = dxCreateTexture("images/progressbar.png")
		textures.progress_active = dxCreateTexture("images/progressbar_active.png")
		textures.progress_rt = dxCreateRenderTarget(progressPos.w*2, progressPos.h+1, true)
		addEventHandler ( "onClientRender", root, renderCourierHUD )
		hud_active = true
	else
		for k, v in pairs(textures) do 
			destroyElement(v)
		end
		textures = {}
		hud_active = false
		removeEventHandler("onClientRender", root, renderCourierHUD)
	end
end


function checkCourierVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
	if not attacker then
		local damage = 0
		local lock = false
		
		if loss >=20 then
			damage = 10
		end
		
		if loss >= 40 then
			damage = 20
		end
		
		if loss >= 60 then
			damage = 30
		end
		
		if damage > pack_health then
			damage = pack_health
		end
		
		pack_health = pack_health - damage
		
		
		if pack_health == 0 then
			if not lock then
				endJob()
				exports["pd-hud"]:showPlayerNotification("Praca została zakończona z powodu uszkodzenia towaru!", "error")
				lock = true
			end
		end
		
		setTimer ( function()
			lock = false
		end, 1000, 1 )
	end
end
