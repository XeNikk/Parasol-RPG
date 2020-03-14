local description = [[Praca polega na przewożeniu pasażerów autobusem po stanie San Andreas.
Masz do dyspozycji trasy miejskie i międzymiastowe.
Zatrzymuj się na przystankach by przyjmować pasażerów i sprzedawaj im bilety.
Uważaj - jeśli zaszalejesz z jazdą pasażerom może się to nie spodobać, co będzie miało wpływ na twoją wypłatę.]]
local requirements = "prawo jazdy kat. D"
local rewards = ""

local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local windowPos = {x=math.floor(screenW/2-882/zoom/2), y=math.floor(screenH/2-573/zoom/2), w=math.floor(882/zoom), h=math.floor(573/zoom)}
local selectWindowPos = {x=math.floor(screenW/2-700/zoom/2), y=math.floor(screenH/2-450/zoom/2), w=math.floor(700/zoom), h=math.floor(450/zoom)}
local sellWindowPos = {x=math.floor(50/zoom), y=math.floor(screenH/2-500/zoom/2), w=math.floor(450/zoom), h=math.floor(500/zoom)}
local buttonSize = {w=math.floor(165/zoom), h=math.floor(41/zoom)}
local textures = {}
local playerPoints = 0
nextBusStopName = ""
happyLevel = 3
leftTime = 0
local ticketPosition = {
	["normalny"] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h/4, ["catch"] = false},
	["ulgowy"] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h - sellWindowPos.h/4, ["catch"] = false},
}
ticketType = false

local acceptButton, cancelButton, upgradesButton
local topGridlist = {}
local showingSell = false

setTimer(function()
	if getElementData(localPlayer, "player:job") ~= "bus" then return end
	leftTime = leftTime - 1
end, 1000, 0)

function angryPeople()
	playSound("sounds/panic.mp3")
	if happyLevel > 1 then
		happyLevel = happyLevel - 1
	end
end

addEventHandler("onClientVehicleCollision", root, function(_, force)
	if getElementData(localPlayer, "player:job") ~= "bus" then return end
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if not jobVehicle then return end
	if source ~= jobVehicle then return end
	if force > 500 then
		angryPeople()
	end
end)

addEventHandler("onClientKey", root, function(key, press)
	if getElementData(localPlayer, "player:job") ~= "bus" then return end
	local jobVehicle = getPedOccupiedVehicle(localPlayer)
	if not jobVehicle then return end
	local vx, vy, vz = getElementVelocity(jobVehicle)
	local speed = math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161)
	if press then
		if speed > 25 then
			local keys = getBoundKeys ("handbrake")
			for k,v in pairs(keys) do
				if key == k then
					angryPeople()
				end
			end
		end
	end
