GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()
local normal_small = GUI:getGUIFont("normal_small")
local normal_big = GUI:getGUIFont("normal_big")
local interiors = {
	["Ośrodek szkoleniowy"] = {1730.98, -2060.83, 13.6, 1725.6, -2071.56, 3.91, 36},
	["Wyjście z ośrodka"] = {1725.6, -2071.56, 3.91, 1730.98, -2060.83, 13.6},
	["Wyjście z przebieralni"] = {387.92, -45.6711, 950.5968, 499.7856, -1360.141, 16.3250},
	["Przebieralnia"] = {499.7856, -1360.141, 16.3250, 387.92, -45.6711, 950.5968, 45},
	["Przechowalnia"] = {1354.46, -1553.63, 1, 0, 0, 0, 15},
	["Przechowalnia2"] = {761.2075, -1377.42346, 05.610, 756.65350, -1370.075, 05.5068, 15},
	["Praca myśliwego"] = {-654.50708007813, -2104.6115722656, 21.993522644043, -654.50708007813, -2104.6115722656, 21.993522644043, 11},
	["Praca astronauty"] = {225.13629150391, 1449.0998535156, 3.42812538147, 225.13629150391, 1449.0998535156, 3.42812538147, 11},
	["Praca fabryki"] = {1107.923828125, -1795.9405517578, 9.1879692077637, 1107.923828125, -1795.9405517578, 9.1879692077637, 11},
	["Praca busy"] = {1764.2387695313, -1097.1944580078, 4.085935592651, 1764.2387695313, -1097.1944580078, 4.085935592651, 11},
	["Ammunation"] = {1367.4875488281, -1279.9360351563, 13.546875, 285.33474731445, -40.562419891357, 1001.515625, 18, 1},
	["Wyjście z Ammunation"] = {285.33474731445, -40.562419891357, 1001.515625, 1367.4875488281, -1279.9360351563, 13.546875, false, 0},
	["Tuner"] = {873.85894775391, -1216.1314697266, 0.59203338623, 873.85894775391, -1216.1314697266, 0.59203338623, 46},
}
local interiorMarkers = {}

for k,v in pairs(interiors) do
	marker, id = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 1, 255, 255, 0, 155, "marker", 1.5)
	interiorMarkers[id] = {marker, k, {v[4], v[5], v[6]}, v[8]}
	if v[7] then
		createBlip(v[1], v[2], v[3], v[7], 2, 255, 255, 255, 255, 0, 250)
	end
end

addEventHandler("onClientRender", root, function()
	veh = getPedOccupiedVehicle(localPlayer)
	if veh then return end
	x, y, z = getElementPosition(localPlayer)
	for k,v in pairs(interiorMarkers) do
		if v[1] and isElement(v[1]) and isElementWithinMarker(localPlayer, v[1]) then
			if getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(v[1]))) < 3 then
				dxDrawImage(sx/2-230/zoom, sy-190/zoom, 460/zoom, 110/zoom, "images/enter.png")
				dxDrawText(v[2], sx/2-120/zoom, sy-165/zoom, sx/2, sy-135/zoom, white, 1.2/zoom, normal_small, "left", "center")
				dxDrawText("Aby przejść kliknij SPACJĘ", sx/2-120/zoom, sy-110/zoom, sx/2, sy-135/zoom, tocolor(181, 0, 202), 1/zoom, normal_small, "left", "center")
			end
		end
	end
end)

entering = false

bindKey("space", "down", function()
	veh = getPedOccupiedVehicle(localPlayer)
	if veh then return end
	if entering then return end
	x, y, z = getElementPosition(localPlayer)
	for k,v in pairs(interiorMarkers) do
		if v[1] and isElement(v[1]) and isElementWithinMarker(localPlayer, v[1]) then
			if getDistanceBetweenPoints3D(x, y, z, Vector3(getElementPosition(v[1]))) < 3 then
				exports["pd-loading"]:showLoading("Wczytywanie obiektów", 5000)
				setElementFrozen(localPlayer, true)
				entering = true
				toggleAllControls(false)
				setTimer(function()
					setElementPosition(localPlayer, unpack(v[3]))
					if v[4] then
						setElementInterior(localPlayer, v[4])
					end
				end, 1500, 1)
				setTimer(function()
					entering = false
					toggleAllControls(true)
					setElementFrozen(localPlayer, false)
				end, 5000, 1)
			end
		end
	end
end)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	for k,v in pairs(interiorMarkers) do
		exports["pd-markers"]:destroyCustomMarker(k)
	end
end)