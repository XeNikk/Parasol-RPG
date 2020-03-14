sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()


preview = {
    enabled = false
}

preview.tex_preview_background = dxCreateTexture("images/preview/background.png")
preview.tex_preview_color = dxCreateTexture("images/preview/color.png")
preview.tex_preview_button = dxCreateTexture("images/preview/button.png")

preview.draw = function()
    --if getPlayerName(localPlayer) ~= "XeNik2" then return end
    --dxDrawImage(0,0,sx,sy, "ss.png")
    dxDrawImage(sx/2-370/zoom, sy/2-275/zoom, 740/zoom, 550/zoom, preview.tex_preview_background)
    dxDrawText(getVehicleNameFromModel(preview.model), sx/2-355/zoom, sy/2-265/zoom, sx/2-355/zoom, sy/2-265/zoom, tocolor(214,0,243,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "left", "top")

    dxDrawText("Przebieg: "..preview.mileage.." km\nPojemność silnika: "..preview.dm.." dm3\nUlepszenie silnika: "..preview.up.."/5\nRegulacja zawieszenia: "..preview.gz.."\nHydraulika: "..preview.hydra.."\nNitro: "..preview.nitro.."\nTurbosprężarka: "..preview.turbo.."\nTyp pojazdu: Osobowe\nNapęd: "..preview.driveType.."\nTyp paliwa: "..preview.fueltype.."\nInstalacja LPG: "..preview.lpg.."", sx/2-355/zoom, sy/2-225/zoom, sx/2-355/zoom, sy/2-225/zoom, tocolor(255,255,255,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top")
    dxDrawImage(sx/2+200/zoom, sy/2-245/zoom, 140/zoom, 140/zoom, ":pd-vehicles-store/images/klasy/"..preview.class..".png")
    dxDrawText("Klasa pojazdu", sx/2+268/zoom, sy/2-110/zoom,  sx/2+268/zoom,  sy/2-110/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")

exports["pd-gui"]:renderButton(button)
end
--addEventHandler("onClientRender", root, preview.draw)

bindKey("mouse1", "down", function()
    if not preview.enabled == true then return end
    if isMouseIn(sx/2-75/zoom, sy/2+210/zoom, 148/zoom, 47/zoom) then 
        if getElementData(localPlayer, "player:uid") == preview.owneruid then 
            exports["pd-hud"]:addNotification("Zabrałeś pojazd z giełdy.", "info", 5000, nil, "info")
        triggerServerEvent("exchange:removeVehicle", localPlayer, localPlayer, preview.vehicle)
        preview.close()
        else 
            if getPlayerMoney(localPlayer) < tonumber(preview.price) then exports["pd-hud"]:addNotification("Nie posiadasz wystarczającej kwoty!", "error", 5000, nil, "error") return end
            triggerServerEvent("exchange:removeVehicle", localPlayer, localPlayer, preview.vehicle)
            triggerServerEvent("exchange:buyVehicle", localPlayer, localPlayer, preview.vehicle, preview.price, preview.sprzedajacy)
            preview.close()
        end
end
end)


preview.open = function(plr,owner, vid, model, mileage, dm, fueltype, naped, class, vehicle, price, sprzedawca, owneruid)
    if getElementData(localPlayer, "player:uid") == owneruid then 
        exports["pd-gui"]:setButtonText(button, "Zabierz")
    else
        exports["pd-gui"]:setButtonText(button, "Kup")
    end


    addEventHandler("onClientRender", root, preview.draw)
    showCursor(true, false)

    preview.enabled = true
    preview.vehicle = vehicle
    preview.vid = vid
    preview.owner = owner
    preview.model = model 
    preview.mileage = mileage 
    preview.dm = dm
    preview.fueltype = fueltype
    preview.drive = naped 
    preview.class = class
    preview.price = price
    preview.sprzedajacy = sprzedawca
    preview.owneruid = owneruid
    preview.up = 0
    preview.handling = getVehicleHandling(vehicle)
    

		for i = 1, 5 do
			if string.find(getElementData(preview.vehicle, "vehicle:addTuning"), "us" .. i) then
				preview.up = preview.up + 1
			end
        end
        if string.find(getElementData(preview.vehicle, "vehicle:addTuning"), "gz") then 
            preview.gz = "Tak"
        else
            preview.gz = "Nie"
        end
        if string.find(getElementData(preview.vehicle, "vehicle:addTuning"), "turbo") then 
            preview.turbo = "Tak"
        else
            preview.turbo = "Nie"
        end
        if string.find(getElementData(preview.vehicle, "vehicle:addTuning"), "lpg") then 
            preview.lpg = "Tak"
        else
            preview.lpg = "Nie"
        end
        
        if preview.handling["driveType"] == "fwd" then 
            preview.driveType = "FWD"
        elseif preview.handling["driveType"] == "rwd" then
            preview.driveType = "RWD"
        elseif preview.handling["driveType"] == "awd" then 
            preview.driveType = "AWD"
        end

        if getVehicleUpgradeOnSlot(preview.vehicle, 8) == 0 then
            preview.nitro = "Nie"
        else
            preview.nitro = "Tak"
        end

        if getVehicleUpgradeOnSlot(preview.vehicle, 9) == 0 then
            preview.hydra = "Nie"
        else
            preview.hydra = "Tak"
        end
end
addEvent("exchange:previewOpen", true)
addEventHandler("exchange:previewOpen", root, preview.open)


preview.close = function(plr)

    removeEventHandler("onClientRender", root, preview.draw)
    showCursor(false)
    preview.enabled = false
    preview.model = false 
    preview.mileage = false 
    preview.dm = false
    preview.fueltype = false
    preview.drive = false 
    preview.class = false
    preview.vehicle = false
    preview.price = false
    preview.sprzedajacy = false
    preview.owneruid = false
end
addEvent("exchange:previewClose", true)
addEventHandler("exchange:previewClose", root, preview.close)


addEventHandler("onClientResourceStart", resourceRoot, function()
    button = exports["pd-gui"]:createButton("", sx/2-75/zoom, sy/2+210/zoom, 148/zoom, 47/zoom)
	exports["pd-gui"]:setButtonTextures(button, {default=":pd-vehicles-exchange/images/store/button.png", hover=":pd-vehicles-exchange/images/store/button.png", press=":pd-vehicles-exchange/images/store/button.png"})
	exports["pd-gui"]:setButtonFont(button, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports["pd-gui"]:destroyButton(button)
end)


addEvent("exchange:noti", true)
addEventHandler("exchange:noti", root, function(plr, type, text)
if plr == localPlayer then 
    exports["pd-hud"]:addNotification(text, type, 5000, nil, type)

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