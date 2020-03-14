sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()

markers = {}

stations = {
    -- STACJA OBOK CYGANA
   {-93.7412109375, -1174.9716796875, 2.269606590271, true},
   {-98.89453125, -1172.3291015625, 2.4451689720154},
   {-87.7509765625, -1177.5224609375, 2.0846939086914},
   {-83.146484375, -1166.5908203125, 2.2622196674347},
   {-88.75390625, -1163.84375, 2.2652821540833},
   {-94.6142578125, -1160.9130859375, 2.1922063827515},

   -- STACJA OBOK SAFD
   {1944.921875, -1769.4228515625, 13.390598297119, true},
   {1944.921875, -1769.4228515625, 13.390598297119},
   {1944.921875, -1769.4228515625, 13.390598297119},
   {1944.490234375, -1776.49609375, 13.390598297119},
   {1938.8031005859, -1767.4409179688, 13.3828125},
   {1939.0577392578, -1777.0543212891, 13.390598297119},

    -- STACJA OBOK BAZY KSA
    {999.52551269531, -940.06512451172, 42.1796875, true},
    {1007.1408691406, -938.96746826172, 42.1796875},
    {1006.612487793, -933.53515625, 42.1796875},
    {998.52575683594, -935.13153076172, 42.1796875},

        -- STACJA MIASTECZKO NAD LS
    {653.21478271484, -570.76086425781, 16.3359375, true},
    {653.40899658203, -560.33349609375, 16.3359375},
    {659.02716064453, -559.23474121094, 16.3359375},
    {659.04876708984, -569.80041503906, 16.3359375},

}

station = {
    enabled = false,
    costforPB = 5,
    costforLPG = 2,
    costforON = 10
}


