SKINNING_TIME_PER_POINT = 240 -- czas w  milisekundach na każdy punkt skórowania

addEvent("onClientPlayAnimalSound", true)

local startPosition = Vector3(-653.95220947266, -2100.5795898438, 28.494802474976)
local endPosition = Vector3(-653.95220947266, -2100.5795898438, 28.494802474976)
local eqPosition = Vector3(-655.35, -2110.2, 27.68)

local skinning = false
local skinningPoints = {}
local skinningTick = 0 

local textures = {}
local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local bearSize = {w=math.floor(600/zoom), h=math.floor(600/zoom)}
local pointSize = {w=math.floor(83/zoom/2), h=math.floor(72/zoom/2)}
local knifeSize = {w=math.floor(58/zoom), h=math.floor(50/zoom)}

function startJob()
	if (isPedInVehicle(localPlayer)) then
		exports["pd-hud"]:showPlayerNotification("Wysiądź z pojazdu!", "error")
		return
	end
	textures.bear = dxCreateTexture("images/bear.png")
	textures.blood_point = dxCreateTexture("images/blood_point.png")
	textures.point = dxCreateTexture("images/point.png")
	textures.knife = dxCreateTexture("images/knife.png")
	ambient = playSound("sounds/forest.mp3", true)
	setSoundVolume(ambient, 0.4)
	
	addEventHandler("onClientPlayerDamage", localPlayer, handlePlayerDamage)
	addEventHandler("onClientPedDamage", root, handlePedDamage)
	addEventHandler("onClientRender", root, renderJob)
	
	exports["pd-models"]:loadModels("job_hunter")
	
	-- dźwięki pedów
	for i=20, 24 do 
		setWorldSoundEnabled(i, false)
	end 
	
	fadeCamera(false)
	setTimer(function()
		triggerServerEvent("onPlayerStartJob", resourceRoot)
		fadeCamera(true)
	end, 1000, 1)
end 

function handlePedDamage(attacker, weapon, bodypart, loss)
	if attacker == localPlayer then 
		loss = loss*1.3 
		if weapon == 27 then 
			loss = loss*2.2
		end 

		if getElementModel(attacker) == 309 then
			loss = loss*0.6
		end 
			
		triggerServerEvent("onPlayerAttackAnimal", resourceRoot, source, loss)
	end
	
	cancelEvent()
end 

function handlePlayerDamage(attacker, weapon, bodypart, loss)
	if source == localPlayer and attacker then
		if getElementType(attacker) == "player" then 
			cancelEvent()
		elseif getElementType(attacker) == "ped" then
			local jobUpgrades = getElementData(localPlayer, "player:job_upgrades") or {}
		
			if jobUpgrades["hunter"] then 
				for k, v in ipairs(jobUpgrades["hunter"].upgrades) do 
					if v == "damage" then 
						loss = loss/2 
						break
					end
				end
			end 
		
			if getElementModel(attacker) == 308 then 
				setElementHealth(localPlayer, getElementHealth(localPlayer)-loss/2)
			else 
				setElementHealth(localPlayer, getElementHealth(localPlayer)-loss)
			end 
		
			cancelEvent()
		end
	end
end

local screenW, screenH = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()

local drawDist = 30
local fadeDist = drawDist-5 
local modelToName = {
	[308] = "Wilk",
	[309] = "Niedźwiedź"
}

local function generateSkinningPoints()
	local points = {}
	local lastX, lastY = 0, 0
	for l=1, math.random(7, 12) do
		local x, y = 0, 0
		if lastX == 0 then 
			x, y = screenW/2-bearSize.w/2, screenH/2-bearSize.h/2
		else 
			x, y = lastX, lastY
		end
		
		if lastX ~= 0 then 
			x = x + math.random(bearSize.w/4, bearSize.w/3)/4
			y = y + math.random(bearSize.h/4, bearSize.h/3)/4
		else
			x = x + math.random(1, bearSize.w)/8
			y = y + math.random(1, bearSize.h)/8
		end 
		
		lastX, lastY = x, y 
		
		local direction = math.random(1, 2) == 1 and "horizontal" or "vertical"
		
		local maxPoints = 1 
		repeat 
			maxPoints = maxPoints+1
		until x+(maxPoints*pointSize.w) > screenW/2+bearSize.w/3 or y+(maxPoints*pointSize.h) > screenH/2+bearSize.h/2.75
		maxPoints = maxPoints-1
		
		if maxPoints > 0 then
			for i=1, math.random(maxPoints/2, maxPoints) do 
				if direction == "horizontal" then 
					x = x+pointSize.w*0.91
					y = y
				else 
					x = x 
					y = y+pointSize.h
				end
				table.insert(points, {x=x, y=y, w=pointSize.w, h=pointSize.h, direction=direction})
			end
		end
	end
	
	return points
end 

