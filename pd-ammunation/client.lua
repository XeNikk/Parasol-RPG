_, licenseStart = exports["pd-markers"]:createCustomMarker(286.13137817383, -30.473972320557, 1001.515625 - 1, 255, 0, 0, 255, "marker", 1)
local col = createColSphere(286.13137817383, -30.473972320557, 1001.515625, 1)
dimension = getElementData(localPlayer, "player:uid")
local licenseObjects = {}
missShots = 0
round = 1
timeLeft = 10
addEventHandler("onClientColShapeHit", col, function(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) then 
		showLicenseGUI()
	end
end)
addEventHandler("onClientColShapeLeave", col, function(el, md)
	if el == localPlayer and md and not isPedInVehicle(el) then 
		hideLicenseGUI()
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	local cost = getElementData(localPlayer, "player:licensestarted")
	if cost then
		stopLicenseTest()
		if cost > 0 then
			exports["pd-core"]:giveMoney(cost)
			exports["pd-hud"]:showPlayerNotification("Test licencji na broń został przeładowany, twoje pieniądze zostały zwrócone.", "error")
		end
	end
end)

addEventHandler("onClientPlayerWeaponFire", root, function(weapon, ammo, ammoleft, x, y, z, hitElement)
	if source == localPlayer and getElementData(localPlayer, "player:licensestarted") then
		local shotObject = false
		for k,v in pairs(licenseObjects) do
			if hitElement == v then
				shotObject = true
				destroyElement(v)
				v = nil
				break
			end
		end
		if shotObject then
			playSound("sounds/hit.wav")
		else
			playSound("sounds/fail.wav")
			missShots = missShots + 1
			if missShots > 3 then
				stopLicenseTest()
				exports["pd-hud"]:showPlayerNotification("Zbyt dużo razy spudłowałeś.", "error")
			end
		end
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	exports["pd-markers"]:destroyCustomMarker(licenseStart)
end)

function buildObject(...)
	local id = #licenseObjects+1
	licenseObjects[id] = createObject(...)
	dimension = getElementData(localPlayer, "player:uid")
	setElementDimension(licenseObjects[id], dimension)
	setElementInterior(licenseObjects[id], 1)
	return licenseObjects[id]
end

function createTarget(x, y, z, tx, ty, tz, time)
	local parent = buildObject(1587, x, y, z)
	for id = 1588, 1592 do
		local object = buildObject(id, 0, 0, 0)
		attachElements(object, parent)
	end
	moveObject(parent, 10000, tx, ty, tz)
	setTimer(function(target)
		if isElement(target) then
			setElementPosition(target, 999, 999, 999)
		end
	end, time * 1000 + 500, 1, parent)
end

setTimer(function()
	timeLeft = timeLeft - 1
end, 1000, 0)

function startLicenseTest()
	missShots = 0
	round = 1
	timeLeft = 10
	setPlayerHudComponentVisible("crosshair", true)
	setElementPosition(localPlayer, 293.69619750977, -24.662231445313, 1001.515625)
	dimension = getElementData(localPlayer, "player:uid")
	triggerServerEvent("setDimension", resourceRoot, localPlayer, dimension)
	triggerServerEvent("giveWeapon", resourceRoot, localPlayer, 22)
	addEventHandler("onClientRender", root, renderLicense)
	createTarget(292.48553466797, -7.6125802993774, 1002, 292.48553466797, -15.6125802993774, 1002, 10)
	timer1 = setTimer(function()
		local destroyedAll = true
		for k,v in pairs(licenseObjects) do
			if isElement(v) and getElementModel(v) >= 1588 then
				destroyedAll = false
				break
			end
		end
		if destroyedAll then
			createTarget(297.48553466797, -7.6125802993774, 1002, 297.48553466797, -15.6125802993774, 1002, 10)
			createTarget(287.48553466797, -7.6125802993774, 1002, 287.48553466797, -15.6125802993774, 1002, 10)
			round = 2
			timeLeft = 10
		else
			stopLicenseTest()
			exports["pd-hud"]:showPlayerNotification("Zbyt wolno.", "error")
		end
		timer1 = false
	end, 10500, 1)
	timer2 = setTimer(function()
		local destroyedAll = true
		for k,v in pairs(licenseObjects) do
			if isElement(v) and getElementModel(v) >= 1588 then
				destroyedAll = false
				break
			end
		end
		if destroyedAll then
			createTarget(292.48553466797, -7.6125802993774, 1002, 292.48553466797, -15.6125802993774, 1002, 15)
			createTarget(297.48553466797, -7.6125802993774, 1002, 297.48553466797, -15.6125802993774, 1002, 15)
			createTarget(287.48553466797, -7.6125802993774, 1002, 287.48553466797, -15.6125802993774, 1002, 15)
			round = 3
			timeLeft = 15
		else
			stopLicenseTest()
			exports["pd-hud"]:showPlayerNotification("Zbyt wolno.", "error")
		end
		timer2 = false
	end, 21000, 1)
	timer3 = setTimer(function()
		local destroyedAll = true
		for k,v in pairs(licenseObjects) do
			if isElement(v) and getElementModel(v) >= 1588 then
				destroyedAll = false
				break
			end
		end
		if destroyedAll then
			local cost = getElementData(localPlayer, "player:licensestarted")
			if cost then
				if cost > 0 then
					exports["pd-hud"]:showPlayerNotification("Egzamin zaliczony!", "success")
					local addData = getElementData(localPlayer, "player:addData")
					addData["license:weapon"] = true
					setElementData(localPlayer, "player:addData", addData)
				end
			end
			stopLicenseTest()
		else
			stopLicenseTest()
			exports["pd-hud"]:showPlayerNotification("Zbyt wolno.", "error")
		end
		timer3 = false
	end, 35500, 1)
end

function stopLicenseTest()
	if timer1 then killTimer(timer1) end
	if timer2 then killTimer(timer2) end
	if timer3 then killTimer(timer3) end
	removeEventHandler("onClientRender", root, renderLicense)
	setPlayerHudComponentVisible("crosshair", false)
	setElementPosition(localPlayer, 286.13137817383, -30.473972320557, 1001.515625)
	dimension = getElementData(localPlayer, "player:uid")
	triggerServerEvent("setDimension", resourceRoot, localPlayer, 0)
	triggerServerEvent("takeWeapon", resourceRoot, localPlayer, 22)
	setElementData(localPlayer, "player:licensestarted", false)
	for k,v in pairs(licenseObjects) do
		if isElement(v) then
			destroyElement(v)
		end
	end
end