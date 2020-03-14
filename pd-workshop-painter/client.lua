local customMarkers = {}
local sx, sy = guiGetScreenSize()
local currentVehicle = false
local zoom = exports["pd-gui"]:getInterfaceZoom()
local pallete = dxCreateTexture("images/palette.png")
local pixel = dxGetTexturePixels(pallete)
local editbox = {}
local selectedPos = {
	{x=0, y=0, h=100},
	{x=0, y=0},
}
local painterPlaces = {
	{838.87365722656, -1176.7681884766, 16.983539581299},
}
local textures = {
	button = dxCreateTexture("images/button.png"),
}
local lastColors = {
	r1 = 255, g1 = 255, b1 = 255, r2 = 255, g2 = 255, b1 = 255
}
local editBoxToCreate = {
	["R1"] = {"255", sx/2 + 0/zoom, sy/2 - 200/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "R"},
	["G1"] = {"255", sx/2 + 100/zoom, sy/2 - 200/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "G"},
	["B1"] = {"255", sx/2 + 200/zoom, sy/2 - 200/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "B"},
	["R2"] = {"255", sx/2 + 0/zoom, sy/2 + 60/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "R"},
	["G2"] = {"255", sx/2 + 100/zoom, sy/2 + 60/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "G"},
	["B2"] = {"255", sx/2 + 200/zoom, sy/2 + 60/zoom, 100/zoom, 100/zoom, exports["pd-gui"]:getGUIFont("normal_small"), 1/zoom, 3, "B"},
}

setElementData(localPlayer, "player:placeReserved", false)

