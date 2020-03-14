local customMarkers = {}
local sx, sy = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local deupgradeParts = {}
local selectedParts = {}
local categories = {
	actual = 0,
	["Hood"] = "+ Maski",
	["Vent"] = "+ Wloty powietrza",
	["Spoiler"] = "+ Spoilery",
	["Sideskirt"] = "+ Listwy progowe",
	["Front Bullbars"] = "+ Przednie ochraniacze",
	["Rear Bullbars"] = "+ Tylne ochraniacze",
	["Headlights"] = "+ Światła",
	["Roof"] = "+ Dachy",
	["Hydraulics"] = "+ Hydraulika",
	["Wheels"] = "+ Felgi",
	["Exhaust"] = "+ Wydechy",
	["Front Bumper"] = "+ Przednie zderzaki",
	["Rear Bumper"] = "+ Tylne zderzaki",
	["Misc"] = "+ Różne",
}
local tunePlaces = {
	{878.47479248047, -1179.2130126953, 17},
	{871.46728515625, -1179.2368164063, 17},
}
local neonList = {
	{name="← Wróć"},
	{name="#ff0000Czerwone neony", color={255, 0, 0}, cost=4500, selected=false},
	{name="#00ff00Zielone neony", color={0, 255, 0}, cost=4500, selected=false},
	{name="#ffff00Żółte neony", color={255, 255, 0}, cost=4500, selected=false},
	{name="#0000ffNiebieskie neony", color={0, 0, 255}, cost=4500, selected=false},
	{name="#00ffffBłękitne neony", color={0, 255, 255}, cost=4500, selected=false},
	{name="#ff00ffRóżowe neony", color={255, 0, 255}, cost=4500, selected=false},
	{name="#4a4a4aCzarne neony", color={0, 0, 0}, cost=4500, selected=false},
	{name="#ffffffBiałe neony", color={255, 255, 255}, cost=4500, selected=false},
}
local engineUpgrades = {
	{name="Ulepszenie silnika 1", cost=20000, selected=false, code="us1"},
	{name="Ulepszenie silnika 2", cost=20000, selected=false, code="us2"},
	{name="Ulepszenie silnika 3", cost=20000, selected=false, code="us3"},
	{name="Ulepszenie silnika 4", cost=20000, selected=false, code="us4"},
	{name="Ulepszenie silnika 5", cost=20000, selected=false, code="us5"},
	{name="Turbosprężarka", cost=15000, selected=false, code="turbo"},
}
local textures = {
	button = dxCreateTexture("images/button.png"),
	scrollbar = dxCreateTexture("images/scrollbar.png"),
	scrollbar_point = dxCreateTexture("images/scrollbar_point.png"),
}
local upgradeNames = {
	["Hood"] = "Maska",
	["Vent"] = "W. powietrza",
	["Spoiler"] = "Spoiler",
	["Sideskirt"] = "L. progowa",
	["Front Bullbars"] = "P. ochraniacz świateł",
	["Rear Bullbars"] = "T. ochraniacz świateł",
	["Headlights"] = "Światła",
	["Roof"] = "Dach",
	["Nitro"] = "Nitro",
	["Hydraulics"] = "Hydraulika",
	["Stereo"] = "Stereo",
	["Unknown"] = "Nieznane",
	["Wheels"] = "Felgi",
	["Exhaust"] = "Wydech",
	["Front Bumper"] = "P. zderzak",
	["Rear Bumper"] = "T. zderzak",
	["Misc"] = "Różne",
}
local avaibleUpgrades = {}
local upgradePrices = {
	[1000] = 100,
}

setElementData(localPlayer, "player:placeReserved", false)

