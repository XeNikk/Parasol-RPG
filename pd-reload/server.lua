resourceNames = {
	["pd-vehicles"] = "Pojazdy prywatne",
	["pd-core"] = "Core",
	["pd-cshop"] = "Przebieralnia",
	["pd-hud"] = "HUD",
	["pd-gui"] = "GUI (zalecany relog)",
	["pd-mars"] = "Mapa Mars",
	["pd-models"] = "Modele",
	["pd-vehicles-shop"] = "Salony",
	["pd-faggio"] = "Pojazdy publiczne",
}

waitingForReload = {}

addEventHandler("onResourceStop", root, function(stoppedResource)
	local resourceName = getResourceName(stoppedResource)
	if resourceNames[resourceName] then
		exports["pd-hud"]:showGlobalNotification("Zasób " .. resourceNames[resourceName] .. " został przeładowany, przepraszamy za utrudnienia.", "error", "error", 10000, "error")
	end
end)