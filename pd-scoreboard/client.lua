local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()
local normal_small = GUI:getGUIFont("normal_small")
local normal_big = GUI:getGUIFont("normal_big")
local editbox = GUI:createEditbox("", sx/2 - 50/zoom, sy/2 - 340/zoom, 280/zoom, 45/zoom, normal_small, 0.8/zoom)
local editbox_texture = dxCreateTexture("images/editbox.png")
local editbox_active_texture = dxCreateTexture("images/editbox_active.png")
GUI:setEditboxMaxLength(editbox, 25)
GUI:setEditboxTextures(editbox, {["default"]=editbox_texture, ["active"]=editbox_active_texture})
GUI:setEditboxHelperText(editbox, "Wyszukaj gracza (nick lub ID)")
local lastText = GUI:getEditboxText(editbox)
local scrollPosition = 1

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	GUI:destroyEditbox(editbox)
	setElementData(localPlayer, "player:showingGUI", false)
end)

function getPlayersFromText(text)
	playersTable = {}
	for k,v in pairs(getElementsByType("player")) do
		local id = getElementData(v, "player:id")
		if id then
			name = id .. " " .. getPlayerName(v)
		else
			name = getPlayerName(v)
		end
		if string.find(name, text) then
			table.insert(playersTable, v)
		end
	end
	return playersTable
end

function renderScoreboard()
	if not getElementData(localPlayer, "player:uid") then return end
	editText = GUI:getEditboxText(editbox)
	allPlayers = getElementsByType("player")
	if editText and editText ~= "" then
		allPlayers = getPlayersFromText(editText)
	end
	data = {}
	for k,v in pairs(allPlayers) do
		idc = getElementData(v, "player:id")
		if idc then
			table.insert(data, {v, id=idc})
		end
	end
	table.sort(data, function(a, b)
		return a.id < b.id
	end)
	allPlayers = data
	dxDrawImage(sx/2 - 400/zoom, sy/2 - 400/zoom, 800/zoom, 800/zoom, "images/background.png")
	dxDrawImage(sx/2 - 390/zoom, sy/2 - 390/zoom, 300/zoom, 130/zoom, "images/logo.png")
	dxDrawImage(sx/2 - 400/zoom, sy/2 - 252/zoom, 800/zoom, 30/zoom, "images/player_background.png")
	GUI:renderEditbox(editbox)
	dxDrawText(#allPlayers, sx/2 + 280/zoom - dxGetTextWidth(#allPlayers, 1/zoom, normal_big), sy/2 - 343/zoom, sx, sy, tocolor(255, 55, 200), 1/zoom, normal_big)
	dxDrawText("Naciśnij PPM by pokazać kursor", sx/2, sy/2 + 400/zoom, sx/2, sy/2 + 400/zoom, white, 1/zoom, normal_small, "center")
	if #allPlayers == 1 then
		text = "Gracz"
	else
		text = "Graczy"
	end
	dxDrawText(text, sx/2 + 285/zoom, sy/2 - 323/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("ID", sx/2 - 380/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("NICK", sx/2 - 310/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("ORGANIZACJA", sx/2 - 85/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("SŁUŻBA", sx/2 + 195/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("RP", sx/2 + 290/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	dxDrawText("PING", sx/2 + 340/zoom, sy/2 - 250/zoom, sx, sy, white, 1/zoom, normal_small)
	ide = 1
	drawingId = 1
	for k,v in ipairs(allPlayers) do
		if ide > 20 then break end
		if drawingId >= scrollPosition and drawingId <= scrollPosition + 20 then
			id = getElementData(v[1], "player:id")
			rp = getElementData(v[1], "player:rp")
			organisation = getElementData(v[1], "player:organisation")
			duty = getElementData(v[1], "player:duty")
			nick = getPlayerName(v[1])
			ping = getPlayerPing(v[1])
			if id then
				if getElementData(v[1], "player:admin:rank") == "Administrator RCON" then
					nick = "#910000"..nick
				elseif getElementData(v[1], "player:admin:rank") == "Administrator" then
					nick = "#e80000"..nick
				elseif getElementData(v[1], "player:admin:rank") == "Moderator" then
					nick = "#009127"..nick
				elseif getElementData(v[1], "player:admin:rank") == "Support" then
					nick = "#00d4f5"..nick
				elseif getElementData(v[1], "player:premium") then
					nick = "#f7da00"..nick
				end
				dxDrawText(id, sx/2 - 380/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small)
				dxDrawText(nick, sx/2 - 310/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small, "left", "top", false, false, false, true)
				dxDrawText(organisation or "Brak", sx/2 - 85/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small)
				dxDrawText(duty or "Brak", sx/2 + 195/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small)
				dxDrawText(rp or 0, sx/2 + 290/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small)
				dxDrawText(ping or 0, sx/2 + 340/zoom, sy/2 - 240/zoom + (30/zoom) * ide, sx, sy, white, 1/zoom, normal_small)
				ide = ide + 1
			end
		end
		drawingId = drawingId + 1
	end
end

tabIsOn = false
isCursorShowingVariable = false

bindKey("mouse2", "down", function()
	if tabIsOn then
		isCursorShowingVariable = not isCursorShowingVariable
		showCursor(isCursorShowingVariable, false)
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if tabIsOn then
		if scrollPosition > 1 then
			scrollPosition = scrollPosition - 1
		end
	end
end)

bindKey("mouse_wheel_down", "down", function()
	if tabIsOn then
		if #allPlayers < 10 then return end
		allPlayers = getElementsByType("player")
		
			scrollPosition = scrollPosition + 1
		
	end
end)

bindKey("TAB", "down", function()
	if tabIsOn then
		isCursorShowingVariable = false
		showCursor(isCursorShowingVariable, false)
		removeEventHandler("onClientRender", root, renderScoreboard)
		tabIsOn = false
		setElementData(localPlayer, "player:showingGUI", false)
	else
		if getElementData(localPlayer, "player:showingGUI") then return end
		addEventHandler("onClientRender", root, renderScoreboard)
		tabIsOn = true
		setElementData(localPlayer, "player:showingGUI", "scoreboard")
	end
end)