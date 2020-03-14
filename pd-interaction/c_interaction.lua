sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()


interaction ={
    enabled = false
}

interaction.textures = {
   header = dxCreateTexture("images/header.png"),
   list_background = dxCreateTexture("images/list_background.png"),
   list_background_active = dxCreateTexture("images/list_background_active.png"),
}

interaction.options = {
    ["vehicle"] = {
        [1] = {"Zamknij", "images/icons/cancel.png", "close"},
        [2] = {"Bagażnik" ,"images/icons/vehicle.png", "openTrunk"},
        [3] = {"Maska" ,"images/icons/vehicle.png", "openHood"},
        [4] = {"Zamek" ,"images/icons/vehicle.png", "closeCar"},
    },
    ["vehicleAdmin"] = {
        [5] = {"Schowaj do przechowalni", "images/icons/vehicle.png", "destroyVehicle"},
        [6] = {"Napraw pojazd", "images/icons/vehicle.png", "fixVehicle"},
        [7] = {"Odwróć pojazd", "images/icons/vehicle.png", "flipVehicle"},
    }
}

interaction.gui = function()
if interaction.type == "vehicle" then 
    dxDrawImage(interaction.x+50/zoom, interaction.y-50/zoom, 350/zoom, 60/zoom, interaction.textures.header)
    --dxDrawImage(0,0,sx,sy, "ss.png")
    local x = 0
    for i,v in ipairs(interaction.options[interaction.type]) do 
        x=x+1
        scroll = (60/zoom)*(x-1)
        if isMouseInPosition(interaction.x+50/zoom, interaction.y+10/zoom+scroll, 350/zoom, 60/zoom) then
            dxDrawImage(interaction.x+50/zoom, interaction.y+10/zoom+scroll, 350/zoom, 60/zoom, interaction.textures.list_background_active)
        else 
            dxDrawImage(interaction.x+50/zoom, interaction.y+10/zoom+scroll, 350/zoom, 60/zoom, interaction.textures.list_background)
        end
        dxDrawImage(interaction.x+60/zoom, interaction.y+20/zoom+scroll, 35/zoom, 35/zoom, v[2])
        dxDrawText(v[1], interaction.x+115/zoom, interaction.y+27/zoom+scroll, interaction.x+60/zoom, interaction.y+27/zoom+scroll, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")
    end

    if getElementData(localPlayer, "player:admin") then
    for k,s in pairs(interaction.options[interaction.type.."Admin"]) do 
        x=x+1
        scroll2 = (60/zoom)*(x-1)
        if isMouseInPosition(interaction.x+50/zoom, interaction.y+10/zoom+scroll2, 350/zoom, 60/zoom) then
            dxDrawImage(interaction.x+50/zoom, interaction.y+10/zoom+scroll2, 350/zoom, 60/zoom, interaction.textures.list_background_active)
        else 
            dxDrawImage(interaction.x+50/zoom, interaction.y+10/zoom+scroll2, 350/zoom, 60/zoom, interaction.textures.list_background)
        end
        dxDrawImage(interaction.x+60/zoom, interaction.y+20/zoom+scroll2, 35/zoom, 35/zoom, s[2])
        dxDrawText(s[1], interaction.x+115/zoom, interaction.y+27/zoom+scroll2, interaction.x+60/zoom, interaction.y+27/zoom+scroll2, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")
    end
end
    end
end


bindKey("mouse1", "down", function()
    if interaction.type then 
        if interaction.type == "vehicle" then 
            local x = 0
            for i,v in ipairs(interaction.options[interaction.type]) do 
                x=x+1
                scroll = (60/zoom)*(x-1)
                if isMouseInPosition(interaction.x+50/zoom, interaction.y+10/zoom+scroll, 350/zoom, 60/zoom) then 
                    if v[3] == "close" then 
                        interaction.open()
                    elseif v[3] == "openTrunk" then 
                        if getElementData(localPlayer, "player:uid") ~= getElementData(interaction.element, "vehicle:owner") then exports["pd-hud"]:addNotification("Nie posiadasz kluczy do tego pojazdu.", "error", 5000, nil, "error") return end
                        if getVehicleDoorOpenRatio(interaction.element, 1) ~= 0 then
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "trunk", "close")
                        else
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "trunk", "open")
                        end
                    elseif v[3] == "openHood" then 
                        if getElementData(localPlayer, "player:uid") ~= getElementData(interaction.element, "vehicle:owner") then exports["pd-hud"]:addNotification("Nie posiadasz kluczy do tego pojazdu.", "error", 5000, nil, "error") return end
                        if getVehicleDoorOpenRatio(interaction.element, 0) ~= 0 then
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "hood", "close")
                        else
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "hood", "open")
                        end
                    elseif v[3] == "closeCar" then 
                        if getElementData(localPlayer, "player:uid") ~= getElementData(interaction.element, "vehicle:owner") then exports["pd-hud"]:addNotification("Nie posiadasz kluczy do tego pojazdu.", "error", 5000, nil, "error") return end
                        if isVehicleLocked(interaction.element) then
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "car", "open")
                        else
                            triggerServerEvent("interaction:vehicleOpenDoor", localPlayer, interaction.element, "car", "close")
                        end
                    end
                end
            end
            for k,s in pairs(interaction.options[interaction.type.."Admin"]) do 
                x=x+1
                scroll2 = (60/zoom)*(x-1)
                if isMouseInPosition(interaction.x+50/zoom, interaction.y+10/zoom+scroll2, 350/zoom, 60/zoom) then
                    if not getElementData(localPlayer, "player:admin") then return end 
                    if s[3] == "destroyVehicle" then
                        exports["pd-hud"]:addNotification("Schowałeś pojazd do przechowalni.", "success", 5000, nil, "success")
                        triggerServerEvent("interaction:vehiclePrzecho", localPlayer, interaction.element)
                    elseif s[3] == "fixVehicle" then 
                        triggerServerEvent("interaction:fixVehicle", localPlayer, interaction.element)
                        exports["pd-hud"]:addNotification("Naprawiłeś pojazd.", "success", 5000, nil, "success")
                    elseif s[3] == "flipVehicle" then 
                        triggerServerEvent("interaction:flipVehicle", localPlayer, interaction.element)
                        exports["pd-hud"]:addNotification("Odwróciłeś pojazd.", "success", 5000, nil, "success")
                    end
                end
            end
        end
    end
