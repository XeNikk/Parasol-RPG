local screenW, screenH = guiGetScreenSize()
-- pozycje 
local zoom = exports["pd-gui"]:getInterfaceZoom()
local mapPos = {x=math.floor(100/zoom), y=0, w=math.floor(1300/zoom), h=math.floor(1000/zoom)}
mapPos.y = math.floor(screenH/2 - mapPos.h/2)

local legendPos = {x=mapPos.x+mapPos.w+math.floor(50/zoom), y=mapPos.y, w=math.floor(505/zoom), h=math.floor(1000/zoom)}

-- zmienne 
local showing = false 
local textures = {}
local playerX, playerY = 0, 0

local mapUnit = 1600/6000 -- rozmiar mapki / 6000
local mapZoom = 2
local mapIsMoving, mapOffsetX, mapOffsetY = false, 0, 0
local wasMapMoved = true 

-- nazwy tekstur z radar_c.lua
local blips = {
	-- [id blipu z gta] = dane
	[15] = {name="Przechowalnia pojazdów", texture="radar_CJ"},
	[30] = {name="Komisariat", texture="radar_police"},
	[8] = {name="Gracz", texture="radar_BIGSMOKE"},
	[18] = {name="Ammunation", texture="radar_emmetGun"},
	[36] = {name="Szkoła jazdy", texture="radar_school"},
	[38] = {name="Stacja benzynowa", texture="radar_SWEET"},
	[20] = {name="Straż pożarna", texture="radar_fire"},
	[42] = {name="Giełda pojazdów", texture="radar_TorenoRanch"},
	[22] = {name="Szpital", texture="radar_hostpital"},
	[44] = {name="Złomowisko", texture="radar_triadsCasino"},
	[45] = {name="Przebieralnia", texture="radar_tshirt"},
	[46] = {name="Warsztat", texture="radar_WOOZIE"},
	[47] = {name="Używane pojazdy (cygan)", texture="radar_ZERO"},
	[55] = {name="Salon pojazdów", texture="radar_impound"},
	[11] = {name="Praca dorywcza", texture="radar_bulldozer"},
	[58] = {name="Urząd", texture="radar_gangB"},
	[41] = {name="Cel", texture="radar_waypoint"},
}
local blipSize = Vector2(24, 24)

local memoryButton = nil 
local memoryCheckbox = false 

