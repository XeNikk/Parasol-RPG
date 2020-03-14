sx, sy = guiGetScreenSize()
zoom = exports["pd-gui"]:getInterfaceZoom()


addEventHandler("onClientColShapeHit", resourceRoot, function(el, md)
    if el~=localPlayer or not md then return end
    if isPedInVehicle(el) then return end
    
    data = getElementData(source, "house:data")
    if data["state"] == 1 then 
        zamek = "otwarty"
    else
        zamek = "zamkniety"
    end
    lokatorzy = getTableFromString(data["occupants"])
    warppos = split(data["entranceTP"], ",")
    addEventHandler("onClientRender", root, houseGUI)
    showCursor(true)
    triggerServerEvent("house:checkHouseAffiliation", localPlayer, localPlayer, data["id"])
end)

addEventHandler("onClientColShapeLeave", resourceRoot, function(el, md)
    if el~=localPlayer or not md then return end
    if isPedInVehicle(el) then return end
    gui = false
    data = false
    warppos = false
    lokatorzy = false
    table_occupants = false
    removeEventHandler("onClientRender", root, houseGUI)
    showCursor(false)
end)

function openGUI(bool)
    if bool == "main" then 
        if data["owner"] == getElementData(localPlayer, "player:uid") then 
            gui = "main"
        else
            gui = "podglad"
        end
    end
    if bool == "free" then 
        gui = "free"
    end
end
addEvent("house:openGUI", true)
addEventHandler("house:openGUI", root, openGUI)

function houseGUI()

dxDrawImage(sx/2-380/zoom, sy/2-250/zoom, 800/zoom, 500/zoom, "images/background.png")
if gui == "main" then
dxDrawImage(sx/2-50/zoom, sy/2-200/zoom, 250/zoom, 250/zoom, "images/icon_house.png")

