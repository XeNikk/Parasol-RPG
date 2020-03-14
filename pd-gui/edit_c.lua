local BACKSPACE_DELAY = 70
local ARROW_DELAY = 90

local editboxes = {}
local backspaceTick = 0  
local arrowTick = 0
local activeEditbox = false 

local id = 0 

function createEditbox(text, x, y, w, h, font, fontHeight)
	if text and x and y and w and h and font and fontHeight then 
		id = id+1
		editboxes[id] = {text=text, x=x, y=y, w=w, h=h, font=font, spaceEnabled=false, fontHeight=fontHeight, carretPos=1, helperText=false, maxLength=35, masked=false, ascii=true, number=false, barProgress=0, alpha=255}
		return id
	end 
	
	return false 
end 

function destroyEditbox(editbox)
	if editboxes[editbox] then 
		if editbox == activeEditbox then 
			activeEditbox = false
		end 
		
		editboxes[editbox] = nil
		return true
	end
	
	return false
end 

function setEditboxSpace(editboxID, enabled)
	if editboxes[editboxID] then 
		editboxes[editboxID].spaceEnabled = enabled
		return true 
	end 
	
	return false
end 

function setEditboxText(editboxID, enabled)
	if editboxes[editboxID] then 
		editboxes[editboxID].text = enabled
		return true 
	end 
	
	return false
end 

function getEditboxText(editboxID)
	local edit = editboxes[editboxID] 
	if edit then 
		return edit.text
	end 
	
	return "false"
end 

function isEditboxActive(editboxID)
	return editboxID == activeEditbox
end 

function setEditboxMasked(editboxID, bool)
	if editboxes[editboxID] and type(bool) == "boolean" then 
		editboxes[editboxID].masked = bool
		return true 
	end 
	
	return false
end 

function setEditboxMaxLength(editboxID, length) 
	if editboxes[editboxID] and length then 
		editboxes[editboxID].maxLength = length
		return true 
	end 
	
	return false 
end 

function setEditboxHelperText(editboxID, text)
	if editboxes[editboxID] and text then 
		editboxes[editboxID].helperText = text
		return true 
	end 
	
	return false
end 

function setEditboxImage(editboxID, image)
	if editboxes[editboxID] and image then 
		editboxes[editboxID].image = image 
		return true 
	end 
	
	return false 
end 

function setEditboxLine(editboxID, image)
	if editboxes[editboxID] and image then 
		editboxes[editboxID].line = image
		return true
	end
	
	return false
end

function setEditboxASCIIMode(editboxID, bool)
	if editboxes[editboxID] then 
		editboxes[editboxID].ascii = bool
		return true
	end
	
	return false
end 

function setEditboxNumberMode(editboxID, bool)
	if editboxes[editboxID] then 
		editboxes[editboxID].number = bool
		return true
	end
	
	return false
end

function setEditboxPosition(editboxID, x, y)
	if editboxes[editboxID] then
		editboxes[editboxID].x = x
		editboxes[editboxID].y = y
		return true
	end

	return false
end

function setEditboxTextures(editboxID, textures)
	if editboxes[editboxID] then
		editboxes[editboxID].textures = textures
		return true
	end

	return false
end

function setEditboxAlpha(editboxID, alpha)
	if editboxes[editboxID] then 
		editboxes[editboxID].alpha = alpha
		return true
	end
	
	return false
end

function destroyEditbox(editboxID) 
	local edit = editboxes[editboxID]
	if edit then 
		editboxes[editboxID] = nil
		if activeEditbox == editboxID then activeEditbox = false end 
		return true 
	end
	
	return false 
end 

local jsSource = [[
	var inputElement = document.createElement('input');
	document.body.appendChild(inputElement);
	inputElement.focus();
	inputElement.onpaste = function() {
		inputElement.value = '';
		setTimeout(function() {
			mta.triggerEvent('returnClipBoardValue',inputElement.value);
		}, 10);
	};
]];

local browser = createBrowser(1,1,true,false);

addEvent('returnClipBoardValue',false);

addEventHandler('returnClipBoardValue',browser,function (data)
	triggerEvent('returnClipBoard',root,data);
end);