for i,v in ipairs(stations) do
    markers[#markers+1] = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3]-0.2, 35, 138, 95, 200, "station_lpg", 2)
    createMarker(v[1], v[2], v[3]-0.95, "cylinder", 4,0,0,0,0)
    if v[4] == true then 
        bliped = createBlip(v[1], v[2], v[3], 38)
        setBlipVisibleDistance(bliped, 250)
    end
end

texbg = dxCreateTexture("images/background.png")
texlpg = dxCreateTexture("images/lpg.png")
texlpgactive = dxCreateTexture("images/lpg_active.png")
texon = dxCreateTexture("images/on.png")
texonactive = dxCreateTexture("images/on_active.png")
texpb = dxCreateTexture("images/pb.png")
texpbactive = dxCreateTexture("images/pb_active.png")
texprogressbarbg = dxCreateTexture("images/progressbar_background.png")
texprogressbar = dxCreateTexture("images/progressbar.png")


function drawGui()
if isPedInVehicle(localPlayer) then 
    if station.menu == "main" then
    dxDrawImage(sx/2-400/zoom, sy/2-150/zoom, 830/zoom, 296/zoom, texbg)
    dxDrawText("Wybierz typ paliwa", sx/2-90/zoom, sy/2-130/zoom, sx/2/zoom, sy/2/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"))
    if isMouseIn(sx/2-240/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) then
    dxDrawImage(sx/2-240/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texlpgactive)
    else 
        dxDrawImage(sx/2-240/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texlpg)
    end
    if isMouseIn((sx/2)-50/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) then
    dxDrawImage((sx/2)-50/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texonactive)
    else
        dxDrawImage((sx/2)-50/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texon)  
    end
    if isMouseIn(sx/2+140/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) then
    dxDrawImage(sx/2+140/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texpbactive)
    else 
        dxDrawImage(sx/2+140/zoom, sy/2-70/zoom, 138/zoom, 138/zoom, texpb)
    end

end

if station.menu == "PB" or station.menu == "ON" or station.menu == "LPG" then
    if station.menu == "PB" then costforl = station.costforPB elseif station.menu == "ON" then costforl = station.costforON elseif station.menu == "LPG" then costforl = station.costforLPG end
    dxDrawImage(sx/2-400/zoom, sy/2-150/zoom, 830/zoom, 296/zoom, texbg)
    dxDrawText("Zatankuj pojazd", sx/2-65/zoom, sy/2-130/zoom, sx/2/zoom, sy/2/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"))
    dxDrawText("Łączny koszt: #49be94$"..math.floor(station.dolane*costforl), sx/2+20/zoom, sy/2-70/zoom, sx/2+20/zoom, sy/2/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)

    local actualfuel = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel")
    local progress = 72 / 100 * ((actualfuel+station.dolane)*100)
    local full = 72 / 100 * (10*100)
    dxDrawImageSection(sx/2-350/zoom, sy/2-20/zoom, full/zoom, 35/zoom, 0, 0, full/zoom, 35/zoom, texprogressbarbg)
    dxDrawImageSection(sx/2-350/zoom, sy/2-20/zoom, progress/zoom, 35/zoom, 0, 0, progress/zoom, 35/zoom, texprogressbar)

    local format = math.floor((actualfuel+station.dolane)*10)/10
    dxDrawText(format.." L / 10 L", sx/2-340/zoom, sy/2+30/zoom, sx/2+20/zoom, sy/2/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false, true)

    dxDrawText("Cena za litr paliwa: #49be94$"..costforl, sx/2+370/zoom, sy/2+30/zoom, sx/2+370/zoom, sy/2/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "top", false, false, false, true)

dxDrawText("Aby zatankować przytrzymaj SPACJĘ", sx/2+110/zoom, sy/2+100/zoom, sx/2/zoom, sy/2+110/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)

if getKeyState("SPACE") then 
    if actualfuel + station.dolane >= 10 or station.dolane*costforl > getPlayerMoney(localPlayer) then return end
    station.dolane = station.dolane + 0.015
end

end

end
end





addEventHandler("onClientMarkerHit", resourceRoot, function(plr, md)
    if localPlayer == plr then
        if isPedInVehicle(localPlayer) then 
            if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:vid") then 
                showCursor(true, false)
                addEventHandler("onClientRender", root, drawGui)
                station.enabled = true
                station.menu = "main"
                station.dolane = 0
            end
        end
end
end)

addEventHandler("onClientMarkerLeave", resourceRoot, function(plr, md)
    if localPlayer == plr then
        if station.enabled == true then
        station.enabled = false
        removeEventHandler("onClientRender", root, drawGui)
        showCursor(false)
        if station.menu == "PB" then costforl = station.costforPB elseif station.menu == "ON" then costforl = station.costforON elseif station.menu == "LPG" then costforl = station.costforLPG end
        if math.floor(station.dolane*costforl) == 0 then return end 
        exports["pd-hud"]:addNotification("Zatankowałeś "..station.dolane.."L paliwa.", "success", 5000, nil, "success")
        setElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel", getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel")+station.dolane )
        triggerServerEvent("station:takeMoney", localPlayer, localPlayer, math.floor(station.dolane*costforl*10)/10)
        end
end
end)

bindKey("mouse1", "down", function()
    if station.enabled == false then return end
    if isMouseIn(sx/2-240/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) and station.menu == "main" then
        if not getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:lpg") then exports["pd-hud"]:addNotification("Twój pojazd nie posiada instalacji LPG.", "error", 5000, nil, "error") return end
        station.menu = "LPG"
    elseif isMouseIn((sx/2)-50/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) and station.menu == "main" then 
        if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel:type") == "Benzyna" then exports["pd-hud"]:addNotification("Twój pojazd nie może być zatankowany tym typem paliwa.", "error", 5000, nil, "error") return end
        station.menu = "ON"
    elseif isMouseIn(sx/2+140/zoom, sy/2-70/zoom, 138/zoom, 138/zoom) and station.menu == "main" then 
        if getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel:type") == "Diesel" then exports["pd-hud"]:addNotification("Twój pojazd nie może być zatankowany tym typem paliwa.", "error", 5000, nil, "error") return end
        station.menu = "PB"

    end
end)


addEventHandler("onClientResourceStop", resourceRoot, function()
    for i,v in pairs(markers) do
    exports["pd-markers"]:destroyCustomMarker(getElementData(v, "marker:id"))
    end
end)


function isMouseIn(psx,psy,pssx,pssy,abx,aby)
	if not isCursorShowing() then return end
	cx,cy=getCursorPosition()
	cx,cy=cx*sx,cy*sy
	if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
		return true,cx,cy
	else
		return false
	end
end