for k,v in pairs(tunePlaces) do
	_, marker = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 0.75, 55, 500, 55, 255 * 1.5, "repair", 1)
	table.insert(customMarkers, marker)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	cancelButton = exports["pd-gui"]:createButton("Anuluj", sx/2 - 405/zoom, sy/2 + 200/zoom, 160/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(cancelButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", cancelButton, function()
		hideTuneGUI()
	end)

	sendButton = exports["pd-gui"]:createButton("Wyślij", sx/2 - 80/zoom, sy/2 + 200/zoom, 160/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(sendButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(sendButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", sendButton, function()
		triggerServerEvent("sendOfferTune", resourceRoot, localPlayer, currentVehicle, selectedParts)
		hideTuneGUI()
		triggerServerEvent("desaveVehicleTuning", resourceRoot, currentVehicle, localPlayer)
	end)

	acceptOfferButton = exports["pd-gui"]:createButton("Akceptuj", sx/2 - 160/zoom, sy/2 + 240/zoom, 160/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(acceptOfferButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(acceptOfferButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", acceptOfferButton, function()
		local canBuy = true
		if totalCost > 0 then
			if getPlayerMoney(localPlayer) < totalCost then
				canBuy = false
			else
				exports["pd-core"]:takeMoney(totalCost)
			end
		else
			exports["pd-core"]:giveMoney(-totalCost)
		end
		if canBuy then
			removeEventHandler("onClientRender", root, renderOfferGUI)
			showCursor(false)
			triggerServerEvent("acceptOfferTune", resourceRoot, localPlayer, senderOffer, selectedParts)
			exports["pd-achievements"]:addPlayerAchievement(localPlayer, "Szpan musi być", 5)
		else
			exports["pd-hud"]:showPlayerNotification("Nie stać cię na ten tuning!", "error")
			removeEventHandler("onClientRender", root, renderOfferGUI)
			showCursor(false)
		end
	end)
	cancelOfferButton = exports["pd-gui"]:createButton("Anuluj", sx/2, sy/2 + 240/zoom, 160/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(cancelOfferButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelOfferButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", cancelOfferButton, function()
		removeEventHandler("onClientRender", root, renderOfferGUI)
		showCursor(false)
		triggerServerEvent("cancelOfferTune", resourceRoot, localPlayer, senderOffer)
	end)

	local sw, sh = dxGetMaterialSize(textures.scrollbar)
	local gripSize = dxGetMaterialSize(textures.scrollbar_point)
	avaibleScroll = exports["pd-gui"]:createScroll(sx/2 - 195/zoom, sy/2 - 220/zoom, sw/zoom, 385/zoom, {background=textures.scrollbar, grip=textures.scrollbar_point}, (gripSize*1)/zoom)
	deupgradeScroll = exports["pd-gui"]:createScroll(sx/2 + 445/zoom, sy/2 - 220/zoom, sw/zoom, 385/zoom, {background=textures.scrollbar, grip=textures.scrollbar_point}, (gripSize*1)/zoom)
	selectedScroll = exports["pd-gui"]:createScroll(sx/2 + 135/zoom, sy/2 - 220/zoom, sw/zoom, 385/zoom, {background=textures.scrollbar, grip=textures.scrollbar_point}, (gripSize*1)/zoom)
	offerScroll = exports["pd-gui"]:createScroll(sx/2 + 215/zoom, sy/2 - 220/zoom, sw/zoom, 410/zoom, {background=textures.scrollbar, grip=textures.scrollbar_point}, (gripSize*1)/zoom)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(customMarkers) do
		exports["pd-markers"]:destroyCustomMarker(v)
	end
	hideTuneGUI()
	setElementFrozen(localPlayer, false)
end)

addEvent("sendOfferTune", true)
addEventHandler("sendOfferTune", localPlayer, function(sender, selected)
	senderOffer = sender
	senderName = getPlayerName(sender)
	selectedParts = selected
	totalCost = 0
	for k,v in pairs(selected) do
		if v.action == "demontage" then
			totalCost = totalCost - v.cost
		end
		if v.action == "montage" then
			totalCost = totalCost + v.cost
		end
		if v.action == "deus" then
			totalCost = totalCost - v.cost
		end
		if v.action == "deturbo" then
			totalCost = totalCost - v.cost
		end
		if v.action == "demontage_neon" then
			totalCost = totalCost - v.cost
		end
		if v.action == "turbo" then
			totalCost = totalCost + v.cost
		end
		if v.action == "montage_neon" then
			totalCost = totalCost + v.cost
		end
		for i = 1, 5 do
			if v.action == "us" .. i then
				totalCost = totalCost + v.cost
			end
		end
	end
	addEventHandler("onClientRender", root, renderOfferGUI)
	showCursor(true)
end)

function renderOfferGUI()
	dxDrawImage(sx/2 - 250/zoom, sy/2 - 300/zoom, 500/zoom, 600/zoom, "images/background_request.png")
	local progress = math.floor(#selectedParts * exports["pd-gui"]:getScrollProgress(offerScroll)) + 1
	local offset = 0
	local max = math.min(progress + 12, #selectedParts)
	exports["pd-gui"]:renderButton(acceptOfferButton)
	exports["pd-gui"]:renderButton(cancelOfferButton)
	dxDrawText("Oferta gracza " .. senderName, sx/2, sy/2 - 280/zoom, sx/2, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	for i = max - 12, max do
		if selectedParts[i] then
			if selectedParts[i].action == "demontage" then
				color = "#ff5454"
			elseif selectedParts[i].action == "montage" then
				color = "#ccff54"
			else
				color = "#ffffff"
			end
			dxDrawRectangle(sx/2 - 200/zoom, sy/2 - 220/zoom + offset, 400/zoom, 30/zoom, tocolor(0, 0, 0, 155))
			dxDrawText(color .. selectedParts[i].name, sx/2 - 190/zoom, sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, false, false, true)
			local text = "$"..selectedParts[i].cost
			dxDrawText(text, sx/2 + 190/zoom - dxGetTextWidth(text, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small")), sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center")
			offset = offset + 32/zoom
		end
	end
	if totalCost >= 0 then
		dxDrawText("Całkowity koszt: $" .. totalCost, sx/2, sy/2 + 200/zoom, sx/2, sy, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	else
		dxDrawText("Po zaakceptowaniu tej oferty otrzymasz: $" .. -totalCost, sx/2, sy/2 + 200/zoom, sx/2, sy, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	end
	if #selectedParts > 13 then
		exports["pd-gui"]:renderScroll(offerScroll)
	end
end

function renderTuneGUI()
	dxDrawImage(sx/2 - 500/zoom, sy/2 - 300/zoom, 1000/zoom, 600/zoom, "images/background_tune.png")
	dxDrawText("Kompnenty do montażu", sx/2 - 325/zoom, sy/2 - 280/zoom, sx/2 - 325/zoom, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	dxDrawText("Twoja oferta", sx/2, sy/2 - 280/zoom, sx/2, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	dxDrawText("Części dostępne do demontażu", sx/2 + 300/zoom, sy/2 - 280/zoom, sx/2 + 300/zoom, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")

	dxDrawText("Wybierz częsci, które chcesz zamontować", sx/2 - 325/zoom, sy/2 + 250/zoom, sx/2 - 325/zoom, sy, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	dxDrawText("Podsumowanie twojej oferty dla gracza.", sx/2, sy/2 + 250/zoom, sx/2, sy, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
	dxDrawText("Wybierz części, które chcesz zdemontować.", sx/2 + 300/zoom, sy/2 + 250/zoom, sx/2 + 300/zoom, sy, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")

	if #deupgradeParts < 1 then
		dxDrawText("BRAK", sx/2 + 300/zoom, sy/2, sx/2 + 300/zoom, sy, tocolor(255, 74, 209, 255), 1.1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	else
		local progress = math.floor(#deupgradeParts * exports["pd-gui"]:getScrollProgress(deupgradeScroll)) + 1
		local offset = 0
		local max = math.min(progress + 11, #deupgradeParts)
		for i = max - 11, max do
			if deupgradeParts[i] then
				if not deupgradeParts[i].selected then
					r, g, b = 0, 0, 0
				else
					r, g, b = 255, 79, 185
				end
				if isMouseInPosition(sx/2 + 175/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
					alpha = 100
				else
					alpha = 155
				end
				dxDrawRectangle(sx/2 + 175/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom, tocolor(r, g, b, alpha))
				dxDrawText(deupgradeParts[i].name, sx/2 + 185/zoom, sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, false, false, true)
				local text = "$"..deupgradeParts[i].cost
				dxDrawText(text, sx/2 + 415/zoom - dxGetTextWidth(text, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small")), sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center")
				offset = offset + 32/zoom
			end
		end
		if #deupgradeParts > 12 then
			exports["pd-gui"]:renderScroll(deupgradeScroll)
		end
	end

	if #selectedParts < 1 then
		dxDrawText("BRAK", sx/2, sy/2, sx/2, sy, tocolor(255, 74, 209, 255), 1.1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	else
		exports["pd-gui"]:renderButton(sendButton)
		local progress = math.floor(#selectedParts * exports["pd-gui"]:getScrollProgress(selectedScroll)) + 1
		local offset = 0
		local max = math.min(progress + 11, #selectedParts)
		for i = max - 11, max do
			if selectedParts[i] then
				if selectedParts[i].action == "demontage" then
					color = "#ff5454"
				elseif selectedParts[i].action == "montage" then
					color = "#ccff54"
				else
					color = "#ffffff"
				end
				dxDrawRectangle(sx/2 - 125/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom, tocolor(0, 0, 0, 155))
				dxDrawText(color .. selectedParts[i].name, sx/2 - 115/zoom, sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, false, false, true)
				local text = "$"..selectedParts[i].cost
				dxDrawText(text, sx/2 + 115/zoom - dxGetTextWidth(text, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small")), sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center")
				offset = offset + 32/zoom
			end
		end
		if #selectedParts > 12 then
			exports["pd-gui"]:renderScroll(selectedScroll)
		end
	end

	if categories.actual == 0 then
		avaibleParts = {
			{name="+ Wizualne"},
			{name="+ Mechaniczne"},
			{name="+ Neony"},
		}
	elseif categories.actual == 1 then
		avaibleParts = {{name="← Wróć"}}
		used = {}
		for k,v in pairs(avaibleUpgrades) do
			if categories[getVehicleUpgradeSlotName(v.id)] and not used[getVehicleUpgradeSlotName(v.id)] then
				table.insert(avaibleParts, {name=categories[getVehicleUpgradeSlotName(v.id)]})
				used[getVehicleUpgradeSlotName(v.id)] = true
			end
		end
	elseif categories.actual == 2 then
		local upgrades = getElementData(currentVehicle, "vehicle:addTuning")
		if not upgrades then upgrades = "" end
		avaibleParts = {{name="← Wróć"}}
		for k,v in pairs(engineUpgrades) do
			if not string.find(upgrades, v.code) then
				table.insert(avaibleParts, v)
			end
		end
	elseif categories.actual == 3 then
		avaibleParts = neonList
	else
		if tostring(categories.actual) and upgradeNames[categories.actual] then
			avaibleParts = {{name="← Wróć"}}
			for k,v in pairs(avaibleUpgrades) do
				if getVehicleUpgradeSlotName(v.id) == categories.actual then
					table.insert(avaibleParts, v)
				end
			end
		end
	end

	if #avaibleParts < 1 then
		dxDrawText("BRAK", sx/2 + 300/zoom, sy/2, sx/2 + 300/zoom, sy, tocolor(255, 74, 209, 255), 1.1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	else
		local progress = math.floor(#avaibleParts * exports["pd-gui"]:getScrollProgress(avaibleScroll)) + 1
		local offset = 0
		local max = math.min(progress + 11, #avaibleParts)
		for i = max - 11, max do
			if avaibleParts[i] then
				if not avaibleParts[i].selected then
					r, g, b = 0, 0, 0
				else
					r, g, b = 255, 79, 185
				end
				if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
					alpha = 100
				else
					alpha = 155
				end
				dxDrawRectangle(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom, tocolor(r, g, b, alpha))
				dxDrawText(avaibleParts[i].name, sx/2 - 440/zoom, sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, false, false, true)
				if avaibleParts[i].cost then
					local text = "$"..avaibleParts[i].cost
					dxDrawText(text, sx/2 - 210/zoom - dxGetTextWidth(text, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small")), sy/2 - 205/zoom + offset, sx, sy/2 - 205/zoom + offset, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center")
				end
				offset = offset + 32/zoom
			end
		end
		if #avaibleParts > 12 then
			exports["pd-gui"]:renderScroll(avaibleScroll)
		end
	end

	exports["pd-gui"]:renderButton(cancelButton)
end

function clickTuneGUI(button, state)
	if #deupgradeParts > 0 and button == "left" and state == "down" then
		local progress = math.floor(#deupgradeParts * exports["pd-gui"]:getScrollProgress(deupgradeScroll)) + 1
		local offset = 0
		local max = math.min(progress + 11, #deupgradeParts)
		for i = max - 11, max do
			if deupgradeParts[i] then
				if isMouseInPosition(sx/2 + 175/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
					deupgradeParts[i].selected = not deupgradeParts[i].selected
					if deupgradeParts[i].selected then
						if deupgradeParts[i].action == "neon" then
							triggerServerEvent("deleteNeon", resourceRoot, currentVehicle)
						elseif deupgradeParts[i].action == "deus" then 
						elseif deupgradeParts[i].action == "demontage_neon" then 
						elseif deupgradeParts[i].action == "deturbo" then
						else
							triggerServerEvent("demontagePart", resourceRoot, currentVehicle, deupgradeParts[i].id)
						end
						table.insert(selectedParts, {name=deupgradeParts[i].name, cost=deupgradeParts[i].cost, action=deupgradeParts[i].action or "demontage", id=deupgradeParts[i].id, code=deupgradeParts[i].code})
					else
						if deupgradeParts[i].action == "neon" then
							triggerServerEvent("setNeon", resourceRoot, currentVehicle)
						elseif deupgradeParts[i].action == "deus" then
						elseif deupgradeParts[i].action == "demontage_neon" then 
						elseif deupgradeParts[i].action == "deturbo" then
						else
							triggerServerEvent("montagePart", resourceRoot, currentVehicle, deupgradeParts[i].id)
						end
						for k,v in pairs(selectedParts) do
							if v.action == "demontage" and v.id == deupgradeParts[i].id then
								table.remove(selectedParts, k)
							end
						end
					end
					break
				end
				offset = offset + 32/zoom
			end
		end
	end
	if button == "left" and state == "down" then
		if categories.actual == 0 then
			if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom, 250/zoom, 30/zoom) then
				categories.actual = 1
			elseif isMouseInPosition(sx/2 - 450/zoom, sy/2 - 188/zoom, 250/zoom, 30/zoom) then
				categories.actual = 2
			elseif isMouseInPosition(sx/2 - 450/zoom, sy/2 - 156/zoom, 250/zoom, 30/zoom) then
				categories.actual = 3
			end
		elseif categories.actual == 1 then
			if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom, 250/zoom, 30/zoom) then
				categories.actual = 0
				return
			end
			avaibleClicks = {}
			used = {}
			for k,v in pairs(avaibleUpgrades) do
				if categories[getVehicleUpgradeSlotName(v.id)] and not used[getVehicleUpgradeSlotName(v.id)] then
					table.insert(avaibleClicks, {name=getVehicleUpgradeSlotName(v.id)})
					used[getVehicleUpgradeSlotName(v.id)] = true
				end
			end
			if #avaibleClicks > 0 then
				local progress = math.floor((#avaibleClicks + 1) * exports["pd-gui"]:getScrollProgress(avaibleScroll)) + 1
				local offset = 32/zoom
				local max = math.min(progress + 11, (#avaibleClicks + 1))
				for i = max - 11, max do
					if avaibleClicks[i] then
						if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
							categories.actual = avaibleClicks[i].name
						end
						offset = offset + 32/zoom
					end
				end
			end
		elseif categories.actual == 2 then
			if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom, 250/zoom, 30/zoom) then
				categories.actual = 0
				return
			end
			local upgrades = getElementData(currentVehicle, "vehicle:addTuning")
			if not upgrades then upgrades = "" end
			avaibleParts = {{name="← Wróć"}}
			for k,v in pairs(engineUpgrades) do
				if not string.find(upgrades, v.code) then
					table.insert(avaibleParts, v)
				end
			end
			if #avaibleParts > 0 then
				local progress = math.floor((#avaibleParts + 1) * exports["pd-gui"]:getScrollProgress(avaibleScroll)) + 1
				local offset = 0
				local max = math.min(progress + 11, (#avaibleParts + 1))
				for i = max - 11, max do
					if avaibleParts[i] then
						if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
							avaibleParts[i].selected = not avaibleParts[i].selected
							if avaibleParts[i].selected then
								table.insert(selectedParts, {name=avaibleParts[i].name, cost=avaibleParts[i].cost, action=avaibleParts[i].code, color=avaibleParts[i].color})
							else
								for k,v in pairs(selectedParts) do
									if v.action == avaibleParts[i].code then
										table.remove(selectedParts, k)
									end
								end
							end
						end
						offset = offset + 32/zoom
					end
				end
			end
		elseif categories.actual == 3 then
			if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom, 250/zoom, 30/zoom) then
				categories.actual = 0
				return
			end
			if #neonList > 0 then
				local progress = math.floor((#neonList + 1) * exports["pd-gui"]:getScrollProgress(avaibleScroll)) + 1
				local offset = 0
				local max = math.min(progress + 11, (#neonList + 1))
				for i = max - 11, max do
					if neonList[i] then
						if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
							for k,v in pairs(selectedParts) do
								if v.action == "montage_neon" then
									table.remove(selectedParts, k)
								end
							end
							for k,v in pairs(neonList) do
								if v ~= neonList[i] then
									v.selected = false
								end
							end
							neonList[i].selected = not neonList[i].selected
							if neonList[i].selected then
								table.insert(selectedParts, {name=neonList[i].name, cost=neonList[i].cost, action="montage_neon", color=neonList[i].color})
								triggerServerEvent("setNeon", resourceRoot, currentVehicle, neonList[i].color, false)
							else
								triggerServerEvent("setNeon", resourceRoot, currentVehicle, false)
								for k,v in pairs(selectedParts) do
									if v.action == "montage_neon" then
										table.remove(selectedParts, k)
									end
								end
							end
						end
						offset = offset + 32/zoom
					end
				end
			end
		else
			if tostring(categories.actual) and upgradeNames[categories.actual] then
				if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom, 250/zoom, 30/zoom) then
					categories.actual = 1
					return
				end
				avaibleClicks = {}
				for k,v in pairs(avaibleUpgrades) do
					if getVehicleUpgradeSlotName(v.id) == categories.actual then
						v.normal = k
						table.insert(avaibleClicks, v)
					end
				end
				if #avaibleClicks > 0 then
					local progress = math.floor((#avaibleClicks + 1) * exports["pd-gui"]:getScrollProgress(avaibleScroll)) + 1
					local offset = 32/zoom
					local max = math.min(progress + 11, (#avaibleClicks + 1))
					for i = max - 11, max do
						if avaibleClicks[i] then
							if isMouseInPosition(sx/2 - 450/zoom, sy/2 - 220/zoom + offset, 250/zoom, 30/zoom) then
								id = avaibleClicks[i].normal
								avaibleUpgrades[id].selected = not avaibleUpgrades[id].selected
								if avaibleUpgrades[id].selected then
									for k,v in pairs(selectedParts) do
										if avaibleUpgrades[id].id and getVehicleUpgradeSlotName(v.id) == getVehicleUpgradeSlotName(avaibleUpgrades[id].id) then
											triggerServerEvent("demontagePart", resourceRoot, currentVehicle, v.id)
											table.remove(selectedParts, k)
										end
									end
									for k,v in pairs(avaibleUpgrades) do
										if getVehicleUpgradeSlotName(v.id) == getVehicleUpgradeSlotName(avaibleUpgrades[id].id) then
											v.selected = false
										end
									end
									avaibleUpgrades[id].selected = true
									triggerServerEvent("montagePart", resourceRoot, currentVehicle, avaibleUpgrades[id].id)
									table.insert(selectedParts, {name=avaibleUpgrades[id].name, cost=avaibleUpgrades[id].cost, action="montage", id=avaibleUpgrades[id].id})
								else
									triggerServerEvent("demontagePart", resourceRoot, currentVehicle, avaibleUpgrades[id].id)
									for k,v in pairs(selectedParts) do
										if v.action == "montage" and v.id == avaibleUpgrades[id].id then
											table.remove(selectedParts, k)
										end
									end
								end
							end
							offset = offset + 32/zoom
						end
					end
				end
			end
		end
	end
end

function showTuneGUI(vehicle)
	originalTuning = getVehicleUpgrades(vehicle)
	for k,v in pairs(neonList) do
		v.selected = false
	end
	triggerServerEvent("saveVehicleTuning", resourceRoot, vehicle, localPlayer)
	deupgradeParts = {}
	categories.actual = 0
	avaibleUpgrades = {}
	selectedParts = {}
	local getAvaibleTuning = createVehicle(getElementModel(vehicle), 0, 0, 0)
	for i = 1000, 1193 do
		if addVehicleUpgrade(getAvaibleTuning, i) then
			avaibleUpgrades[#avaibleUpgrades + 1] = {name=upgradeNames[getVehicleUpgradeSlotName(i)] .. " #" .. i, cost=(upgradePrices[i] or 10), selected=false, id = i}
		end
	end
	destroyElement(getAvaibleTuning)
	for k,v in ipairs(originalTuning) do
		deupgradeParts[#deupgradeParts + 1] = {name=upgradeNames[getVehicleUpgradeSlotName(v)] .. " #" .. v, cost=(upgradePrices[v] or 10)/2, selected=false, id = v}
	end
	local neon = getElementData(vehicle, "vehicle:neon")
	if neon then
		local found = false
		for k,v in pairs(neonList) do
			if v.color and neon.color and v.color[1] == neon.color[1] and v.color[2] == neon.color[2] and v.color[3] == neon.color[3] then
				found = true
				neonName = v.name
				break
			end
		end
		if not found then
			neonName = "Niestandardowy neon"
		end
		deupgradeParts[#deupgradeParts + 1] = {name=neonName, cost=2250, selected=false, action="demontage_neon"}
	end
	local upgrades = getElementData(vehicle, "vehicle:addTuning")
	if upgrades and tostring(upgrades) then
		for i = 1, 5 do
			if string.find(upgrades, "us" .. i) then
				deupgradeParts[#deupgradeParts + 1] = {name="Ulepszenie silnika " .. i, cost=10000, selected=false, action="deus", code=i}
			end
		end
		if string.find(upgrades, "turbo") then
			deupgradeParts[#deupgradeParts + 1] = {name="Turbosprężarka", cost=7500, selected=false, action="deturbo", code=i}
		end
	end
	setElementFrozen(localPlayer, true)
	currentVehicle = vehicle
	addEventHandler("onClientRender", root, renderTuneGUI)
	addEventHandler("onClientClick", root, clickTuneGUI)
	showCursor(true)
end

function hideTuneGUI()
	setElementFrozen(localPlayer, false)
	if currentVehicle and isElement(currentVehicle) then
		triggerServerEvent("setVehicleTuning", resourceRoot, currentVehicle)
	end
	currentVehicle = false
	removeEventHandler("onClientRender", root, renderTuneGUI)
	removeEventHandler("onClientClick", root, clickTuneGUI)
	showCursor(false)
end

addEventHandler("onClientColShapeHit", root, function(el, md)
	local tuneOwner = getElementData(source, "tune:owner")
	if el == localPlayer and md and not isPedInVehicle(el) and tuneOwner then
		if tuneOwner == "Brak" then
			triggerServerEvent ("reserveTunePlace", resourceRoot, localPlayer, source)
		elseif tuneOwner == getPlayerName(localPlayer) then
			local data = getElementData(source, "tuneSphere")
			local vehicle = false
			for k,v in pairs(getElementsWithinColShape(data[1], "vehicle")) do
				if isElement(v) then
					vx, vy, vz = getElementVelocity(v)
					if math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161) < 2 then
						vehicle = v
						break
					end
				end
			end
			if isElement(vehicle) then
				showTuneGUI(vehicle)
			end
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