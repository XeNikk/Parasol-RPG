--[[
	##########################################################
	# @project: Paradise RPG
	# @author: Virelox <virelox@gmail.com>
	# @filename: gui_c.lua
	# @description: Kurier - GUI od rozpoczęcia pracy
	# All rights reserved.
	##########################################################
--]]

local description = [[Praca polega na dowiezieniu przesyłki
]]
local requirements = "prawo jazdy kategoria C"
local rewards = ""

local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local windowPos = {x=math.floor(screenW/2-882/zoom/2), y=math.floor(screenH/2-573/zoom/2), w=math.floor(882/zoom), h=math.floor(573/zoom)}
local buttonSize = {w=math.floor(165/zoom), h=math.floor(41/zoom)}
local textures = {}

local acceptButton, cancelButton 
local topGridlist 

local showing = false
function showJobGUI()
	if showing then return end 
	toggleAllControls(false)
	showing = true
	triggerServerEvent("onPlayerGetTopData", resourceRoot)
	
	textures.background = dxCreateTexture("images/gui_background.png")
	textures.button = dxCreateTexture("images/gui_button.png")
	textures.image = dxCreateTexture("images/gui_job_image.png")
	textures.scroll, textures.scroll_point = dxCreateTexture("images/gui_scrollbar.png"), dxCreateTexture("images/gui_scrollbar_point.png")
	
	rewards = "$"..tostring(exports["pd-jobsettings"]:getJobData("courier", "reward")).." za każdą przesyłkę"
	
	addEventHandler("onClientRender", root, renderJobGUI)
	showCursor(true)
	
	acceptButton = exports["pd-gui"]:createButton("Pracuj", windowPos.x+math.floor(25/zoom), math.floor(windowPos.y+windowPos.h-buttonSize.h*3), buttonSize.w, buttonSize.h)
	exports["pd-gui"]:setButtonTextures(acceptButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(acceptButton, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	addEventHandler("onClientClickButton", acceptButton, function()
		licenseTable = getElementData(localPlayer, "player:pj")
		if tonumber(licenseTable["C"]) ~= 1 then
			exports["pd-hud"]:showPlayerNotification("Nie masz prawa jazdy kat. C!", "error")
			return
		end 
		triggerServerEvent("startJobCourierServer", resourceRoot)
		hideJobGUI()
	end)
	
	upgradesButton = exports["pd-gui"]:createButton("Ulepszenia", math.floor(windowPos.x+buttonSize.w+50/zoom), math.floor(windowPos.y+windowPos.h-buttonSize.h*3), buttonSize.w, buttonSize.h)
	exports["pd-gui"]:setButtonTextures(upgradesButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(upgradesButton, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
	
	addEventHandler("onClientClickButton", upgradesButton, function()
		hideJobGUI()
		showUpgradesGUI()
	end)
	
	cancelButton = exports["pd-gui"]:createButton("Anuluj", math.floor(windowPos.x+math.floor(75/zoom/2)+buttonSize.w/2), math.floor(windowPos.y+windowPos.h-buttonSize.h*1.5), buttonSize.w, buttonSize.h)
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
	if not showing then return end 
	showing = false
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

function renderJobGUI()
	dxDrawImage(windowPos.x, windowPos.y, windowPos.w, windowPos.h, textures.background)
	
	local x, y, w, h = windowPos.x+math.floor(25/zoom), windowPos.y+math.floor(25/zoom), math.floor(362/zoom), math.floor(204/zoom)
	dxDrawImage(x, y, w, h, textures.image)
	dxDrawText(description, x, y+h+math.floor(10/zoom), x+w, y, tocolor(255, 255, 255, 255), 0.95/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, true)
	
	exports["pd-gui"]:renderButton(acceptButton)
	exports["pd-gui"]:renderButton(cancelButton)
	exports["pd-gui"]:renderButton(upgradesButton)
	
	x = math.floor(x+w*1.2)
	dxDrawText("Top 5 graczy", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	exports["pd-gui"]:renderGridlist(topGridlist)
	
	y = y+math.floor(300/zoom)
	dxDrawText("Wymagania", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	dxDrawText(requirements, x, y+math.floor(35/zoom), x+w, y, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	
	y = y+math.floor(125/zoom)
	dxDrawText("Wynagrodzenie", x, y, x+w, y, tocolor(255, 51, 204, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
	dxDrawText(rewards, x, y+math.floor(35/zoom), x+w, y, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, true)
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