local neonTexture = dxCreateTexture("images/neon.png")
local neonLights = {}

addEventHandler("onClientPreRender", root, function()
	local px, py, pz = getElementPosition(localPlayer)
	for k,v in pairs(getElementsByType("vehicle")) do
		local vx, vy, vz = getElementPosition(v)
		local neonData = getElementData(v, "vehicle:neon")
		if getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz) < 100 and neonData then
			local x0, y0, z0, x1, y1, z1 = getElementBoundingBox(v)
			if neonData.left then
				local sx, sy, sz = getPositionFromElementOffset(v, x0 + 0.3, 1.25, 0)
				local cx, cy, cz = getPositionFromElementOffset(v, x0 + 0.3, 0, 0)
				local ex, ey, ez = getPositionFromElementOffset(v, x0 + 0.3, -1.25, 0)
				local sz = getGroundPosition(sx, sy, sz) + 0.01
				local ez = getGroundPosition(ex, ey, ez) + 0.01
				dxDrawMaterialLine3D(sx, sy, sz, ex, ey, ez, neonTexture, 1.5, tocolor(unpack(neonData.color)), false, cx, cy, cz + 1)
			end
			if neonData.right then
				local sx, sy, sz = getPositionFromElementOffset(v, x1 - 0.3, 1.25, 0)
				local cx, cy, cz = getPositionFromElementOffset(v, x1 - 0.3, 0, 0)
				local ex, ey, ez = getPositionFromElementOffset(v, x1 - 0.3, -1.25, 0)
				local sz = getGroundPosition(sx, sy, sz) + 0.01
				local ez = getGroundPosition(ex, ey, ez) + 0.01
				dxDrawMaterialLine3D(sx, sy, sz, ex, ey, ez, neonTexture, 1.5, tocolor(unpack(neonData.color)), false, cx, cy, cz + 1)
			end
			if neonData.front then
				local sx, sy, sz = getPositionFromElementOffset(v, 0.75, y1 - 0.3, 0)
				local cx, cy, cz = getPositionFromElementOffset(v, 0, y1 - 0.3, 0)
				local ex, ey, ez = getPositionFromElementOffset(v, -0.75, y1 - 0.3, 0)
				local sz = getGroundPosition(sx, sy, sz) + 0.01
				local ez = getGroundPosition(ex, ey, ez) + 0.01
				dxDrawMaterialLine3D(sx, sy, sz, ex, ey, ez, neonTexture, 1.5, tocolor(unpack(neonData.color)), false, cx, cy, cz + 1)
			end
			if neonData.rear then
				local sx, sy, sz = getPositionFromElementOffset(v, 0.75, y0 + 0.3, 0)
				local cx, cy, cz = getPositionFromElementOffset(v, 0, y0 + 0.3, 0)
				local ex, ey, ez = getPositionFromElementOffset(v, -0.75, y0 + 0.3, 0)
				local sz = getGroundPosition(sx, sy, sz) + 0.01
				local ez = getGroundPosition(ex, ey, ez) + 0.01
				dxDrawMaterialLine3D(sx, sy, sz, ex, ey, ez, neonTexture, 1.5, tocolor(unpack(neonData.color)), false, cx, cy, cz + 1)
			end
		end
	end
end)

function getPositionFromElementOffset(element,offX,offY,offZ)
    local m = getElementMatrix (element)
    local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
    local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
    local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
    return x, y, z
end