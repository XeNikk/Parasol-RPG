sx, sy = guiGetScreenSize()

x,y,z = 386.879, -38.7495, 950.596-1

przeb = {
enabled = false,
actual = "main",
delay = false
}

skins = {
	["men"] = {"⬅ Powrót",0, 1, 2, 7, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 33, 34, 45, 46, 47, 48, 49, 51, 52, 59, 60, 61, 62, 66, 67, 68, 72, 73, 78, 79, 80, 81, 82, 83, 84, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 134, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 306, 307, 308, 310, 311, 312},
	["woman"] = {"⬅ Powrót", 12, 31, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304},
	["premiummen"] = {"⬅ Powrót",15, 32, 35, 36, 37, 43,44, 57, 58, 94, 95, 96, 132, 133, 135 },
	["premiumwoman"] = {"⬅ Powrót", 9, 10, 11, 13, 14, 38, 39, 40, 41, 53}
}

zoom = exports["pd-gui"]:getInterfaceZoom()

przeb.texbg = dxCreateTexture("images/select_skin_back.png")
przeb.texlistbgactive = dxCreateTexture("images/list_background_active.png")
przeb.texlistbg = dxCreateTexture("images/list_background.png")

local k = 1
local n = 6
local m = 6
local categories = {
	["Mężczyzna"] = {100/zoom, sy/2 - 315/zoom, 447/zoom, 62/zoom},
	["Kobieta"] = {100/zoom, sy/2 - 253/zoom, 447/zoom, 62/zoom},
	["Premium (Mężczyzna)"] = {100/zoom, sy/2 - 192/zoom, 447/zoom, 62/zoom},
	["Premium (Kobieta)"] = {100/zoom, sy/2 - 130/zoom, 447/zoom, 62/zoom},
    ["✖ Zamknij"] = {100/zoom, sy/2 - 68/zoom, 447/zoom, 62/zoom},
}

