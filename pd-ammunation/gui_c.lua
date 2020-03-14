local sx, sy = guiGetScreenSize()
local zoom = exports["pd-gui"]:getInterfaceZoom()
local button = dxCreateTexture("images/button.png")

info = [[Witaj na strzelnicy, w tym miejscu możesz się sprawdzić lub przystąpić do testu na zdanie licencji na broń.
		Licencja na broń jest potrzebna do niektórych prac które dostępne są na serwerze.
		Jeżeli jesteś zwykłym cywilem to po zdaniu tej licencji nie będziesz mógł kupić broni, tylko odblokujesz prace które tej licencji wymagają.
		Broń będziesz mógł zakupić dopiero gdy dołączysz do jakiejś organizacji przestępczej.
		Koszt takiej licencji to $1000, trening oczywiście jest darmowy.]]

function renderLicenseGUI()
	dxDrawImage(sx/2 - 1000/zoom/2, sy/2 - 260/zoom/2, 1000/zoom, 260/zoom, "images/shootrange_window.png")
	dxDrawText(info, sx/2 - 950/zoom/2, sy/2 - 220/zoom/2, sx, sy, white, 0.85/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
	exports["pd-gui"]:renderButton(startTestButton)
	exports["pd-gui"]:renderButton(trainingButton)
	exports["pd-gui"]:renderButton(cancelButton)
end

function renderLicense()
	dxDrawImage(sx/2 - 500/zoom/2, sy - 250/zoom, 500/zoom, 150/zoom, "images/shootrange_window.png")
	dxDrawText("Runda " .. round, sx/2, sy - 240/zoom, sx/2, sy, tocolor(255, 0, 155, 255), 1.2/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	dxDrawText("Pozostały czas: " .. timeLeft .. " sekund", sx/2, sy - 200/zoom, sx/2, sy, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	dxDrawText("Pudła " .. missShots .. "/3", sx/2, sy - 150/zoom, sx/2, sy, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	startTestButton = exports["pd-gui"]:createButton("Przystąp do testu", sx/2 - 450/zoom, sy/2 + 50/zoom, 170/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(startTestButton, {default=button, hover=button, press=button})
	exports["pd-gui"]:setButtonFont(startTestButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", startTestButton, function()
		local addData = getElementData(localPlayer, "player:addData")
		if not addData["license:weapon"] then
			if getPlayerMoney(localPlayer) >= 1000 then
				hideLicenseGUI()
				startLicenseTest()
				exports["pd-core"]:takeMoney(1000)
				setElementData(localPlayer, "player:licensestarted", 1000)
			else
				exports["pd-hud"]:showPlayerNotification("Nie posiadasz tyle pieniędzy.", "error")
			end
		else
			exports["pd-hud"]:showPlayerNotification("Już posiadasz licencję na broń.", "error")
		end
	end)

	trainingButton = exports["pd-gui"]:createButton("Trening", sx/2 - 170/zoom/2, sy/2 + 50/zoom, 170/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(trainingButton, {default=button, hover=button, press=button})
	exports["pd-gui"]:setButtonFont(trainingButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", trainingButton, function()
		hideLicenseGUI()
		startLicenseTest()
		setElementData(localPlayer, "player:licensestarted", 0)
	end)

	cancelButton = exports["pd-gui"]:createButton("Anuluj", sx/2 + 280/zoom, sy/2 + 50/zoom, 170/zoom, 40/zoom)
	exports["pd-gui"]:setButtonTextures(cancelButton, {default=button, hover=button, press=button})
	exports["pd-gui"]:setButtonFont(cancelButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", cancelButton, function()
		hideLicenseGUI()
	end)
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports["pd-gui"]:destroyButton(startTestButton)
	exports["pd-gui"]:destroyButton(trainingButton)
	exports["pd-gui"]:destroyButton(cancelButton)
end)

function showLicenseGUI()
	showCursor(true)
	addEventHandler("onClientRender", root, renderLicenseGUI)
end

function hideLicenseGUI()
	showCursor(false)
	removeEventHandler("onClientRender", root, renderLicenseGUI)
end