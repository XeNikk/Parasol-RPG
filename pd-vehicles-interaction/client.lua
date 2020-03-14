local sx, sy = guiGetScreenSize()
local GUI = exports["pd-gui"]
local normal_small = GUI:getGUIFont("normal_small")
local zoom = GUI:getInterfaceZoom()
local lastTickCount = getTickCount() - 200
local renderingInteraction = false

guiPosition = {
	["neon"] = {sx/2-350/zoom,sy/2-100/zoom,getString=function(veh) return "" end},
	["engine"] = {sx/2-230/zoom,sy/2-310/zoom,getString=function(veh) if getVehicleEngineState(veh) then return "Zgaś silnik" else return "Odpal silnik" end end},
	["light"] = {sx/2+30/zoom,sy/2-310/zoom,getString=function(veh) if getVehicleOverrideLights(veh) == 1 then return "Zapal światła" else return "Zgaś światła" end end},
	["brake"] = {sx/2+150/zoom,sy/2-100/zoom,getString=function(veh) if isElementFrozen(veh) then return "Spuść ręczny" else return "Zaciągnij ręczny" end end},
	["lock"] = {sx/2+30/zoom,sy/2+110/zoom,getString=function(veh) if isVehicleLocked(veh) then return "Otwórz pojazd" else return "Zamknij pojazd" end end},
	["passengers"] = {sx/2-230/zoom,sy/2+110/zoom,getString=function(veh) return "Wyrzuć pasażerów" end},
}

function renderInteraction()
	veh = getPedOccupiedVehicle(localPlayer)
	if not renderingInteraction then return end
	if not veh then return end
	if getVehicleController(veh) ~= localPlayer then return end
	GUI:drawBWRectangle(0, 0, sx, sy)
	dxDrawImage(sx/2 - 150/zoom, sy/2 - 150/zoom, 300/zoom, 300/zoom, "images/background.png")
	hoverElement = false
	for k,v in pairs(guiPosition) do
		hover = isMouseInHexagon(v[1], v[2], 200/zoom, 0)
		dxDrawImage(v[1], v[2], 200/zoom, 200/zoom, hover and "images/background.png" or "images/background_hover.png")
		dxDrawImage(v[1] + 35/zoom, v[2] + 35/zoom, 130/zoom, 130/zoom, "images/" .. k .. ".png")
		if hover then
			hoverElement = {k, v.getString(veh)}
		end
	end
	if hoverElement then
		dxDrawImage(sx/2 - 75/zoom, sy/2 - 75/zoom, 150/zoom, 150/zoom, "images/" .. hoverElement[1] .. ".png")
		dxDrawText(hoverElement[2], sx/2, sy/2+75/zoom, sx/2, sy/2+75/zoom, white, 1/zoom, normal_small, "center", "center")
	end
end

addEvent("playClientSound", true)
addEventHandler("playClientSound", localPlayer, function(sound)
	playSound(sound)
end)

addEventHandler("onClientVehicleExit", root, function(plr)
	if plr == localPlayer then
		if renderingInteraction then
			setElementData(localPlayer, "player:showingGUI", false)
			removeEventHandler("onClientRender", root, renderInteraction)
			showCursor(false)
			renderingInteraction = false
		end
	end
end)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if not renderingInteraction then return end
	veh = getPedOccupiedVehicle(localPlayer)
	if button ~= "left" or state ~= "down" or not veh or getVehicleController(veh) ~= localPlayer then return end
	hoverElement = false
	for k,v in pairs(guiPosition) do
		if isMouseInHexagon(v[1], v[2], 200/zoom, 0) then
			hoverElement = k
			break
		end
	end
	if lastTickCount + 200 > getTickCount() then return end
	if hoverElement then
		triggerServerEvent("vehicleInteraction", resourceRoot, veh, hoverElement, localPlayer)
		lastTickCount = getTickCount()
	end
end)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	setElementData(localPlayer, "player:showingGUI", false)
end)

bindKey("lshift", "down", function()
	veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end
	if getVehicleController(veh) ~= localPlayer then return end
	if not renderingInteraction then
		if getElementData(localPlayer, "player:showingGUI") then return end
		addEventHandler("onClientRender", root, renderInteraction)
		setElementData(localPlayer, "player:showingGUI", "vehicle:interaction")
	else
		removeEventHandler("onClientRender", root, renderInteraction)
		setElementData(localPlayer, "player:showingGUI", false)
	end
	showCursor(not renderingInteraction, false)
	renderingInteraction = not renderingInteraction
end)