local painterElements = {}
local painterPlaces = {
	{838.87365722656, -1176.7681884766, 16.983539581299, 841.18914794922, -1177.3374023438, 16.983539581299},
}

for k,v in pairs(painterPlaces) do
	text3d = createElement("3dtext")
	setElementPosition(text3d, v[1], v[2], v[3] - 0.5)
	setElementData(text3d, "3dtext", "Wolne stanowisko")

	col = createColSphere(v[1], v[2], v[3], 1)
	colpainter = createColSphere(v[4], v[5], v[6], 3)
	setElementData(col, "painterSphere", {colpainter, text3d})
	setElementData(col, "painter:owner", "Brak")
	table.insert(painterElements, {col, text3d})
end

addEvent("reservePainterPlace", true)
addEventHandler("reservePainterPlace", resourceRoot, function(plr, place)
	if getElementData(plr, "player:workshop:duty") then
		if not getElementData(plr, "player:placeReserved") then
			local data = getElementData(place, "painterSphere")
			setElementData(data[2], "3dtext", "Stanowisko #ff00cc" .. getPlayerName(plr))
			setElementData(place, "painter:owner", getPlayerName(plr))
			exports["pd-hud"]:showPlayerNotification(plr, "Zajmujesz wolne stanowisko!", "success")
			setElementData(plr, "player:placeReserved", data[1])
		else
			exports["pd-hud"]:showPlayerNotification(plr, "Posiadasz już zajęte stanowisko!", "error")
		end
	else
		exports["pd-hud"]:showPlayerNotification(plr, "Nie jesteś na służbie lakiernika!", "error")
	end
end)

setTimer(function()
	for k,v in pairs(painterElements) do
		local x, y, z = getElementPosition(v[1])
		local owner = getElementData(v[1], "painter:owner")
		if owner ~= "Brak" then
			local plr = getPlayerFromName(owner)
			if plr then
				local px, py, pz = getElementPosition(plr)
				if getDistanceBetweenPoints3D(x, y, z, px, py, pz) > 10 then
					setElementData(v[1], "painter:owner", "Brak")
					setElementData(v[2], "3dtext", "Wolne stanowisko")
					setElementData(plr, "player:placeReserved", false)
					exports["pd-hud"]:showPlayerNotification(plr, "Opuściłeś swoje stanowisko!", "error")
				end
			else
				setElementData(v[1], "painter:owner", "Brak")
				setElementData(v[2], "3dtext", "Wolne stanowisko")
			end
		end
	end
end, 1000, 0)