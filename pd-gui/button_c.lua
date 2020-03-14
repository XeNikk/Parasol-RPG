local buttonID = 0 
local activeButton, prevActiveButton = false, false
local clickedButton = false 

addEvent("onClientClickButton", true)
addEvent("onClientHoverButton", true)

function createButton(text, x, y, w, h)
	if text and x and y and w and h then 
		buttonID = buttonID + 1
		local el = createElement("pd_button", "pd_button"..tostring(buttonID)) 
		setElementData(el, "data", {text=text, 
													x=x, 
													y=y,
													w=w, 
													h=h,
													font="default-bold",
													fontSize=1.0,
													enabled=true}, false)
		return el
	end
end 

function destroyButton(button)
	if isElement(button) and getElementType(button) == "pd_button" then 
		destroyElement(button)
	end
end 

function getButtonPosition(button)
	if isElement(button) then 
		data = getElementData(button, "data")
		return data.x, data.y, data.w, data.h
	end
end 

-- state: true / false
function setButtonEnabled(button, state)
	if isElement(button) and type(state) == "boolean" then 
		data = getElementData(button, "data")
		data.enabled = state
		setElementData(button, "data", data, false)
	end
end 

-- textures: {default=":sciezkadozasobu/images/...", hover=":sciezkadozasobu/images/...", press=":sciezkadozasobu/images/..."},
function setButtonTextures(button, textures)
	if isElement(button) and type(textures) == "table" then
		data = getElementData(button, "data")
		data.textures = textures 
		setElementData(button, "data", data, false)
	end
end

function setButtonTexturesColor(button, color)
	if isElement(button) and color then
		data = getElementData(button, "data")
		data.texturesColor = color 
		setElementData(button, "data", data, false)
	end
end 

function setButtonText(button, text)
	if isElement(button) and text then 
		data = getElementData(button, "data")
		data.text = text
		setElementData(button, "data", data, false)
	end
end

-- font: dxCreateFont font, fontSize (0-1)
function setButtonFont(button, font, fontSize)
	if isElement(button) and font and fontSize then 
		data = getElementData(button, "data")
		data.font = font 
		data.fontSize = fontSize
		setElementData(button, "data", data, false)
	end
end

function setButtonPosition(button, x, y, w, h)
	if isElement(button) and x and y then 
		data = getElementData(button, "data")
		data.x = x 
		data.y = y 
		if w then data.w = w end 
		if h then data.h = h end 
		
		setElementData(button, "data", data, false)
	end
end 

function isButtonHovered(button)
	return activeButton == button
end 

function renderButton(button)
	if isElement(button) then
		local buttonData = getElementData(button, "data")
		if isCursorOnElement(buttonData.x, buttonData.y, buttonData.w, buttonData.h) and buttonData.enabled then 
			activeButton = button
			if activeButton ~= prevActiveButton then 
				playHoverSound()
				triggerEvent("onClientHoverButton", button)
			end 
			
			prevActiveButton = button
		else 
			if activeButton == button then 
				activeButton = false
				prevActiveButton = false
			end
		end
		
		local type = "default"
		if activeButton == button then 
			type = "hover"
		end 
		
		if clickedButton == button then 
			type = "press"
		end 
		
		if buttonData.enabled == false then 
			type = "default"
		end 
	
		if buttonData.textures then
			dxDrawImage(buttonData.x, buttonData.y, buttonData.w, buttonData.h, buttonData.textures[type], 0, 0, 0, buttonData.texturesColor or tocolor(255, 255, 255, 255))
		end 
		
		dxDrawText(buttonData.text, buttonData.x, buttonData.y, buttonData.x+buttonData.w, buttonData.y+buttonData.h, buttonData.texturesColor or tocolor(255, 255, 255, 255), buttonData.fontSize, buttonData.font, "center", "center")
		--dxDrawRectangle(buttonData.x, buttonData.y, buttonData.w, buttonData.h)
	end
end 

function onClientClickButton(button, state)
	if button == "left" and state == "up" then
		if isElement(clickedButton) then 
			local buttonData = getElementData(clickedButton, "data")
			if isCursorOnElement(buttonData.x, buttonData.y, buttonData.w, buttonData.h) and buttonData.enabled then 
				triggerEvent("onClientClickButton", clickedButton)
				clickedButton = false
				
				playClickSound()
			else 
				activeButton = false 
				clickedButton = false
			end
		end
	elseif button == "left" and state == "down" then
		if isElement(activeButton) then 
			local buttonData = getElementData(activeButton, "data")
			if isCursorOnElement(buttonData.x, buttonData.y, buttonData.w, buttonData.h) then 
				clickedButton = activeButton
			else 
				activeButton = false 
				clickedButton = false
			end
		end 
	end 
end
