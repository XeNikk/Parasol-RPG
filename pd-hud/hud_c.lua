local screenW, screenH = guiGetScreenSize()
-- pozycje
local zoom = exports["pd-gui"]:getInterfaceZoom()

local hudPos = {x=0, y=0, w=screenW, h=math.floor(60/zoom)}
hudPos.y = screenH-hudPos.h 

local logoSize = Vector2(math.floor((200/zoom)*0.6), math.floor((200/zoom)*0.6))
local iconSize = Vector2(math.floor(hudPos.h*0.6), math.floor(hudPos.h*0.6))
local progressSize = {w=math.floor((1074/zoom)*0.5), h=math.floor((74/zoom)*0.5)}

local animations = {}
local a = {}

function setAnimation( id, start, stop, time, interpolateType )
	animations[id] = {start, stop, getTickCount(), time, interpolateType}
	a[id] = start
end

function getAnimationProgress( id )
	fProgress = (getTickCount() - animations[id][3]) / animations[id][4]
	if fProgress > 1 then fProgress = 1 end
	return fProgress
end

addEventHandler( "onClientRender", root, function()
	tickCount = getTickCount()
	for k,v in pairs( animations ) do
		fProgress = (tickCount - v[3]) / v[4]
		if fProgress > 1 then fProgress = 1 end
		interpolate = interpolateBetween( v[1], 0, 0, v[2], 0, 0, fProgress, v[5] )
		a[k] = interpolate
	end
end )

setAnimation("loadingY", -screenH, -screenH, 1000, "Linear")

-- zmienne
local textures = {} 
local showing = false

infoText = "Aby wystawić ogłoszenie wpisz komendę /ogloszenie"

local progressTitle, progressTime, progressShowing = "", 0, false 
local progressTick = 0 

local components = {
	["weapon"] = false,
	["ammo"] = false,
	["area_name"] = false,
	["health"] = false,
	["clock"] = false,
	["money"] = false,
	["breath"] = false,
	["armour"] = false,
	["wanted"] = false,
	["radar"] = true,
	["vehicle_name"] = false,
	["crosshair"] = true
}

function showNormalHUD(show)
	for k,v in pairs(components) do
		if show then
			setPlayerHudComponentVisible(k, v)
		else
			setPlayerHudComponentVisible(k, false)
		end
	end
end

function showHUD(show)
	showing = show
	if showing then 
		triggerEvent("showSpeedo", root)
	else 
		triggerEvent("hideSpeedo", root)
	end
	setPlayerHudComponentVisible("radar", false)
end 

function showHUDProgress(title, time)
	if title and time then 
		progressTitle = title 
		progressShowing = true
		progressTime = time
		progressTick = getTickCount()		
		setTimer(function()
			progressShowing = false
		end, time, 1)
	end
end 

local loadingTips = {
	"Znalazłeś jakikolwiek błąd bądź bug? Czym prędzej zgłoś go nam, aby nie utrudniał rozgrywki",
	"Widzisz gracza który łamie regulamin? Wpisz komendę #ff00cc/report",
}

