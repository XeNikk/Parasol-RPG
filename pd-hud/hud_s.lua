advertsQueue = {}

setTimer(function()
	local ad = {}
	for k,v in pairs(advertsQueue) do
		v[3] = k
		table.insert(ad, v)
	end
	if ad[1] then
		triggerClientEvent(root, "hud:addAdvert", root, ad[1][1], ad[1][2])
		table.remove(advertsQueue, ad[1][3])
	end
end, 10000, 0)

addCommandHandler("ogloszenie", function(plr, cmd, ...)
    if not getElementData(plr, "player:premium") == true then addNotification("Nie posiadasz statusu premium.", "error", 5000, nil, "error") return end
    local text = table.concat({...}, " " )
    if not ... then showPlayerNotification(plr, "Poprawne użycie:\n/ogloszenie [Treść].", "error", 5000, nil, "error") return end
	if string.len(text) < 3 then showPlayerNotification(plr, "Twoje ogłoszenie jest zbyt krótkie.", "error", 5000, nil, "error") return end
	table.insert(advertsQueue, {plr, text})
	showPlayerNotification(plr, "Dodano ogłoszenie do kolejki!", "success", 5000, nil, "success")
end)