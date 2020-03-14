
local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()

local button = nil
normal_small = GUI:getGUIFont("normal_small")
normal_big = GUI:getGUIFont("normal_big")


local cameraData = {
	["actual"] = 1,
	{1531, -1766, 84.5, 1475, -1710, 70},
	{2477.2, 1665.3, 42, 2436.5, 1652.9, 29.4},
	{2477.2, -1665.3, 42, 2436.5, -1652.9, 29.4},
	{2110.5, 1256.6, 50.8, 2062.3, 1400.8, 37.8},
}
local strengthAnim = 0
local lastTickCount = getTickCount()
editbox = {}
notifications = {}
local menuPos = {
	currentMenu = 1,
	["select"] = {sx*0.8, sy/2},
	["gui"] = {sx/2,sy/2},
}

edit_line_texture = dxCreateTexture("data/login/edit_line.png")
user_texture = dxCreateTexture("data/login/user.png")
password_texture = dxCreateTexture("data/login/password.png")
email_texture = dxCreateTexture("data/login/email.png")
checkbox_texture = dxCreateTexture("data/login/checkbox.png")
checkbox_active_texture = dxCreateTexture("data/login/checkbox_active.png")
button_texture = dxCreateTexture("data/login/button.png")

updates = {
	["page"] = 1,
	{"26.12.2019", "Dodanie aktualizacji\nDodanie animacji w panelu logowania"},
	{"25.12.2019", "Utworzenie discorda discord.gg/HnXgfeW"},
	{"23.12.2019", "Rozpoczęcie prac nad panelem logowania"},
	{"22.12.2019", "Rozpoczęcie prac nad serwerem\nSystem GUI"},
}
hexagons = {
	{x=-290/zoom, y=-200/zoom, s=250/zoom, img="login"},
	{x=-60/zoom, y=-200/zoom, s=250/zoom, img="register"},
	{x=-175/zoom, y=0, s=250/zoom, img="changes"},
}

setAnimation("hexagonX", sx*0.8, sx*0.8, 1000, "Linear")
setAnimation("hexagonY", sy/2, sy/2, 1000, "Linear")
setAnimation("guiX", sx + 500, sx + 500, 1000, "Linear")
setAnimation("guiY", sy/2, sy/2, 1000, "Linear")

function nextCamera()
	fadeCamera(false)
	changeCamera = setTimer(function()
		cameraData["actual"] = cameraData["actual"] + 1
		changeCamera = nil
		if cameraData["actual"] > #cameraData then
			cameraData["actual"] = 1
		end
		setCameraMatrix(unpack(cameraData[cameraData["actual"]]))
		fadeCamera(true)
	end, 1500, 1)
end

if not fileExists("remember.xml") then
	local xml = xmlCreateFile("remember.xml", "userdata")
	local nick = xmlCreateChild(xml, "nick")
	local password = xmlCreateChild(xml, "password")
	xmlSaveFile(xml)
	xmlUnloadFile(xml)
end
local xml = xmlLoadFile("remember.xml")
local loginChild = xmlFindChild(xml, "nick", 0)
local passwordChild = xmlFindChild(xml, "password", 0)
local login = xmlNodeGetValue(loginChild)
local password = xmlNodeGetValue(passwordChild)

editboxToCreate = {
	["login"] = {login, -500, -500, 450/zoom, 50/zoom, normal_small, 1/zoom, 16, "Nazwa użytkownika", edit_line_texture, user_texture, false},
	["password"] = {password, -500, -500, 450/zoom, 50/zoom, normal_small, 1/zoom, 16, "Hasło", edit_line_texture, password_texture, true},
	["repeat_password"] = {"", -500, -500, 450/zoom, 50/zoom, normal_small, 1/zoom, 16, "Powtórz hasło", edit_line_texture, password_texture, true},
	["email"] = {"", -500, -500, 450/zoom, 50/zoom, normal_small, 1/zoom, 50, "E-mail", edit_line_texture, email_texture, false},
}

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "player:uid") then return end
	triggerEvent("loading:close", localPlayer)
	setElementData(localPlayer, "player:showingGUI", "logging")
	setElementData(localPlayer, "player:spawned", false)
	triggerServerEvent("logging:checkBan", localPlayer, localPlayer)
	showCursor(true)
	exports["pd-hud"]:showHUD(false)
	music = playSound("data/music.mp3", true)
	addEventHandler("onClientRender", root, renderBackgroundCamera)
	addEventHandler("onClientRender", root, renderLogin)
	nextCameraTimer = setTimer(nextCamera, 10000, 0)
	nextCamera()
	for k,v in pairs(editboxToCreate) do
		editbox[k] = GUI:createEditbox(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
		GUI:setEditboxMaxLength(editbox[k], v[8])
		GUI:setEditboxHelperText(editbox[k], v[9])
		GUI:setEditboxLine(editbox[k], v[10])
		GUI:setEditboxImage(editbox[k], v[11])
		GUI:setEditboxMasked(editbox[k], v[12])
	end
	GUI:setEditboxASCIIMode(editbox["login"], false)
	checkbox = GUI:createCheckbox("", -500, 500, 250/zoom, 25/zoom)
	GUI:setCheckboxTextures(checkbox, {default=checkbox_texture, active=checkbox_active_texture})
	GUI:setCheckboxFont(checkbox, normal_small, 1/zoom)
	buttong = GUI:createButton("Zaloguj", -500, sy/2, 150, 40)
	GUI:setButtonTextures(buttong, {default=button_texture, hover=button_texture, press=button_texture})
	GUI:setCheckboxFont(buttong, normal_small, 1/zoom)
end)

