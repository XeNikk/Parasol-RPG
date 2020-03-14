local repairPlaces = {
	{864.04321289063, -1179.255859375, 17, 866.23370361328, -1181.1840820313, 17},
	{857.00427246094, -1179.2396240234, 17, 857.00427246094, -1179.2396240234, 17},
	{850.16937255859, -1178.8331298828, 17, 851.76068115234, -1180.8699951172, 17}
}
local repairMarkers = {}
local currentVehicle = false
local customMarkers = {}
local senderOffer = false
local zoom = exports["pd-gui"]:getInterfaceZoom()
local sx, sy = guiGetScreenSize()
local toRepairTable = {}
local repairingVehicle = false
local comboBoxVehicle = false
local toFix = {
	{"Silnik", 1, fn=function(veh) if getElementHealth(veh)>=2040 then return true end; return false, ((1000-getElementHealth(veh)) / 50) end}, 
	{"Maska", 2, fn=function(veh) if getVehicleDoorState(veh, 0)==0 or getVehicleDoorState(veh, 0)==1 then return true end; return false, 25 end},
	{"Bagażnik", 3, fn=function(veh) if getVehicleDoorState(veh, 1)==0 or getVehicleDoorState(veh, 1)==1 then return true end; return false, 25 end},
	{"Drzwi, lewy przód", 4, fn=function(veh) if getVehicleDoorState(veh, 2)==0 or getVehicleDoorState(veh, 2)==1 then return true end; return false, 10 end},
	{"Drzwi, prawy przód", 5, fn=function(veh) if getVehicleDoorState(veh, 3)==0 or getVehicleDoorState(veh, 3)==1 then return true end; return false, 10 end},
	{"Drzwi, lewy tył", 6, fn=function(veh) if getVehicleDoorState(veh, 4)==0 or getVehicleDoorState(veh, 4)==1 then return true end; return false, 10 end},
	{"Drzwi, prawy tył", 7, fn=function(veh) if getVehicleDoorState(veh, 5)==0 or getVehicleDoorState(veh, 5)==1 then return true end; return false, 10 end},
	{"Szyba", 8, fn=function(veh) if getVehiclePanelState(veh, 4)==0 then return true end; return false, 10 end},
	{"Zderzak przód", 9, fn=function(veh) if getVehiclePanelState(veh, 5)==0 then return true end; return false, 20 end},
	{"Zderzak tył", 10, fn=function(veh) if getVehiclePanelState(veh, 6)==0 then return true end; return false, 20 end},
	{"Światła, lewy przód", 11, fn=function(veh) if getVehicleLightState(veh, 0)==0 then return true end; return false, 15 end},
	{"Światła, prawy przód", 12, fn=function(veh) if getVehicleLightState(veh, 1)==0 then return true end; return false, 15 end},
}
local repairPositions = {
	{"Silnik", "Maska", "Zderzak przód", "Szyba", unical="Przód", x = 0, y = "y1", z = 0},
	{"Bagażnik", "Zderzak tył", unical="Tył", x = 0, y = "y0", z = 0},
	{"Drzwi, lewy przód", unical="Lewe drzwi", x = "x0", y = 0.25, z = 0},
	{"Drzwi, prawy przód", unical="Prawe drzwi", x = "x1", y = 0.25, z = 0},
	{"Drzwi, lewy tył", unical="Lewe drzwi tył", x = "x0", y = -0.75, z = 0},
	{"Drzwi, prawy tył", unical="Prawe drzwi tył", x = "x1", y = -0.75, z = 0},
	{"Światła, lewy przód", unical="Światło lewe", x = "x0", y = "y1", z = 0},
	{"Światła, prawy przód", unical="Światło prawe", x = "x1", y = "y1", z = 0},
}
local textures = {
	button = dxCreateTexture("images/button.png")
}

setElementData(localPlayer, "player:placeReserved", false)

