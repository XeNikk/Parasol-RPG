sx, sy = guiGetScreenSize()
zoom = exports["pd-gui"]:getInterfaceZoom()
normal_small = exports["pd-gui"]:getGUIFont("normal_small")
local radarRotation = 0
local fuel = 100
local oxygen = 100
local maximumfuel = 600
local maximumoxygen = 800
local createdPoints = {id=1}
local drillActive = false

local progressSize = {w=math.floor((1074/zoom)*0.5), h=math.floor((74/zoom)*0.5)}
local progressTextures = {normal=dxCreateTexture(":pd-hud/images/download/progressbar.png"), active=dxCreateTexture(":pd-hud/images/download/progressbar_active.png")}

regenerating = false

setTimer(function()
	if getElementData(localPlayer, "player:job") ~= "astronaut" then return end
	local dist = getDistanceBetweenPoints2D(5356.2958984375,319.079101562, x, y)
	if dist > 25 then
		oxygen = oxygen - 0.1
		if oxygen < 0 then
			oxygen = 0
			triggerServerEvent("killPlayer", resourceRoot, localPlayer)
			setTimer(function()
				endJob()
			end, 1000, 1)
		end
	end
end, 1000, 0)

function reloadPoints()
	local x, y, z = getElementPosition(localPlayer)
	for k,v in ipairs(points) do
		local dist = getDistanceBetweenPoints2D(v[1], v[2], x, y)
		local dist = dist
		if dist > 100 then
			if not createdPoints[k] then
				createdPoints[k], id = exports["pd-markers"]:createCustomMarker(v[1], v[2], v[3]-1, 255, 255, 50, 155, "marker", 1)
				setElementData(createdPoints[k], "astronaut:marker:id", id)
				setElementData(createdPoints[k], "astronaut:marker:idc", k)
				
				addEventHandler("onClientMarkerHit", createdPoints[k], function(el, md)
					if el == localPlayer and not isPedInVehicle(el) then
						id = getElementData(source, "astronaut:marker:id")
						idc = getElementData(source, "astronaut:marker:idc")
						createdPoints[idc] = false
						if id then
							exports["pd-markers"]:destroyCustomMarker(id)
							source = nil
							drillSound = playSound("sounds/drill.mp3")
							triggerServerEvent("setDrillAnimation", resourceRoot, localPlayer)
							toggleAllControls(false)
							drillActive = getTickCount()
							setTimer(function()
								toggleAllControls(true)
								drillActive = false
								stopSound(drillSound)
								triggerServerEvent("onPlayerDrillResource", resourceRoot, localPlayer)
							end, 5000, 1)
						end
					end
				end)
			end
		end
	end
end
reloadPoints()

setTimer(function()
	reloadPoints()
end, 60 * 1000 * 10, 0)

