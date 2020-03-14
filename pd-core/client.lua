addEvent("loadPlayerData", true)
addEventHandler("loadPlayerData", localPlayer, function()
	exports["pd-hud"]:showHUD(true)
end)

function setAddData(data, value)
	local addData = getElementData(localPlayer, "player:addData")
	addData[data] = value
	setElementData(localPlayer, "player:addData", addData)
end

function getAddData(data)
	local addData = getElementData(localPlayer, "player:addData")
	return addData[data]
end

function takeMoney(amount)
	triggerServerEvent("changeMoneyAmount", resourceRoot, localPlayer, -amount)
end

function giveMoney(amount)
	triggerServerEvent("changeMoneyAmount", resourceRoot, localPlayer, amount)
end

lastPlayTickCount = getTickCount()
lastAFKTickCount = getTickCount()
sx, sy = guiGetScreenSize()
afk_window = dxCreateTexture("images/afk_window.png")

addEventHandler("onClientRender", root, function()
	local logged = getElementData(localPlayer, "player:logged") or false
	if not logged then return end

	local spawned = getElementData(localPlayer, "player:spawned") or false
	if not spawned then return end

	if getPedWeapon(localPlayer) == 0 then
		toggleControl("fire", false)
		toggleControl("aim_weapon", false)
		setPlayerHudComponentVisible("crosshair", false)
	else
		toggleControl("fire", true)
		toggleControl("aim_weapon", true)
		setPlayerHudComponentVisible("crosshair", true)
	end

	if isChatBoxInputActive() and not getElementData(localPlayer, "player:typing") then
		setElementData(localPlayer, "player:typing", true)
	elseif not isChatBoxInputActive() and getElementData(localPlayer, "player:typing") then
		setElementData(localPlayer, "player:typing", false)
	end

	local remaining = getTickCount() - lastPlayTickCount

	local playtime = getElementData(localPlayer, "player:play_time") or 0
    local session = getElementData(localPlayer, "player:session_time") or 0

	if remaining > 1000 and not getElementData(localPlayer, "player:away") then
		lastPlayTickCount = getTickCount()

		playtime = playtime + 1
        session = session + 1
        setElementData(localPlayer, "player:play_time", playtime, true)
		setElementData(localPlayer, "player:session_time", session, true)

		if getElementData(localPlayer, "player:session_time") >= 28800 then 
			exports["pd-achievements"]:addPlayerAchievement(localPlayer, "No life", 5)

		end
	end

	if getTickCount() - lastAFKTickCount > 30000 then
		if not getElementData(localPlayer, "player:away") then
			setElementData(localPlayer, "player:away", true)
		end
		exports["pd-gui"]:drawBWRectangle(0, 0, sx, sy)
		dxDrawImage((sx - 448)/2, (sy - 160)/2, 448, 160, afk_window)
	end
end)

addEventHandler("onClientKey", root, function()
	lastAFKTickCount = getTickCount()
	setElementData(localPlayer, "player:away", false)
end)

addEventHandler("onClientCursorMove", root, function()
	lastAFKTickCount = getTickCount()
	setElementData(localPlayer, "player:away", false)
end)