addEventHandler("onClientResourceStop", root, function(stoppedResource)
	if stoppedResource ~= getThisResource() then return end
	for k,v in pairs(editboxToCreate) do
		GUI:destroyEditbox(editbox[k])
	end
	GUI:destroyCheckbox(checkbox)
	GUI:destroyButton(buttong)
end)

function stopLogging()
	showCursor(false)
	stopSound(music)
	removeEventHandler("onClientRender", root, renderBackgroundCamera)
	removeEventHandler("onClientRender", root, renderLogin)
	for k,v in pairs(editboxToCreate) do
		GUI:destroyEditbox(editbox[k])
	end
	GUI:destroyCheckbox(checkbox)
	GUI:destroyButton(buttong)
	killTimer(nextCameraTimer)
end
addEvent("logging:stopDraw", true)
addEventHandler("logging:stopDraw", root, stopLogging)

function renderBackgroundCamera()
	x, y, z, lx, ly, lz = getCameraMatrix()
	setCameraMatrix(x, y + 0.1, z, lx, ly, lz)
	GUI:drawBWRectangle(0, 0, sx, sy, tocolor(155, 155, 155, 255))
end

function drawHexagons()
	for id, v in pairs(hexagons) do
		dxDrawImage(menuPos["select"][1] + v.x, menuPos["select"][2] + v.y, v.s, v.s, "data/login/hexagon.png")
		if isMouseInHexagon(menuPos["select"][1] + v.x, menuPos["select"][2] + v.y, v.s, 0) then
			dxDrawImage(menuPos["select"][1] + v.x, menuPos["select"][2] + v.y, v.s, v.s, "data/login/" .. v.img .. "-hover.png")
		else
			dxDrawImage(menuPos["select"][1] + v.x, menuPos["select"][2] + v.y, v.s, v.s, "data/login/" .. v.img .. ".png")
		end
	end
end

function drawUpdates()
	if updates[updates["page"] - 1] then
		dxDrawImage(menuPos["gui"][1] - 230/zoom, menuPos["gui"][2] + 140/zoom, 40/zoom, 40/zoom, "data/login/arrow.png")
	end
	if updates[updates["page"] + 1] then
		dxDrawImage(menuPos["gui"][1] + 220/zoom, menuPos["gui"][2] + 140/zoom, -40/zoom, 40/zoom, "data/login/arrow.png")
	end
	dxDrawText(updates[updates["page"]][1], menuPos["gui"][1], menuPos["gui"][2] - 80/zoom, menuPos["gui"][1], menuPos["gui"][2] - 180/zoom, white, 1/zoom, normal_big, "center", "center")
	dxDrawText(updates[updates["page"]][2], menuPos["gui"][1], menuPos["gui"][2] - 100/zoom, menuPos["gui"][1], menuPos["gui"][2] - 180/zoom, white, 1/zoom, normal_small, "center", "top")
end