addEventHandler("onClientBrowserCreated",browser,function()
	loadBrowserURL(browser,'http://mta/nothing');
	focusBrowser(browser);
end);

addEventHandler("onClientBrowserDocumentReady",browser,function()
	executeBrowserJavascript(browser, jsSource);
end);

addEventHandler('onClientKey',root,function(key,state)
    if state then
        if (getKeyState('rctrl') or getKeyState('lctrl')) and (getKeyState('v') or getKeyState("V")) then
            cancelEvent();
        end
    end
end);

addEvent('returnClipBoard',true)
addEventHandler('returnClipBoard',localPlayer,function(value)
	if activeEditbox then
		editboxes[activeEditbox].text = editboxes[activeEditbox].text .. value
	end
end);

function changeEditbox(key, press) -- tabulator
	if key == "tab" and press then 
		if activeEditbox then
			local lastBox = activeEditbox
			createAnimation(1, 0, "InOutQuad", 300, function(progress)
				if editboxes[lastBox] and editboxes[lastBox].barProgress > 0 then 
					editboxes[lastBox].barProgress = progress
				end
			end)
			
			activeEditbox = activeEditbox+1
			if activeEditbox > #editboxes then 
				activeEditbox = 1 
			end
		
			createAnimation(0, 1, "InOutQuad", 300, function(progress)
				if editboxes[activeEditbox] then 
					editboxes[activeEditbox].barProgress = progress
				end
			end)
		end
	end
end  
addEventHandler("onClientKey", root, changeEditbox)

