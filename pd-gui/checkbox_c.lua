local checkboxID = 0 

function createCheckbox(text, x, y, w, h)
	if text and x and y and w and h then 
		checkboxID = checkboxID + 1
		local el = createElement("pd_checkbox", "pd_checkbox"..tostring(checkboxID)) 
		setElementData(el, "data", {text=text, 
													x=x, 
													y=y,
													w=w, 
													h=h,
													font="default-bold",
													fontSize=1.0,
													type="default"}, false)
		return el
	end
end 

function destroyCheckbox(checkbox)
	if isElement(checkbox) and getElementType(checkbox) == "pd_checkbox" then 
		destroyElement(checkbox)
	end
end 

function getCheckboxPosition(checkbox)
	if isElement(checkbox) then 
		data = getElementData(checkbox, "data")
		return data.x, data.y, data.w, data.h
	end
end 

function setCheckboxActive(checkbox, active)
	if isElement(checkbox) then 
		data = getElementData(checkbox, "data")
		if data.type == "default" then 
			return false
		else
			return true
		end
	end
end 


function setCheckboxText(checkbox, text)
	if isElement(checkbox) then 
		data = getElementData(checkbox, "data")
		data.text = text 
		setElementData(checkbox, "data", data, false)
	end
end 

function isCheckboxActive(checkbox)
	if isElement(checkbox) then 
		data = getElementData(checkbox, "data")
		if data.type == "default" then
			return false
		else
			return true
		end
	end
end 

function setCheckboxTextures(checkbox, textures)
	if isElement(checkbox) and type(textures) == "table" then
		data = getElementData(checkbox, "data")
		data.textures = textures 
		setElementData(checkbox, "data", data, false)
	end
end

function setCheckboxFont(checkbox, font, fontSize)
	if isElement(checkbox) and font and fontSize then 
		data = getElementData(checkbox, "data")
		data.font = font 
		data.fontSize = fontSize
		setElementData(checkbox, "data", data, false)
	end
end

function setCheckboxPosition(checkbox, x, y, w, h)
	if isElement(checkbox) and x and y then 
		data = getElementData(checkbox, "data")
		data.x = x 
		data.y = y 
		if w then data.w = w end 
		if h then data.h = h end 
		
		setElementData(checkbox, "data", data, false)
	end
end 

function renderCheckbox(checkbox)
	if isElement(checkbox) then
		local checkboxData = getElementData(checkbox, "data")
		if checkboxData.textures then
			dxDrawImage(checkboxData.x, checkboxData.y, checkboxData.h, checkboxData.h, checkboxData.textures[checkboxData.type], 0, 0, 0, checkboxData.texturesColor or tocolor(255, 255, 255, 255))
		end
		dxDrawText(checkboxData.text, checkboxData.x + checkboxData.h + 10, checkboxData.y + checkboxData.h / 2, 999, checkboxData.y + checkboxData.h / 2, tocolor(255, 255, 255, 255), checkboxData.fontSize, checkboxData.font, "left", "center")
	end
end 

addEventHandler("onClientClick", root, function(button, state, cx, cy)
	if button ~= "left" or state ~= "down" then return end
	for id,checkbox in pairs(getElementsByType("pd_checkbox")) do
		data = getElementData(checkbox, "data")
		if (cx >= data.x and cx <= data.x + data.h) and (cy >= data.y and cy <= data.y + data.h) then
			if data.type == "default" then
				data.type = "active"
			else
				data.type = "default"
			end
		end
		setElementData(checkbox, "data", data, false)
	end
end)