function getRepairMultiplier(veh)
	class = exports["pd-vehicles"]:getModelClass(getElementModel(veh))
	if class == "A" then
		return 3.5
	elseif class == "B" then
		return 2.5
	elseif class == "C" then
		return 2
	elseif class == "D" then
		return 1.5
	else
		return 1
	end
end

function checkWhatNeedRepair(veh)
	local repairTable = {}
	for k,v in pairs(toFix) do
		local value, cost = v.fn(veh)
		if value == false and cost > 0 then
			table.insert(repairTable, {name=v[1], cost=math.floor(getRepairMultiplier(veh)*cost), selected=false})
		end
	end
	return repairTable
end

addEventHandler("onClientClick", root, function(button, state)
	if button ~= "left" or state ~= "down" then return end
	offset = 50/zoom
	for k,v in pairs(toRepairTable) do
		if isMouseInPosition(sx/2 - 300/zoom, sy/2 - 350/zoom + offset, 600/zoom, 35/zoom) then
			v.selected = not v.selected
		end
		offset = offset + 40/zoom
	end
end)

function renderRepairGUI()
	dxDrawImage(sx/2 - 350/zoom, sy/2 - 400/zoom, 700/zoom, 800/zoom, "images/background2.png")
	exports["pd-gui"]:renderButton(repairSelectedButton)
	exports["pd-gui"]:renderButton(repairAllButton)

	dxDrawText("Nazwa komponentu", sx/2 - 300/zoom, sy/2 - 350/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
	dxDrawText("Koszt naprawy", sx/2 + 100/zoom, sy/2 - 350/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"))

	offset = 50/zoom
	for k,v in pairs(toRepairTable) do
		local x, y, w, h = sx/2 - 300/zoom, sy/2 - 350/zoom + offset, 600/zoom, 35/zoom
		if isMouseInPosition(x, y, w, h) then
			ac = 15
		else
			ac = 0
		end
		dxDrawRectangle(x, y, w, h, v.selected and tocolor(255, 0 + ac, 125 + ac, 155) or tocolor(0 + ac, 0 + ac, 0 + ac, 155))
		dxDrawText(v.name, sx/2 - 292/zoom, sy/2 - 343/zoom + offset, sx, sy, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		dxDrawText("$"..v.cost, sx/2 + 105/zoom, sy/2 - 343/zoom + offset, sx, sy, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		offset = offset + 40/zoom
	end
end

function renderOfferGUI()
	dxDrawImage(sx/2 - 350/zoom, sy/2 - 400/zoom, 700/zoom, 800/zoom, "images/background2.png")
	exports["pd-gui"]:renderButton(acceptOffer)
	exports["pd-gui"]:renderButton(cancelOffer)

	dxDrawText("Nazwa komponentu", sx/2 - 300/zoom, sy/2 - 350/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
	dxDrawText("Koszt naprawy", sx/2 + 100/zoom, sy/2 - 350/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"))

	offset = 50/zoom
	costofall = 0
	for k,v in pairs(toRepairTable) do
		local x, y, w, h = sx/2 - 300/zoom, sy/2 - 350/zoom + offset, 600/zoom, 35/zoom
		dxDrawRectangle(x, y, w, h, tocolor(25, 25, 25, 155))
		dxDrawText(v.name, sx/2 - 292/zoom, sy/2 - 343/zoom + offset, sx, sy, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		dxDrawText("$"..v.cost, sx/2 + 105/zoom, sy/2 - 343/zoom + offset, sx, sy, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		offset = offset + 40/zoom
		costofall = costofall + v.cost
	end
	
	dxDrawText("Całkowity koszt naprawy: $" .. costofall, sx/2, sy/2 + 250/zoom, sx/2, sy/2 + 250/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "center")
end

addEvent("sendOffer", true)
addEventHandler("sendOffer", localPlayer, function(sender, toRepair)
	addEventHandler("onClientRender", root, renderOfferGUI)
	showCursor(true)
	senderOffer = sender
	toRepairTable = toRepair
end)

addEvent("playSound3D", true)
addEventHandler("playSound3D", resourceRoot, function(x, y, z)
	playSound3D("sounds/repair.mp3", x, y, z)
end)

function repairPart(vehicle, element, marker, col)
	exports["pd-markers"]:destroyCustomMarker(marker)
	destroyElement(col)
	triggerServerEvent("repairPart", resourceRoot, localPlayer, vehicle, element)
	triggerServerEvent("setPedAnimation", resourceRoot, localPlayer)
	setElementFrozen(localPlayer, false)
end

function startRepair(element)
	if element == localPlayer and not getPedOccupiedVehicle(localPlayer) then
		setElementFrozen(localPlayer, true)
		local repairData =  getElementData(source, "repair:data")
		if repairData then
			if isElement(repairData.vehicle) then
				setTimer(repairPart, 2000, 1, repairData.vehicle, repairData.unical, repairData.marker, source)
				local x, y, z = getElementPosition(localPlayer)
				triggerServerEvent("setPedAnimation", resourceRoot, localPlayer, "bomber", "bom_plant")
				triggerServerEvent("playSound3D", resourceRoot, x, y, z)
			else
				stopRepairingVehicle()
			end
		end
	end
end

addEvent("createRepairPlaces", true)
addEventHandler("createRepairPlaces", localPlayer, function(veh, tabel)
	stopRepairingVehicle()
	local foundElements = {}
	repairingVehicle = veh
	for k,v in pairs(repairPositions) do
		local found = false
		for _, data in pairs(v) do
			for _, c in pairs(tabel) do
				if c.name == data then
					found = true
					break
				end
			end
		end
		if found then
			table.insert(foundElements, {unical=v.unical, x=v.x, y=v.y, z=v.z})
		end
	end
	local x, y, z = getElementPosition(veh)
	for k,v in pairs(foundElements) do
		local x0, y0, z0, x1, y1, z1 = getElementBoundingBox(veh)
		local boundingBox = {["x0"] = x0, ["y0"] = y0, ["z0"] = z0, ["x1"] = x1, ["y1"] = y1, ["z1"] = z1}
		if tonumber(v.x) then
			cx = v.x
		else
			cx = boundingBox[v.x]
		end
		if tonumber(v.y) then
			cy = v.y
		else
			cy = boundingBox[v.y]
		end
		if tonumber(v.z) then
			cz = v.z
		else
			cz = boundingBox[v.z]
		end
		local cx, cy, cz = cx * 1.25, cy * 1.25, cz
		local ground = getGroundPosition(x, y, z)
		_, marker = exports["pd-markers"]:createCustomMarker(0, 0, 0, 255, 255, 55, 255 * 1.5, "repair", 1)
		exports["pd-markers"]:attachCustomMarker(marker, veh, cx, cy, z - ground - 1.5)
		col = createColSphere(0, 0, 0, 1)
		setElementData(col, "repair:data", {marker=marker, name=v.name, vehicle=veh, unical=v.unical})
		attachElements(col, veh, cx, cy, z - ground - 1)
		table.insert(repairMarkers, marker)
		addEventHandler("onClientColShapeHit", col, startRepair)
	end
end)

function stopRepairingVehicle()
	setElementFrozen(localPlayer, false)
	repairingVehicle = false
	for k,v in pairs(getElementsByType("colshape")) do
		if getElementData(v, "repair:data") then
			destroyElement(v)
		end
	end
	if repairMarkers then
		for k,v in pairs(repairMarkers) do
			exports["pd-markers"]:destroyCustomMarker(v)
		end
	end
end

setTimer(function()
	if repairingVehicle then
		if isElement(repairingVehicle) then
			local x, y, z = getElementPosition(localPlayer)
			local x2, y2, z2 = getElementPosition(repairingVehicle)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if dist > 10 or not getVehicleController(repairingVehicle) then
				stopRepairingVehicle()
			end
		else
			stopRepairingVehicle()
		end
	end
end, 1000, 0)

function showRepairGUI(vehicle)
	toRepairTable = checkWhatNeedRepair(vehicle)
	if #toRepairTable > 0 then
		setElementFrozen(localPlayer, true)
		currentVehicle = vehicle
		addEventHandler("onClientRender", root, renderRepairGUI)
		showCursor(true)
	end
end

function hideRepairGUI()
	setElementFrozen(localPlayer, false)
	currentVehicle = false
	removeEventHandler("onClientRender", root, renderRepairGUI)
	showCursor(false)
end

for k,v in pairs(repairPlaces) do
	_, marker = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 0.75, 500, 55, 55, 255 * 1.5, "repair", 1)
	table.insert(customMarkers, marker)
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(customMarkers) do
		exports["pd-markers"]:destroyCustomMarker(v)
	end
	stopRepairingVehicle()
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	repairSelectedButton = exports["pd-gui"]:createButton("Napraw zaznaczone", sx/2 - 190/zoom, sy/2 + 320/zoom, 190/zoom, 50/zoom)
	exports["pd-gui"]:setButtonTextures(repairSelectedButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(repairSelectedButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", repairSelectedButton, function()
		newToRepairTable = {}
		for k,v in pairs(toRepairTable) do
			if v.selected then
				table.insert(newToRepairTable, v)
			end
		end
		if #newToRepairTable > 0 then
			triggerServerEvent("sendRepairOffert", resourceRoot, localPlayer, newToRepairTable, currentVehicle)
			hideRepairGUI()
			exports["pd-hud"]:showPlayerNotification("Wysłano propozycję naprawy.", "info")
		else
			exports["pd-hud"]:showPlayerNotification("Wybierz co chcesz naprawić.", "error")
		end
	end)

	repairAllButton = exports["pd-gui"]:createButton("Napraw wszystko", sx/2, sy/2 + 320/zoom, 190/zoom, 50/zoom)
	exports["pd-gui"]:setButtonTextures(repairAllButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(repairAllButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", repairAllButton, function()
		triggerServerEvent("sendRepairOffert", resourceRoot, localPlayer, toRepairTable, currentVehicle)
		hideRepairGUI()
		exports["pd-hud"]:showPlayerNotification("Wysłano propozycję naprawy.", "info")
	end)

	acceptOffer = exports["pd-gui"]:createButton("Akceptuj", sx/2 - 190/zoom, sy/2 + 320/zoom, 190/zoom, 50/zoom)
	exports["pd-gui"]:setButtonTextures(acceptOffer, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(acceptOffer, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", acceptOffer, function()
		costofall = 0
		for k,v in pairs(toRepairTable) do
			costofall = costofall + v.cost
		end
		triggerServerEvent("acceptRepairOffer", resourceRoot, localPlayer, senderOffer, toRepairTable, costofall)
		removeEventHandler("onClientRender", root, renderOfferGUI)
		showCursor(false)
	end)

	cancelOffer = exports["pd-gui"]:createButton("Anuluj", sx/2, sy/2 + 320/zoom, 190/zoom, 50/zoom)
	exports["pd-gui"]:setButtonTextures(cancelOffer, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelOffer, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", cancelOffer, function()
		triggerServerEvent("cancelRepairOffer", resourceRoot, localPlayer, senderOffer)
		removeEventHandler("onClientRender", root, renderOfferGUI)
		showCursor(false)
	end)
end)

addEventHandler("onClientColShapeHit", root, function(el, md)
	local repairOwner = getElementData(source, "repair:owner")
	if el == localPlayer and md and not isPedInVehicle(el) and repairOwner then
		if repairOwner == "Brak" then
			triggerServerEvent ("reserveRepairPlace", resourceRoot, localPlayer, source)
		elseif repairOwner == getPlayerName(localPlayer) then
			local data = getElementData(source, "repairSphere")
			local vehicle = false
			for k,v in pairs(getElementsWithinColShape(data[1], "vehicle")) do
				if isElement(v) then
					vx, vy, vz = getElementVelocity(v)
					if math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161) < 2 then
						vehicle = v
						break
					end
				end
			end
			if isElement(vehicle) then
				showRepairGUI(vehicle)
			end
		end
	end
end)

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end