addEvent("onClientClickGridlist", true)
addEvent("onClientHoverGridlist", true)
addEvent("onClientSelectGridlistItem", true)

local listID = 0
local activeGridlist = false 

local previousRow, previousRowData = nil, nil -- do hovera i kliku

function createGridlist(x, y, w, h, scrollTextures)
	if x and y and w and h then 
		listID = listID + 1
		
		local sw, sh = dxGetMaterialSize(scrollTextures.background)
		local gripSize = dxGetMaterialSize(scrollTextures.grip)
		local scroll = createScroll(math.floor(x+w+sw/zoom/2), y, math.floor(sw/zoom), h, scrollTextures, (gripSize*0.8)/zoom)
		
		local listData = {  
			x=x, 
			y=y,
			w=w, 
			h=h,
			font="default-bold",
			fontSize=1.0,
			columns={},
			columnsSize={},
			columnsOffsets={},
			sortedColumns={},
			selectionMode="single", -- lub many
			scroll=scroll,
			maxRows=0,
		}
		
		local maxRows = 0
		local itemH = dxGetFontHeight(listData.fontSize, listData.font)*1.5+dxGetFontHeight(listData.fontSize, listData.font)
		repeat 
			maxRows = maxRows+1
			itemH = itemH+dxGetFontHeight(listData.fontSize, listData.font)*1.5
		until itemH >= h
		listData.maxRows = maxRows
		
		local el = createElement("pd_gridlist", "pd_gridlist"..tostring(listID)) 
		setElementData(el, "data", listData, false)
		
		activeGridlist = el

		return el
	end
end 

function destroyGridlist(list)
	if isElement(list) and getElementType(list) == "pd_gridlist" then 
		local data = getElementData(list, "data")
		destroyScroll(data.scroll)
		
		if list == activeGridlist then 
			activeGridlist = false
		end 
		
		destroyElement(list)
	end
end

function addGridlistColumn(list, column, size)
	if isElement(list) and getElementType(list) == "pd_gridlist" then 
		local data = getElementData(list, "data")
		data.columns[column] = {}
		
		local offset = 0 
		for k, v in pairs(data.columnsSize) do 
			offset = offset + (v * data.w)
		end
		
		data.columnsSize[column] = size
		data.columnsOffsets[column] = offset
		
		table.insert(data.sortedColumns, column)
		setElementData(list, "data", data, false)
		
		return true
	end
	
	return false
end 

function addGridlistItem(list, column, item)
	if isElement(list) and getElementType(list) == "pd_gridlist" and item then
		local data = getElementData(list, "data")
		if data.columns[column] then
			
			table.insert(data.columns[column], {title=item, selected=false, color={255, 255, 255, 255}})
			setElementData(list, "data", data, false)
			
			return #data.columns[column]
		end
	end
	
	return false
end

function setGridlistFont(list, font, fontSize)
	if isElement(list) and getElementType(list) == "pd_gridlist" and font and fontSize then
		local data = getElementData(list, "data")
		data.font = font 
		data.fontSize = fontSize
		
		local maxRows = 0
		local itemH = dxGetFontHeight(fontSize, font)*1.5+dxGetFontHeight(data.fontSize, data.font)
		repeat 
			maxRows = maxRows+1
			itemH = itemH+dxGetFontHeight(fontSize, font)*1.5
		until itemH >= data.h
		data.maxRows = maxRows 
		
		setElementData(list, "data", data, false)
	end
end

function setGridlistSelectionMode(list, type)
	if isElement(list) and getElementType(list) == "pd_gridlist" and type then 
		local data = getElementData(list, "data")
		data.selectionMode = type 
		setElementData(list, "data", data, false)
	end
end 

function setGridlistItemSelected(list, column, item, bool)
	if isElement(list) and getElementType(list) == "pd_gridlist" and item then
		local data = getElementData(list, "data")
		if data.columns[column] then
			data.columns[column][item].selected = bool
			setElementData(list, "data", data, false)
			return true
		end
	end
	
	return false
