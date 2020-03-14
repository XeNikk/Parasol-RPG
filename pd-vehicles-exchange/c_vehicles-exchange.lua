sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()


exchanges = {
    {"Los Santos", 2270.1171875, -2010.7685546875, 13.429420471191},
}

exchg = {}

exchg.tex_store_background = dxCreateTexture("images/store/background.png")
exchg.tex_store_edit_line = dxCreateTexture("images/store/edit_line.png")
exchg.tex_store_button = dxCreateTexture("images/store/button.png")


exchg.store = function()
dxDrawImage(sx/2-367/zoom, sy/2-155/zoom, 734/zoom, 298/zoom, exchg.tex_store_background)
dxDrawText("Wystaw pojazd", sx/2, sy/2-150/zoom, sx/2, sy/2-150/zoom, tocolor(214,0,243,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center", "top")
dxDrawText("W tym miejscu możesz wystawić swój pojazd na giełdę.\nInni gracze będą mogli wykupić twój pojazd za podaną przez Ciebie cenę.\nJeśli będziesz offline, a ktoś wykupi twoje auto, pieniądze zostaną\ndodane na twoje konto bankowe.", sx/2, sy/2-106/zoom, sx/2, sy/2-106/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
exports["pd-gui"]:renderEditbox(editbox)
exports["pd-gui"]:renderButton(wystaw)
exports["pd-gui"]:renderButton(zamknij)

end

bindKey("mouse1", "down", function()
	if not exchg.enabled == true then return end
	if isMouseIn(sx/2+8/zoom, sy/2+80/zoom, 148/zoom, 47/zoom) then 
		removeEventHandler("onClientRender", root, exchg.store)
		exchg.vehicle = false
		exchg.enabled = false
		showCursor(false)
	elseif isMouseIn(sx/2-157/zoom, sy/2+80/zoom, 148/zoom, 47/zoom) then 
		if isPedInVehicle(localPlayer) then
			if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:owner") ~= getElementData(localPlayer, "player:uid") then exports["pd-hud"]:addNotification("Pojazd nie należy do ciebie!", "error", 5000, nil, "error")  return end
			if tonumber(exports["pd-gui"]:getEditboxText(editbox)) == nil then exports["pd-hud"]:addNotification("Cena musi być liczbą!", "error", 5000, nil, "error") return end
			if string.len(exports["pd-gui"]:getEditboxText(editbox)) < 3 then exports["pd-hud"]:addNotification("Cena jest zbyt niska!", "error", 5000, nil, "error") return end
			triggerServerEvent("exchange:addVehicle", localPlayer, localPlayer,localPlayer, getPedOccupiedVehicle(localPlayer), currentExchange, exports["pd-gui"]:getEditboxText(editbox), getPedOccupiedVehicle(localPlayer), localPlayer)
		end
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	editbox = exports["pd-gui"]:createEditbox("",sx/2-130/zoom, sy/2+19/zoom, 260/zoom, 40/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	exports["pd-gui"]:setEditboxLine(editbox, exchg.tex_store_edit_line)
	exports["pd-gui"]:setEditboxHelperText(editbox, "Za ile $ chcesz wystawić pojazd")
	exports["pd-gui"]:setEditboxMaxLength(editbox, 9)
	exports["pd-gui"]:setEditboxNumberMode(editbox, true)

	wystaw = exports["pd-gui"]:createButton("Wystaw", sx/2-157/zoom, sy/2+80/zoom, 148/zoom, 47/zoom)
	exports["pd-gui"]:setButtonTextures(wystaw, {default=":pd-vehicles-exchange/images/store/button.png", hover=":pd-vehicles-exchange/images/store/button.png", press=":pd-vehicles-exchange/images/store/button.png"})
	exports["pd-gui"]:setButtonFont(wystaw, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)

	zamknij = exports["pd-gui"]:createButton("Zamknij", sx/2+8/zoom, sy/2+80/zoom, 148/zoom, 47/zoom)
	exports["pd-gui"]:setButtonTextures(zamknij, {default=":pd-vehicles-exchange/images/store/button.png", hover=":pd-vehicles-exchange/images/store/button.png", press=":pd-vehicles-exchange/images/store/button.png"})
	exports["pd-gui"]:setButtonFont(zamknij, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
		exports["pd-gui"]:destroyButton(wystaw)
		exports["pd-gui"]:destroyButton(zamknij)
	    exports["pd-gui"]:destroyEditbox(editbox)
end)


for i,k in pairs(exchanges) do 
	exchanges[i] = exports["pd-markers"]:createCustomMarker(k[2], k[3], k[4]-0.2, 180, 0, 180, 200, "store_car", 2)
	marker = createMarker(k[2], k[3], k[4]-0.95, "cylinder", 5, 0,0,0,0)
	createBlip(k[2], k[3], k[4], 42,0,0,0,0,0,0,250)
	setElementData(marker, "exchange:id", k[1])
end


exchg.storeGUI = function(plr, dim)
	if localPlayer == plr then 
		if isPedInVehicle(localPlayer) then
			if getPedOccupiedVehicleSeat(localPlayer) == 0 then
			id = getElementData(source, "exchange:id")
			if id then
				currentExchange = id
				addEventHandler("onClientRender", root, exchg.store)
				exchg.vehicle = getPedOccupiedVehicle(localPlayer)
				exchg.enabled = true
				showCursor(true)
			end
			end
		end
	end
end


addEventHandler("onClientMarkerHit", resourceRoot, exchg.storeGUI)

exchg.storeClose = function(plr, dim)
	if localPlayer == plr then 
		if isPedInVehicle(localPlayer) then 
			removeEventHandler("onClientRender", root, exchg.store)
			exchg.vehicle = false
			exchg.enabled = false
			exchg.exchange = false
			showCursor(false)
		end
	end
end
addEventHandler("onClientMarkerLeave", resourceRoot, exchg.storeClose)


addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in ipairs(exchanges) do
		exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
	end
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