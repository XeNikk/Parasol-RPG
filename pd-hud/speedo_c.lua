-- z neta xd

-- przebieg 
local zoom = exports["pd-gui"]:getInterfaceZoom()
odometerPosX, odometerPosY = 0, 0
defaultOdometerSettings = {
	["scale"] = 1/zoom,
	["style"] = "analog",
	["positionFrom"] = "center",
	["digitPadding"] = 1.65,
	["spaceBetweenDigits"]= 0.2,
	["backgroundPaddingVertical"] = 14/zoom,
	["backgroundPaddingHorizontal"] = 8/zoom,

	-- Colors
	["fontColorRed"] = 255,
	["fontColorGreen"] = 255,
	["fontColorBlue"] = 255,
	["fontColorAlpha"] = 255,

	["fontColor2Red"] = 255,
	["fontColor2Green"] = 0,
	["fontColor2Blue"] = 0,
	["fontColor2Alpha"] = 255,

	-- Odometer
	["tripEnabled"] = true,
	["tripNumberOfDigits"] = 6
}
local s = function(setting,settingType)
	return defaultOdometerSettings[setting]
end

local digitTypeNormal = 0
local digitTypeTripHundred = 1

local timerIntervall = 50
function initiateOdometer()
	screenWidth, screenHeight = guiGetScreenSize()
	--setTimer(calculateDistance,timerIntervall,0)
end
addEventHandler("onClientResourceStart",getResourceRootElement(getThisResource()),initiateOdometer)

-------------
-- Drawing --
-------------

--[[
-- This draws both odometers if the player is in a vehicle.
-- This function is called from the speedometer script's onClientRender handler.
-- ]]
function drawOdometer()
	if not getVehicleFromPlayer(getLocalPlayer()) then
		return
	end
	prepareDrawOdometer("trip")
end

--[[
-- Draw a single digit
--
-- @param   int    x: The x coordinate
-- @param   int    y: The y coordinate
-- @param   float  number: Which number to draw, if in between two digits
-- 				this will be a floating point number
-- @param   int    numberType: If it is the hunderd-meter digit of the trip
-- 				counter or not
-- @param   float  padding: The horizontal distance to the left or right border
-- ]]
function drawOdometerDigit(x,y,number,numberType,padding)
	local bottomNumber = math.ceil(number)
	if bottomNumber > 9 then bottomNumber = 0 end
	local topNumber = math.floor(number)

	local state = number - topNumber
	
	local topBottom = y+fontHeight - fontHeight * state
	local bottomTop = y+fontHeight - fontHeight * state
	
	local fontColor = tocolor(
				s("fontColorRed"),
				s("fontColorGreen"),
				s("fontColorBlue"),
				s("fontColorAlpha"))
	if numberType == digitTypeTripHundred then
		fontColor = tocolor(
				s("fontColor2Red"),
				s("fontColor2Green"),
				s("fontColor2Blue"),
				s("fontColor2Alpha"))
	end
	local fontScale = defaultOdometerSettings["scale"]
	
	dxDrawText( tostring(topNumber), x, y, x+textWidth*padding, topBottom, fontColor,fontScale,exports["pd-gui"]:getGUIFont("normal_small"),"center","bottom",true,false,false)
	dxDrawText( tostring(bottomNumber), x, bottomTop, x+textWidth*padding, y+fontHeight*0.9, fontColor,fontScale,exports["pd-gui"]:getGUIFont("normal_small"),"center","top",true,false,false)
end

