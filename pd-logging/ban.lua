local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()

function drawBan()
    GUI:drawBWRectangle(0, 0, sx, sy, tocolor(155, 155, 155, 255))
    dxDrawImage(sx/2-200/zoom, sy/2-400/zoom, 400/zoom, 400/zoom, "data/login/logo.png")
    dxDrawText("#f6349fJesteś zbanowany!\n#ffffffPowód: "..powod.."\nBanujący: "..banujacy.."\nData otrzymania: "..datanadania.."\nData wygaśnięcia bana: "..wygasa.."\n\nJeśli uważasz, że jesteś niesłusznie zbanowany, napisz odwołanie na naszym forum:\n#f6349fparadicerpg.pl", sx/2, sy/2+150/zoom, sx/2, sy/2+150/zoom, tocolor(246, 52, 159,255), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "center", false, false, false, true)
end

addEvent("logging:drawBan", true)
addEventHandler("logging:drawBan", root, function(serial, reason,admin,date, timeout)
	addEventHandler("onClientRender", root, drawBan)
	playSound("data/ban.mp3")
	seryjny = serial
	powod = reason
	banujacy = admin
	datanadania = date
	wygasa = timeout
	exports["pd-hud"]:showHUD(false)
	smoothMoveCamera(2524.517578125, -2008.453125, 100.95263671875, 2912.560546875, -2408.787109375, 100.95263671875,699.216796875, -1041.8515625, 96.996025085449,2912.560546875, -2408.787109375, 100.95263671875, 60000)
end)

local sm = {}
sm.moov = 0
sm.object1,sm.object2 = nil,nil

local function removeCamHandler()
    if(sm.moov == 1)then
        sm.moov = 0
    end
end

local function camRender()
    if (sm.moov == 1) then
        local x1,y1,z1 = getElementPosition(sm.object1)
        local x2,y2,z2 = getElementPosition(sm.object2)
        setCameraMatrix(x1,y1,z1,x2,y2,z2)
    else
        removeEventHandler("onClientPreRender",root,camRender)
    end
end


function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
    if(sm.moov == 1)then return false end
    sm.object1 = createObject(1337,x1,y1,z1)
    sm.object2 = createObject(1337,x1t,y1t,z1t)
    setElementCollisionsEnabled (sm.object1,false)
    setElementCollisionsEnabled (sm.object2,false)
    setElementAlpha(sm.object1,0)
    setElementAlpha(sm.object2,0)
    setObjectScale(sm.object1,0.01)
    setObjectScale(sm.object2,0.01)
    moveObject(sm.object1,time,x2,y2,z2,0,0,0,"InOutQuad")
    moveObject(sm.object2,time,x2t,y2t,z2t,0,0,0,"InOutQuad")
    sm.moov = 1
    setTimer(removeCamHandler,time,1)
    setTimer(destroyElement,time,1,sm.object1)
    setTimer(destroyElement,time,1,sm.object2)
    addEventHandler("onClientPreRender",root,camRender)
    return true
end