przeb.draw = function()
	if getPedOccupiedVehicle(localPlayer) then return end
	if przeb.actual == "main" then 
		dxDrawImage(100/zoom, sy/2 - 450/zoom, 447/zoom, 135/zoom, przeb.texbg,0,0,0, tocolor(255,255,255,255))
		for k,v in pairs(categories) do
			if isMouseIn(v[1], v[2], v[3], v[4]) then
				dxDrawImage(v[1], v[2], v[3], v[4], przeb.texlistbgactive,0,0,0, tocolor(255,255,255,255))
			else
				dxDrawImage(v[1], v[2], v[3], v[4], przeb.texlistbg,0,0,0, tocolor(255,255,255,255))
			end
            dxDrawText(k, v[1] + 10, v[2] + v[4] / 2, v[3], v[2] + v[4] / 2, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "center")
		end
	end
	if przeb.actual ~= "main" then
	dxDrawImage(100/zoom, sy/2 - 450/zoom, 447/zoom, 135/zoom, przeb.texbg,0,0,0, tocolor(255,255,255,255))
	local x = 0
	for i, v in ipairs(skins[przeb.actual]) do
		if i >= k and i <= n then 
			x = x+1
			scroll = (62/zoom)*(x-1)
			if isMouseIn(100/zoom, sy/2 - 315/zoom+scroll, 447/zoom, 62/zoom) then 
				dxDrawImage(100/zoom, sy/2 - 315/zoom+scroll, 447/zoom, 62/zoom, przeb.texlistbgactive,0,0,0, tocolor(255,255,255,255))
			else 
			   dxDrawImage(100/zoom, sy/2 - 315/zoom+scroll, 447/zoom, 62/zoom, przeb.texlistbg,0,0,0, tocolor(255,255,255,255))
			end
				dxDrawText(v, 114/zoom, sy/2 - 303/zoom+scroll, 447/zoom, 62/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left")
			end 
		end
	end
end

function setDress(dress)
	przeb.actual = dress
	przeb.delay = true
	setTimer(function()
		przeb.delay = false
	end, 500, 1)
	setElementRotation(localPlayer, 0,0,180, "default", true)
end

bindKey("mouse1", "down", function()
	if przeb.enabled == false then return end
	if isMouseIn(sx/2 -924/zoom, sy/2 - 68/zoom, 447/zoom, 62/zoom) and przeb.actual == "main" and przeb.delay == false then
		removeEventHandler("onClientRender", root, przeb.draw)
		przeb.enabled = false
		przeb.delay = false
		showCursor(false)
		showChat(true)
		toggleAllControls(true)
		setCameraTarget(localPlayer, localPlayer)
	elseif isMouseIn(sx/2 -924/zoom, sy/2 - 315/zoom, 447/zoom, 62/zoom) and przeb.actual == "main" and przeb.delay == false then
		setDress("men")
	elseif isMouseIn(sx/2 -924/zoom, sy/2 - 253/zoom, 447/zoom, 62/zoom) and przeb.actual == "main" and przeb.delay == false then
		setDress("woman")
	elseif isMouseIn(sx/2 -924/zoom, sy/2 - 192/zoom, 447/zoom, 62/zoom) and przeb.actual == "main" and przeb.delay == false then
		if getElementData(localPlayer, "player:premium") == false then exports["pd-hud"]:addNotification("Nie posiadasz aktywnego statusu Premium.", "error", 5000, nil, "error") return end
		setDress("premiummen")
	elseif isMouseIn(sx/2 -924/zoom, sy/2 - 130/zoom, 447/zoom, 62/zoom) and przeb.actual == "main" and przeb.delay == false then
		if getElementData(localPlayer, "player:premium") == false then exports["pd-hud"]:addNotification("Nie posiadasz aktywnego statusu Premium.", "error", 5000, nil, "error") return end
		setDress("premiumwoman")
	end
end)

bindKey("mouse1", "down", function()
	if not przeb.enabled == true then return end
	if przeb.actual == "main" then return end
	local x = 0
	for i, v in ipairs(skins[przeb.actual]) do
		if i >= k and i <= n then
			x = x+1
			scroll = (62/zoom)*(x-1)
			if isMouseIn(sx/2 -924/zoom, sy/2 - 315/zoom+scroll, 447/zoom, 62/zoom) and przeb.actual ~= "main" and przeb.delay == false then
				if v == "⬅ Powrót" then
					przeb.actual = "main"
					przeb.delay = true
					setTimer(function()
					przeb.delay = false
					end, 500, 1)
				else
					triggerServerEvent("przeb:changeSkin", localPlayer, localPlayer, v)
				end
			end
		end
	end
end)

przeb.start = function(el)
	if getPedOccupiedVehicle(localPlayer) then return end
	if el == localPlayer then
		toggleAllControls(false)
		addEventHandler("onClientRender", root, przeb.draw)
		showCursor(true)
		showChat(false)
		przeb.enabled = true
		przeb.actual = "main"
		przeb.delay = false
		setCameraMatrix( 386.879, -42.7495, 951.596, x, y, z+1)
		setElementPosition(localPlayer, 386.879, -38.7495, 950.596)
		setElementRotation(localPlayer, 0, 0, 180)
	end
end
marker = exports["pd-markers"]:createCustomMarker(x, y, z, 255, 255, 0, 155, "marker", 1)
addEventHandler("onClientMarkerHit", marker, przeb.start)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	exports["pd-markers"]:destroyCustomMarker(getElementData(marker, "marker:id"))
end)

bindKey("mouse_wheel_down", "both", function()
	if przeb.enabled == false then return end
	if przeb.actual == "main" then return end
	if n >= #skins[przeb.actual] then return end
	k = k+1
	n = n+1
end)

bindKey("mouse_wheel_up", "both", function()
	if przeb.enabled == false then return end
	if przeb.actual == "main" then return end
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