--[[
-- Calculates the single digits and draws them, as well
-- as the background.
--
-- @param   string   odometerType: Whether its the trip or total-odometer
-- ]]
function prepareDrawOdometer(odometerType)
	local number = 0
	local numberOfDigits = 0
	local left = 0
	local top = 0
	if odometerType == "trip" then
		if not s("tripEnabled") then
			return false
		end
		number = ((getElementData(getVehicleFromPlayer(getLocalPlayer()), "vehicle:mileage")) or 0)
		left = s("tripLeft")
		top = s("tripTop")
		numberOfDigits = s("tripNumberOfDigits")
	end

	local style = s("style")

	-- settings
	local digitPadding = s("digitPadding")
	local spaceBetweenDigits = s("spaceBetweenDigits")

	local fontScale = defaultOdometerSettings["scale"]

	if style == "analog" then	
	-- get font properties
		fontHeight = dxGetFontHeight(fontScale,exports["pd-gui"]:getGUIFont("normal_small"))
		textWidth = dxGetTextWidth("0",fontScale,exports["pd-gui"]:getGUIFont("normal_small"))
	else
		fontHeight = dxGetFontHeight(fontScale,exports["pd-gui"]:getGUIFont("normal_small"))
		fontWidth = dxGetTextWidth(string.rep("0",numberOfDigits),exports["pd-gui"]:getGUIFont("normal_small"))
	end

	-- calculate stuff from properties and settings
	local digitWidth = textWidth * digitPadding
	--local spaceBetweenDigitsAbsolute = digitWidth * (spaceBetweenDigits)
	local spaceBetweenDigitsAbsolute = 0.1

	
	local backgroundPaddingHorizontal = s("backgroundPaddingHorizontal")
	local backgroundPaddingVertical = s("backgroundPaddingVertical")
	local backgroundWidth = numberOfDigits * (digitWidth + spaceBetweenDigitsAbsolute) + backgroundPaddingHorizontal*2 - spaceBetweenDigitsAbsolute
	
	local posX = odometerPosX
	local posY = odometerPosY
	
	if s("style") == "analog" then

		if odometerType == "total" then
			numberOfDigits = numberOfDigits + 1
		end
	
		-- Calculate single digits
		for i = 1, numberOfDigits, 1 do
		
			local numberToDraw = number % (10^i)
			if i > 1 then
				numberToDraw = numberToDraw / (10^(i - 1))
				if numberToDraw % 1 < tonumber("0."..string.rep("9",i - 1)) then
					numberToDraw = math.floor(numberToDraw)
				else
					numberToDraw = math.floor(numberToDraw) + (numberToDraw * 10^(i-1)) % 1
				end
			end
			local digitType = digitTypeNormal
			if i == 1 and odometerType == "trip" then
				digitType = digitTypeTripHundred
			end
			if odometerType == "trip" or i > 1 then
				-- Draw single digit
				drawOdometerDigit(posX + backgroundPaddingHorizontal + (numberOfDigits - i)*(digitWidth + (spaceBetweenDigitsAbsolute)),posY + backgroundPaddingVertical,numberToDraw,digitType,digitPadding)
			end
		end

	else
		dxDrawText(tostring(round(number)),posX,posY)
	end
	
end

function getVehicleFromPlayer(player)
	local vehicle = getPedOccupiedVehicle(player)
	if vehicle and getVehicleController(vehicle) == player then 
		return vehicle
	end
	
	return false
end

-- licznik 
local screenW, screenH = guiGetScreenSize()

-- pozycje 
local speedoPos = {x=0, y=0, w=math.floor(380/zoom), h=math.floor(380/zoom)}
speedoPos.x = screenW-speedoPos.w-math.floor(80/zoom)
speedoPos.y = screenH-speedoPos.h-math.floor(100/zoom)

odometerPosX = speedoPos.x+speedoPos.w/2-math.floor(63/zoom)
odometerPosY = speedoPos.y+speedoPos.h-math.floor(154/zoom)

local tachoPos = {x=0, y=0, w=math.floor(270/zoom), h=math.floor(277/zoom)}
tachoPos.x = math.floor(speedoPos.x-tachoPos.w/2+15/zoom)
tachoPos.y = math.floor(speedoPos.y+tachoPos.h/2)

local iconsPos = {x=speedoPos.x+speedoPos.w/2, y=speedoPos.y+speedoPos.h-math.floor(100/zoom), w=math.floor(34/zoom), h=math.floor(34/zoom)}

local fuelPos = {x=speedoPos.x+speedoPos.w, y=speedoPos.y, w=math.floor(71/zoom*0.65), h=math.floor(355/zoom*0.65)}
fuelPos.y = math.floor(fuelPos.y-fuelPos.h/2+speedoPos.h/2)
-- zmienne 
local textures = {}