end

function setGridlistItemColor(list, column, item, color)
	if isElement(list) and getElementType(list) == "pd_gridlist" and item then
		local data = getElementData(list, "data")
		if data.columns[column] then
			data.columns[column][item].color = color
			setElementData(list, "data", data, false)
			return true
		end
	end
	
	return false
end 

function moveGridlistScroll(list, direction, value)
	if isElement(list) and getElementType(list) == "pd_gridlist" and direction and value then
		local data = getElementData(list, "data")
		moveScroll(data.scroll, direction, value)
		return true
	end
	
	return false
end

function getGridlistSelectedItems(list, outputNames)
	if isElement(list) and getElementType(list) == "pd_gridlist" then 
		local data = getElementData(list, "data")
		local items = {} 
		for k, item in ipairs(data.columns[data.sortedColumns[1]]) do
			if item.selected == true then 
				if outputNames then 
					table.insert(items, item.title)
				else
					table.insert(items, k)
				end
			end
		end 
		
		return items
	end
	
	return false
end 

function clearGridlistItems(list)
	if isElement(list) and getElementType(list) == "pd_gridlist" then 
		local data = getElementData(list, "data")
		for k, v in pairs(data.columns) do 
			data.columns[k] = {}
		end
		setElementData(list, "data", data, false)
	
		return true
	end
	
	return false
end

local prevSelectedItem = false
function renderGridlist(list)
	if isElement(list) and getElementType(list) == "pd_gridlist" then 
		local data = getElementData(list, "data")
		if isCursorOnElement(data.x, data.y, data.w, data.h) then 
			activeGridlist = list
		end 
		
		-- itemy 
		local scrollProgress = getScrollProgress(data.scroll)
		
		local offsetX = 0
		local itemH = dxGetFontHeight(data.fontSize, data.font)*1.5
		
		for i, columnName in ipairs(data.sortedColumns) do 
			offsetX = data.columnsOffsets[columnName]
			offsetY = dxGetFontHeight(data.fontSize, data.font)
			
			dxDrawText(columnName, data.x+offsetX+10, data.y, 0, data.y+dxGetFontHeight(data.fontSize*0.85, data.font), tocolor(220, 220, 220, 255), data.fontSize*0.85, data.font, "left", "center")
				
			-- wyświetlamy teraz itemsy 
			local selectedRow = 1
			local visibleRows = data.maxRows
			if #data.columns[data.sortedColumns[1]] > data.maxRows then 
				selectedRow = math.ceil(scrollProgress * (#data.columns[data.sortedColumns[1]]-data.maxRows+1))
				visibleRows = math.max(data.maxRows, selectedRow+data.maxRows-1)
						
				renderScroll(data.scroll)
			end 
			
			for k, item in ipairs(data.columns[columnName]) do 
				if k >= selectedRow and k <= visibleRows then 
					local x, y, w, h = data.x+offsetX, data.y+offsetY, data.w, itemH
					if i == 1 then
						if isCursorOnElement(x, y, w, h) then 
							if item.selected then
								dxDrawRectangle(x, y, w, h, tocolor(255, 51, 204, 150))
							else 
								dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 100))
							end 
							
							if (prevSelectedItem and prevSelectedItem.item ~= k) then 
								playHoverSound()
							end 
							
							prevSelectedItem = {title=item.title, item=k, column=columnName, x=x, y=y, w=w, h=h}
						else 
							if item.selected then 
								dxDrawRectangle(x, y, w, h, tocolor(255, 51, 204, 150))
							else 
								dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 150))
							end
						end
					end
					
					if item.selected then 
						dxDrawText(item.title, x+10, y, x+w, y+h, tocolor(255, 255, 255, 255), data.fontSize, data.font, "left", "center")
					else	
						dxDrawText(item.title, x+10, y, x+w, y+h, tocolor(item.color[1], item.color[2], item.color[3], item.color[4]), data.fontSize, data.font, "left", "center")
					end 
					
					offsetY = math.floor(offsetY+itemH+itemH*0.06)
				end
			end
		end
	end
