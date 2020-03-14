local scrolls = {}
local activeScroll = false
local oldMousePosition = {0, 0}
local lastButtonMove = 0 

function createScroll(x, y, w, h, textures, grip)
	if x and y and w and h and textures then
		table.insert(scrolls, {x=x, y=y, w=w, h=h, gripSize=grip, textures=textures, gripPosition=y+grip*0.4})
		return #scrolls
	end
end

function destroyScroll(scroll)
	if scrolls[scroll] then 
		if scroll == activeScroll then 
			activeScroll = false 
		end 
		
		table.remove(scrolls, scroll)
	end
end 


function getScrollProgress(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		local min = scrollData.y
		local max = scrollData.gripPosition
		local change = max - min
		local sRatio = change / (scrollData.h-scrollData.gripSize) -- przesunięcie 0-1 scrolla 
		return sRatio
	end
end

function setScrollProgress(scroll, progress)
	local scrollData = scrolls[scroll]
	if scrollData then 
		local min = scrollData.y
		local max = scrollData.h
		local change = max - min
		scrollData.gripPosition = scrollData.y + change * progress
	end
end

function moveScroll(scroll, direction, value)
	local scrollData = scrolls[scroll]
	if scrollData and direction and value then 
		if direction == "up" then
			scrollData.gripPosition = scrollData.gripPosition - value
		elseif direction == "down" then
			scrollData.gripPosition = scrollData.gripPosition + value
		end
		
		local grip = scrollData.gripSize
		scrollData.gripPosition = math.max(scrollData.gripPosition, scrollData.y+grip*0.25)
		scrollData.gripPosition = math.min(scrollData.gripPosition, scrollData.y+scrollData.h-grip*1.4)
	end
end

function resetScroll(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		activeScroll = false 
		
		scrollData.gripPosition = scrollData.y
	end
end

function renderScroll(scroll)
	local scrollData = scrolls[scroll]
	if scrollData then 
		local now = getTickCount()
		
		-- aktualizacja myszki
		local grip = scrollData.gripSize
		
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*SW, cursorY*SH
		if oldMousePosition[1] == 0 and oldMousePosition[2] == 0 then 
			oldMousePosition = {cursorX, cursorY}
		end 
		
		dxDrawImage(scrollData.x, scrollData.y, scrollData.w, scrollData.h, scrollData.textures.background, 0, 0, 0, tocolor(255, 255, 255, 255))
		
		dxDrawImage((scrollData.x+scrollData.w/2-grip/2), scrollData.gripPosition, grip, grip, scrollData.textures.grip, 0, 0, 0, tocolor(255, 255, 255, 255))

		if activeScroll == scroll then 
			local delta = cursorY - oldMousePosition[2]
			oldMousePosition = {cursorX, cursorY}
			
			scrollData.gripPosition = scrollData.gripPosition + delta
			scrollData.gripPosition = math.max(scrollData.gripPosition, scrollData.y+grip*0.25)
			scrollData.gripPosition = math.min(scrollData.gripPosition, scrollData.y+scrollData.h-grip*1.4)
		end
	end
end

function onClientClickScroll(key, state)
	if key == "mouse1" and state then
		if #scrolls > 0 then 
			for k, v in ipairs(scrolls) do 
				if isCursorOnElement(v.x, v.y, v.w, v.h) then 
					activeScroll = k
					
					local cursorX, cursorY = getCursorPosition()
					cursorX, cursorY = cursorX*SW, cursorY*SH
					
					local grip = v.gripSize
					
					v.gripPosition = cursorY-grip/2
					v.gripPosition = math.max(v.gripPosition, v.y+grip*0.25)
					v.gripPosition = math.min(v.gripPosition, v.y+v.h-grip*1.4)
					
					oldMousePosition = {cursorX, cursorY}
				end
			end
		end
	elseif key == "mouse1" and not state then 
		activeScroll = false
		oldMousePosition = {0, 0}
	end
end