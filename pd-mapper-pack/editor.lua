local sx, sy = guiGetScreenSize()
local baseX = 2048
zoom = 1 
local minZoom = 2.2
if sx < baseX then
	zoom = math.min(minZoom, baseX/sx)
end
local currentSelected = nil
normal_small = dxCreateFont("data/font.ttf", 15, false, "antialiased")
local normal_big = dxCreateFont("data/font.ttf", 30, false, "antialiased")
local editingData = {1, "a", 1}
local texturesCount = 343
local tex = false

function isMouseInPosition(x, y, width, height)
	if(not isCursorShowing()) then
		return false
	end
	local cx, cy = getCursorPosition()
	local cx, cy =(cx * sx),(cy * sy)
	return((cx >= x and cx <= x + width) and(cy >= y and cy <= y + height))
end


addCommandHandler("eloeoeldlsakldsadsa", function(plr)
	tex = not tex
	showCursor(tex, true)
end)

addEventHandler("onClientClick", root, function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button ~= "left" or state ~= "down" then return end
	if not tex then return end
	if isMouseInPosition(sx-520/zoom, sy-570/zoom, 160/zoom, 46/zoom) then
		if editingData[2] == "a" then
			editingData[2] = "b"
		else
			editingData[2] = "a"
		end
	end
	if currentSelected and isElement(currentSelected) then
		for i = 0, 3 do
			if isMouseInPosition(sx-495/zoom + 100/zoom*i, sy-500/zoom, 90/zoom, 90/zoom) then
				setElementData(currentSelected, editingData[2] .. "Texture", editingData[1] + 0 + i)
			elseif isMouseInPosition(sx-495/zoom + 100/zoom*i, sy-400/zoom, 90/zoom, 90/zoom) then
				setElementData(currentSelected, editingData[2] .. "Texture", editingData[1] + 3 + i)
			elseif isMouseInPosition(sx-495/zoom + 100/zoom*i, sy-300/zoom, 90/zoom, 90/zoom) then
				setElementData(currentSelected, editingData[2] .. "Texture", editingData[1] + 6 + i)
			end
		end
	end
	if clickedElement and getElementType(clickedElement) == "object" then
		currentSelected = clickedElement
	end
end)

bindKey("mouse_wheel_down", "down", function()
	if not tex then return end
	if editingData[1] < 334 then
		editingData[1] = editingData[1] + 4
	end
end)

bindKey("mouse_wheel_up", "down", function()
	if not tex then return end
	if editingData[1] > 4 then
		editingData[1] = editingData[1] - 4
	end
end)

addEventHandler("onClientRender", root, function()
	if not tex then return end
	dxDrawImage(sx-550/zoom, sy-600/zoom, 500/zoom, 470/zoom, "data/window.png")
	if currentSelected and isElement(currentSelected) then model = getElementModel(currentSelected) end
	dxDrawText(model or "Brak", sx-302/zoom, sy-552/zoom, sx-302/zoom, sy-552/zoom, tocolor(0, 0, 0, 255), 1/zoom, normal_big, "center", "center")
	dxDrawText(model or "Brak", sx-300/zoom, sy-550/zoom, sx-300/zoom, sy-550/zoom, white, 1/zoom, normal_big, "center", "center")
	dxDrawImage(sx-520/zoom, sy-520/zoom, 440/zoom, 350/zoom, "data/window.png")
	for i = 0, 3 do
		if fileExists("data/images/" .. editingData[1] + 0 + i .. ".jpg") then
			dxDrawImage(sx-495/zoom + 100/zoom*i, sy-500/zoom, 90/zoom, 90/zoom, "data/images/" .. editingData[1] + 0 + i .. ".jpg")
		end
		if fileExists("data/images/" .. editingData[1] + 3 + i .. ".jpg") then
			dxDrawImage(sx-495/zoom + 100/zoom*i, sy-400/zoom, 90/zoom, 90/zoom, "data/images/" .. editingData[1] + 3 + i .. ".jpg")
		end
		if fileExists("data/images/" .. editingData[1] + 6 + i .. ".jpg") then
			dxDrawImage(sx-495/zoom + 100/zoom*i, sy-300/zoom, 90/zoom, 90/zoom, "data/images/" .. editingData[1] + 6 + i .. ".jpg")
		end
	end
	dxDrawImage(sx-520/zoom, sy-570/zoom, 160/zoom, 46/zoom, "data/" .. editingData[2] .. ".png")
	dxDrawImage(sx-240/zoom, sy-570/zoom, 160/zoom, 46/zoom, "data/button.png")
	dxDrawText("Jasność: " .. editingData[3], sx-160/zoom, sy-547/zoom, sx-160/zoom, sy-547/zoom, white, 1/zoom, normal_small, "center", "center")
end)