end)

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "player:job") == "bus" then
		dxDrawImage(screenW/2 - 600/zoom/2, 50/zoom, 600/zoom, 140/zoom, "images/background.png")
		if math.floor(happyLevel) == 3 then
			dxDrawImage(screenW/2 - 555/zoom/2, 65/zoom, 80/zoom, 80/zoom, "images/smile.png")
		elseif math.floor(happyLevel) == 2 then
			dxDrawImage(screenW/2 - 555/zoom/2, 65/zoom, 80/zoom, 80/zoom, "images/neutral.png")
		else
			dxDrawImage(screenW/2 - 555/zoom/2, 65/zoom, 80/zoom, 80/zoom, "images/angry.png")
		end
		dxDrawText("Zadowolenie", screenW/2 - 555/zoom/2 + 40/zoom, 165/zoom, screenW/2 - 555/zoom/2 + 40/zoom, 165/zoom, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "center")
		dxDrawText("N. przystanek " .. nextBusStopName, screenW/2 - 555/zoom/2 + 100/zoom, 75/zoom, 0, 0, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		if leftTime < 0 then
			leftTime02 = -leftTime
		else
			leftTime02 = leftTime
		end
		local m = math.floor(leftTime02 / 60)
		local s = math.floor(leftTime02 - (60 * m))
		if leftTime > 0 then
			text = string.format("-" .. m .. ":%02d", s)
		else
			text = string.format("+" .. m .. ":%02d", s)
		end
		dxDrawText(text, screenW/2 - 555/zoom/2 + 100/zoom, 90/zoom, 0, 0, tocolor(0, 178, 194), 1.2/zoom, exports["pd-gui"]:getGUIFont("normal_big"))
		if leftTime > 60 then
			addInfo = "Jedziesz za wcześnie"
		elseif leftTime < -20 then
			addInfo = "Jedziesz za późno"
		else
			addInfo = "Planowany przyjazd"
		end
		dxDrawText(addInfo, screenW/2 - 555/zoom/2 + 100/zoom, 145/zoom, 0, 0, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
	end
end)

function showSellTickets()
	textures.ticket_background = dxCreateTexture("images/ticket_background.png")
	textures.ticket_info_background = dxCreateTexture("images/ticket_info_background.png")
	textures.halfprice_ticket = dxCreateTexture("images/halfprice_ticket.png")
	textures.normal_ticket = dxCreateTexture("images/normal_ticket.png")

	if not showingSell then
		addEventHandler("onClientRender", root, renderSellTickets)
		showingSell = true
	end
	showCursor(true)
	showChat(false)
end

function hideSellTickets()
	if showingSell then
		removeEventHandler("onClientRender", root, renderSellTickets)
		showingSell = false
	end
	for k, v in pairs(textures) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	textures = {}
	showCursor(false)
	showChat(true)
end

function showSelectType()
	triggerServerEvent("onPlayerGetPoints", resourceRoot)

	textures.background = dxCreateTexture("images/gui_background.png")
	textures.city = dxCreateTexture("images/select_1.png")
	textures.aboardcity = dxCreateTexture("images/select_2.png")

	addEventHandler("onClientRender", root, renderSelectTypeGUI)
	addEventHandler("onClientClick", root, selectTypeClick)
	showCursor(true)
end

function hideSelectType()
	removeEventHandler("onClientClick", root, selectTypeClick)
	removeEventHandler("onClientRender", root, renderSelectTypeGUI)

	for k, v in pairs(textures) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	textures = {}
	showCursor(false)
end

function showJobGUI()
	toggleAllControls(false)
	triggerServerEvent("onPlayerGetTopData", resourceRoot)
	
	textures.background = dxCreateTexture("images/gui_background.png")
	textures.button = dxCreateTexture("images/gui_button.png")
	textures.image = dxCreateTexture("images/gui_job_image.png")
	textures.scroll, textures.scroll_point = dxCreateTexture("images/gui_scrollbar.png"), dxCreateTexture("images/gui_scrollbar_point.png")
	
	rewards = "$"..tostring(exports["pd-jobsettings"]:getJobData("bus", "city")..": za każdy przystanek miejski\n$"..exports["pd-jobsettings"]:getJobData("bus", "countryside")..": za każdy przystanek międzymiastowy\n$"..exports["pd-jobsettings"]:getJobData("bus", "ticket")..": za każdy sprzedany bilet")
	
	addEventHandler("onClientRender", root, renderJobGUI)
	showCursor(true)
	
	acceptButton = exports["pd-gui"]:createButton("Pracuj", windowPos.x+math.floor(25/zoom), math.floor(windowPos.y+windowPos.h-buttonSize.h*2), buttonSize.w, buttonSize.h)
	exports["pd-gui"]:setButtonTextures(acceptButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(acceptButton, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	addEventHandler("onClientClickButton", acceptButton, function()
		licenseTable = getElementData(localPlayer, "player:pj")
		if tonumber(licenseTable["D"]) == 1 then
			hideJobGUI()
			showSelectType()
		else
			exports["pd-hud"]:showPlayerNotification("Nie masz prawa jazdy kat. D!", "error")
		end
	end)
	
	cancelButton = exports["pd-gui"]:createButton("Anuluj", math.floor(windowPos.x+buttonSize.w+50/zoom), math.floor(windowPos.y+windowPos.h-buttonSize.h*2), buttonSize.w, buttonSize.h)
	exports["pd-gui"]:setButtonTextures(cancelButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelButton, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	addEventHandler("onClientClickButton", cancelButton, function()
		hideJobGUI()
	end)
	
	topGridlist = exports["pd-gui"]:createGridlist(windowPos.x+math.floor(450/zoom), windowPos.y+math.floor(60/zoom), math.floor(360/zoom), math.floor(200/zoom), {background=textures.scroll, grip=textures.scroll_point})
	exports["pd-gui"]:addGridlistColumn(topGridlist, "Gracz", 0.6)
	exports["pd-gui"]:addGridlistColumn(topGridlist, "Wynik", 0.4)
	exports["pd-gui"]:setGridlistFont(topGridlist, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	exports["pd-gui"]:setGridlistSelectionMode(topGridlist, "none")
	
end 

function hideJobGUI()
	toggleAllControls(true)
	removeEventHandler("onClientRender", root, renderJobGUI)
	
	exports["pd-gui"]:destroyButton(acceptButton)
	exports["pd-gui"]:destroyButton(cancelButton)
	exports["pd-gui"]:destroyButton(upgradesButton)
	exports["pd-gui"]:destroyGridlist(topGridlist)
	for k, v in pairs(textures) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	textures = {}
	
	showCursor(false)
end 

local tick = getTickCount()

function selectTypeClick(button, state)
	local x, y, w, h = screenW/2 - 310/2/zoom, screenH/2 - 210/2/zoom, 310/zoom, 210/zoom
	if button == "left" and state == "down" and tick < getTickCount() then
		tick = getTickCount() + 300
		if isMouseInPosition(x - 170/zoom, y, w, h) then
			startJob("miastowy")
			hideSelectType()
			happyLevel = 3
			leftTime = 40
		end
		if isMouseInPosition(x + 170/zoom, y, w, h) then
			if playerPoints >= 250 then
				startJob("międzymiastowy")
				hideSelectType()
				happyLevel = 3
				leftTime = 40
			else
				exports["pd-hud"]:addNotification("Nie posiadasz 250 punktów.", "error", "error", 5000, "error")
			end
		end
	end
end

function renderSellTickets()
	dxDrawImage(sellWindowPos.x, sellWindowPos.y, sellWindowPos.w, sellWindowPos.h, textures.ticket_background)
	dxDrawImage(sellWindowPos.x, sellWindowPos.y-150/zoom, sellWindowPos.w, 130/zoom, textures.ticket_info_background)
	
	local x, y = sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y - 150/zoom + 130/zoom/2
	dxDrawText("Pasażer prosi o bilet " .. ticketType .. "\n#ffffffAby sprzedaż bilet pasażerowi, przeciągnij bilet\nw stronę pasażera", x, y, x, y, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "center", false, true, false, true)

	cx, cy = getCursorPosition()
	if not cx or not cy then return end
	cx, cy = cx * screenW, cy * screenH
	tickets = {
		["normalny"] = {ticketPosition["normalny"][1] - 400/zoom/2, ticketPosition["normalny"][2] - 130/zoom/2, 400/zoom, 180/zoom, textures.halfprice_ticket},
		["ulgowy"] = {ticketPosition["ulgowy"][1] - 400/zoom/2, ticketPosition["ulgowy"][2] - 230/zoom/2, 400/zoom, 180/zoom, textures.normal_ticket},
	}
	catch = false
	for k,v in pairs(tickets) do
		x, y, w, h = v[1], v[2], v[3], v[4]
		dxDrawImage(x, y, w, h, v[5], 0, 0, 0, tocolor(255, 255, 255, isMouseInPosition(x, y, w, h) and 255 or 155))
		if not catch then
			if ticketPosition[k].catch then
				if getKeyState("mouse1") then
					ticketPosition[k][1] = cx
					ticketPosition[k][2] = cy
					catch = true
				else
					if cx > screenW/2 then
						if not string.find(ticketType, k) then
							local money = exports["pd-jobsettings"]:getJobData("bus", "ticket")
							exports["pd-hud"]:addNotification("Bonus za sprzedaż biletów $" .. money, "success", "success", 5000, "success")
							exports["pd-core"]:giveMoney(tonumber(money))
						else
							exports["pd-hud"]:addNotification("Podano zły bilet pasażerowi.", "error", "error", 5000, "error")
							if happyLevel > 1 then
								happyLevel = happyLevel - 1
							end
						end
						sellNextTicket()
					end
					if k == "normalny" then
						ticketPosition[k] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h/4, ["catch"] = false}
					else
						ticketPosition[k] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h - sellWindowPos.h/4, ["catch"] = false}
					end
				end
			else
				if isMouseInPosition(x, y, w, h) and getKeyState("mouse1") then
					ticketPosition[k].catch = true
				else
					if k == "normalny" then
						ticketPosition[k] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h/4, ["catch"] = false}
					else
						ticketPosition[k] = {sellWindowPos.x + sellWindowPos.w/2, sellWindowPos.y + sellWindowPos.h - sellWindowPos.h/4, ["catch"] = false}
					end
				end
			end
		end
	end
end

function renderSelectTypeGUI()
	dxDrawImage(selectWindowPos.x, selectWindowPos.y, selectWindowPos.w, selectWindowPos.h, textures.background)

	local x, y = screenW/2, selectWindowPos.y + 30/zoom
	dxDrawText("Wybierz preferowany typ linii", x, y, x, y, white, 1.2/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	
	local x, y = screenW/2, selectWindowPos.y + 80/zoom
	dxDrawText("Wynik: ".. playerPoints, x, y, x, y, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)

	local x, y, w, h = screenW/2 - 310/2/zoom, screenH/2 - 210/2/zoom, 310/zoom, 210/zoom
	dxDrawImage(x - 170/zoom, y, w, h, textures.city, 0, 0, 0, white)
	if not isMouseInPosition(x - 170/zoom, y, w, h) then
		exports["pd-gui"]:drawBWRectangle(x - 170/zoom, y, w, h)
	end
	dxDrawImage(x + 170/zoom, y, w, h, textures.aboardcity, 0, 0, 0, white)
	if not isMouseInPosition(x + 170/zoom, y, w, h) then
		exports["pd-gui"]:drawBWRectangle(x + 170/zoom, y, w, h)
	end
	dxDrawText("Linia miejska\nDostępna od 0 punktów", screenW/2 - 170/zoom, y + 230/zoom, screenW/2 - 170/zoom, y + 230/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	dxDrawText("Linia międzymiastowa\nDostępna od 250 punktów", screenW/2 + 170/zoom, y + 230/zoom, screenW/2 + 170/zoom, y + 230/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
end

function renderJobGUI()
	dxDrawImage(windowPos.x, windowPos.y, windowPos.w, windowPos.h, textures.background)
	
	local x, y, w, h = windowPos.x+math.floor(25/zoom), windowPos.y+math.floor(25/zoom), math.floor(362/zoom), math.floor(204/zoom)
	dxDrawImage(x, y, w, h, textures.image)
	dxDrawText(description, x, y+h+math.floor(10/zoom), x+w, y, white, 0.85/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, true)
	
	exports["pd-gui"]:renderButton(acceptButton)
	exports["pd-gui"]:renderButton(cancelButton)
	exports["pd-gui"]:renderButton(upgradesButton)
	
	x = math.floor(x+w*1.2)
	dxDrawText("Top 5 graczy", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	exports["pd-gui"]:renderGridlist(topGridlist)
	
	y = y+math.floor(300/zoom)
	dxDrawText("Wymagania", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	dxDrawText(requirements, x, y+math.floor(35/zoom), x+w, y, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	
	y = y+math.floor(125/zoom)
	dxDrawText("Wynagrodzenie", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	dxDrawText(rewards, x, y+math.floor(35/zoom), x+w, y, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
end 

addEvent("onClientGetTopData", true)
addEventHandler("onClientGetTopData", resourceRoot, function(data)
	if isElement(topGridlist) then 
		for i=1, 5 do
			local player, score = (data[i] and data[i].name or "---"), (data[i] and data[i].stats or "---")
			exports["pd-gui"]:addGridlistItem(topGridlist, "Gracz", player)
			exports["pd-gui"]:addGridlistItem(topGridlist, "Wynik", score)
		end
	end
end)


addEvent("onClientGetPoints", true)
addEventHandler("onClientGetPoints", resourceRoot, function(data)
	if data then
		playerPoints = data
	end
end)

function isMouseInPosition ( x, y, width, height )
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	if not cx or not cy then return end
	local cx, cy = ( cx * sx ), ( cy * sy )
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end