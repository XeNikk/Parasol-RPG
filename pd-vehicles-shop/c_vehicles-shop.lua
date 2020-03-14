local sx, sy = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local normal_small = exports["pd-gui"]:getGUIFont("normal_small")
local normal_big = exports["pd-gui"]:getGUIFont("normal_big")
local buyInfo = {showing=false}

addEventHandler("onClientColShapeHit", root, function(plr)
	if not plr or getElementType(plr) ~= "player" then return end
	veh = getPedOccupiedVehicle(plr)
	if veh then return end
	if plr ~= localPlayer then return end
	if getElementData(localPlayer, "player:showingGUI") then return end
	if getElementData(source, "vehicle:buy") then
		showCursor(true, false)
		setElementData(localPlayer, "player:showingGUI", "vehicle:buy")
		buyInfo = {
			showing = true,
			id = getElementData(source, "vehicle:buy"),
			name = getElementData(source, "vehicle:buy:name"),
			model = getElementData(source, "vehicle:buy:model"),
			dm = getElementData(source, "vehicle:buy:dm"),
			vtype = getElementData(source, "vehicle:buy:type"),
			wheels = getElementData(source, "vehicle:buy:wheels"),
			fuel_type = getElementData(source, "vehicle:buy:fuel_type"),
			max_velocity = getElementData(source, "vehicle:buy:max_velocity"),
			class = getElementData(source, "vehicle:buy:class"),
			spawnPosition = getElementData(source, "vehicle:buy:spawn_position"),
			mileage = getElementData(source, "vehicle:buy:mileage"),
			cost = getElementData(source, "vehicle:buy:cost"),
			color = getElementData(source, "vehicle:buy:color"),
			quantity = getElementData(source, "vehicle:buy:quantity"),
			text = getElementData(source, "vehicle:buy:text"),
			marker = source,
		}
	end
end)

addEventHandler("onClientColShapeLeave", root, function(plr)
	if plr ~= localPlayer then return end
	buyInfo = {showing=false}
	showCursor(false)
	setElementData(localPlayer, "player:showingGUI", false)
end)

addEventHandler("onClientRender", root, function()
	veh = getPedOccupiedVehicle(localPlayer)
	if veh then return end
	if buyInfo.showing then
		dxDrawImage(sx/2 - 350/zoom, sy/2 - 150/zoom, 700/zoom, 300/zoom, "images/background.png", 0, 0, 0, tocolor(255, 255, 255, 230))
		dxDrawImage(sx/2 + 175/zoom, sy/2 - 125/zoom, 150/zoom, 150/zoom, "images/klasy/" .. buyInfo.class .. ".png")
		dxDrawText(buyInfo.name, sx/2 - 340/zoom, sy/2 - 145/zoom, sx, sy, tocolor(255, 0, 255, 255), 1/zoom, normal_big, "left", "top")
		dxDrawText("Pojemność silnika: " .. buyInfo.dm .. " dm³\nTyp pojazdu: " .. buyInfo.vtype .. "\nNapęd: " .. buyInfo.wheels .. "\nTyp paliwa: " .. buyInfo.fuel_type .. "\nPrędkość maksymalna: ~" .. buyInfo.max_velocity .. " km/h", sx/2 - 340/zoom, sy/2 - 95/zoom, sx, sy, white, 1/zoom, normal_small, "left", "top")
		dxDrawText("Klasa pojazdu", sx/2 + 250/zoom, sy/2 + 30/zoom, sx/2 + 250/zoom, sy/2 + 30/zoom, white, 1/zoom, normal_small, "center", "center")
		dxDrawImage(sx/2 - 75/zoom, sy/2 + 75/zoom, 150/zoom, 50/zoom, "images/button.png")
		dxDrawText("Kup", sx/2, sy/2 + 100/zoom, sx/2, sy/2 + 100/zoom, white, 1/zoom, normal_small, "center", "center")
	end
end)

local lastClickCount = getTickCount()

addEventHandler("onClientClick", root, function(button, state)
	veh = getPedOccupiedVehicle(localPlayer)
	if button ~= "left" or state ~= "down" or getTickCount() < lastClickCount or veh or not buyInfo.showing then return end
	local lastClickCount = getTickCount() + 2000
	if isMouseInPosition(sx/2 - 75/zoom, sy/2 + 75/zoom, 150/zoom, 50/zoom) then
		if buyInfo.quantity > 0 then
			if getPlayerMoney(localPlayer) >= buyInfo.cost then
				canSpawn = true
				for k,v in pairs(getElementsByType("vehicle")) do
					if getDistanceBetweenPoints3D(Vector3(getElementPosition(v)), unpack(buyInfo.spawnPosition)) < 5 then
						canSpawn = false
					end
				end
				if canSpawn then
					triggerServerEvent("buyCar", resourceRoot, localPlayer, buyInfo)
					exports["pd-achievements"]:addPlayerAchievement(localPlayer, "Pierwsze auto", 5)
					buyInfo = {showing=false}
					showCursor(false)
					setElementData(localPlayer, "player:showingGUI", false)
				else
					exports["pd-hud"]:addNotification("Wyjazd jest zablokowany.", "error", 2000, nil, "error")
				end
			else
				exports["pd-hud"]:addNotification("Nie stać cię na ten pojazd.", "error", 2000, nil, "error")
			end
		else
			exports["pd-hud"]:addNotification("Brak dostępnych sztuk na składzie.", "error", 4000, nil, "error")
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