local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local normal_big = GUI:getGUIFont("normal_big")
local normal_small = GUI:getGUIFont("normal_small")
local licenseMarkers = {}	
local sx, sy = guiGetScreenSize()
local localVehicles = {}
local mileage = 21
local lastPosition = {x=0, y=0, z=0}
local blipElement = false
local markers = {
	["A"] = {
		[1] = "all",
		[2] = {1820.62, -2152.66, 13.44, false, "sounds/prosto.wav", "Jedź prosto."},
		[3] = {1770.76, -2164.52, 13.45, false, "sounds/prawo.wav", "Skręć w prawo."},
		[4] = {1532.17, -1885.14, 13.01, false, "sounds/naprzod.wav", "Jedź prosto."},
		[5] = {1404.41, -1870.07, 13.44, false, "sounds/lewo.wav", "Skręć w lewo."},
		[6] = {1211.35, -1849.38, 13.06, false, "sounds/naprzod.wav", "Jedź prosto."},
		[7] = {1181.97, -1792.91, 13.07, false, "sounds/prawo.wav", "Skręć w prawo."},
		[8] = {1051.12, -1710.31, 13.06, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[9] = {1039.81, -1588.37, 13.06, false, "sounds/prawo.wav", "Skręć w prawo."},
		[10] = {1063.03, -1452.20, 13.04, false, "sounds/naprzod.wav", "Jedź prosto."},
		[11] = {983.09, -1398.07, 12.66, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[12] = {654.65, -1397.95, 13.07, false, "sounds/prosto.wav", "Jedź prosto."},
		[13] = {530.31, -1412.93, 15.95, false, "sounds/naprzod.wav", "Jedź prosto."},
		[14] = {489.24, -1475.67, 19.16, false, "sounds/lewo.wav", "Skręć w lewo."},
		[15] = {576.92, -1591.45, 15.99, false, "sounds/wyjazd_parking_lewo.wav", "Wyjedź z parkingu i skręć w lewo."},
		[16] = {623.09, -1709.58, 14.38, false, "sounds/prawo.wav", "Skręć w prawo."},
		[17] = {490.48, -1708.22, 11.66, false, "sounds/prawo.wav", "Skręć w prawo."},
		[18] = {48.20, -1523.48, 5.08, false, "sounds/naprzod.wav", "Jedź prosto."},
		[19] = {-36.97, -1567.94, 2.36, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[20] = {-252.75, -1725.56, 3.34, false, "sounds/prosto.wav", "Jedź prosto."},
		[21] = {-262.20, -2029.67, 32.35, false, "sounds/naprzod.wav", "Jedź prosto."},
		[22] = {-337.92, -2134.79, 42.01, false, false, "Jedź prosto."},
		[23] = "freeride",
	},
	["B"] = {
		[1] = "all",
		[2] = {1839.37, -2169, 13.16, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[3] = {1963.9, -2153.4, 13.16, false, "sounds/skrec_w_lewo_ponownie.wav", "Skręć ponownie w lewo."},
		[4] = {1964.2, -2043.23, 13.17, false, "sounds/prosto.wav", "Jedź cały czas prosto."},
		[5] = {1964.57, -1956.07, 13.46, false, "sounds/pociag.wav", "Zaczekaj aż przejedzie pociąg."},
		[6] = {1988.1, -1934.65, 13.1, false, "sounds/prawo.wav", "Skręć w prawo."},
		[7] = {2055.18, -1919.4, 13.27, false, "sounds/lewo.wav", "Skręć w lewo."},
		[8] = {2065.47, -1919.73, 13.27, 0, "sounds/parkowanie_tylem.wav", "Zaparkuj między dwoma pojazdami."},
		[9] = {2083.95, -1867.31, 13.1, false, "sounds/wyjazd_parking_lewo.wav", "Wyjedź z parkingu i skręć w lewo."},
		[10] = {2083.74, -1823.65, 13.11, false, "sounds/prosto.wav", "Jedź prosto."},
		[11] = {2114.43, -1445.44, 23.55, false, "sounds/naprzod.wav", "Dalej kieruj się prosto."},
		[12] = {2072.2, -1361.1, 23.55, false, "sounds/przepusc_pieszego_lewo.wav", "Przepuść pieszego, a następnie skręć w lewo."},
		[13] = {2071.61, -1233.45, 23.53, false, "sounds/naprzod.wav", "Jedź prosto."},
		[14] = {2095.61, -1103.77, 24.68, false, "sounds/prawo.wav", "Skręć w prawo"},
		[15] = {2287.48, -1152.27, 26.48, false, "sounds/prosto.wav", "Jedź prosto."},
		[16] = {2301.83, -1187.21, 24.97, false, "sounds/prawo.wav", "Skręć w prawo."},
		[17] = {2323.09, -1219.08, 22.43, false, "sounds/podziemny_parking.wav", "Zjedź na podziemny parking."},
		[18] = {2330.3, -1224.82, 22.23, false, "sounds/slalom.wav", "Przejedź slalom."},
		[19] = {2326.77, -1239.65, 22.22, false, false, "Przejedź slalom."},
		[20] = {2331.29, -1248.99, 22.22, false, false, "Przejedź slalom."},
		[21] = {2326.08, -1258.76, 22.23, false, false, "Przejedź slalom."},
		[22] = {2335.14, -1274.16, 22.27, 270, "sounds/parkowanie_rownolegle.wav", "Zaparkuj równolegle między dwoma pojazdami."},
		[23] = "freeride",
	},
	["C"] = {
		[1] = "all",
		[2] = {1820.62, -2152.66, 13.44, false, "sounds/prosto.wav", "Jedź prosto."},
		[3] = {1770.76, -2164.52, 13.45, false, "sounds/prawo.wav", "Skręć w prawo."},
		[4] = {1532.17, -1885.14, 13.01, false, "sounds/naprzod.wav", "Jedź prosto."},
		[5] = {1404.41, -1870.07, 13.44, false, "sounds/lewo.wav", "Skręć w lewo."},
		[6] = {1211.35, -1849.38, 13.06, false, "sounds/naprzod.wav", "Jedź prosto."},
		[7] = {1181.97, -1792.91, 13.07, false, "sounds/prawo.wav", "Skręć w prawo."},
		[8] = {1051.12, -1710.31, 13.06, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[9] = {1039.81, -1588.37, 13.06, false, "sounds/prawo.wav", "Skręć w prawo."},
		[10] = {1063.03, -1452.20, 13.04, false, "sounds/naprzod.wav", "Jedź prosto."},
		[11] = {983.09, -1398.07, 12.66, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[12] = {654.65, -1397.95, 13.07, false, "sounds/prosto.wav", "Jedź prosto."},
		[13] = {530.31, -1412.93, 15.95, false, "sounds/naprzod.wav", "Jedź prosto."},
		[14] = {489.24, -1475.67, 19.16, false, "sounds/lewo.wav", "Skręć w lewo."},
		[15] = {576.92, -1591.45, 15.99, false, "sounds/wyjazd_parking_lewo.wav", "Wyjedź z parkingu i skręć w lewo."},
		[16] = {623.09, -1709.58, 14.38, false, "sounds/prawo.wav", "Skręć w prawo."},
		[17] = {490.48, -1708.22, 11.66, false, "sounds/prawo.wav", "Skręć w prawo."},
		[18] = {48.20, -1523.48, 5.08, false, "sounds/naprzod.wav", "Jedź prosto."},
		[19] = {-36.97, -1567.94, 2.36, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[20] = {-252.75, -1725.56, 3.34, false, "sounds/prosto.wav", "Jedź prosto."},
		[21] = {-262.20, -2029.67, 32.35, false, "sounds/naprzod.wav", "Jedź prosto."},
		[22] = {-337.92, -2134.79, 42.01, false, false, "Jedź prosto."},
		[23] = "freeride",
	},
	["D"] = {
		[1] = "all",
		[2] = {1820.62, -2152.66, 13.44, false, "sounds/prosto.wav", "Jedź prosto."},
		[3] = {1770.76, -2164.52, 13.45, false, "sounds/prawo.wav", "Skręć w prawo."},
		[4] = {1532.17, -1885.14, 13.01, false, "sounds/naprzod.wav", "Jedź prosto."},
		[5] = {1404.41, -1870.07, 13.44, false, "sounds/lewo.wav", "Skręć w lewo."},
		[6] = {1211.35, -1849.38, 13.06, false, "sounds/naprzod.wav", "Jedź prosto."},
		[7] = {1181.97, -1792.91, 13.07, false, "sounds/prawo.wav", "Skręć w prawo."},
		[8] = {1051.12, -1710.31, 13.06, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[9] = {1039.81, -1588.37, 13.06, false, "sounds/prawo.wav", "Skręć w prawo."},
		[10] = {1063.03, -1452.20, 13.04, false, "sounds/naprzod.wav", "Jedź prosto."},
		[11] = {983.09, -1398.07, 12.66, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[12] = {654.65, -1397.95, 13.07, false, "sounds/prosto.wav", "Jedź prosto."},
		[13] = {530.31, -1412.93, 15.95, false, "sounds/naprzod.wav", "Jedź prosto."},
		[14] = {489.24, -1475.67, 19.16, false, "sounds/lewo.wav", "Skręć w lewo."},
		[15] = {576.92, -1591.45, 15.99, false, "sounds/wyjazd_parking_lewo.wav", "Wyjedź z parkingu i skręć w lewo."},
		[16] = {623.09, -1709.58, 14.38, false, "sounds/prawo.wav", "Skręć w prawo."},
		[17] = {490.48, -1708.22, 11.66, false, "sounds/prawo.wav", "Skręć w prawo."},
		[18] = {48.20, -1523.48, 5.08, false, "sounds/naprzod.wav", "Jedź prosto."},
		[19] = {-36.97, -1567.94, 2.36, false, "sounds/skrec_w_lewo.wav", "Na najbliższym skrzyżowaniu skręć w lewo."},
		[20] = {-252.75, -1725.56, 3.34, false, "sounds/prosto.wav", "Jedź prosto."},
		[21] = {-262.20, -2029.67, 32.35, false, "sounds/naprzod.wav", "Jedź prosto."},
		[22] = {-337.92, -2134.79, 42.01, false, false, "Jedź prosto."},
		[23] = "freeride",
	},
}

local licenses = {
	["A"] = {1707.5, -2071.96, 3.9, 350, "Zdobycie uprawnień kategorii A umożliwi tobie\nprowadzenie jednośladów. Jedź ostrożnie i nie\nuszkodź pojazdu egzaminacyjnego."},
	["B"] = {1723.4, -2066.74, 3.9, 0, "Zdobycie uprawnień kategorii B umożliwi tobie\nprowadzenie samochodów. Jedź ostrożnie i nie\nuszkodź pojazdu egzaminacyjnego."},
	["C"] = {1707.27, -2053.3, 3.9, 750, "Zdobycie uprawnień kategorii C umożliwi tobie\nprowadzenie mini vanów, które są wymagane w\nniektórych pracach dorywwczych. Pamiętaj, aby\npodczas zdawania nie uszkodzić pojazdu\negzaminacyjnego."},
	["D"] = {1719.8, -2060.1, 3.9, 1000, "Zdobycie uprawnień kategorii D umożliwi tobie\nprowadzenie busów, które są wymagane w\nniektórych pracach dorywwczych. Pamiętaj, aby\npodczas zdawania nie uszkodzić pojazdu\negzaminacyjnego."},
}

addCommandHandler("prawko", function()
	setElementPosition(localPlayer, 1715.6591796875, -2065.45703125, 3.8579692840576)
end)

function isMouseInPosition(x, y, width, height)
	if (not isCursorShowing()) then
		return false
	end
	local sx, sy = guiGetScreenSize ()
	local cx, cy = getCursorPosition ()
	local cx, cy = (cx * sx), (cy * sy)
	
	return ((cx >= x and cx <= x + width) and (cy >= y and cy <= y + height))
end

function renderLicenses()
	dxDrawImage(sx/2 - 275/zoom, sy/2 - 200/zoom, 550/zoom, 400/zoom, "images/background.png")
	dxDrawText("Prawo jazdy kat. " .. licenseRender, sx/2, sy/2 - 150/zoom, sx/2, sy/2 - 150/zoom, white, 1/zoom, normal_big, "center", "center")
	if licenseRender then
		dxDrawText(licenses[licenseRender][5] .. "\n\nKoszt: $" .. licenses[licenseRender][4], sx/2, sy/2, sx/2, sy/2, white, 1/zoom, normal_small, "center", "center")
	end
	dxDrawImage(sx/2 - 205/zoom, sy/2 + 100/zoom, 200/zoom, 50/zoom, "images/button.png")
	dxDrawImage(sx/2 + 5/zoom, sy/2 + 100/zoom, 200/zoom, 50/zoom, "images/button.png")
	dxDrawText("Podejdź", sx/2 - 105/zoom, sy/2 + 125/zoom, sx/2 - 105/zoom, sy/2 + 125/zoom, white, 1/zoom, normal_small, "center", "center")
	dxDrawText("Anuluj", sx/2 + 105/zoom, sy/2 + 125/zoom, sx/2 + 105/zoom, sy/2 + 125/zoom, white, 1/zoom, normal_small, "center", "center")
end

function showLicenses(hitElement)
	if hitElement ~= localPlayer then return end
	_, _, z = getElementPosition(hitElement)
	if z > 5 then return end
	addEventHandler("onClientRender", root, renderLicenses)
	licenseRender = getElementData(source, "marker:license")
	showCursor(true, false)
end

function hideLicenses(hitElement)
	if hitElement ~= localPlayer then return end
	removeEventHandler("onClientRender", root, renderLicenses)
	licenseRender = false
	showCursor(false)
end

addEventHandler("onClientMarkerHit", root, function(hitElement)
	if hitElement == localPlayer and source == markerElement then
		rot = getElementData(markerElement, "license:rotation")
		if rot then
			_, _, z = getElementRotation(getPedOccupiedVehicle(localPlayer))
			z = z + 360
			rot = rot + 360
			if z > rot - 25 and z < rot + 25 then
				exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
				destroyElement(blipElement)
				nextMarker()
			end
		else
			exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
			destroyElement(blipElement)
			nextMarker()
		end
	end
end)

function spawnTrain()
	train = createVehicle(538, 1937.0927734375, -1957.8115234375, 13.33029460907)
	setElementData(train, "vehicle:ghost:off", true)
	setElementVelocity(train, 1, 0, 0)
	ped = createPed(0, 0, 0, 0)
	warpPedIntoVehicle(ped, train)
	setTrainSpeed(train, -0.15)
end

function nextMarker()
	currentMarker = currentMarker + 1
	v = markers[licenseRender][currentMarker]
	if v then
		if licenseRender == "B" then
			if currentMarker == 5 then
				spawnTrain()
			end
			if currentMarker == 8 then
				destroyElement(train)
				destroyElement(ped)
			end
			if currentMarker == 12 then
				ped = createPed(math.random(1, 250), 2122.07, -1391.47, 23.98, 90)
				setPedControlState(ped, "forwards", true)
				setPedControlState(ped, "walk", true)
			end
			if currentMarker == 13 then
				destroyElement(ped)
			end
		end
		if v[5] then
			if actualSound and isElement(actualSound) then
				stopSound(actualSound)
				actualSound = nil
			end
			actualSound = playSound(v[5])
		end
		actualTarget = v[6]
		markerElement = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3], 255, 255, 0, 155, "marker", 2)
		blipElement = createBlip(v[1], v[2], v[3], 41)
		if v[4] then
			setElementData(markerElement, "license:rotation", v[4])
		end
	end
end

function destroyAllVehicles()
	if localVehicles[1] then
		destroyElement(localVehicles[1])
		destroyElement(localVehicles[2])
		destroyElement(localVehicles[3])
		destroyElement(localVehicles[4])
	end
end

addEventHandler("onClientPedDamage", root, function()
	if source == ped then
		playSound("sounds/potracenie_pieszego.wav")
		destroyElement(ped)
		currentMarker = false
		actualTarget = false
		destroyAllVehicles()
		setTimer(function()
			triggerServerEvent("stopLicenseTest", resourceRoot, localPlayer)
		end, 5500, 1)
		exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
		destroyElement(blipElement)
	end
end)

addEventHandler("onClientRender", root, function()
	if currentMarker then
		veh = getPedOccupiedVehicle(localPlayer)
		if not veh then
			currentMarker = false
			actualTarget = false
			destroyAllVehicles()
			exports["pd-hud"]:addNotification("Opuściłeś pojazd, egzamin jest niezaliczony.", "error", nil, 5000, "error")
			triggerServerEvent("stopLicenseTest", resourceRoot, localPlayer)
			exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
			destroyElement(blipElement)
			return
		end
	end
	if currentMarker == 1 then
		if getVehicleOverrideLights(veh) == 2 and getVehicleEngineState(veh) and not isElementFrozen(veh) then
			nextMarker()
		else
			if getDistanceBetweenPoints3D(1820.9, -2035.75, 13.55, Vector3(getElementPosition(veh))) > 5 then
				actualSound = playSound("sounds/nie_wykonal_polecen.wav")
				currentMarker = false
				actualTarget = false
				destroyAllVehicles()
				exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
				setTimer(function()
					triggerServerEvent("stopLicenseTest", resourceRoot, localPlayer)
				end, 3500, 1)
				destroyElement(blipElement)
			end
		end
	elseif currentMarker == 8 then
		_, _, z = getElementRotation(getPedOccupiedVehicle(localPlayer))
		if ((z > 350 and z < 360) or (z > 0 and z < 10)) and isElementWithinMarker(localPlayer, markerElement) then
			exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
			destroyElement(blipElement)
			nextMarker()
		end
	elseif currentMarker == 22 then
		_, _, z = getElementRotation(getPedOccupiedVehicle(localPlayer))
		if z > 260 and z < 280 then
			x, y, z = getElementPosition(localPlayer)
			if getDistanceBetweenPoints3D(x, y, z, 2335.14, -1274.16, 22.27) < 0.5 then
				exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
				destroyElement(blipElement)
				currentMarker = currentMarker + 1
				mileage = 21
				playSound("sounds/jazda_swobodna.wav")
				lastPosition = Vector3(getElementPosition(localPlayer))
			end
		end
	elseif currentMarker == 23 then
		actualTarget = "Jazda swobodna\nPrzejedź jeszcze " .. math.floor(mileage) / 10 .. "km by zakończyć egzamin"
		x, y, z = getElementPosition(localPlayer)
		dist = getDistanceBetweenPoints3D(lastPosition.x, lastPosition.y, lastPosition.z, Vector3(getElementPosition(localPlayer)))
		mileage = mileage - dist / 100
		if mileage <= 0 then
			exports["pd-hud"]:addNotification("Egzamin zdany pomyślnie!", "success", nil, 5000, "success")
			currentMarker = false
			actualTarget = false
			destroyAllVehicles()
			triggerServerEvent("stopLicenseTest", resourceRoot, localPlayer)
			destroyElement(blipElement)
			local licenseTable = getElementData(localPlayer, "player:pj")
			licenseTable[licenseRender] = 1
			setElementData(localPlayer, "player:pj", licenseTable)
		end
	end
	if actualTarget then
		dxDrawImage(sx/2 - 250/zoom, 50/zoom, 500/zoom, 120/zoom, "images/hud_background.png")
		dxDrawText("Aktualny cel", sx/2, 70/zoom, sx/2, 70/zoom, tocolor(255, 0, 255), 0.7/zoom, normal_big, "center", "center")
		dxDrawText(actualTarget, sx/2, 110/zoom, sx/2, 110/zoom, white, 1/zoom, normal_small, "center", "center")
	end
	lastPosition = Vector3(getElementPosition(localPlayer))
end)

addEvent("startLicenseTest", true)
addEventHandler("startLicenseTest", localPlayer, function(category)
	currentMarker = 1
	actualTarget = "Włącz światła, silnik i zdejmij hamulec ręczny"
	actualSound = playSound("sounds/odpal_silnik_swiatla_reczny.wav")
	licenseRender = category
	if category == "B" then
		localVehicles[1] = createVehicle(496, 2068.337890625, -1919.91015625, 13.262877464294, 0, 0, 180)
		localVehicles[2] = createVehicle(436, 2062.2451171875, -1919.8486328125, 13.31317329406, 0, 0, 180)
		localVehicles[3] = createVehicle(411, 2327.966796875, -1274.2001953125, 22.228832244873, 0, 0, -90)
		localVehicles[4] = createVehicle(429, 2341.001953125, -1274.38671875, 22.180978775024, 0, 0, -90)
		setElementData(localVehicles[1], "vehicle:ghost:off", true)
		setElementData(localVehicles[2], "vehicle:ghost:off", true)
		setElementData(localVehicles[3], "vehicle:ghost:off", true)
		setElementData(localVehicles[4], "vehicle:ghost:off", true)
		setElementFrozen(localVehicles[1], true)
		setElementFrozen(localVehicles[2], true)
		setElementFrozen(localVehicles[3], true)
		setElementFrozen(localVehicles[4], true)
	end
end)

local lastClickCount = getTickCount()

addEventHandler ("onClientClick", root, function(button, state)
	if button ~= "left" or state ~= "down" or not licenseRender or lastClickCount > getTickCount() then return end
	isNear = false
	for k,v in pairs(licenseMarkers) do
		if isElementWithinMarker(localPlayer, v) then
			isNear = true
		end
	end
	if not isNear then return end
	if isMouseInPosition(sx/2 - 205/zoom, sy/2 + 100/zoom, 200/zoom, 50/zoom) then
		if getPlayerMoney() >= licenses[licenseRender][4] then
			local licenseTable = getElementData(localPlayer, "player:pj")
			if tonumber(licenseTable[licenseRender]) == 1 then
				exports["pd-hud"]:addNotification("Posiadasz już prawo jazdy kategorii " .. licenseRender .. ".", "error", nil, 5000, "error")
			else
				triggerServerEvent("startLicense", resourceRoot, localPlayer, licenseRender, licenses[licenseRender][4])
				lastClickCount = getTickCount() + 1000
			end
		else
			exports["pd-hud"]:addNotification("Nie stać cię na ten egzamin.", "error", nil, 5000, "error")
		end
	end
	if isMouseInPosition(sx/2 + 5/zoom, sy/2 + 100/zoom, 200/zoom, 50/zoom) then
		hideLicenses(localPlayer)
	end
end)

addEventHandler("onClientResourceStart", root,function(startedResource)
	if startedResource ~= getThisResource() then return end
	for k,v in pairs(licenses) do
		licenseMarkers[k] = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 1, 55, 140, 200, 255, "marker", 1.5)
		setElementData(licenseMarkers[k], "marker:license", k)
		addEventHandler("onClientMarkerHit", licenseMarkers[k], showLicenses)
		addEventHandler("onClientMarkerLeave", licenseMarkers[k], hideLicenses)
	end
end)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	for k,v in pairs(licenseMarkers) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
	end
	if markerElement and isElement(markerElement) then
		exports["pd-markers"]:destroyCustomMarker(getElementData(markerElement, "marker:id"))
	end
end)