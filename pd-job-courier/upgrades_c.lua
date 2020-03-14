--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Virelox <virelox@gmail.com>
	# @filename: c.lua
	# @description: Praca kuriera - ulepszenia, interfejs
	# All rights reserved.
	##########################################################
--]]

local upgrades = {
	{name="Obrotny", description="Możliwość załadowania większej ilości paczek.", id="speedy", icon="speedy", price=200},
	{name="Kondycja", description="Możliwość szybszego poruszania się podczas noszenia paczek.", id="condition", icon="condition", price=200},
	{name="Napiwek", description="Klienci będą wręczać ci napiwki", id="tip", icon="tip", price=300},
}

local textures = {}
local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()

local windowPos = {x=math.floor(screenW/2-((1097/zoom*0.8))/2), y=math.floor(screenH/2-((688/zoom)*0.8)/2), w=math.floor((1097/zoom)*0.8), h=math.floor((688/zoom)*0.8)}
local rowPos = {w=math.floor((977/zoom)*0.8), h=math.floor((118/zoom)*0.8)}
local buttonSize = {w=math.floor((186/zoom)*0.8), h=math.floor((66/zoom)*0.8)}
local buttonSmallSize = {w=math.floor((139/zoom)*0.8), h=math.floor((53/zoom)*0.8)}
local iconSize = math.floor((120/zoom)*0.8)

local maxVisibleRows = 4
local cancelButton, scroll
local points = 0 

function buyUpgrade(id, price)
	triggerServerEvent("onPlayerBuyUpgrade", resourceRoot, id, price)
	hideUpgradesGUI()
end 