function renderLogin()
	strength = 0
	if isChatVisible() then
		showChat(false)
	end
	if isElement(music) then
		FFT = getSoundFFTData(music, 4096, 256)
	end
	strength = FFT[4] * 100
	if strength > strengthAnim then
		strengthAnim = strengthAnim + 1
	elseif strength < strengthAnim then
		strengthAnim = strengthAnim - 1
	end
	alphaFft = FFT[4] * 250
	setSoundSpeed(music, 1)
	if alphaFft > 255 then alphaFft = 255 end
	local x, y, w, h = sx * 0.2 - 200/zoom, (sy/2 - 200/zoom), 400/zoom, 400/zoom
	dxDrawImage(x - strengthAnim/2, y - strengthAnim/2, w + strengthAnim, h + strengthAnim, "data/login/light.png", 0, 0, 0, tocolor(255, 255, 255, alphaFft))
	dxDrawImage(x - strengthAnim/2, y - strengthAnim/2, w + strengthAnim, h + strengthAnim, "data/login/logo.png")

	menuPos["select"] = {a["hexagonX"], a["hexagonY"]}
	menuPos["gui"] = {a["guiX"], a["guiY"]}
	drawHexagons()
	if menuPos.currentMenu == 1 then
		dxDrawImage(menuPos["gui"][1] - 250/zoom, menuPos["gui"][2] - 200/zoom, 500/zoom, 400/zoom, "data/login/window.png")
		dxDrawImage(menuPos["gui"][1] - 60/zoom, menuPos["gui"][2] + 200/zoom, 120/zoom, 40/zoom, "data/login/back.png")
		drawUpdates()
	elseif menuPos.currentMenu == 2 then
		dxDrawImage(menuPos["gui"][1] - 250/zoom, menuPos["gui"][2] - 200/zoom, 500/zoom, 400/zoom, "data/login/window.png")
		dxDrawImage(menuPos["gui"][1] - 60/zoom, menuPos["gui"][2] + 200/zoom, 120/zoom, 40/zoom, "data/login/back.png")
		dxDrawText("Logowanie", menuPos["gui"][1], menuPos["gui"][2] - 155/zoom, menuPos["gui"][1], menuPos["gui"][2] - 155/zoom, white, 1/zoom, normal_big, "center", "center")
		GUI:setEditboxPosition(editbox["login"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 115/zoom)
		GUI:setEditboxPosition(editbox["password"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 40/zoom)
		GUI:setCheckboxPosition(checkbox, menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] + 50/zoom)
		GUI:setButtonPosition(buttong, menuPos["gui"][1] - 70/zoom, menuPos["gui"][2] + 105/zoom, 140/zoom, 50/zoom)
	else
		dxDrawImage(menuPos["gui"][1] - 250/zoom, menuPos["gui"][2] - 300/zoom, 500/zoom, 550/zoom, "data/login/window.png")
		dxDrawImage(menuPos["gui"][1] - 60/zoom, menuPos["gui"][2] + 250/zoom, 120/zoom, 40/zoom, "data/login/back.png")
		dxDrawText("Rejestracja", menuPos["gui"][1], menuPos["gui"][2] - 250/zoom, menuPos["gui"][1], menuPos["gui"][2] - 270/zoom, white, 1/zoom, normal_big, "center", "center")
		GUI:setEditboxPosition(editbox["login"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 215/zoom)
		GUI:setEditboxPosition(editbox["password"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 140/zoom)
		GUI:setEditboxPosition(editbox["repeat_password"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 75/zoom)
		GUI:setEditboxPosition(editbox["email"], menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] - 10/zoom)
		GUI:setCheckboxPosition(checkbox, menuPos["gui"][1] - 215/zoom, menuPos["gui"][2] + 80/zoom)
		GUI:setButtonPosition(buttong, menuPos["gui"][1] - 80/zoom, menuPos["gui"][2] + 145/zoom, 160/zoom, 50/zoom)
	end
	GUI:renderEditbox(editbox["login"])
	GUI:renderEditbox(editbox["password"])
	GUI:renderEditbox(editbox["repeat_password"])
	GUI:renderEditbox(editbox["email"])
	GUI:renderCheckbox(checkbox)
	GUI:renderButton(buttong)
	d = 1
	for k,v in pairs(notifications) do
		dxDrawImage(a["noti" .. k], 10/zoom + (90/zoom * (d - 1)), 500/zoom, 80/zoom, "data/notifications/" .. v[2] .. ".png")
		dxDrawText(v[1], a["noti" .. k] + 75/zoom, 10/zoom + (90/zoom * (d - 1)) + 40/zoom - dxGetFontHeight(1/zoom, normal_small)/2, sx, sy, white, 1/zoom, normal_small)
		d = d + 1
	end
end

function destroyNotification(idnotki)
	setAnimation("noti" .. idnotki, sx - 510/zoom, sx + 500, 1000, "InQuad")
	setTimer(function(idnotki)
		notifications[idnotki] = nil
	end, 1000, 1, idnotki)
end

idn = 1
function addNotification(text, type)
	notifications[idn] = {text, type}
	setTimer(destroyNotification, 3000, 1, idn)
	setAnimation("noti" .. idn, sx + 500, sx - 510/zoom, 1000, "OutQuad")
	idn = idn + 1
	return idn - 1
end
addEvent("addNotification", true)
addEventHandler("addNotification", localPlayer, addNotification)

addEvent("loginToServer", true)
addEventHandler("loginToServer", localPlayer, function()
	removeEventHandler("onClientRender", root, renderBackgroundCamera)
	removeEventHandler("onClientRender", root, renderLogin)
	triggerEvent("showSpawns", root )
	killTimer(nextCameraTimer)
	if changeCamera then
		killTimer(changeCamera)
	end
end)

function allAnimationsAreStopped()
	return getAnimationProgress("hexagonX") == 1 and getAnimationProgress("hexagonY") == 1 and getAnimationProgress("guiX") == 1 and getAnimationProgress("guiY") == 1
end

addEventHandler ("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button ~= "left" or state ~= "down" then return end
	if isMouseInPosition(menuPos["gui"][1] - 230/zoom, menuPos["gui"][2] + 140/zoom, 40/zoom, 40/zoom) and updates[updates["page"] - 1] then
		updates["page"] = updates["page"] - 1
	end
	if isMouseInPosition(menuPos["gui"][1] + 180/zoom, menuPos["gui"][2] + 140/zoom, 40/zoom, 40/zoom) and updates[updates["page"] + 1] then
		updates["page"] = updates["page"] + 1
	end
	if isMouseInPosition(menuPos["gui"][1] - 80/zoom, menuPos["gui"][2] + 145/zoom, 160/zoom, 50/zoom) and menuPos.currentMenu == 3 then
		login = GUI:getEditboxText(editbox["login"])
		password = GUI:getEditboxText(editbox["password"])
		repeat_password = GUI:getEditboxText(editbox["repeat_password"])
		email = GUI:getEditboxText(editbox["email"])
		if string.len(login) < 5 then
			return addNotification("Login jest zbyt krótki", "error")
		end
		if string.len(password) < 5 then
			return addNotification("Hasło jest zbyt proste", "error")
		end
		if password ~= repeat_password then
			return addNotification("Hasłą się nie zgadzają", "error")
		end
		if not validemail(email or "") then
			return addNotification("Email nie jest poprawny", "error")
		end
		if not GUI:isCheckboxActive(checkbox) then
			return addNotification("Nie zaakceptowałeś/aś regulaminu", "error")
		end
		if getTickCount() - lastTickCount > 1500 then
			triggerServerEvent ("registerAccount", resourceRoot, localPlayer, login, password, email)
			lastTickCount = getTickCount()
		else
			return addNotification("Nie laguj serwera", "error")
		end
	end
	if isMouseInPosition(menuPos["gui"][1] - 70/zoom, menuPos["gui"][2] + 105/zoom, 140/zoom, 50/zoom) and menuPos.currentMenu == 2 then
		login = GUI:getEditboxText(editbox["login"])
		password = GUI:getEditboxText(editbox["password"])
		if getTickCount() - lastTickCount > 1500 then
			triggerServerEvent ("loginToAccount", resourceRoot, localPlayer, login, password)
			lastTickCount = getTickCount()
			if GUI:isCheckboxActive(checkbox) then
				xmlNodeSetValue(loginChild, login)
				xmlNodeSetValue(passwordChild, password)
				xmlSaveFile(xml)
			end
		else
			return addNotification("Nie laguj serwera", "error")
		end
	end
	if allAnimationsAreStopped() then
		if (isMouseInPosition(menuPos["gui"][1] - 60/zoom, menuPos["gui"][2] + 200/zoom, 120/zoom, 40/zoom) and menuPos.currentMenu ~= 3) or (isMouseInPosition(menuPos["gui"][1] - 60/zoom, menuPos["gui"][2] + 250/zoom, 120/zoom, 40/zoom) and menuPos.currentMenu == 3) then
			setAnimation("hexagonY", sy/2, sy/2, 1500, "OutQuad")
			setAnimation("hexagonX", sx+500, sx*0.8, 1500, "OutQuad")
			setAnimation("guiX", sx*0.8, sx*0.8, 1500, "OutQuad")
			setAnimation("guiY", sy/2, -500, 1500, "OutQuad")
		end
		for id, v in pairs(hexagons) do
			if isMouseInHexagon(menuPos["select"][1] + v.x, menuPos["select"][2] + v.y, v.s, 0) then
				setAnimation("hexagonX", sx*0.8, sx*0.8, 1000, "InQuad")
				setAnimation("hexagonY", sy/2, -500, 1000, "InQuad")
				setAnimation("guiX", sx+500, sx * 0.8, 1500, "OutQuad")
				setAnimation("guiY", sy/2, sy/2, 1500, "OutQuad")
				if v.img == "changes" then
					menuPos.currentMenu = 1
				elseif v.img == "login" then
					menuPos.currentMenu = 2
					GUI:setCheckboxText(checkbox, "Zapamiętaj mnie")
					GUI:setButtonText(buttong, "Zaloguj")
				else
					menuPos.currentMenu = 3
					GUI:setCheckboxText(checkbox, "Akceptuję regulamin serwera")
					GUI:setButtonText(buttong, "Zarejestruj")
				end
			end
		end
	end
end)