actualTip = math.random(1, #loadingTips)
function showLoading(time)
	actualTip = math.random(1, #loadingTips)
	setAnimation("loadingY", a["loadingY"], 0, 1000, "OutQuad")
	setTimer(function()
		setAnimation("loadingY", a["loadingY"], -screenH, 1000, "OutQuad")
	end, time, 1)
end

local lastTick = getTickCount()
local fpsCount = 60
local fpsNow = 0

setTimer(function()
	fpsCount = fpsNow
	fpsNow = 0
end, 1000, 0)

function renderHUD()
	if not getElementData(localPlayer, "player:uid") or not showing then return end 

	if getElementData(localPlayer, "player:fps") then
		dxDrawText("FPS "..fpsCount, screenW - 20/zoom, 0, 1000, 1000, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
		fpsNow = fpsNow + 1
	end
	
	if not getElementData(localPlayer, "player:hud") then
		dxDrawImage(hudPos.x, hudPos.y, hudPos.w, hudPos.h, textures.background, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawImage(hudPos.x+math.floor(5/zoom), hudPos.y-math.floor(logoSize.y/1.8), logoSize.x, logoSize.y, textures.logo, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		dxDrawText("Parasol 1.0", hudPos.x+logoSize.x+math.floor(5/zoom)+1, hudPos.y-math.floor(30/zoom)+1, hudPos.w, hudPos.h, tocolor(0, 0, 0, 200), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false)
		dxDrawText("Parasol 1.0", hudPos.x+logoSize.x+math.floor(5/zoom), hudPos.y-math.floor(30/zoom), hudPos.w, hudPos.h, tocolor(255, 255, 255, 200), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false)
		
		-- ikonki
		local x, y, w, h = hudPos.x+logoSize.x+math.floor(30/zoom), math.floor(hudPos.y+hudPos.h/2-iconSize.y/2), iconSize.x, iconSize.y
		dxDrawImage(x, y, w, h, textures.health_icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
		
		x = x+math.floor(70/zoom)
		local hp = math.ceil(getElementHealth(localPlayer))
		dxDrawText(tostring(hp).."%", x, y, x+w, y+h, tocolor(255, 255, 255, 200), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center", "center", false, false, false)
		
		local weapon = getPedWeapon(localPlayer)
		if weapon ~= 0 then
			x = x+iconSize.x+math.floor(40/zoom)
			dxDrawImage(x, y, 120/zoom, h, "images/weapons/" .. weapon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)

			x = x+math.floor(130/zoom)
			local inClipAmmo = getPedAmmoInClip(localPlayer)
			local totalAmmo = getPedTotalAmmo(localPlayer)
			dxDrawText("#16a2de" .. comma_valueAmmo(inClipAmmo) .. "#ffffff/#d6369e" .. comma_valueAmmo(totalAmmo - inClipAmmo), x, y, x+w, y+h, tocolor(255, 255, 255, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "left", "center", false, false, false, true)
		else
			x = x+iconSize.x+math.floor(40/zoom)
			local points = getElementData(localPlayer, "player:rp") or 0
			dxDrawImage(x, y, w, h, textures.reputation_icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
			
			x = x+math.floor(70/zoom)
			dxDrawText(tostring(points), x, y, x+w, y+h, tocolor(255, 255, 255, 200), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center", "center", false, false, false)
			
			x = x+iconSize.x+math.floor(40/zoom)
			dxDrawImage(x, y, w, h, textures.money_icon, 0, 0, 0, tocolor(255, 255, 255, 255), false)
				
			x = x+math.floor(80/zoom)
			local money = getPlayerMoney(localPlayer)
			dxDrawText(comma_value(money), x, y, x+w, y+h, tocolor(255, 255, 255, 200), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center", "center", false, false, false)
		end

		dxDrawImage(0, a["loadingY"], screenW, screenH, "images/download/background.png", 0, 0, 0, white, true)
		dxDrawImage(screenW/2-250/zoom, a["loadingY"]+screenH/2-250/zoom, 500/zoom, 500/zoom, "images/download/logo.png", 0, 0, 0, white, true)
		dxDrawText(loadingTips[actualTip], screenW/2, a["loadingY"]+screenH*0.7, screenW/2, a["loadingY"]+screenH*0.7, tocolor(255, 255, 255, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true, true)
		dxDrawText("Wczytywanie obiektów", screenW*0.9, a["loadingY"]+screenH*0.9, screenW*0.9, a["loadingY"]+screenH*0.9, tocolor(255, 255, 255, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true, true)
		--[[local isDownloading = exports.pd_download:isDownloading()
		if isDownloading then 
			local progress = exports.pd_download:getDownloadProgress()
			
			dxSetRenderTarget(textures.download_progress_rt, true)
			dxDrawImage(0, 0, progressSize.w, progressSize.h, textures.download_progress_active, 0, 0, 0, tocolor(255, 255, 255, 255))
			dxSetRenderTarget()
			
			local x, y = math.floor(hudPos.x+hudPos.w-progressSize.w*1.1), math.floor(hudPos.y+hudPos.h/2-progressSize.h/2)
			dxDrawImage(x, y, progressSize.w, progressSize.h, textures.download_progress, 0, 0, 0, tocolor(255, 255, 255, 200), true)
			dxDrawImageSection(math.floor(x-(progressSize.w-(progressSize.w*progress))), y, progressSize.w, progressSize.h, math.floor(progressSize.w+(progressSize.w*progress)), 0, progressSize.w, progressSize.h, textures.download_progress_rt, 0, 0, 0, tocolor(255, 255, 255, 255), true)
			
			local file, downloadedFilesSize, downloadFilesSize, type = exports.pd_download:getDownloadInfo()
			dxDrawText(((type == "loading") and "Ładowanie" or "Pobieranie").." zasobów "..tostring(downloadedFilesSize).."/"..tostring(downloadFilesSize).." MB", x+1, y+1, x+progressSize.w+1, y+progressSize.h+1, tocolor(0, 0, 0, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true)
			dxDrawText(((type == "loading") and "Ładowanie" or "Pobieranie").." zasobów "..tostring(downloadedFilesSize).."/"..tostring(downloadFilesSize).." MB", x, y, x+progressSize.w, y+progressSize.h, tocolor(255, 255, 255, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true)
		else]]
			local textWidth = dxGetTextWidth(infoText, 0.85/zoom, exports["pd-gui"]:getGUIFont("normal"), false)
			local x, y, w, h = hudPos.x+hudPos.w-textWidth-math.floor(30/zoom), hudPos.y, hudPos.w, hudPos.h
			dxDrawText(infoText, x, y, x+w, y+h, tocolor(255, 255, 255, 200), 0.85/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "center", false, false, true)
		--end
		
		if progressShowing then 
			local now = getTickCount()
			local progress = (now-progressTick) / progressTime 
			
			dxSetRenderTarget(textures.download_progress_rt, true)
			dxDrawImage(0, 0, progressSize.w, progressSize.h, textures.download_progress_active, 0, 0, 0, tocolor(255, 255, 255, 255))
			dxSetRenderTarget()
			
			local x, y = math.floor(screenW/2-progressSize.w/2), math.floor(hudPos.y-math.floor(50/zoom))
			dxDrawImage(x, y, progressSize.w, progressSize.h, textures.download_progress, 0, 0, 0, tocolor(255, 255, 255, 200), true)
			dxDrawImageSection(math.floor(x-(progressSize.w-(progressSize.w*progress))), y, progressSize.w, progressSize.h, math.floor(progressSize.w+(progressSize.w*progress)), 0, progressSize.w, progressSize.h, textures.download_progress_rt, 0, 0, 0, tocolor(255, 255, 255, 255), true)
		
			dxDrawText(progressTitle, x+1, y+1, x+progressSize.w+1, y+progressSize.h+1, tocolor(0, 0, 0, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true)
			dxDrawText(progressTitle, x, y, x+progressSize.w, y+progressSize.h, tocolor(255, 255, 255, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, true)
		end
	else
		setPlayerHudComponentVisible("all", false)
		setPlayerHudComponentVisible("radar", false)
		setPlayerHudComponentVisible("crosshair", false)
	end
end 

function isHudShowing()
	return showing
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	textures.background = dxCreateTexture("images/background.png")
	textures.logo = dxCreateTexture("images/logo.png")
	
	textures.health_icon = dxCreateTexture("images/health_icon.png", "argb", true, "clamp")
	textures.money_icon = dxCreateTexture("images/money_icon.png", "argb", true, "clamp")
	textures.reputation_icon = dxCreateTexture("images/reputation_icon.png", "argb", true, "clamp")
	
	textures.download_progress = dxCreateTexture("images/download/progressbar.png")
	textures.download_progress_active = dxCreateTexture("images/download/progressbar_active.png")
	textures.download_progress_rt = dxCreateRenderTarget(progressSize.w*2, progressSize.h+1, true)
		
	setPlayerHudComponentVisible("all", false)
	setPlayerHudComponentVisible("radar", showing)
	setPlayerHudComponentVisible("crosshair", showing)
	
	addEventHandler("onClientRender", root, renderHUD, true, "high-1")
	
	--if getElementData(localPlayer, "player:spawned") then 
		showHUD(true)
	--end
end)




addEvent("hud:addAdvert", true)
addEventHandler("hud:addAdvert", root, function(plr, text)

	infoText = getPlayerName(plr)..": "..text

	setTimer(function()
	
		infoText = "Aby wystawić ogłoszenie wpisz komendę /ogloszenie"
	
	end, 10000, 1)

end)
-- utils
function comma_value(n) -- credit http://richard.warburton.it
	local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function comma_valueAmmo(n) -- credit http://richard.warburton.it
	if n < 10 then n = 0 .. n end
	return n
end