for k,v in pairs(painterPlaces) do
	_, marker = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3] - 0.75, 500, 55, 55, 255 * 1.5, "repair", 1)
	table.insert(customMarkers, marker)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	colorPicker01 = exports["pd-dgs"]:dgsCreateColorPicker("HSLSquare", sx/2 - 300/zoom, sy/2 - 200/zoom, 200/zoom, 200/zoom, false)
	colorPicker02 = exports["pd-dgs"]:dgsCreateColorPicker("HSLSquare", sx/2 - 300/zoom, sy/2 + 60/zoom, 200/zoom, 200/zoom, false)
	colorSelector01 = exports["pd-dgs"]:dgsColorPickerCreateComponentSelector(sx/2 - 90/zoom, sy/2 - 200/zoom, 15/zoom, 200/zoom, false, false)
	colorSelector02 = exports["pd-dgs"]:dgsColorPickerCreateComponentSelector(sx/2 - 90/zoom, sy/2 + 60/zoom, 15/zoom, 200/zoom, false, false)
	exports["pd-dgs"]:dgsBindToColorPicker(colorSelector01, colorPicker01, "HSL", "L")
	exports["pd-dgs"]:dgsBindToColorPicker(colorSelector02, colorPicker02, "HSL", "L")
	exports["pd-dgs"]:dgsSetVisible(colorPicker01, false)
	exports["pd-dgs"]:dgsSetVisible(colorPicker02, false)
	exports["pd-dgs"]:dgsSetVisible(colorSelector01, false)
	exports["pd-dgs"]:dgsSetVisible(colorSelector02, false)

	cancelButton = exports["pd-gui"]:createButton("Anuluj", sx/2 - 70/zoom, sy/2 + 290/zoom, 140/zoom, 45/zoom)
	exports["pd-gui"]:setButtonTextures(cancelButton, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(cancelButton, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", cancelButton, function()
		hidePainterGUI()
	end)

	takeSpray01 = exports["pd-gui"]:createButton("Weź spray", sx/2 - 20/zoom, sy/2 - 120/zoom, 140/zoom, 45/zoom)
	exports["pd-gui"]:setButtonTextures(takeSpray01, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(takeSpray01, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", takeSpray01, function()
		hidePainterGUI()
	end)

	sendOffer01 = exports["pd-gui"]:createButton("Wyślij ofertę", sx/2 + 120/zoom, sy/2 - 120/zoom, 140/zoom, 45/zoom)
	exports["pd-gui"]:setButtonTextures(sendOffer01, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(sendOffer01, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", sendOffer01, function()
		hidePainterGUI()
	end)

	takeSpray02 = exports["pd-gui"]:createButton("Weź spray", sx/2 - 20/zoom, sy/2 + 140/zoom, 140/zoom, 45/zoom)
	exports["pd-gui"]:setButtonTextures(takeSpray02, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(takeSpray02, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", takeSpray02, function()
		hidePainterGUI()
	end)

	sendOffer02 = exports["pd-gui"]:createButton("Wyślij ofertę", sx/2 + 120/zoom, sy/2 + 140/zoom, 140/zoom, 45/zoom)
	exports["pd-gui"]:setButtonTextures(sendOffer02, {default=textures.button, hover=textures.button, press=textures.button})
	exports["pd-gui"]:setButtonFont(sendOffer02, exports["pd-gui"]:getGUIFont("normal_small"), 0.9/zoom)
	addEventHandler("onClientClickButton", sendOffer02, function()
		hidePainterGUI()
	end)

	for k,v in pairs(editBoxToCreate) do
		editbox[k] = exports["pd-gui"]:createEditbox(v[1], v[2], v[3], v[4], v[5], v[6], v[7])
		exports["pd-gui"]:setEditboxMaxLength(editbox[k], v[8])
		exports["pd-gui"]:setEditboxHelperText(editbox[k], v[9])
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(customMarkers) do
		exports["pd-markers"]:destroyCustomMarker(v)
	end
	for k,v in pairs(editbox) do
		exports["pd-gui"]:destroyEditbox(v)
	end
	hidePainterGUI()
	destroyElement(colorPicker01)
	destroyElement(colorPicker02)
	destroyElement(colorSelector01)
	destroyElement(colorSelector02)
end)

function renderPainterGUI()
	dxDrawImage(sx/2 - 350/zoom, sy/2 - 300/zoom, 700/zoom, 650/zoom, "images/background.png")
	dxDrawText("Wybierz kolor pojazdu", sx/2, sy/2 - 290/zoom, sx/2, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")

	dxDrawText("Kolor 1", sx/2 - 300/zoom, sy/2 - 230/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")
	dxDrawText("Kolor 2", sx/2 - 300/zoom, sy/2 + 30/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")

	dxDrawText("Cena: $500", sx/2 + 70/zoom, sy/2 - 50/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")
	dxDrawText("Cena: $1000", sx/2 + 70/zoom, sy/2 + 210/zoom, sx, sy, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top")

	local r, g, b = exports["pd-dgs"]:dgsColorPickerGetColor(colorPicker01)
	if r ~= lastColors.r1 or g ~= lastColors.g1 or b ~= lastColors.b1 then
		exports["pd-gui"]:setEditboxText(editbox["R1"], tostring(r))
		exports["pd-gui"]:setEditboxText(editbox["G1"], tostring(g))
		exports["pd-gui"]:setEditboxText(editbox["B1"], tostring(b))
		lastColors.r1, lastColors.g1, lastColors.b1 = tonumber(r), tonumber(g), tonumber(b)
	else
		local r = exports["pd-gui"]:getEditboxText(editbox["R1"])
		local g = exports["pd-gui"]:getEditboxText(editbox["G1"])
		local b = exports["pd-gui"]:getEditboxText(editbox["B1"])
		exports["pd-dgs"]:dgsColorPickerSetColor(colorPicker01, tonumber(r), tonumber(g), tonumber(b))
		lastColors.r1, lastColors.g1, lastColors.b1 = tonumber(r), tonumber(g), tonumber(b)
	end
	local r, g, b = exports["pd-dgs"]:dgsColorPickerGetColor(colorPicker02)
	if r ~= lastColors.r2 or g ~= lastColors.g2 or b ~= lastColors.b2 then
		exports["pd-gui"]:setEditboxText(editbox["R2"], tostring(r))
		exports["pd-gui"]:setEditboxText(editbox["G2"], tostring(g))
		exports["pd-gui"]:setEditboxText(editbox["B2"], tostring(b))
		lastColors.r2, lastColors.g2, lastColors.b2 = tonumber(r), tonumber(g), tonumber(b)
	else
		local r = exports["pd-gui"]:getEditboxText(editbox["R2"])
		local g = exports["pd-gui"]:getEditboxText(editbox["G2"])
		local b = exports["pd-gui"]:getEditboxText(editbox["B2"])
		exports["pd-dgs"]:dgsColorPickerSetColor(colorPicker02, tonumber(r), tonumber(g), tonumber(b))
		lastColors.r2, lastColors.g2, lastColors.b2 = tonumber(r), tonumber(g), tonumber(b)
	end

	exports["pd-gui"]:renderButton(takeSpray01)
	exports["pd-gui"]:renderButton(takeSpray02)
	exports["pd-gui"]:renderButton(sendOffer01)
	exports["pd-gui"]:renderButton(sendOffer02)
	exports["pd-gui"]:renderButton(cancelButton)
	for k,v in pairs(editbox) do
		exports["pd-gui"]:renderEditbox(v)
	end
end

addEventHandler("onClientColShapeHit", root, function(el, md)
	local painterOwner = getElementData(source, "painter:owner")
	if el == localPlayer and md and not isPedInVehicle(el) and painterOwner then
		if painterOwner == "Brak" then
			triggerServerEvent ("reservePainterPlace", resourceRoot, localPlayer, source)
		elseif painterOwner == getPlayerName(localPlayer) then
			local data = getElementData(source, "painterSphere")
			local vehicle = false
			for k,v in pairs(getElementsWithinColShape(data[1], "vehicle")) do
				if isElement(v) then
					vx, vy, vz = getElementVelocity(v)
					if math.ceil((vx^2+vy^2+vz^2) ^ (0.5) * 161) < 2 then
						vehicle = v
						break
					end
				end
			end
			if isElement(vehicle) then
				showPainterGUI(vehicle)
			end
		end
	end
end)

function showPainterGUI(vehicle)
	setElementFrozen(localPlayer, true)
	showCursor(true)
	currentVehicle = vehicle
	exports["pd-dgs"]:dgsSetVisible(colorPicker01, true)
	exports["pd-dgs"]:dgsSetVisible(colorPicker02, true)
	exports["pd-dgs"]:dgsSetVisible(colorSelector01, true)
	exports["pd-dgs"]:dgsSetVisible(colorSelector02, true)
	addEventHandler("onClientRender", root, renderPainterGUI)
end

function hidePainterGUI()
	setElementFrozen(localPlayer, false)
	showCursor(false)
	currentVehicle = false
	exports["pd-dgs"]:dgsSetVisible(colorPicker01, false)
	exports["pd-dgs"]:dgsSetVisible(colorPicker02, false)
	exports["pd-dgs"]:dgsSetVisible(colorSelector01, false)
	exports["pd-dgs"]:dgsSetVisible(colorSelector02, false)
	removeEventHandler("onClientRender", root, renderPainterGUI)
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end