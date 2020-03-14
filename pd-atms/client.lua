local sx, sy = guiGetScreenSize()
local GUI = exports["pd-gui"]
local normal_small = GUI:getGUIFont("normal_small")
local normal_big = GUI:getGUIFont("normal_big")
local zoom = GUI:getInterfaceZoom()
local ATM_markers = {}
local ATM_showing = true
local line_texture = dxCreateTexture("images/edit_line.png")
local money_box = GUI:createEditbox("", sx/2 - 90/zoom, sy/2 - 20/zoom, 150, 40, normal_small, 1/zoom, 16)
GUI:setEditboxMaxLength(money_box, 8)
GUI:setEditboxHelperText(money_box, "Wpisz kwotę")
GUI:setEditboxLine(money_box, line_texture)
GUI:setEditboxNumberMode(money_box, true)
local gui_buttons = {
	["storecash"] = sx/2-210/zoom,
	["getcash"] = sx/2,
	["logout"] = sx/2+210/zoom,
}
local ATM_positions = {
	{1741.3659, -2053.8271, 13.571, 0},
	{1345.4562988281, -1540.759765625, 13.539655685425, 80},
	{1497.4438476563, -1749.8938232422, 15.4453125, 180},
}

if not getElementData(localPlayer, "player:bank") then
	setElementData(localPlayer, "player:bank", 0)
end

addEventHandler("onClientClick", root, function(button, state)
	if button ~= "left" or state ~= "down" then return end
	if ATM_menu == "menu" then
		for k,v in pairs(gui_buttons) do
			if isMouseInPosition(v - 100/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) then
				if k == "logout" then
					showCursor(false)
					removeEventHandler("onClientRender", root, renderATM)
					ATM_menu = false
					setElementData(localPlayer, "player:showingGUI", false)
				else
					ATM_menu = k
				end
			end
		end
	elseif ATM_menu == "getcash" or ATM_menu == "storecash" then
		if isMouseInPosition(sx/2 - 75/zoom, sy/2 + 75/zoom, 150/zoom, 50/zoom) then
			local money = getPlayerMoney(localPlayer)
			local bank_money = getElementData(localPlayer, "player:bank")
			local payMoney = GUI:getEditboxText(money_box)
			if string.len(payMoney) < 1 then return end
			if tonumber(payMoney) < 0 then return end
			if ATM_menu == "storecash" then
				if tonumber(payMoney) <= money then
					exports["pd-core"]:takeMoney(tonumber(payMoney))
					setElementData(localPlayer, "player:bank", bank_money + tonumber(payMoney))
					ATM_menu = "menu"
				else
					exports["pd-hud"]:addNotification("Nie posiadasz tyle pieniędzy.", "error", nil, 5000, "error")
				end
			elseif ATM_menu == "getcash" then
				if tonumber(bank_money) >= tonumber(payMoney) then
					exports["pd-core"]:giveMoney(tonumber(payMoney))
					setElementData(localPlayer, "player:bank", bank_money - tonumber(payMoney))
					ATM_menu = "menu"
				else
					exports["pd-hud"]:addNotification("Nie posiadasz tyle pieniędzy.", "error", nil, 5000, "error")
				end
			end
		end
	end
end)

function renderATM()
	if not getElementData(localPlayer, "player:spawned") then return end
	local money = "$" .. getElementData(localPlayer, "player:bank")
	dxDrawImage(sx/2 - 400/zoom, sy/2 - 250/zoom, 800/zoom, 500/zoom, "images/background.png")
	dxDrawText(money, sx/2 + 390/zoom - dxGetTextWidth(money, 1/zoom, normal_big), sy/2 - 240/zoom, sx, sy, tocolor(255, 0, 255, 255), 1/zoom, normal_big)
	if ATM_menu == "menu" then
		for k,v in pairs(gui_buttons) do
			dxDrawImage(v - 100/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom, isMouseInPosition(v - 100/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) and "images/" .. k .. "_hover.png" or "images/" .. k .. ".png")
		end
	else
		GUI:renderEditbox(money_box)
		dxDrawImage(sx/2 - 75/zoom, sy/2 + 75/zoom, 150/zoom, 50/zoom, "images/button.png")
		if ATM_menu == "storecash" then
			dxDrawText("Wpłata pieniędzy", sx/2, sy/2 - 150/zoom, sx/2, sy/2 - 150/zoom, white, 1/zoom, normal_big, "center", "center")
			dxDrawText("Wpłać", sx/2, sy/2 + 100/zoom, sx/2, sy/2 + 100/zoom, white, 1/zoom, normal_small, "center", "center")
		else
			dxDrawText("Wypłata pieniędzy", sx/2, sy/2 - 150/zoom, sx/2, sy/2 - 150/zoom, white, 1/zoom, normal_big, "center", "center")
			dxDrawText("Wypłać", sx/2, sy/2 + 100/zoom, sx/2, sy/2 + 100/zoom, white, 1/zoom, normal_small, "center", "center")
		end
	end
end

function showATM(plr)
	if getElementData(localPlayer, "player:showingGUI") then return end
	if plr ~= localPlayer then return end
	setElementData(localPlayer, "player:showingGUI", "atm")
	showCursor(true, false)
	addEventHandler("onClientRender", root, renderATM)
	ATM_menu = "menu"
end

function hideATM(plr)
	if plr ~= localPlayer then return end
	if getElementData(localPlayer, "player:showingGUI") ~= "atm" then return end
	setElementData(localPlayer, "player:showingGUI", false)
	ATM_menu = false
	showCursor(false)
	removeEventHandler("onClientRender", root, renderATM)
end

for k,v in ipairs(ATM_positions) do
	atm = createObject(2942, v[1], v[2], v[3]-0.35, 0, 0, v[4])
	setObjectBreakable(atm, false)
	ATM_markers[#ATM_markers+1] = createMarker(v[1], v[2], v[3], "cylinder", 2, 0, 0, 0, 0)
	addEventHandler("onClientMarkerHit", ATM_markers[#ATM_markers], showATM)
	addEventHandler("onClientMarkerLeave", ATM_markers[#ATM_markers], hideATM)
end

function isMouseInPosition(x, y, w, h)
	if not isCursorShowing() then return false end
	cx, cy = getCursorPosition()
	cx, cy = cx * sx, cy * sy
	if (cx >= x and cx <= x + w) and (cy >= y and cy <= y + h) then
		return true
	else
		return false
	end
end

addEventHandler("onClientResourceStop", root, function(res)
	if res ~= getThisResource() then return end
	GUI:destroyEditbox(money_box)
end)