end

function onClientClickGridlist(button, state)
	if button == "mouse1" and state then 
		if activeGridlist then 
			if prevSelectedItem and isCursorOnElement(prevSelectedItem.x, prevSelectedItem.y, prevSelectedItem.w, prevSelectedItem.h) then 
				local data = getElementData(activeGridlist, "data")
				if not data.columns[prevSelectedItem.column] or not data.columns[prevSelectedItem.column][prevSelectedItem.item] then return end 
				
				if data.selectionMode == "single" then 
					for k, item in ipairs(data.columns[prevSelectedItem.column]) do 
						local s = (k == prevSelectedItem.item) and (not item.selected) or false
						if s ~= item.selected then 
							triggerEvent("onClientSelectGridlistItem", activeGridlist, prevSelectedItem.title, prevSelectedItem.item, s == false)
						end
						item.selected = s
					end
					setElementData(activeGridlist, "data", data, false)
				elseif data.selectionMode == "many" then 
					local s = not data.columns[prevSelectedItem.column][prevSelectedItem.item].selected
					data.columns[prevSelectedItem.column][prevSelectedItem.item].selected = s
					setElementData(activeGridlist, "data", data, false)
					
					triggerEvent("onClientSelectGridlistItem", activeGridlist, prevSelectedItem.title, prevSelectedItem.item, s == false)
				elseif data.selectionMode == "none" then 
					return
				end
				
				triggerEvent("onClientClickGridlist", activeGridlist)
				playClickSound()
			end
		end
	elseif button == "mouse_wheel_up" then 
		if activeGridlist then 
			local data = getElementData(activeGridlist, "data")
			moveScroll(data.scroll, "up", data.h/(#data.columns[data.sortedColumns[1]]-data.maxRows))
		end
	elseif button == "mouse_wheel_down" then 
		if activeGridlist then 
			local data = getElementData(activeGridlist, "data")
			moveScroll(data.scroll, "down", data.h/(#data.columns[data.sortedColumns[1]]-data.maxRows))
		end
	end
end

--[[
local list = createGridlist(400, 00, 500, 400, {background=dxCreateTexture(":pd_repair/images/scrollbar.png"), grip=dxCreateTexture(":pd_repair/images/scrollbar_point.png")})
addGridlistColumn(list, "Siema1", 0.5)
addGridlistColumn(list, "Siema2", 0.5)
addGridlistItem(list, "Siema1", "elo1")
addGridlistItem(list, "Siema1", "elo2")
addGridlistItem(list, "Siema1", "elo3")
addGridlistItem(list, "Siema1", "elo4")
addGridlistItem(list, "Siema1", "elo5")
addGridlistItem(list, "Siema1", "elo6")
addGridlistItem(list, "Siema1", "elo7")
addGridlistItem(list, "Siema1", "elo1")
addGridlistItem(list, "Siema1", "elo2")
addGridlistItem(list, "Siema1", "elo3")
addGridlistItem(list, "Siema1", "elo4")
addGridlistItem(list, "Siema1", "elo5")
addGridlistItem(list, "Siema1", "elo6")
addGridlistItem(list, "Siema1", "elo7")
addGridlistItem(list, "Siema2", "elo1")
addGridlistItem(list, "Siema2", "elo2")
addGridlistItem(list, "Siema2", "elo3")
addGridlistItem(list, "Siema2", "elo4")
addGridlistItem(list, "Siema2", "elo5")
addGridlistItem(list, "Siema2", "elo6")
addGridlistItem(list, "Siema2", "kurwa elo7")

addEventHandler("onClientRender", root, function() renderGridlist(list) setGridlistFont(list, getGUIFont("normal"), 1/zoom) end)
--]]
