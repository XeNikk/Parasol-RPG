local GUI = exports["pd-gui"]
local zoom = GUI:getInterfaceZoom()
local sx, sy = guiGetScreenSize()
local normal_small = GUI:getGUIFont("normal_small")
local normal_big = GUI:getGUIFont("normal_big")

function draw3DText(text, x, y, z, cx, cy, cz, ignored, fontSize)
	px, py = getScreenFromWorldPosition(x, y, z)
	if not px or not py then return end
	dist = getDistanceBetweenPoints3D(x, y, z, cx, cy, cz)
	if dist > 25 then return end
	dist = 25 - dist
	dist = dist / 20
	if dist < 0 then dist = 0 end
	if fontSize then dist = dist * fontSize end
	if not isLineOfSightClear(x, y, z, cx, cy, cz, true, true, true, true, true, false, true, ignored) then return end
	dxDrawText(text:gsub("#%x%x%x%x%x%x", ""), px+1, py+1, px+1, py+1, tocolor(0, 0, 0, 255), dist/zoom/1.5, normal_big, "center", "center")
	dxDrawText(text, px, py, px, py, white, dist/zoom/1.5, normal_big, "center", "center", false, false, false, true)
end

addEventHandler("onClientRender", root, function()
	if not getElementData(localPlayer, "player:spawned") then return end
	cx, cy, cz = getCameraMatrix()
	for k,v in pairs(getElementsByType("3dtext"), root, true) do
		fontSize = getElementData(v, "3dtext:fontSize")
		x, y, z = getElementPosition(v)
		draw3DText(getElementData(v, "3dtext"), x, y, z, cx, cy, cz, nil, fontSize or 1)
	end
	for k,v in pairs(getElementsByType("vehicle"), root, true) do
		text = getElementData(v, "3dtext")
		fontSize = getElementData(v, "3dtext:fontSize")
		if text then
			x, y, z = getElementPosition(v)
			draw3DText(text, x, y, z, cx, cy, cz, v, fontSize or 1)
		end
	end
end)

function create3DText(text, x, y, z)
	element = createElement("3dtext")
	setElementPosition(element, x, y, z)
	setElementData(element, "3dtext", text)
	return element
end

function change3DTextText(element, text)
	setElementData(element, "3dtext", text)
end

function setVehicle3DText(vehicle, text)
	setElementData(vehicle, "3dtext", text)
end