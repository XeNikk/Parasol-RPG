sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()


function drawBW()
    
    if((getTickCount()-tick) > 1000)then
		tick=getTickCount();
		time=time-1;
    end
    
    if(time < 1)then

        setElementData(localPlayer, "player:bw", false)
        removeEventHandler("onClientRender", root, drawBW)
        showChat(true)
        triggerServerEvent("core:BWSpawnPlayer", localPlayer, localPlayer)
        exports["pd-hud"]:showHUD(true)
    end

    exports["pd-gui"]:drawBWRectangle(0/zoom, 0/zoom, sx, sy, tocolor(0,0,0,255), false)
    dxDrawText("Straciłeś przytomność.", 10/zoom, sy-70/zoom, 10/zoom, sy-70/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
    dxDrawText(secondsToClock(time), 10/zoom, sy-40/zoom, 10/zoom, sy-40/zoom, tocolor(255, 94, 94, 255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
end

function initBW()

setElementData(localPlayer, "player:bw", true)
addEventHandler("onClientRender", root, drawBW)
showChat(false)
tick = getTickCount()
time = 10
exports["pd-hud"]:showHUD(false)
exports["pd-achievements"]:addPlayerAchievement(localPlayer, "Chwila słabości", 5)

end
addEventHandler("onClientPlayerWasted",localPlayer,initBW)

function secondsToClock(seconds)
	seconds = seconds or 0
	if seconds <= 0 then
		return "00:00"
	else
		hours = string.format("%02.f", math.floor(seconds/3600))
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
		return ""..mins..":"..secs
	end
end