local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()
local lastHover = nil
local fadeTimer = false
local normal_small = GUI:getGUIFont("normal_small")
setElementData(localPlayer, "player:uid", nil)

spawnLocations = {
	["Szkoła jazdy"] = {1756.4, -2071.7, 20.5, 1733.7, -2057, 13.6, 1742.82629, -2059.18970, 13.58972},
	["Centrum"] = {1465.9, -1630.7, 15.9, 1478.7, -1651.8, 15, 1479.89685, -1710.12769, 14.04688},
	["Przechowalnia"] = {781, -1357.6, 13.5, 769.1, -1367.7, 13.5, 778.86401, -1368.55054, 13.53397},
}

function renderSpawns()
	GUI:drawBWRectangle(0, 0, sx, sy)
	y = sy/2 - (1080/zoom)/2
	dxDrawImage(a["spawnGui"], y, 543/zoom, 1080/zoom, "data/spawn/background.png")
	id = 0
	for k,v in pairs(spawnLocations) do
		if isMouseInPosition(a["spawnGui"] + (543/zoom/2) - (425/zoom/2), y + 30 + (90/zoom) * id, 425/zoom, 80/zoom) then
			dxDrawImage(a["spawnGui"] + (543/zoom/2) - (425/zoom/2), y + 30 + (90/zoom) * id, 425/zoom, 80/zoom, "data/spawn/button.png")
			hover = k
		else
			dxDrawImage(a["spawnGui"] + (543/zoom/2) - (425/zoom/2), y + 30 + (90/zoom) * id, 425/zoom, 80/zoom, "data/spawn/button.png", 0, 0, 0, tocolor(255, 255, 255, 155))
		end
		dxDrawText(k, a["spawnGui"] + (543/zoom/2), y + 30 + (90/zoom) * id + 40/zoom, a["spawnGui"] + (543/zoom/2), y + 30 + (90/zoom) * id + 40/zoom, white, 1/zoom, normal_small, "center", "center")
		id = id + 1
	end
	if spawnLocations[hover] and hover ~= lastHover then
		lastHover = hover
		if fadeTimer and getTimerDetails(fadeTimer) then
			killTimer(fadeTimer)
			fadeTimer = nil
		end
		fadeCamera(false)
		fadeTimer = setTimer(function()
			fadeTimer = nil
			fadeCamera(true)
			c = spawnLocations[lastHover]
			setCameraMatrix(c[1], c[2], c[3], c[4], c[5], c[6])
		end, 1500, 1)
	end
end

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button ~= "left" or state ~= "down" or getElementData(localPlayer,"player:uid") then return end
	id = 0
	y = sy/2 - (1080/zoom)/2
	for k,v in pairs(spawnLocations) do
		if isMouseInPosition(a["spawnGui"] or -500 + (543/zoom/2) - (425/zoom/2), y + 30 + (90/zoom) * id, 425/zoom, 80/zoom) then
			triggerServerEvent("spawnPlayer", resourceRoot, localPlayer, v[7], v[8], v[9], uid)
			exports["pd-hud"]:showHUD(true)
			removeEventHandler("onClientRender", root, renderSpawns)
			if fadeTimer and getTimerDetails(fadeTimer) then
				killTimer(fadeTimer)
				fadeTimer = nil
			end
			stopSound(music)
			showCursor(false)
			break
		end
		id = id + 1
	end
end)

function showSpawns()
	showCursor(true)
	setAnimation("spawnGui", -500, 30/zoom, 1000, "OutQuad")
	addEventHandler("onClientRender", root, renderSpawns)
end
addEvent("showSpawns", true )
addEventHandler("showSpawns", root, showSpawns)