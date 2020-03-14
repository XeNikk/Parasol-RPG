

sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()

vstore = {
	enabled = false,
}

local k = 1
local n = 6
local m = 6

vstore.texmaintitle = dxCreateTexture("images/main_title.png")
vstore.texbg = dxCreateTexture("images/background.png")
vstore.texcolor = dxCreateTexture("images/color.png")
vstore.texdata = dxCreateTexture("images/data_background.png")
vstore.texdataactive = dxCreateTexture("images/data_background_active.png")

vstore.draw = function()
	dxDrawImage(100/zoom, 100/zoom, 447/zoom, 135/zoom, vstore.texmaintitle,0,0,0, tocolor(255,255,255,255))
	local x = 0
	for i, v in ipairs(loadedVehicles) do
		if i >= k and i <= n then
			x = x+1
			scroll = (62/zoom)*(x-1)
			if isMouseIn(100/zoom, 235/zoom+scroll, 447/zoom, 62/zoom) then 
				dxDrawImage(100/zoom, 235/zoom+scroll, 447/zoom, 62/zoom, vstore.texdataactive,0,0,0, tocolor(255,255,255,255))
			else
				dxDrawImage(100/zoom, 235/zoom+scroll, 447/zoom, 62/zoom, vstore.texdata,0,0,0, tocolor(255,255,255,255))
			end
			local vehName = getVehicleNameFromModel(v.model)
			dxDrawText("["..v.id.."] "..vehName, 114/zoom, 247/zoom+scroll, 447/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left")
			if isMouseIn(100/zoom, 235/zoom+scroll, 447/zoom, 62/zoom) then 
				dxDrawImage(562/zoom, 100/zoom, 642/zoom, 452/zoom, vstore.texbg)
				dxDrawText(vehName, 580/zoom, 110/zoom, 447/zoom, 62/zoom, tocolor(214, 10, 232,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "left")
				dxDrawText("\nPrzebieg: "..v.przeb.. " km\nPojemność silnika: ".. math.floor(tonumber(v.poj)*10)/10 .. " dm3\nUlepszenie silnika: "..v.up.."/5\nRegulacja zawieszenia: "..v.gz.."\nHydraulika: "..v.hydraulic.."\nNitro: "..v.nitro.."\nTurbosprężarka: "..v.turbo.."\nTyp pojazdu: "..v.typ.."\nNapęd: "..v.naped.."\nTyp paliwa: "..v.typpaliwa.."\nInstalacja LPG: "..v.lpg.."", 580/zoom, 130/zoom, 447/zoom, 62/zoom, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "left")
				dxDrawImage(1030/zoom, 110/zoom, 150/zoom, 150/zoom, "images/klasy/"..v.klasa..".png")
				dxDrawText("Klasa pojazdu", 1108/zoom, 250/zoom, 1100/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
				local rgb = split(v.color, " ")

				dxDrawImage(1120/zoom, 270/zoom, 60/zoom, 60/zoom, vstore.texcolor, 0,0,0, tocolor(rgb[1],rgb[2],rgb[3], 255))
				dxDrawText("Kolor podstawowy", 1118/zoom, 285/zoom, 1118/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right")

				dxDrawImage(1120/zoom, 320/zoom, 60/zoom, 60/zoom, vstore.texcolor, 0,0,0, tocolor(rgb[4],rgb[5],rgb[6], 255))
				dxDrawText("Kolor dodatkowy", 1118/zoom, 335/zoom, 1118/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right")

				dxDrawImage(1120/zoom, 370/zoom, 60/zoom, 60/zoom, vstore.texcolor, 0,0,0, tocolor(rgb[7],rgb[8],rgb[9], 255))
				dxDrawText("Kolor świateł", 1118/zoom, 385/zoom, 1118/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right")
			end
		end
	end

end

vstore.start = function(table)
	addEventHandler("onClientRender", root, vstore.draw)
	showChat(false)
	showCursor(true, false)
	x = 0
	k = 1
	n = 6
	m = 6
	vstore.enabled = true
	for k,v in pairs(table) do
		for i = 1, 5 do
			if string.find(v["addTune"], "us" .. i) then
				v["up"] = v["up"] + 1
			end
		end
		if string.find(v["tuning"], "1087") then
			v["hydraulic"] = "Tak"
		else
			v["hydraulic"] = "Nie"
		end
		if string.find(v["addTune"], "gz") then
			v["gz"] = "Tak"
		else
			v["gz"] = "Nie"
		end
		if string.find(v["addTune"], "turbo") then
			v["turbo"] = "Tak"
		else
			v["turbo"] = "Nie"
		end
		if string.find(v["addTune"], "lpg") then
			v["lpg"] = "Tak"
		else
			v["lpg"] = "Nie"
		end
		if string.find(v["tuning"], "1008") or string.find(v["tuning"], "1009") or string.find(v["tuning"], "1010") then
			v["nitro"] = "Tak"
		else
			v["nitro"] = "Nie"
		end
	end
	loadedVehicles = table
end
addEvent("przecho:start", true)
addEventHandler("przecho:start", root, vstore.start)

addEvent("przecho:cantSpawn", true)
addEventHandler("przecho:cantSpawn", root, function()
	exports["pd-hud"]:addNotification("Wyjazd jest zablokowany.", "error", 5000, nil, "error")
end)

addEvent("przecho:canSpawn", true)
addEventHandler("przecho:canSpawn", root, function(model)
	exports["pd-hud"]:addNotification("Zespawnowałeś "..model..".\nZjedź z miejsca spawnu i nie blokuj innych!", "success", 5000, nil, "success")
end)

bindKey("mouse1", "down", function()
	if vstore.enabled == false then return end
	--local x = 0
	for i, v in ipairs(loadedVehicles) do
		if i >= k and i <= n then
			x = x+1
			scroll = (62/zoom)*(x-1)
			if isMouseIn(100/zoom, 235/zoom+scroll, 447/zoom, 62/zoom) then 
				local name = getVehicleNameFromModel(v.model)
				removeEventHandler("onClientRender", root, vstore.draw)
				showChat(true)
				showCursor(false)
				vstore.enabled = false
				triggerServerEvent("przecho:spawnCar", localPlayer, localPlayer, v.id, getElementData(localPlayer, "player:store:show"), name)
			end 
		end
	end
end)

bindKey("mouse_wheel_down", "both", function()
	if vstore.enabled == false then return end
	if n >= #loadedVehicles then return end
	k = k+1
	n = n+1
end)

bindKey("mouse_wheel_up", "both", function()
	if vstore.enabled == false then return end
	if n == m then return end
	k = k-1
	n = n-1
end)

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
	if not isCursorShowing() then return end
	cx,cy=getCursorPosition()
	cx,cy=cx*sx,cy*sy
	if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
		return true,cx,cy
	else
		return false
	end
end

stores = {}
getStores = {}
storeMarkers = {
	[1] = {1349.6318359375, -1549.8544921875, 13.546875, 1342.7080078125, -1561.0185546875, 13.546875},
	[2] = {761.2075, -1377.42346, 13.610, 756.65350, -1370.075, 13.5068},
	[3] = {737.8953,  -1352.91589, 13.5, 734.682, -1343.1123, 13.5214},
}

getColshapes = {}
storeColshapes = {}

for k,v in pairs(storeMarkers) do
	stores[#stores + 1] = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 0.4, 214, 10, 232, 155, "store_car", 3)
	storeColshapes[k] = createColSphere(v[1], v[2], v[3], 3)
	getStores[#getStores + 1] = exports["pd-markers"]:createCustomMarker(v[4], v[5], v[6] - 0.5, 10, 129, 237, 155, "get_car", 1.5)
	getColshapes[k] = createColSphere(v[4], v[5], v[6], 1)
end

addEventHandler("onClientColShapeHit", resourceRoot, function(plr, md)
	if localPlayer == plr then
		for k,v in ipairs(storeColshapes) do
			if isElementWithinColShape(localPlayer, v) then
				if isPedInVehicle(localPlayer) then
					if not getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:vid") then return end
					triggerServerEvent("przecho:storeCar", localPlayer, localPlayer, getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:vid"))
					exports["pd-hud"]:addNotification("Schowałeś swój pojazd do przechowalni!", "info", 5000, nil, "info")
				else 
					exports["pd-hud"]:addNotification("W tym miejscu możesz chować swoje pojazdy do przechowalni.", "info", 5000, nil, "info")
				end
			end
		end
		for k,v in pairs(getColshapes) do
			if isElementWithinColShape(localPlayer, v) then
				if isPedInVehicle(localPlayer) then return end
				triggerServerEvent("przecho:getCars", localPlayer, localPlayer)
				setElementData(localPlayer, "player:store:show", k)
				
			end
		end
	end
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(plr, md)
	if localPlayer == plr then
		removeEventHandler("onClientRender", root, vstore.draw)
		showChat(true)
		showCursor(false)
		vstore.enabled = false
	end 
end)


addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(stores) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
	end
	for k,v in pairs(getStores) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
	end
end)