function showUpgradesGUI()
	local playerUpgrades = getElementData(localPlayer, "player:job_upgrades") or {}
	if playerUpgrades["courier"] then 
		for k, v in ipairs(playerUpgrades["courier"].upgrades) do 
			for i, upgrade in ipairs(upgrades) do 
				if upgrade.id == v then 
					upgrade.bought = true
				end
			end
		end
		
		points = playerUpgrades["courier"].points
	else 
		points = 0
	end 
	
	textures.background = dxCreateTexture("images/upgrades_background.png")
	textures.data = dxCreateTexture("images/upgrades_background_data.png")
	
	textures.tip_icon = dxCreateTexture("images/upgrades_tip_icon.png")
	textures.condition_icon = dxCreateTexture("images/upgrades_condition_icon.png")
	textures.speedy_icon = dxCreateTexture("images/upgrades_speedy_icon.png")
	
	textures.button = dxCreateTexture("images/upgrades_button.png")
	textures.button_small = dxCreateTexture("images/upgrades_button_small.png")
	textures.scrollbar_point = dxCreateTexture(":pd-radio/images/scrollbar_point.png")
	textures.scrollbar = dxCreateTexture(":pd-radio/images/scrollbar.png")
	
	cancelButton = exports["pd-gui"]:createButton("Anuluj", math.floor(windowPos.x+windowPos.w/2-buttonSize.w/2), math.floor(windowPos.y+windowPos.h-buttonSize.h*1.5), buttonSize.w, buttonSize.h)
	exports["pd-gui"]:setButtonTextures(cancelButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelButton, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	
	if #upgrades > maxVisibleRows then
		scroll = exports["pd-gui"]:createScroll(windowPos.x+windowPos.w-math.floor(40/zoom), windowPos.y+math.floor(60/zoom), math.floor(28/zoom), windowPos.h*0.73, {grip=textures.scrollbar_point, background=textures.scrollbar}, math.floor(25/zoom))
	end 
	
	addEventHandler("onClientClickButton", cancelButton, function()
		hideUpgradesGUI()
	end)
	
	showCursor(true)
	addEventHandler("onClientRender", root, renderUpgradesGUI)
	addEventHandler("onClientKey", root, scrollUpgradesWindow)
end 

function hideUpgradesGUI()
	exports["pd-gui"]:destroyButton(cancelButton)
	exports["pd-gui"]:destroyScroll(scroll)
	removeEventHandler("onClientRender", root, renderUpgradesGUI)
	removeEventHandler("onClientKey", root, scrollUpgradesWindow)
	showCursor(false)
	
	for k, v in ipairs(upgrades) do 
		if v.button then 
			exports["pd-gui"]:destroyButton(v.button)
			v.button = nil
		end
	end 
	
	for k, v in pairs(textures) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end
	textures = {}
end 

local prevSelectedRow = 0
function renderUpgradesGUI()
	dxDrawImage(windowPos.x, windowPos.y, windowPos.w, windowPos.h, textures.background)
	dxDrawText("Dostępne ulepszenia", windowPos.x, windowPos.y+math.floor(10/zoom), windowPos.x+windowPos.w, windowPos.h, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	dxDrawText("Posiadane punkty: "..tostring(points), windowPos.x, windowPos.y+math.floor(15/zoom), windowPos.x+windowPos.w-math.floor(50/zoom), windowPos.h, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "top")
	
	local scrollProgress = 0
		
	if scroll then 
		scrollProgress = exports["pd-gui"]:getScrollProgress(scroll)
		selectedRow = math.ceil(scrollProgress * (#upgrades-maxVisibleRows+1))
		visibleRows = math.max(maxVisibleRows, selectedRow+maxVisibleRows-1)
	else 
		selectedRow = 1 
		visibleRows = maxVisibleRows
	end 
	local scrolled = selectedRow ~= prevSelectedRow
	prevSelectedRow = selectedRow
	
	local n = 0
	local offsetY = math.floor(60/zoom)
	for k, v in ipairs(upgrades) do 
		if scrolled and v.button then 
			exports["pd-gui"]:destroyButton(v.button)
			v.button = nil
		end 
		
		if k >= selectedRow and k <= visibleRows then 
			n = n+1 
			
			local x, y, w, h = windowPos.x+windowPos.w/2-rowPos.w/2, windowPos.y+offsetY, rowPos.w, rowPos.h
			dxDrawImage(x, y, w, h, textures.data, 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawImage(x, y+rowPos.h/2-iconSize/2, iconSize, iconSize, textures[v.icon.."_icon"])
			dxDrawText(v.name, x+iconSize*1.15, y+math.floor(10/zoom), w, h, tocolor(255, 51, 204, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top")
			dxDrawText(v.description, x+iconSize*1.15, y+math.floor(40/zoom), x+w*0.75, h, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, true)
				
			if v.bought then
				local x, y, w, h = x+w-buttonSmallSize.w*1.25, y+h-buttonSmallSize.h*1.25, buttonSmallSize.w, buttonSmallSize.h
				dxDrawText("Zakupiono", x, y, x+w, y+h, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "center")
			else
				local x, y, w, h = x+w-buttonSmallSize.w*1.25, y+h-buttonSmallSize.h*1.25, buttonSmallSize.w, buttonSmallSize.h
				dxDrawText(tostring(v.price).." punktów", x, y-h/2-math.floor(10/zoom), x+w, h, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
				
				if not v.button then
					v.button = exports["pd-gui"]:createButton("Kup", x, y, w, h)
					exports["pd-gui"]:setButtonTextures(v.button, {default=textures.button_small, hover=textures.button_small, press=textures.button_small})
					exports["pd-gui"]:setButtonFont(v.button, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
					
					addEventHandler("onClientClickButton", v.button, function()
						buyUpgrade(v.id, v.price)
					end)
				end
				
				exports["pd-gui"]:renderButton(v.button)
			end 
			
			offsetY = offsetY+rowPos.h+math.floor(10/zoom)
		end
	end
	exports["pd-gui"]:renderScroll(scroll)
	exports["pd-gui"]:renderButton(cancelButton)
end 

function scrollUpgradesWindow(key)
	if scroll then
		if key == "mouse_wheel_up" then 
			exports["pd-gui"]:moveScroll(scroll, "up", math.floor(502/zoom)/(#upgrades-maxVisibleRows))
		elseif key == "mouse_wheel_down" then 
			exports["pd-gui"]:moveScroll(scroll, "down", math.floor(502/zoom)/(#upgrades-maxVisibleRows))
		end
	end
end 
