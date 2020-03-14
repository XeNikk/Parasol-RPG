local startPosition = Vector3(225.13629150391, 1449.0998535156, 13.42812538147)
local endPosition = Vector3(5350.2690429688, 327.71505737305, 845.99237060547)
local regenerationPosition = Vector3(5348.79296875, 314.90051269531, 845.99237060547)
local backgroundSound = playSound("sounds/background.mp3", true)
local breathSound = playSound("sounds/breath.mp3", true)
setSoundVolume(backgroundSound, 0)
setSoundVolume(breathSound, 0)

addEventHandler("onClientResourceStart", resourceRoot, function()
	_, markerID01 = exports["pd-markers"]:createCustomMarker(startPosition.x, startPosition.y, startPosition.z - 1, 50, 255, 50, 155, "marker", 2.5)
	local col = createColSphere(startPosition.x, startPosition.y, startPosition.z, 4)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			if getElementData(localPlayer, "player:job") then 
				exports["pd-hud"]:showPlayerNotification("Już pracujesz!", "error")
				return
			end 
			showJobGUI()
		end
	end)
	local col = createColSphere(endPosition.x, endPosition.y, endPosition.z, 2)
	setElementDimension(col, 2)
	_, markerID02 = exports["pd-markers"]:createCustomMarker(endPosition.x, endPosition.y, endPosition.z - 1, 50, 255, 50, 155, "marker", 1)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			exitConfirmation = exports["pd-gui"]:createConfirmationWindow("Czy na pewno chcesz opuścić pracę?")
			showCursor(true)

			addEventHandler("onClientAcceptConfirmation", exitConfirmation, function()
				exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
				showCursor(false)
				endJob()
			end)
			addEventHandler("onClientDenyConfirmation", exitConfirmation, function()
				exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
				showCursor(false)
			end)
		end
	end)
	addEventHandler("onClientColShapeLeave", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
		end
	end)
	_, markerID03 = exports["pd-markers"]:createCustomMarker(regenerationPosition.x, regenerationPosition.y, regenerationPosition.z - 1, 50, 185, 255, 155, "marker", 2)
	local col = createColSphere(regenerationPosition.x, regenerationPosition.y, regenerationPosition.z, 2)
	setElementDimension(col, 2)
	addEventHandler("onClientColShapeHit", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			regenerating = true
		end
	end)
	addEventHandler("onClientColShapeLeave", col, function(el, md)
		if el == localPlayer and md and not isPedInVehicle(el) then 
			regenerating = false
		end
	end)
end)

addEventHandler("onClientRender", root, function()
	exports["pd-gui"]:renderConfirmationWindow(exitConfirmation)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports["pd-markers"]:destroyCustomMarker(markerID01)
	exports["pd-markers"]:destroyCustomMarker(markerID02)
	exports["pd-markers"]:destroyCustomMarker(markerID03)
	exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
	if getElementData(localPlayer, "player:job") then
		fastEndJob()
		exports["pd-hud"]:showPlayerNotification("Praca w której pracowałeś została przeładowana przez administrację. Przepraszamy za utrudnienia.", "error", 15000)
	end
end)

function startJob()
	if (isPedInVehicle(localPlayer)) then
		exports["pd-hud"]:showPlayerNotification("Wysiądź z pojazdu!", "error")
		return
	end
	setJetpackMaxHeight(10000)
	exports["pd-loading"]:showLoading("Wczytywanie Marsa", 5000)
	setTimer(function()
		exports["pd-mars"]:loadMarsMap()
		loadJobModels()
		setElementPosition(localPlayer, 5351.1708984375, 320.58267211914, 845.99237060547)
		setElementFrozen(localPlayer, true)
		triggerServerEvent("setDimension", resourceRoot, localPlayer, 2)
		triggerServerEvent("setSkin", resourceRoot, localPlayer, 311)
		triggerServerEvent("giveJetpack", resourceRoot, localPlayer)
		setGravity(0.002)
		setElementData(localPlayer, "player:job", "astronaut")
	end, 1000, 1)
	setTimer(function()
		setElementFrozen(localPlayer, false)
		setElementPosition(localPlayer, 5351.1708984375, 320.58267211914, 845.99237060547)
		setSoundVolume(backgroundSound, 1)
		setSoundVolume(breathSound, 1)
	end, 5000, 1)
end

function fastEndJob()
	if exitConfirmation then 
		exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
	end
	toggleControl("fire", false)
	toggleControl("aim_weapon", false)
end

function endJob()
	toggleControl("fire", false)
	toggleControl("aim_weapon", false)
	if exitConfirmation then 
		exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
	end 
	exports["pd-gui"]:destroyConfirmationWindow(exitConfirmation)
	showCursor(false)
	setElementData(localPlayer, "player:job", false)
	exports["pd-loading"]:showLoading("Wczytywanie świata", 5000)
	setSoundVolume(backgroundSound, 0)
	setSoundVolume(breathSound, 0)
	setTimer(function()
		exports["pd-mars"]:unloadMarsMap()
		unloadJobModels()
		setGravity(0.008)
		triggerServerEvent("setSkin", resourceRoot, localPlayer, getElementData(localPlayer, "player:skin"))
		triggerServerEvent("removeJetpack", resourceRoot, localPlayer)
		triggerServerEvent("setDimension", resourceRoot, localPlayer, 0)
		setElementPosition(localPlayer, startPosition.x, startPosition.y, startPosition.z)
		setElementFrozen(localPlayer, true)
	end, 1000, 1)
	setTimer(function()
		setElementFrozen(localPlayer, false)
		triggerServerEvent("removeJetpack", resourceRoot, localPlayer)
		triggerServerEvent("setSkin", resourceRoot, localPlayer, getElementData(localPlayer, "player:skin"))
	end, 5000, 1)
end

function loadJobModels()
	engineImportTXD(engineLoadTXD("models/chnsaw.txd"), 341)
	engineReplaceModel(engineLoadDFF("models/chnsaw.dff"), 341)

	engineImportTXD(engineLoadTXD("models/jetpack.txd"), 370)
	engineReplaceModel(engineLoadDFF("models/jetpack.dff"), 370)

	engineImportTXD(engineLoadTXD("models/skin311.txd"), 311)
	engineReplaceModel(engineLoadDFF("models/skin311.dff"), 311)
end

function unloadJobModels()
	engineRestoreModel(341)
	engineRestoreModel(370)
	engineRestoreModel(311)
end

if getElementData(localPlayer, "player:job") == "astronaut" then
	startJob()
end