function moveCarret(direction)
	if activeEditbox then 
		if direction == "left" then 
			editboxes[activeEditbox].carretPos = math.max(0, editboxes[activeEditbox].carretPos-1)
		elseif direction == "right" then 
			editboxes[activeEditbox].carretPos = math.min(editboxes[activeEditbox].carretPos+1, #editboxes[activeEditbox].text)
		end
	end
end 

function renderEditbox(editboxID)
	local editboxData = editboxes[editboxID]
	if editboxData then 
		if isElement(editboxData.font) then 
			local text = editboxData.text
			local x, y, w, h = editboxData.x, editboxData.y, editboxData.w, editboxData.h 
			if editboxData.textures then
				if isEditboxActive(editboxID) then
					dxDrawImage(x - 20/zoom, y, w + 10/zoom, h, editboxData.textures["active"])
				else
					dxDrawImage(x - 20/zoom, y, w + 10/zoom, h, editboxData.textures["default"])
				end
			end
			if editboxData.image then 
				local height = dxGetFontHeight(editboxData.fontHeight, editboxData.font)*1.1
				dxDrawImage(math.floor(x-height/3), math.floor(y+h/2-height/2), math.floor(height), math.floor(height), editboxData.image, 0, 0, 0, tocolor(255, 255, 255, editboxData.alpha))
				x = x+height 
				w = w-height*2
			end
			
			local carretText = utf8.sub(text, 1, editboxData.carretPos)
			local textWidth = dxGetTextWidth(carretText, editboxData.fontHeight, editboxData.font)

			if editboxData.helperText and activeEditbox ~= editboxID and #editboxData.text == 0 then 
				text = editboxData.helperText
				dxDrawText(text, x, y, x+w, y+h, tocolor(160, 160, 160, editboxData.alpha*0.7), editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)				
			elseif editboxData.masked then 
				text = utf8.gsub(editboxData.text, ".", "*")
				dxDrawText(text, x, y, x+w, y+h, tocolor(255, 255, 255, editboxData.alpha), editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)
				
				carretText = utf8.sub(text, 1, editboxData.carretPos)
				textWidth = dxGetTextWidth(carretText, editboxData.fontHeight, editboxData.font)
			else 
				dxDrawText(text, x, y, x+w, y+h, tocolor(255, 255, 255, editboxData.alpha), editboxData.fontHeight, editboxData.font, "left", "center", true, false, true)
			end 
			
			if isElement(editboxData.line) then 
				dxDrawRectangle(x, y+h, w, 3/zoom, tocolor(150, 150, 150, editboxData.alpha))
				if editboxData.barProgress > 0 then 
					local bW = w*editboxData.barProgress
					local bX = (x+w/2) - bW/2
					--dxDrawRectangle(bX, y+h, bW, 3, tocolor(GUI_R, GUI_G, GUI_B, 255))
					if editboxData.line then 
						dxDrawImage(bX, y+h, bW, 3/zoom, editboxData.line, 0, 0, 0, tocolor(255, 255, 255, editboxData.alpha))
					end
				end 
			end 
			
			if activeEditbox == editboxID then 
				-- backspace 
				if getKeyState("backspace") then 
					local now = getTickCount()
					if now > backspaceTick then 
						editboxData.text = utf8.sub(editboxData.text, 1, math.max(0, editboxData.carretPos-1))..utf8.sub(editboxData.text, editboxData.carretPos+1)
						editboxData.carretPos = math.max(0, editboxData.carretPos-1)
						backspaceTick = now+BACKSPACE_DELAY 
					end 
				elseif getKeyState("space") then 
					local now = getTickCount()
					if now > backspaceTick then 
						if editboxData.spaceEnabled then
							editboxData.text = editboxData.text .. " "
							editboxData.carretPos = math.max(0, editboxData.carretPos+1)
							backspaceTick = now+BACKSPACE_DELAY 
						end
					end 
				elseif getKeyState("arrow_l") then 
					local now = getTickCount()
					if now > arrowTick then 
						moveCarret("left")
						arrowTick = now+ARROW_DELAY
					end
				elseif getKeyState("arrow_r") then 
					local now = getTickCount() 
					if now > arrowTick then 
						moveCarret("right")
						arrowTick = now+ARROW_DELAY
					end
				end
				
				-- kursor 
				local cursorW, cursorH = 1, h-math.floor(h*0.2)  
				local cursorX, cursorY = x+textWidth+1, y+math.floor(h*0.1)
				dxDrawRectangle(cursorX, cursorY, cursorW, cursorH, tocolor(51, 102, 255, (editboxData.alpha * math.abs(getTickCount() % 1000 - 500) / 500)), true)
			end
		end 
	end 
end 

function onClientClickEditbox(button, state, x, y)
	if button == "left" and state == "down" then 
		local lastActiveBox = activeEditbox
		createAnimation(1, 0, "InOutQuad", 300, function(progress)
			local box = lastActiveBox
			if activeEditbox == lastActiveBox then return end 
			
			if editboxes[box] and editboxes[box].barProgress > 0 then 
				editboxes[box].barProgress = progress
			end
		end)
		
		activeEditbox = false
		for editboxID, editboxData in pairs(editboxes) do
			if isCursorOnElement(editboxData.x - 10/zoom, editboxData.y, editboxData.w, editboxData.h) then 
				activeEditbox = editboxID
				editboxData.carretPos = #editboxData.text
				break
			end 
		end 
		
		if lastActiveBox ~= activeEditbox then 
			createAnimation(0, 1, "InOutQuad", 300, function(progress)
				if editboxes[activeEditbox] then
					editboxes[activeEditbox].barProgress = progress
				end
			end)
		end
	end
end

function onEditboxType(character)
	if editboxes[activeEditbox] and #editboxes[activeEditbox].text < editboxes[activeEditbox].maxLength and isCursorShowing() then
		local check = true 
		if editboxes[activeEditbox].ascii then 
			check = isStringValid(character)
		end 
		
		if editboxes[activeEditbox].number then 
			check = tonumber(character)
		end
		
		if check then 
			editboxes[activeEditbox].text = utf8.sub(editboxes[activeEditbox].text, 1, editboxes[activeEditbox].carretPos)..character..utf8.sub(editboxes[activeEditbox].text, editboxes[activeEditbox].carretPos+1)
			editboxes[activeEditbox].carretPos = editboxes[activeEditbox].carretPos+1
		end
	end 
end 
addEventHandler("onClientCharacter", root, onEditboxType)

function isCursorOnElement(x,y,w,h)
	if not isCursorShowing() then return end 
	
	local mx,my = getCursorPosition ()
	local fullx,fully = guiGetScreenSize()
	cursorx,cursory = mx*fullx,my*fully
	if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
		return true
	else
		return false
	end
end

function isStringValid(string)
   local length = string:len()
   for i=1,length do
          if string:byte(i) > 126 or string:byte(i) < 33 then return false end
   end
   return true
end