dxDrawText(data["name"].. " (ID: "..data["id"]..")", sx/2+75/zoom, sy/2+40/zoom, sx/2+75/zoom, sy/2+40/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center") 

if data["occupants"] == "" then
dxDrawText("Ważny do: "..data["paid"].. "\nOpłata: $"..data["price"].." / tydzień\nZamek: "..zamek, sx/2+75/zoom, sy/2+80/zoom, sx/2+75/zoom, sy/2+80/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
else 
    dxDrawText("Lokatorzy: "..table.concat(lokatorzy, ", ").."\nWażny do: "..data["paid"].. "\nOpłata: $"..data["price"].." / tydzień\nZamek: "..zamek, sx/2+75/zoom, sy/2+80/zoom, sx/2+75/zoom, sy/2+80/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
end


if isMouseIn(sx/2-380/zoom, sy/2-250/zoom, 200/zoom, 50/zoom) then
    dxDrawImage(sx/2-380/zoom, sy/2-250/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
else
    dxDrawImage(sx/2-380/zoom, sy/2-250/zoom, 200/zoom, 50/zoom, "images/option_background.png")
end
dxDrawText("Wejdź", sx/2-275/zoom, sy/2-240/zoom, sx/2-275/zoom, sy/2-240/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

if isMouseIn(sx/2-380/zoom, sy/2-200/zoom, 200/zoom, 50/zoom) then
    dxDrawImage(sx/2-380/zoom, sy/2-200/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
else
    dxDrawImage(sx/2-380/zoom, sy/2-200/zoom, 200/zoom, 50/zoom, "images/option_background.png")
end
dxDrawText("Zamek", sx/2-275/zoom, sy/2-190/zoom, sx/2-275/zoom, sy/2-190/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")


if isMouseIn(sx/2-380/zoom, sy/2-150/zoom, 200/zoom, 50/zoom) then
    dxDrawImage(sx/2-380/zoom, sy/2-150/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
else
    dxDrawImage(sx/2-380/zoom, sy/2-150/zoom, 200/zoom, 50/zoom, "images/option_background.png")
end
    if data["free"] == true then 
        dxDrawText("Wykup dom", sx/2-275/zoom, sy/2-140/zoom, sx/2-275/zoom, sy/2-140/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    else
        dxDrawText("Przedłuż ważność", sx/2-275/zoom, sy/2-140/zoom, sx/2-275/zoom, sy/2-140/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    end

    if isMouseIn(sx/2-380/zoom, sy/2-100/zoom, 200/zoom, 50/zoom) then
        dxDrawImage(sx/2-380/zoom, sy/2-100/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
    else
        dxDrawImage(sx/2-380/zoom, sy/2-100/zoom, 200/zoom, 50/zoom, "images/option_background.png")
    end
    dxDrawText("Sprzedaj dom", sx/2-275/zoom, sy/2-90/zoom, sx/2-275/zoom, sy/2-90/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    
    if isMouseIn(sx/2-380/zoom, sy/2-50/zoom, 200/zoom, 50/zoom) then
        dxDrawImage(sx/2-380/zoom, sy/2-50/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
    else
        dxDrawImage(sx/2-380/zoom, sy/2-50/zoom, 200/zoom, 50/zoom, "images/option_background.png")
    end
    dxDrawText("Dodaj lokatora", sx/2-275/zoom, sy/2-40/zoom, sx/2-275/zoom, sy/2-40/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    if isMouseIn(sx/2-380/zoom, sy/2, 200/zoom, 50/zoom) then
        dxDrawImage(sx/2-380/zoom, sy/2, 200/zoom, 50/zoom, "images/option_background_on.png")
    else
        dxDrawImage(sx/2-380/zoom, sy/2, 200/zoom, 50/zoom, "images/option_background.png")
    end
    dxDrawText("Usuń lokatora", sx/2-275/zoom, sy/2+10/zoom, sx/2-275/zoom, sy/2+10/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    if isMouseIn(sx/2-380/zoom, sy/2+50/zoom, 200/zoom, 50/zoom) then
        dxDrawImage(sx/2-380/zoom, sy/2+50/zoom, 200/zoom, 50/zoom, "images/option_background_on.png")
    else
        dxDrawImage(sx/2-380/zoom, sy/2+50/zoom, 200/zoom, 50/zoom, "images/option_background.png")
    end
    dxDrawText("Anuluj", sx/2-275/zoom, sy/2+60/zoom, sx/2-275/zoom, sy/2+60/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")


elseif gui == "buy" then 

    dxDrawText("Wybór płatności", sx/2+20/zoom, sy/2-230/zoom, sx/2+20/zoom, sy/2-230/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center")
    dxDrawImage(sx/2-275/zoom, sy/2-180/zoom, 250/zoom, 250/zoom, "images/money.png")
    dxDrawImage(sx/2+50/zoom, sy/2-180/zoom, 250/zoom, 250/zoom, "images/star.png")

    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2-210/zoom, sy/2+80/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("$"..data["price"], sx/2-148/zoom, sy/2+86/zoom, sx/2-148/zoom, sy/2+86/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2+120/zoom, sy/2+80/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText(data["pricePP"].. " PP", sx/2+184/zoom, sy/2+86/zoom, sx/2+184/zoom, sy/2+86/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

elseif gui == "sell" then 

    dxDrawText("Sprzedaż domu", sx/2+20/zoom, sy/2-230/zoom, sx/2+20/zoom, sy/2-230/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center")

    dxDrawImage(sx/2-115/zoom, sy/2-180/zoom, 250/zoom, 250/zoom, "images/money.png")
    dxDrawImage(sx/2-50/zoom, sy/2+75/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("$"..math.floor(data["price"]/2), sx/2+12/zoom, sy/2+82/zoom, sx/2+12/zoom, sy/2+82/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

elseif gui == "free" then 

    dxDrawText("Wybór płatności", sx/2+20/zoom, sy/2-230/zoom, sx/2+20/zoom, sy/2-230/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center")
    dxDrawImage(sx/2-275/zoom, sy/2-180/zoom, 250/zoom, 250/zoom, "images/money.png")
    dxDrawImage(sx/2+50/zoom, sy/2-180/zoom, 250/zoom, 250/zoom, "images/star.png")

    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2-210/zoom, sy/2+80/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("$"..data["price"], sx/2-148/zoom, sy/2+86/zoom, sx/2-148/zoom, sy/2+86/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2+120/zoom, sy/2+80/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText(data["pricePP"].. " PP", sx/2+184/zoom, sy/2+86/zoom, sx/2+184/zoom, sy/2+86/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

elseif gui == "podglad" then
    
    dxDrawImage(sx/2-85/zoom, sy/2-200/zoom, 200/zoom, 200/zoom, "images/icon_house.png")
    dxDrawText(data["name"].. " (ID: "..data["id"]..")\nWłaściciel: "..data["ownername"].."", sx/2+15/zoom, sy/2-10/zoom, sx/2+15/zoom, sy/2-10/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center")
 
    dxDrawImage(sx/2-120/zoom, sy/2+100/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Zapukaj", sx/2-55/zoom, sy/2+106/zoom, sx/2-55/zoom, sy/2+106/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2+20/zoom, sy/2+100/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Wejdź", sx/2+82/zoom, sy/2+106/zoom, sx/2+82/zoom, sy/2+106/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")


elseif gui == "addoccupant" then

    dxDrawImage(sx/2-110/zoom, sy/2-240/zoom, 250/zoom, 250/zoom, "images/icon_house.png")
    dxDrawText("Wpisz dokłady nick gracza do dodania jako współlokator.\nWspółlokatorzy: "..table.concat(lokatorzy, ", ").."", sx/2+15/zoom, sy/2-20/zoom, sx/2+15/zoom, sy/2-20/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    
    dxDrawImage(sx/2-50/zoom, sy/2+100/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Dodaj", sx/2+12/zoom, sy/2+105/zoom, sx/2+12/zoom, sy/2+105/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    exports["pd-gui"]:renderEditbox(addplayer)

elseif gui == "removeoccupant" then

    dxDrawImage(sx/2-110/zoom, sy/2-240/zoom, 250/zoom, 250/zoom, "images/icon_house.png")
    dxDrawText("Wpisz dokłady nick współlokatora do usunięcia.\nWspółlokatorzy: "..table.concat(lokatorzy, ", ").."", sx/2+15/zoom, sy/2-20/zoom, sx/2+15/zoom, sy/2-20/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    
    dxDrawImage(sx/2-50/zoom, sy/2+100/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Usuń", sx/2+12/zoom, sy/2+105/zoom, sx/2+12/zoom, sy/2+105/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    dxDrawImage(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom, "images/gui_button.png")
    dxDrawText("Anuluj", sx/2+12/zoom, sy/2+156/zoom, sx/2+12/zoom, sy/2+156/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
    exports["pd-gui"]:renderEditbox(removeplayer)

end
end

bindKey("mouse1", "down", function()
    if gui == false then return end
        if isMouseIn(sx/2-380/zoom, sy/2-250/zoom, 200/zoom, 50/zoom) and gui == "main" then
            enterHouse()
        elseif isMouseIn(sx/2-380/zoom, sy/2-200/zoom, 200/zoom, 50/zoom) and gui == "main" then
            if data["state"] == 1 then 
                setHouseLocked("close")
            else
                setHouseLocked("open")
            end
        elseif isMouseIn(sx/2-380/zoom, sy/2-150/zoom, 200/zoom, 50/zoom) and gui == "main" then
            gui = "buy"
        elseif isMouseIn(sx/2-50/zoom, sy/2+150/zoom, 125/zoom, 40/zoom) then
            if gui == "buy" or gui == "sell" or gui == "addoccupant" or gui == "removeoccupant" then
            gui = "main"
            end
            if gui == "free" or gui == "podglad" then
                gui = false
                data = false
                warppos = false
                removeEventHandler("onClientRender", root, houseGUI)
                showCursor(false)
            end
        elseif isMouseIn(sx/2-210/zoom, sy/2+80/zoom, 125/zoom, 40/zoom) and gui == "buy" then
            if getPlayerMoney(localPlayer) < data["price"] then outputChatBox("Nie posiadasz tyle gotówki.") return end
            triggerServerEvent("house:validityUpdate", localPlayer, data["id"], localPlayer, data["price"], "money")
            triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
            outputChatBox("Przedłużyłeś ważność domku")
            gui = "main"
        elseif isMouseIn(sx/2+120/zoom, sy/2+80/zoom, 125/zoom, 40/zoom) and gui == "buy" then
            if getElementData(localPlayer, "player:saldoPP") < data["pricePP"] then outputChatBox("Nie posiadasz tyle punktów premium.") return end
            triggerServerEvent("house:validityUpdate", localPlayer, data["id"], localPlayer, data["pricePP"], "PP")
            triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
            outputChatBox("Przedłużyłeś ważność domku")
            gui = "main"
        elseif isMouseIn(sx/2-210/zoom, sy/2+80/zoom, 125/zoom, 40/zoom) and gui == "free" then
            if getPlayerMoney(localPlayer) < data["price"] then outputChatBox("Nie posiadasz tyle gotówki.") return end
            triggerServerEvent("house:buyHouse", localPlayer, data["id"], localPlayer, data["price"], "money")
            triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
            outputChatBox("Zakupiłeś domek")
            gui = "main"
        elseif isMouseIn(sx/2+120/zoom, sy/2+80/zoom, 125/zoom, 40/zoom) and gui == "free" then
            if getElementData(localPlayer, "player:saldoPP") < data["pricePP"] then outputChatBox("Nie posiadasz tyle punktów premium.") return end
            triggerServerEvent("house:buyHouse", localPlayer, data["id"], localPlayer, data["pricePP"], "PP")
            triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
            outputChatBox("Zakupiłeś domek")
            gui = "main"
        elseif isMouseIn(sx/2-380/zoom, sy/2-100/zoom, 200/zoom, 50/zoom) and gui == "main" then
            gui = "sell"
        elseif isMouseIn(sx/2-50/zoom, sy/2+75/zoom, 125/zoom, 40/zoom) and gui == "sell" then
            triggerServerEvent("house:sellHouse", localPlayer, data["id"], localPlayer, math.floor(data["price"]/2))
            gui = false
            data = false
            warppos = false
            removeEventHandler("onClientRender", root, houseGUI)
            showCursor(false)
        elseif isMouseIn(sx/2-380/zoom, sy/2-50/zoom, 200/zoom, 50/zoom) and gui == "main" then
            gui = "addoccupant"
        elseif isMouseIn(sx/2-380/zoom, sy/2, 200/zoom, 50/zoom) and gui == "main" then
            gui = "removeoccupant"
        elseif isMouseIn(sx/2-380/zoom, sy/2+50/zoom, 200/zoom, 50/zoom) and gui == "main" then
            gui = false
            data = false
            warppos = false
            removeEventHandler("onClientRender", root, houseGUI)
            showCursor(false)
        elseif isMouseIn(sx/2-50/zoom, sy/2+100/zoom, 125/zoom, 40/zoom) then
            if gui == "addoccupant" then
            if exports["pd-gui"]:getEditboxText(addplayer) == getPlayerName(localPlayer) then outputChatBox("Nie możesz dodać siebie jako współlokatora.") return end
            if getPlayerFromName(exports["pd-gui"]:getEditboxText(addplayer)) == false then outputChatBox("Nie znaleziono podanego gracza lub nie jest online.") return end
            if table.find(lokatorzy, exports["pd-gui"]:getEditboxText(addplayer)) then outputChatBox("Podany gracz jest już dodany do domku.") return end
            table.insert(lokatorzy, exports["pd-gui"]:getEditboxText(addplayer))
            triggerServerEvent("house:editOccupants", localPlayer, data["id"], getStringFromTable(lokatorzy))
            outputChatBox("Dodałeś "..exports["pd-gui"]:getEditboxText(addplayer).." jako współlokatora.")
            end 

            if gui == "removeoccupant" then 
                if not table.find(lokatorzy, exports["pd-gui"]:getEditboxText(removeplayer)) then outputChatBox("Podany gracz nie jest dodany jako współlokator.") return end
                table.remove(lokatorzy, table.find(lokatorzy, exports["pd-gui"]:getEditboxText(removeplayer)))
                triggerServerEvent("house:editOccupants", localPlayer, data["id"], getStringFromTable(lokatorzy))
                outputChatBox("Usunąłęś wspołlokatora "..exports["pd-gui"]:getEditboxText(removeplayer)..".")
            end
        elseif isMouseIn(sx/2+20/zoom, sy/2+100/zoom, 125/zoom, 40/zoom) and gui == "podglad" then
            enterHouse()
        elseif isMouseIn(sx/2-120/zoom, sy/2+100/zoom, 125/zoom, 40/zoom) and gui == "podglad" then
            local sound = playSound3D("door.mp3", warppos[1], warppos[2], warppos[3], false)
            setElementDimension(sound, data["id"])
            setElementInterior(sound, data["interior"])
    end
end)



function enterHouse()
if data["state"] == 0 then 
    if data["owner"] == getElementData(localPlayer, "player:uid") or table.find(lokatorzy, getPlayerName(localPlayer)) then 
        fadeCamera(false)
        setTimer(function()
            triggerServerEvent("house:enterHouse", localPlayer,localPlayer, warppos[1], warppos[2], warppos[3], data["id"], data["interior"])
            fadeCamera(true)
        end, 2000, 1)
    else 
        outputChatBox("Ten dom jest zamknięty, nie możesz wejść do niego.")
    end
else
    fadeCamera(false)
    setTimer(function()
        triggerServerEvent("house:enterHouse", localPlayer,localPlayer, warppos[1], warppos[2], warppos[3], data["id"], data["interior"])
        fadeCamera(true)
    end, 2000, 1)
end
end

function setHouseLocked(bool)
    if data["free"] == true then 
        outputChatBox("Ten dom nie należy do ciebie.")
    return 
end
    if not data["owner"] == getElementData(localPlayer, "player:uid") then 
        outputChatBox("Ten dom nie należy do ciebie.")
    return 
end
    if bool == "open" then
        data["state"] = 1
        zamek = "otwarty"
        triggerServerEvent("house:setHouseClosed", localPlayer, data["id"], data["state"])
        triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
    end
    if bool == "close" then
        data["state"] = 0
        zamek = "zamkniety"
        triggerServerEvent("house:setHouseClosed", localPlayer, data["id"], data["state"])
        triggerServerEvent("house:reloadHouse", localPlayer, data["id"])
    end
end


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

function getTableFromString(s)
	local t = {}
		for w in string.gmatch(s, "%S+") do
			table.insert(t, w)
		end
	return t
end

function getStringFromTable(t)
	local s = ""
	for k,v in ipairs(t) do
		s = s .. v .. " "
	end
	return s
end

function table.find(tabl,word) 
    if type(tabl) ~= "table" or word == nil then 
    return false 
    else 
    local ret = false 
    for k,v in pairs(tabl) do 
        if v == word then 
        return k 
        end 
    end 
end 
end 


addEventHandler("onClientResourceStop", resourceRoot, function()

    exports["pd-gui"]:destroyEditbox(addplayer)
    exports["pd-gui"]:destroyEditbox(removeplayer)

end)

addEventHandler("onClientResourceStart", resourceRoot, function()

    addplayer = exports["pd-gui"]:createEditbox("", sx/2-130/zoom, sy/2+40/zoom, 300/zoom, 40/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
    local line_texture = dxCreateTexture(":pd-atms/images/edit_line.png")
    exports["pd-gui"]:setEditboxLine(addplayer, line_texture)
    exports["pd-gui"]:setEditboxHelperText(addplayer, "Wprowadź nazwę")

    removeplayer = exports["pd-gui"]:createEditbox("", sx/2-130/zoom, sy/2+40/zoom, 300/zoom, 40/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
    exports["pd-gui"]:setEditboxLine(removeplayer, line_texture)
    exports["pd-gui"]:setEditboxHelperText(removeplayer, "Wprowadź nazwę")

end)


      