addEventHandler("onClientRender", root, function()
	if getElementData(localPlayer, "player:job") ~= "astronaut" then return end
	radarRotation = radarRotation + 1
	local x, y, z = getElementPosition(localPlayer)
	local cx, cy, cz, tx, ty, tz = getCameraMatrix(localPlayer)
	local north = findRotation(cx, cy, tx, ty)
	local bx, by = getScreenFromWorldPosition(5356.2958984375,319.079101562,848.26599121094)
	local dist = getDistanceBetweenPoints2D(5356.2958984375,319.079101562, x, y)
	-- baza
	if bx and by and dist > 25 then
		alpha = (dist - 25) * 10
		if alpha > 255 then alpha = 255 end
		dxDrawText(math.floor(dist) .. "m", bx - 64/zoom, by+60/zoom, bx + 45/zoom, by+60/zoom, tocolor(255, 255, 255, alpha), 1/zoom, normal_small, "center", "center")
		dxDrawImage(bx - 64/zoom, by - 64/zoom, 128/zoom, 128/zoom, "images/base.png", 0, 0, 0, tocolor(255, 255, 255, alpha))
	end

	-- radar
	dxDrawImage(50/zoom, sy-450/zoom, 350/zoom, 350/zoom, "images/background.png")
	dxDrawImage(50/zoom, sy-450/zoom, 350/zoom, 350/zoom, "images/background_light.png", radarRotation)
	for i,v in pairs(createdPoints) do
		if v and isElement(v) then
			ox, oy = getElementPosition(v)
			local dist = getDistanceBetweenPoints2D(x, y, ox, oy) / 2
			if dist < 150/zoom then
				local angle = 180-north + findRotation(x, y, ox, oy)
				local pointx, pointy = getPointFromDistanceRotation(0, 0, dist, angle)

				dxDrawImage(225/zoom+pointx-10/zoom, sy-275/zoom+pointy-10/zoom, 20/zoom, 20/zoom, "images/light.png")
			end
		end
	end
	-- dodatki
	dxDrawImage(400/zoom, sy-385/zoom, 50/zoom, 220/zoom, "images/fuel.png")
	dxDrawImage(450/zoom, sy-385/zoom, 50/zoom, 220/zoom, "images/oxygen.png")
	dxDrawImageSection(400/zoom, sy-165/zoom, 50/zoom, -fuel*(220/100)/zoom, 0, 0, 53, fuel*(223/100), "images/fuel_active.png")
	dxDrawImageSection(450/zoom, sy-165/zoom, 50/zoom, -oxygen*(220/100)/zoom, 0, 0, 53, oxygen*(223/100), "images/oxygen_active.png")
	dxDrawImage(400/zoom, sy-165/zoom, 50/zoom, 50/zoom, "images/fuel_icon.png")
	dxDrawImage(450/zoom, sy-165/zoom, 50/zoom, 50/zoom, "images/oxygen_icon.png")
	dxDrawText(math.floor(fuel*(maximumfuel/100)), 425/zoom, sy-400/zoom, 425/zoom, sy-400/zoom, tocolor(255, 0, 245, 255), 1/zoom, normal_small, "center", "center")
	dxDrawText(math.floor(oxygen*(maximumoxygen/100)), 475/zoom, sy-400/zoom, 475/zoom, sy-400/zoom, tocolor(0, 168, 255, 255), 1/zoom, normal_small, "center", "center")
	-- ubieranie paliwa
	z = z - getGroundPosition(x, y, z+1)
	if z > 1.1 then
		fuel = fuel - 0.005
	end
	if fuel < 0 then
		fuel = 0
		toggleControl("sprint", false)
		toggleControl("jump", false)
	else
		toggleControl("sprint", true)
		toggleControl("jump", true)
	end
	if regenerating then
		fuel = fuel + 0.05
		oxygen = oxygen + 0.05
		if fuel*(maximumfuel/100) > maximumfuel then fuel = maximumfuel/(maximumfuel/100) end
		if oxygen*(maximumoxygen/100) > maximumoxygen then oxygen = maximumoxygen/(maximumoxygen/100) end
	end
	if drillActive then
		local tick = getTickCount()
		local progress = (tick-drillActive)/5000
		dxDrawImage(sx/2 - progressSize.w/2, sy - 150/zoom, progressSize.w, progressSize.h, progressTextures.normal)
		dxDrawImageSection(sx/2 - progressSize.w/2, sy - 150/zoom, progressSize.w*progress, progressSize.h, 0, 0, 1074*progress, 74, progressTextures.active)
		dxDrawText("Wydobywanie surowca", sx/2, sy - 150/zoom, sx/2, sy - 150/zoom + progressSize.h, white, 1/zoom, normal_small, "center", "center")
	end
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
	for k,v in pairs(createdPoints) do
		if v and isElement(v) then
			id = getElementData(v, "astronaut:marker:id")
			if id then
				exports["pd-markers"]:destroyCustomMarker(id)
			end
		end
	end
end)

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end

function findRotation(x1, y1, x2, y2) 
    local t = -math.deg(math.atan2(x2 - x1, y2 - y1))
    return t < 0 and t + 360 or t
end