local function startSkinning(animal)
	if skinning then return end 
	
	skinning = animal
	skinningPoints = generateSkinningPoints()
	skinningTick = getTickCount()+(#skinningPoints*SKINNING_TIME_PER_POINT)
		
	setCursorAlpha(0)
	showCursor(true)
	
	triggerServerEvent("onPlayerStartSkinning", resourceRoot)
end 

local function endSkinning(animal, timeBonus)
	if skinning then
		if isElement(skinMarker) then destroyElement(skinMarker) skinMarker = nil end 
		
		if not animal then animal = false end
		if not timeBonus then timeBonus = false end
		triggerServerEvent("onPlayerSkinAnimal", resourceRoot, animal, timeBonus)
		
		local function checkDisable(animal)
			if isElement(animal) then 
				setTimer(checkDisable, 100, 1, animal)
			else 
				skinning = false
				skinningPoints = nil
				setCursorAlpha(255)
				showCursor(false)
			end
		end 
		checkDisable(animal)
	end
end 

function renderJob()
	local jobUpgrades = getElementData(localPlayer, "player:job_upgrades") or {}
	
	local breathing = true 
	if jobUpgrades["hunter"] then 
		for k, v in ipairs(jobUpgrades["hunter"].upgrades) do 
			if v == "breath" then 
				breathing = false 
				break
			end
		end
	end 
	
	-- strzelanie
	local task = getPedTask (localPlayer, "secondary", 0)
	local divider = breathing and 1 or 2
	setCameraShakeLevel(task == "TASK_SIMPLE_USE_GUN" and (getControlState("crouch") and 30/divider or 25/divider) or 0)
	
	-- hp zwierzątek
	local cx, cy, cz = getCameraMatrix()
	for k, v in ipairs(getElementsByType("ped", resourceRoot)) do 
		local x, y, z = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
						
		local sx, sy = getScreenFromWorldPosition(x, y, z+0.40, 0.3)
		
		local alpha = 255
		if dist >= fadeDist then 
			local progress = (dist-fadeDist)/(drawDist-fadeDist)
			alpha = 255 - (255*progress)
		end 
		
		if sx and sy and alpha > 0 then
			local w, h = screenW*0.05, screenH*0.0075
			if not isPedDead(v) then
				dxDrawRectangle(sx-w/2, sy, w, h, tocolor(30, 30, 30, math.max(0, alpha-60)))
				dxDrawRectangle(sx-w/2, sy, w*(math.floor(getElementHealth(v))/100), h, tocolor(231, 76, 60, math.max(0, alpha-60)), true, true)
			end
			
			local tx, ty, tw, th = sx, sy-h-20, sx, sy
			local name = modelToName[getElementModel(v)]
			dxDrawText(name, tx+1, ty+1, tw+1, th+1, tocolor(0, 0, 0, alpha), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
			dxDrawText(name, tx, ty, tw, th, tocolor(255, 255, 255, alpha), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
		end
		
		-- wykrywanie skórowania
		if getElementData(v, "animal:killer") == localPlayer then
			if not skinMarker then 
				skinMarker = createElement("pd_marker")
				setElementDimension(skinMarker, 1)
				setElementPosition(skinMarker, x, y, z-0.8)
				setElementData(skinMarker, "disableLight", true, false)
			end 
			
			if dist < 5.5 then
				startSkinning(v)
			end
		end
	end
	
	-- skórowanie 
	if skinning then 
		local x, y, w, h = screenW/2-bearSize.w/2, screenH/2-bearSize.h/2, bearSize.w, bearSize.h
		dxDrawImage(x, y, w, h, textures.bear)
		dxDrawText("Oskóruj zwierzę", x+1, y-math.floor(50/zoom)+1, x+w+1, h+1, tocolor(0, 0, 0, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
		dxDrawText("Oskóruj zwierzę", x, y-math.floor(50/zoom), x+w, h, tocolor(255, 255, 255, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
		
		local timeLeft = skinningTick - getTickCount()
		local timeStr = timeLeft > 0 and tostring(round(timeLeft/1000, 2)).."s" or "nie zdążyłeś!"
		dxDrawText("Bonus za sprawność\n"..timeStr, x+1, y+h+1, x+w+1, h+1, tocolor(0, 0, 0, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
		if timeLeft > 0 then 
			dxDrawText("Bonus za sprawność\n"..timeStr, x, y+h, x+w, h, tocolor(46, 204, 113, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
		else 
			dxDrawText("Bonus za sprawność\n"..timeStr, x, y+h, x+w, h, tocolor(231, 76, 60, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
		end 
		
		if isCursorShowing() then 
			local x, y = getCursorPosition()
			x, y = x*screenW, y*screenH
			dxDrawImage(x, y, knifeSize.w, knifeSize.h, textures.knife, 0, 0, 0, tocolor(255, 255, 255, 255), true)
		end 
		
		local allFinished = true
		for k, v in ipairs(skinningPoints) do 
			local rot = v.direction == "vertical" and 0 or 90
			
			if isCursorOnElement(v.x+(v.w/2)/2, v.y+(v.h/2)/2, v.w/2, v.h/2) and not v.finished then 
				v.finished = true
				
				local snd = playSound("sounds/cut.mp3")
				setSoundVolume(snd, 0.5)
			end
			
			if not v.finished then 
				dxDrawImage(v.x, v.y, v.w, v.h, textures.point, rot, 0, 0, tocolor(150, 150, 150, 200))
				allFinished = false
			else 
				dxDrawImage(v.x, v.y, v.w, v.h, textures.blood_point, rot )
			end
		end
		
		if allFinished then 
			endSkinning(skinning, timeLeft > 0)
		end
	end 
	
	exports["pd-gui"]:renderConfirmationWindow(exitConfirmation)
end 

function endJob()
	exports["pd-models"]:unloadModels("job_hunter")
	
	if exitConfirmation then 
		exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
	end 
	
	for k, v in pairs(textures) do 
		if isElement(v) then 
			destroyElement(v)
		end
	end 
	textures = {}
	stopSound(ambient)
	removeEventHandler("onClientPlayerDamage", localPlayer, handlePlayerDamage)
	removeEventHandler("onClientPedDamage", root, handlePedDamage)
	removeEventHandler("onClientRender", root, renderJob)
	
	triggerServerEvent("onPlayerEndJob", resourceRoot)
	
	skinning = false
	skinningPoints = nil
	setCursorAlpha(255)
	showCursor(false)
	
	-- dźwięki pedów
	for i=20, 24 do 
		setWorldSoundEnabled(i, true)
	end 
	
	setTimer(setCameraShakeLevel, 50, 5, 0)
end 

function isCursorOnElement(x, y, w, h)
	local mx, my = getCursorPosition ()
	cursorx, cursory = mx*screenW, my*screenH

	return cursorx > x and cursorx < x + w and cursory > y and cursory < y + h
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

addEventHandler("onClientPlayAnimalSound", resourceRoot, function(model, sound, x, y, z)
	if model == 308 then 
		sound = "sounds/wolf/wolf_"..sound..".mp3"
	else 
		sound = "sounds/bear/bear_"..sound..".mp3"
	end 
	
	local sound = playSound3D(sound, x, y, z, false)
	setElementDimension(sound, 1)
	setSoundMaxDistance(sound, 60)
	setSoundVolume(sound, 0.6)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	-- start pracy
	customMarker, markerID = exports["pd-markers"]:createCustomMarker(startPosition.x, startPosition.y, startPosition.z - 1, 50, 255, 50, 155, "marker", 2.5)
	
	local col = createColSphere(startPosition.x, startPosition.y, startPosition.z, 4)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			if getElementData(localPlayer, "player:job") then 
				exports["pd-hud"]:showPlayerNotification("Już pracujesz!", "error")
				return
			end 
			
			showJobGUI()
		end
	end)
	
	-- koniec pracy
	local radius = 5
	local marker = createElement("pd_marker")
	setElementPosition(marker, endPosition.x, endPosition.y, endPosition.z)
	setElementDimension(marker, 1)
	setElementData(marker, "radius", radius)
	setElementData(marker, "color", {230, 126, 34, 255})
	
	local text = createElement("pd_3dtext")
	setElementPosition(text, endPosition.x, endPosition.y, endPosition.z+0.5)
	setElementDimension(text, 1)
	setElementData(text, "text", "Zakończ pracę")
	
	local col = createColSphere(endPosition.x, endPosition.y, endPosition.z, radius*0.4)
	setElementDimension(col, 1)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			exitConfirmation = exports["pd-gui"]:createConfirmationWindow("Czy na pewno chcesz opuścić pracę?")
			showCursor(true)
			
			addEventHandler("onClientAcceptConfirmation", exitConfirmation, function()
				exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
				showCursor(false)
				
				fadeCamera(false)
				setTimer(function()
					endJob()
					fadeCamera(true)
				end, 1000, 1)
			end)
			
				addEventHandler("onClientDenyConfirmation", exitConfirmation, function()
				exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
				showCursor(false)
			end)
			
		end
	end)
	
	-- asorytment
	local radius = 5
	local marker = createElement("pd_marker")
	setElementPosition(marker, eqPosition.x, eqPosition.y, eqPosition.z)
	setElementDimension(marker, 1)
	setElementData(marker, "radius", radius)
	setElementData(marker, "color", {46, 204, 113, 255})
	
	local text = createElement("pd_3dtext")
	setElementPosition(text, eqPosition.x, eqPosition.y, eqPosition.z+0.5)
	setElementDimension(text, 1)
	setElementData(text, "text", "Dobierz ulepszenia")
	
	local col = createColSphere(eqPosition.x, eqPosition.y, eqPosition.z, radius*0.4)
	setElementDimension(col, 1)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			showUpgradesGUI()
		end
	end)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	if getElementData(localPlayer, "player:job") == "hunter" then 
		endJob()
	end
	exports["pd-markers"]:destroyCustomMarker(markerID)
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	if getElementData(localPlayer, "player:job") == "hunter" then 
		endJob()
	end
end)