function renderBigMap()	
	if not wasMapMoved then 
		playerX, playerY = getElementPosition(localPlayer)
	end 
	
	local absoluteX, absoluteY = 0, 0
	local cursorX, cursorY = getCursorPosition()
			
	if (getKeyState('mouse1')) and mapIsMoving then
		absoluteX = (cursorX * screenW)
		absoluteY = (cursorY * screenH)
		
		playerX = -(absoluteX * mapZoom / mapUnit - mapOffsetX)
		playerY = (absoluteY * mapZoom / mapUnit - mapOffsetY)
						
		playerX = math.max(-3000, math.min(3000, playerX))
		playerY = math.max(-3000, math.min(3000, playerY))
	end

	local mapX = (((3000 + playerX) * mapUnit) - (mapPos.w / 2) * mapZoom)
	local mapY = (((3000 - playerY) * mapUnit) - (mapPos.h / 2) * mapZoom)
	local mapWidth, mapHeight = mapPos.w * mapZoom, mapPos.h * mapZoom
	
	exports["pd-gui"]:drawBWRectangle(0, 0, screenW, screenH, tocolor(255, 255, 255, 255))
	dxDrawImageSection(mapPos.x, mapPos.y, mapPos.w, mapPos.h, mapX, mapY, mapWidth, mapHeight, textures.map, 0, 0, 0, tocolor(255, 255, 255, 200)) -- mapka
	dxDrawImage(mapPos.x, mapPos.y, mapPos.w, mapPos.h, textures.border, 0, 0, 0, tocolor(255, 255, 255, 200)) -- obramowanie
	
	local blipSize = math.floor(35/zoom)
	for _, blip in ipairs(getElementsByType("blip")) do
		if getElementInterior(blip) == getElementInterior(localPlayer) and getElementDimension(blip) == getElementDimension(localPlayer) then 
			local icon = getBlipIcon(blip)
			if blips[icon] then
				local blipX, blipY, blipZ = getElementPosition(blip)
				local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
				local leftFrame = (centerX - mapPos.w / 2) + (blipSize/ 2)
				local rightFrame = (centerX + mapPos.w / 2) - (blipSize/ 2)
				local topFrame = (centerY - mapPos.h / 2) + (blipSize/ 2)
				local bottomFrame = (centerY + mapPos.h / 2) - (blipSize/ 2)
				local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
								
				centerX = math.max(leftFrame, math.min(rightFrame, blipX))
				centerY = math.max(topFrame, math.min(bottomFrame, blipY))
				
				dxDrawImage(centerX - (blipSize/ 2), centerY - (blipSize/ 2), blipSize, blipSize, BLIP_TEXTURES[blips[icon].texture], 0, 0, 0, tocolor(255, 255, 255, 255))
			end
		end
	end
	
	local localX, localY, localZ = getElementPosition(localPlayer)
	local blipX, blipY = getMapFromWorldPosition(localX, localY)
	if (blipX >= mapPos.x and blipX <= mapPos.x + mapPos.w) and (blipY >= mapPos.y and blipY <= mapPos.y + mapPos.h) then
		local _, _, playerRotation = getElementRotation(localPlayer)
		dxDrawImage(blipX - 10, blipY - 10, 20, 20, BLIP_TEXTURES["radar_centre"], 360 - playerRotation)
	end
	
	if memoryCheckbox then 
		exports["pd-gui"]:setButtonTextures(memoryButton, {default=textures.checkbox_active, hover=textures.checkbox_active, press=textures.checkbox_active})
	else 
		exports["pd-gui"]:setButtonTextures(memoryButton, {default=textures.checkbox, hover=textures.checkbox, press=textures.checkbox})
	end 
	exports["pd-gui"]:renderButton(memoryButton)
	dxDrawText("Zachowaj teksturę mapy w pamięci (szybsze wczytywanie)", mapPos.x+math.floor(50/zoom), mapPos.y+mapPos.h+math.floor(15/zoom), 0, mapPos.y+mapPos.h+math.floor(47/zoom), tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, true)
	
	-- legenda 
	dxDrawImage(legendPos.x, legendPos.y, legendPos.w, legendPos.h, textures.legend, 0, 0, 0, tocolor(255, 255, 255, 255))
	dxDrawText("Legenda", legendPos.x, legendPos.y+math.floor(40/zoom), legendPos.x+legendPos.w, legendPos.h, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center", "top", false, true)
	
	local offset = 0
	for blipID, blipData in pairs(blips) do 
		dxDrawText(blipData.name, legendPos.x+math.floor(120/zoom), legendPos.y+math.floor(118/zoom)+offset, legendPos.w, legendPos.h, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, true)
		if BLIP_TEXTURES[blipData.texture] then
			dxDrawImage(legendPos.x+math.floor(50/zoom), legendPos.y+math.floor(115/zoom)+offset, blipSize, blipSize, BLIP_TEXTURES[blipData.texture], 0, 0, 0, tocolor(255, 255, 255, 255))
		end 
		
		offset = offset + math.floor(40/zoom)
	end 
	
	dxDrawText("Klawiszologia", legendPos.x, legendPos.y+legendPos.h-math.floor(170/zoom), legendPos.x+legendPos.w, legendPos.h, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, true)
	dxDrawText("Rolka myszki - powiększanie/zmniejszanie mapy\nLewy przycisk myszy - przeciąganie mapy", legendPos.x+math.floor(30/zoom), legendPos.y+legendPos.h-math.floor(130/zoom), legendPos.x+legendPos.w, legendPos.h, tocolor(255, 255, 255, 255), 0.85/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, true)
end 

function moveBigMap(button, state, cursorX, cursorY)
	if (button == 'left' and state == 'down') then
		if (cursorX >= mapPos.x and cursorX <= mapPos.x + mapPos.w) and (cursorY >= mapPos.y and cursorY <= mapPos.y + mapPos.h)  then
			mapOffsetX = (cursorX * mapZoom / mapUnit + playerX)
			mapOffsetY = (cursorY * mapZoom / mapUnit - playerY)
			mapIsMoving = true
			wasMapMoved = true
		end
	elseif (button == 'left' and state == 'up') then
		mapIsMoving = false
	end
end

function scrollBigMap(key)
	if key == "mouse_wheel_down" then 
		mapZoom = math.min(mapZoom+0.3, 3)
	elseif key == "mouse_wheel_up" then 
		mapZoom = math.max(0.75, mapZoom-0.3)
	end
end 

function showBigMap()
	showing = not showing
	showCursor(showing, false)
	
	if showing then 
		playerX, playerY = getElementPosition(localPlayer)
		wasMapMoved = false 
		
		if not memoryCheckbox then
			textures.map = dxCreateTexture("images/map/map.png")
			dxSetTextureEdge(textures.map, 'border', tocolor(110, 158, 204, 255))
			textures.border = dxCreateTexture("images/map/map_border.png")
			textures.legend = dxCreateTexture("images/map/blips_legend.png")
			textures.checkbox = dxCreateTexture("images/map/checkbox.png")
			textures.checkbox_active = dxCreateTexture("images/map/checkbox_active.png")
		end 
		
		bindKey("mouse_wheel_up", "down", scrollBigMap)
		bindKey("mouse_wheel_down", "down", scrollBigMap)
		
		addEventHandler("onClientRender", root, renderBigMap)
		addEventHandler("onClientClick", root, moveBigMap)
		showHUD(false)
		showChat(false)
		
		memoryButton = exports["pd-gui"]:createButton("", mapPos.x, mapPos.y+mapPos.h+math.floor(15/zoom), math.floor(32/zoom), math.floor(32/zoom))
		exports["pd-gui"]:setButtonTextures(memoryButton, {default=textures.checkbox, hover=textures.checkbox, press=textures.checkbox})
		addEventHandler("onClientClickButton", memoryButton, function()
			memoryCheckbox = not memoryCheckbox
		end)
	else 
		exports["pd-gui"]:destroyButton(memoryButton)
		unbindKey("mouse_wheel_up", "down", scrollBigMap)
		unbindKey("mouse_wheel_down", "down", scrollBigMap)
		removeEventHandler("onClientRender", root, renderBigMap)
		removeEventHandler("onClientClick", root, moveBigMap)
		if not memoryCheckbox then
			for k, v in pairs(textures) do 
				if isElement(v) then 
					destroyElement(v)
				end
			end
			textures = {}
		end 
		showHUD(true)
		showChat(true)
	end
end 

function isBigMapShowing()
	return showing
end

addEventHandler("onClientKey", root, function(key, state)
	if key == "F11" and state then
		cancelEvent()
		forcePlayerMap(false)
		if (getElementData(localPlayer, "player:showingGUI") and getElementData(localPlayer, "player:showingGUI") ~= "f11") then return end
		showBigMap()
	end
end)

function getWorldFromMapPosition(mapX, mapY)
	local worldX = playerX + ((mapX * ((mapPos.w * mapZoom) * 2)) - (mapPos.w * mapZoom))
	local worldY = playerY + ((mapY * ((mapPos.h * mapZoom) * 2)) - (mapPos.h * mapZoom)) * -1
	
	return worldX, worldY
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (mapPos.x + (mapPos.w / 2)), (mapPos.y + (mapPos.h / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / mapZoom * mapUnit)
	local mapRightFrame = centerX + ((worldX - playerX) / mapZoom * mapUnit)
	local mapTopFrame = centerY - ((worldY - playerY) / mapZoom * mapUnit)
	local mapBottomFrame = centerY + ((playerY - worldY) / mapZoom * mapUnit)
	
	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))
	
	return centerX, centerY
end
