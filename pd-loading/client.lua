sx, sy = guiGetScreenSize()

local baseX = 1920 
local zoom = 1 
local minZoom = 2 
if sx < baseX then 
    zoom = math.min(minZoom, baseX/sx)
end

setAnimation("alpha", 0, 1, 1000, "Linear")
setAnimation("rotation", 0, 1, 1000, "Linear")
local sound = playSound("sounds/music.mp3", true)
local loadingText = ""
local rotation = 0
local timer = false
setSoundVolume(sound, 0)

local texts = {
	actual = 1,
	"Widzisz gracza który łamie regulamin? Wpisz komendę #ff0099/report",
	"Zajrzyj na naszego discorda #ff0099discord.gg/PGX9KMz",
	"Masz dla nas jakąś propozycję? Napisz ją na discordzie!",
}

rot = 0

function renderLoading()
	if isTransferBoxActive() then
		ac = 255
		rc = rotation
		rotation = rotation + 1
		text = "Pobieranie zasobów"
	else
		ac = a["alpha"]
		rc = a["rotation"]
		text = loadingText
	end
	local soundFFT = getSoundFFTData (sound, 2048, 256)
	local add = 0
	if soundFFT then
		for i = 1, 256 do
			if soundFFT[i] then
				add = add + math.sqrt(soundFFT[i])
			end
		end
	end
	add = add * 3
	local alpha = 255*((ac/255) * add) / 20
	if alpha > 255 then alpha = 255 end
	rot = rot + 5 > 360 and 0 or rot + 5
	dxDrawImage(0, 0, sx, sy, "images/background.png", 0, 0, 0, tocolor(255, 255, 255, ac), false)
	dxDrawImage(sx/2 - 200/zoom - add/zoom/2, sy/2 - 200/zoom - add/zoom/2, 400/zoom + add/zoom, 400/zoom + add/zoom, "images/lights.png", 0, 0, 0, tocolor(255, 255, 255, alpha), false)
	dxDrawImage(sx/2 - 200/zoom - add/zoom/2, sy/2 - 200/zoom - add/zoom/2, 400/zoom + add/zoom, 400/zoom + add/zoom, "images/logo.png", 0, 0, 0, tocolor(255, 255, 255, ac), false)
	dxDrawImage(sx - 85/zoom, sy - 85/zoom, 50/zoom, 50/zoom, "images/loading.png", rot, 0, 0, tocolor(255, 255, 255, ac), false)
	dxDrawText(text, sx - 110/zoom - dxGetTextWidth(text, 1.3/zoom, exports["pd-gui"]:getGUIFont("normal_small")), sy - 60/zoom, sx - 150/zoom, sy - 60/zoom, tocolor(255, 255, 255, ac), 1.3/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "center", false, false, false)
	dxDrawText(texts[texts.actual], sx/2, sy/2 + 250/zoom, sx/2, sy/2 + 250/zoom, tocolor(255, 255, 255, ac), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "center", false, false, false, true)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	if getElementData(localPlayer, "player:uid") then return end
	addEventHandler("onClientRender", root, renderLoading)
	downloadMusic = playSound("sounds/music.mp3", true)
	showChat(false)
end)


function closeDownload()

	removeEventHandler("onClientRender", root, renderLoading)
	stopSound(downloadMusic)
	setAnimation("alpha", a["alpha"], 255, 500, "InQuad")

end
addEvent("loading:close", true)
addEventHandler("loading:close", root, closeDownload)

setTimer(function()
	texts.actual = texts.actual + 1
	if texts.actual > #texts then texts.actual = 1 end
end, 5000, 0)

function showLoading(text, time)
	if timer then killTimer(timer) timer = false end
	addEventHandler("onClientRender", root, renderLoading, true, "normal")
	setSoundVolume(sound, 1)
	setAnimation("alpha", a["alpha"], 255, 500, "InQuad")
	setAnimation("rotation", 0, time/5, time, "OutQuad")
	loadingText = text
	showChat(false)
	timer = setTimer(function()
		setSoundVolume(sound, 0)
		setAnimation("alpha", a["alpha"], 0, 500, "InQuad")
		timer = setTimer(function()
			removeEventHandler("onClientRender", root, renderLoading)
			showChat(true)
			timer = false
		end, 500, 1)
	end, time, 1)
end