function renderSpeedo()	
	local vehicle = getVehicleFromPlayer(localPlayer)
	if vehicle then 
		if not textures.background then return end
		local light = (getVehicleOverrideLights(vehicle) == 2) and "_light" or ""
		
		if not getElementData(localPlayer, "settings:rpm") then
			local rpm = ((exports["pd-engines"]:getVehicleRPM(vehicle))/ 10000) * 200
			dxDrawImage(tachoPos.x, tachoPos.y-math.floor(2/zoom), tachoPos.w, tachoPos.h, textures.tachometer_background, 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawImage(tachoPos.x-math.floor(27/zoom), tachoPos.y, tachoPos.w, tachoPos.h, textures["tachometer_lines"..light], 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawImage(tachoPos.x-math.floor(27/zoom), tachoPos.y, tachoPos.w, tachoPos.h, textures["tachometer_numbers"..light], 0, 0, 0, tocolor(255, 255, 255, 255))
			dxDrawImage(tachoPos.x+math.floor(10/zoom), tachoPos.y+math.floor(tachoPos.h*0.1)-math.floor(5/zoom), math.floor(tachoPos.w*0.9), math.floor(tachoPos.h*0.9), textures.indicator, rpm-88, 0, 0, tocolor(255, 255, 255, 255))
		end
		
		local speed = (Vector3(getElementVelocity(vehicle)) * 170).length
		dxDrawImage(speedoPos.x, speedoPos.y, speedoPos.w, speedoPos.h, textures.background, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawImage(speedoPos.x, speedoPos.y-math.floor(20/zoom), speedoPos.w, speedoPos.h, textures.counter, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawImage(speedoPos.x, speedoPos.y, speedoPos.w, speedoPos.h, textures["lines"..light], 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawImage(speedoPos.x, speedoPos.y, speedoPos.w, speedoPos.h, textures["numbers"..light], 0, 0, 0, tocolor(255, 255, 255, 255))
		--dxDrawImage(speedoPos.x, speedoPos.y, speedoPos.w, speedoPos.h, textures.numbers_light, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawImage(speedoPos.x, speedoPos.y, speedoPos.w, speedoPos.h, textures.indicator, speed, 0, 0, tocolor(255, 255, 255, 255))
		
		local light = isVehicleLocked(vehicle) and "_light" or ""
		local lightColor = (light == "_light") and tocolor(236, 0, 0, 255) or tocolor(143, 143, 143, 255)
		dxDrawImage(iconsPos.x+iconsPos.w+math.floor(7/zoom), iconsPos.y, math.floor(iconsPos.w*0.96), math.floor(iconsPos.h*0.96), textures["lock_icon"..light], 0, 0, 0, lightColor)
		
		local light = isElementFrozen(vehicle) and "_light" or ""
		local lightColor = (light == "_light") and tocolor(236, 111, 0, 255) or tocolor(143, 143, 143, 255)
		dxDrawImage(iconsPos.x, iconsPos.y, iconsPos.w, iconsPos.h, textures["brake_icon"..light], 0, 0, 0, lightColor)
		
		local light = (getVehicleEngineState(vehicle) == true) and "_light" or ""
		local lightColor = (light == "_light") and tocolor(236, 0, 0, 255) or tocolor(143, 143, 143, 255)
		dxDrawImage(iconsPos.x-iconsPos.w-math.floor(8/zoom), iconsPos.y, iconsPos.w, iconsPos.h, textures["engine_icon"..light], 0, 0, 0, lightColor)
		
		local light = (getVehicleOverrideLights(vehicle) == 2) and "_light" or ""
		local lightColor = (light == "_light") and tocolor(37, 198, 0, 255) or tocolor(143, 143, 143, 255)
		dxDrawImage(iconsPos.x-iconsPos.w*2-math.floor(12/zoom), iconsPos.y, iconsPos.w, iconsPos.h, textures["lights_icon"..light], 0, 0, 0, lightColor)
		
		drawOdometer()
		
		dxSetRenderTarget(textures.fuel_bar_rt, true)
		dxDrawImage(0, 0, fuelPos.w, fuelPos.h, textures.fuel_bar, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxSetRenderTarget()
	
		local fuel = getElementData(vehicle, "vehicle:fuel") or 9
		local maxFuel = getElementData(vehicle, "vehicle:maxFuel") or 10
		local progress = fuel / maxFuel
		
		dxDrawImage(fuelPos.x, fuelPos.y, fuelPos.w, fuelPos.h*1.08, textures.fuel_background, 0, 0, 0, tocolor(255, 255, 255, 255))
		local h = fuelPos.h
		dxDrawImageSection(fuelPos.x+math.floor(15/zoom), math.floor(fuelPos.y+15/zoom+(h-(h*progress))), fuelPos.w-math.floor(30/zoom), h, 0, math.floor(h-(h*progress)+10/zoom), fuelPos.w-math.floor(30/zoom), h, textures.fuel_bar_rt, 0, 0, 0, tocolor(255, 255, 255, 255))
		local fueltype = getElementData(getPedOccupiedVehicle(localPlayer), "vehicle:fuel:type")
		if fueltype == "Benzyna" then fueltype = "PB" elseif fueltype == "Diesel" then fueltype = "ON" elseif fueltype == false then fueltype = "" end
		dxDrawImage(fuelPos.x, fuelPos.y+fuelPos.h+math.floor(20/zoom), math.floor(71/zoom*0.7), math.floor(84/zoom*0.7), textures["fuel_icon"..fueltype], 0, 0, 0, tocolor(255, 255, 255, 255))
	end
end

function showSpeedo()
	if getElementData(localPlayer, "player:job") == "cosmonaut" then return end 
	
	textures.background = dxCreateTexture("images/speedo/background.png")
	textures.counter = dxCreateTexture("images/speedo/counter.png")
	textures.indicator = dxCreateTexture("images/speedo/indicator.png")
	textures.lines = dxCreateTexture("images/speedo/lines.png")
	textures.lines_light = dxCreateTexture("images/speedo/lines_light.png")
	textures.numbers = dxCreateTexture("images/speedo/numbers.png")
	textures.numbers_light = dxCreateTexture("images/speedo/numbers_light.png")
	
	textures.tachometer_background = dxCreateTexture("images/speedo/tachometer_background.png")
	textures.tachometer_lines = dxCreateTexture("images/speedo/tachometer_lines.png")
	textures.tachometer_lines_light = dxCreateTexture("images/speedo/tachometer_lines_light.png")
	textures.tachometer_numbers = dxCreateTexture("images/speedo/tachometer_numbers.png")
	textures.tachometer_numbers_light = dxCreateTexture("images/speedo/tachometer_numbers_light.png")
	
	textures.brake_icon = dxCreateTexture("images/speedo/brake.png")
	textures.brake_icon_light = dxCreateTexture("images/speedo/brake_a.png")
	textures.engine_icon = dxCreateTexture("images/speedo/engine.png")
	textures.engine_icon_light = dxCreateTexture("images/speedo/engine_a.png")
	textures.lights_icon = dxCreateTexture("images/speedo/lights.png")
	textures.lights_icon_light = dxCreateTexture("images/speedo/lights_a.png")
	textures.lock_icon = dxCreateTexture("images/speedo/lock.png")
	textures.lock_icon_light = dxCreateTexture("images/speedo/lock_a.png")
	
	textures.fuel_background = dxCreateTexture("images/speedo/fuel_background.png")
	textures.fuel_bar = dxCreateTexture("images/speedo/fuel_bar.png")
	textures.fuel_bar_rt = dxCreateRenderTarget(fuelPos.w+1, fuelPos.h*2, true)
	textures.fuel_icon = dxCreateTexture("images/speedo/fuel_icon.png")
	textures.fuel_iconPB = dxCreateTexture("images/speedo/fuel_pb.png")
	textures.fuel_iconON = dxCreateTexture("images/speedo/fuel_on.png")
	textures.fuel_iconLPG = dxCreateTexture("images/speedo/fuel_lpg.png")
end 
addEvent("showSpeedo", true )
addEventHandler("showSpeedo", root, showSpeedo)

function hideSpeedo()
	for k, texture in pairs(textures) do 
		if isElement(texture) then 
			destroyElement(texture)
		end
	end
	textures = {}
end 
addEvent("hideSpeedo", true )
addEventHandler("hideSpeedo", root, hideSpeedo)

eventHandled = false

addEventHandler("onClientResourceStart", resourceRoot, function()
	if isPedInVehicle(localPlayer) then 
		showSpeedo()
	end
	
	addEventHandler("onClientVehicleEnter", root, function(player, seat)
		if player == localPlayer and seat == 0 then
			showSpeedo()
			if not eventHandled then
				addEventHandler("onClientRender", root, renderSpeedo)
				eventHandled = true
			end
		end
	end)

	addEventHandler("onClientVehicleExit", root, function(player, seat)
		if player == localPlayer and seat == 0 then
			hideSpeedo()
			if eventHandled then
				removeEventHandler("onClientRender", root, renderSpeedo)
				eventHandled = false
			end
		end
	end)
end)
