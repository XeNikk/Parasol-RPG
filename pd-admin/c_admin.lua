sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()



for k,v in ipairs (getElementsByType("admin:data")) do
	if getElementData (v,"reports") then
        reporty = v
    end
    if getElementData (v,"logs") then 
        logi = v
	end
end


function adminDraw()
    local reports = {}
    for i,v in ipairs(getElementData(reporty, "reports")) do 
        if v[1] then reports[#reports+1] = v[1] 
        end 
    end
    local reports = table.concat(reports, "\n")
	if adminreports == true then 
		dxDrawText(string.gsub(reports, "#%x%x%x%x%x%x", ""), sx-172/zoom, sy/2-118/zoom, sx-10/zoom, sy/2/zoom, tocolor(0,0,0,255), 0.85/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "top", false, false, false, false )
dxDrawText(reports, sx-170/zoom, sy/2-120/zoom, sx-10/zoom, sy/2/zoom, white, 0.85/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "top", false, false, false, true )

    end
local logs = {}
for i,v in ipairs(getElementData(logi, "logs")) do 
    if v[1] then logs[#logs+1] = v[1] 
    end 
end
local logs = table.concat(logs, "\n")
if adminlogs == true then
	dxDrawText(string.gsub(logs,"#%x%x%x%x%x%x", ""), 9/zoom, sy/2-121/zoom, 9/zoom, sy/2/zoom-1/zoom, tocolor(0, 0, 0, 255), 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, true, false, true )
dxDrawText(logs, 10/zoom, sy/2-120/zoom, 10/zoom, sy/2/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, true, false, true )
end
end





function csideduty(plr, el, rank)
if el == true then 
    exports["pd-hud"]:addNotification("Wchodzisz na duty administracji.\nRanga: "..rank..".", "success", 5000, nil, "success")
    addEventHandler("onClientRender", root, adminDraw)
    adminlogs = true
    adminreports = true
else
    exports["pd-hud"]:addNotification("Schodzisz z duty administracji.", "success", 5000, nil, "success")
    removeEventHandler("onClientRender", root, adminDraw)
    adminlogs = false
    adminreports = false
end


end
addEvent("admin:csideDuty", true)
addEventHandler("admin:csideDuty", root, csideduty)

addCommandHandler("reporty", function(cmd)
    adminreports = not adminreports
end)

addCommandHandler("logi", function(cmd)
    adminlogs = not adminlogs
end)


addCommandHandler("admins", function()

admins = {
    ["Administrator RCON"] = {},
    ["Administrator"] = {},
    ["Moderator"] = {},
    ["Support"] = {}
}    


for i,v in ipairs(getElementsByType("player")) do 
    if getElementData(v, "player:admin") then 
            local rank = getElementData(v, "player:admin:rank")
            table.insert(admins[rank], "#ffffff["..getElementData(v, "player:id").."] "..getPlayerName(v).."")
    end
end

local tabrcon = table.concat(admins["Administrator RCON"],", ")
local tabadmin = table.concat(admins["Administrator"],", ")
local tabmod = table.concat(admins["Moderator"],", ")
local tabsup = table.concat(admins["Support"],", ")

if #tabrcon == 0 then tabrcon = "#ffffff brak" end
if #tabadmin == 0 then tabadmin = "#ffffff brak" end
if #tabmod == 0 then tabmod = "#ffffff brak" end
if #tabsup == 0 then tabsup = "#ffffff brak" end

outputChatBox("#910000Zarząd: "..tabrcon.."", 255,255,255,true)
outputChatBox("#f21000Administracja: "..tabadmin.."", 255,255,255,true)
outputChatBox("#009127Moderatorzy: "..tabmod.."", 255,255,255,true)
outputChatBox("#00ace0Supporterzy: "..tabsup.."", 255,255,255,true)

end)


function addNoti(text, type)
        --exports["pd-hud"]:addNotification(text, type, 5000, nil, type)
    end
addEvent("admin:addNoti", true)
addEventHandler("admin:addNoti", root, addNoti)


addCommandHandler("gp", function(cmd)
	if isPedInVehicle(localPlayer) then
		x,y,z = getElementPosition(getPedOccupiedVehicle(localPlayer))
	else
		x,y,z = getElementPosition(localPlayer)
	end
	outputChatBox(x..", "..y..", "..z)
	setClipboard(""..x..", "..y..", "..z.."")
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
	if(sm.moov == 1)then
		destroyElement(sm.object1)
		destroyElement(sm.object2)
		killTimer(timer1)
		killTimer(timer2)
		killTimer(timer3)
		removeEventHandler("onClientPreRender",root,camRender)
	end
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
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(destroyElement,time,1,sm.object1)
	timer3 = setTimer(destroyElement,time,1,sm.object2)
	addEventHandler("onClientPreRender",root,camRender)
	return true
end

addCommandHandler("cam", function(cmd)
    setCameraTarget(localPlayer, localPlayer)
end)

addCommandHandler("camintro", function(cmd)
setCameraMatrix(1999.8645019531, -858.91912841797, 122.67736816406, 1990.2825927734, -892.85522460938, 117.83081054688)
end)