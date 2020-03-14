sx, sy = guiGetScreenSize()

function getPositionFromElementOffset(element,offX,offY,offZ)
		local m = getElementMatrix(element)
		local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
		local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
		local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
		return x, y, z
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function isTriangleMouse( x1, y1, x2, y2, x3, y3, px, py )
		local areaOrig = math.abs( (x2-x1)*(y3-y1) - (x3-x1)*(y2-y1) )
		local area1 = math.abs( (x1-px)*(y2-py) - (x2-px)*(y1-py) )
		local area2 = math.abs( (x2-px)*(y3-py) - (x3-px)*(y2-py) )
		local area3 = math.abs( (x3-px)*(y1-py) - (x1-px)*(y3-py) )
		if (area1 + area2 + area3 == areaOrig) then
				return true
		else
				return false
		end
end

function isMouseInHexagon(posX, posY, width, Angel)
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	if not cx or not cy then return end
	local cx, cy = ( cx * sx ), ( cy * sy )
	local posX = posX + width / 2
	local posY = posY + width / 2
	local Size = width / 2
	local lastX = nil
	local lastY = nil
	local points = {}
	for i=0,6 do
		local angle = Angel+(2 * math.pi / 6 * (i + 0.5) )
		local x = posX + Size * math.cos(angle)
		local y = posY + Size * math.sin(angle)
		if i > 0 then
			--dxDrawText(i, lastX, lastY, 100, 100, tocolor(255, 255, 255, 255) )
			--dxDrawLine(lastX, lastY, x, y, tocolor(255, 0, 0, 255))
		end
		points[i+1] = { Vector2(lastX, lastY), Vector2(x, y) }
		lastX = x
		lastY = y
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cursor = Vector2(cx * sx, cy * sy)
	local toggle = false
	if isTriangleMouse(points[6][2].x, points[6][2].y, points[2][2].x, points[2][2].y, points[3][2].x, points[3][2].y, cursor.x, cursor.y) or isTriangleMouse(points[3][2].x, points[3][2].y, points[4][2].x, points[4][2].y, points[5][2].x, points[5][2].y, cursor.x, cursor.y) or isTriangleMouse(points[2][2].x, points[2][2].y, points[6][2].x, points[6][2].y, points[1][2].x, points[1][2].y, cursor.x, cursor.y) or isTriangleMouse(points[6][2].x, points[6][2].y, points[3][2].x, points[3][2].y, points[5][2].x, points[5][2].y, cursor.x, cursor.y) then
		toggle = true
	end
	--[[dxDrawLine(points[3][2].x, points[3][2].y, points[4][2].x, points[4][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[4][2].x, points[4][2].y, points[5][2].x, points[5][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[5][2].x, points[5][2].y, points[3][2].x, points[3][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[6][2].x, points[6][2].y, points[3][2].x, points[3][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[3][2].x, points[3][2].y, points[5][2].x, points[5][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[5][2].x, points[5][2].y, points[6][2].x, points[6][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[2][2].x, points[2][2].y, points[6][2].x, points[6][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[1][2].x, points[1][2].y, points[2][2].x, points[2][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[1][2].x, points[1][2].y, points[6][2].x, points[6][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[2][2].x, points[2][2].y, points[3][2].x, points[3][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[3][2].x, points[3][2].y, points[6][2].x, points[6][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)
	dxDrawLine(points[6][2].x, points[6][2].y, points[2][2].x, points[2][2].y, toggle and tocolor(255, 0, 0, 255) or tocolor(0, 255, 0, 255), 2.0)]]
	return toggle
end

function validemail(str)
	if str == nil then return nil end
	if (type(str) ~= 'string') then
		error("Expected string")
		return nil
	end
	local lastAt = str:find("[^%@]+$")
	local localPart = str:sub(1, (lastAt - 2)) -- Returns the substring before '@' symbol
	local domainPart = str:sub(lastAt, #str) -- Returns the substring after '@' symbol
	-- we werent able to split the email properly
	if localPart == nil then
		return nil, "Local name is invalid"
	end

	if domainPart == nil then
		return nil, "Domain is invalid"
	end
	-- local part is maxed at 64 characters
	if #localPart > 64 then
		return nil, "Local name must be less than 64 characters"
	end
	-- domains are maxed at 253 characters
	if #domainPart > 253 then
		return nil, "Domain must be less than 253 characters"
	end
	-- somthing is wrong
	if lastAt >= 65 then
		return nil, "Invalid @ symbol usage"
	end
	-- quotes are only allowed at the beginning of a the local name
	local quotes = localPart:find("[\"]")
	if type(quotes) == 'number' and quotes > 1 then
		return nil, "Invalid usage of quotes"
	end
	-- no @ symbols allowed outside quotes
	if localPart:find("%@+") and quotes == nil then
		return nil, "Invalid @ symbol usage in local part"
	end
	-- no dot found in domain name
	if not domainPart:find("%.") then
		return nil, "No TLD found in domain"
	end
	-- only 1 period in succession allowed
	if domainPart:find("%.%.") then
		return nil, "Too many periods in domain"
	end
	if localPart:find("%.%.") then
		return nil, "Too many periods in local part"
	end
	-- just a general match
	if not str:match('[%w]*[%p]*%@+[%w]*[%.]?[%w]*') then
		return nil, "Email pattern test failed"
	end
	-- all our tests passed, so we are ok
	return true
end