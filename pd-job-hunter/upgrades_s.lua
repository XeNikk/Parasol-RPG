addEvent("onPlayerBuyUpgrade", true)
addEventHandler("onPlayerBuyUpgrade", resourceRoot, function(id, cost)
	if exports["pd-jobsettings"]:addPlayerJobUpgrade(client, "hunter", id, cost) then 
		exports["pd-hud"]:showPlayerNotification(client, "Zakupiono ulepszenie pomyślnie.", "success")
	else 
		exports["pd-hud"]:showPlayerNotification(client, "Nie stać cię na to ulepszenie.", "error")
	end
end)