end)

function klik(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
    if button=='left' and state=='down' and interaction.enabled then 
    if getElementType(clickedElement) == "vehicle" then
      x,y,z = getElementPosition(localPlayer)
      x2,y2,z2 = getElementPosition(clickedElement)
      if getDistanceBetweenPoints3D(x,y,z, x2,y2,z2) > 3 then return end
       if isElement(clickedElement) then 
        local pos = {getElementPosition(localPlayer)}
        local pos2 = {getElementPosition(clickedElement)}
        local distance=getDistanceBetweenPoints3D(pos[1],pos[2],pos[3],pos2[1],pos2[2],pos2[3])
        interaction.getxy(clickedElement)
        interaction.type = getElementType(clickedElement)
        end
    end 
end
end

interaction.getxy = function(element)
    local cX,cY=getCursorPosition()
    cX=sx*cX 
    cY=sy*cY 
    interaction.x = cX - 210/zoom
    interaction.y = cY
    interaction.state=true 
    interaction.element = element
    removeEventHandler('onClientClick',root,klik)
  end 

interaction.open = function()
    if not getElementData(localPlayer, "player:uid") then return end
    if (getElementData(localPlayer, "player:showingGUI") and getElementData(localPlayer, "player:showingGUI") ~= "interaction") then return end
    if isPedInVehicle(localPlayer) then return end
if interaction.enabled == false then 
    setElementData(localPlayer, "player:showingGUI", "interaction")
    exports["pd-hud"]:addNotification("Włączyłeś tryb interakcji. Kliknij E by wyłączyć.", "info", 5000, nil, "info")
    showCursor(true, false)
    addEventHandler("onClientClick", root, klik)
    addEventHandler("onClientRender", root, interaction.gui)
    interaction.enabled = true
    interaction.type = false
    interaction.element = false
else
    setElementData(localPlayer, "player:showingGUI", false)
    exports["pd-hud"]:addNotification("Wyłączyłeś tryb interakcji.", "info", 5000, nil, "info")
    showCursor(false)
    removeEventHandler("onClientClick", root, klik)
    removeEventHandler("onClientRender", root, interaction.gui)
    interaction.enabled = false
    interaction.type = false
    interaction.element = false
    end
end

bindKey("E", "down", interaction.open)


function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
    local sx, sy = guiGetScreenSize ( )
    local cx, cy = getCursorPosition ( )
    local cx, cy = ( cx * sx ), ( cy * sy )
    if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
        return true
    else
        return false
    end
end