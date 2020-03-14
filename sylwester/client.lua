local fireworks = {}
local fireTexture = dxCreateTexture("images/gwiazda.png")
local startSpeed = 1
local fireworkObject = createObject(2000, 0, 0, 0)
setElementAlpha(fireworkObject, 0)
setElementCollisionsEnabled(fireworkObject, false)

function getPositionFromElementOffset(element,offX,offY,offZ)
	local m = getElementMatrix (element)
	local x = offX * m[1][1] + offY * m[2][1] + offZ * m[3][1] + m[4][1]
	local y = offX * m[1][2] + offY * m[2][2] + offZ * m[3][2] + m[4][2]
	local z = offX * m[1][3] + offY * m[2][3] + offZ * m[3][3] + m[4][3]
	return x, y, z
end

function initColor(color)
	if color == "random" then
		return {math.random(0, 255), math.random(0, 255), math.random(0, 255)}
	else
		return color
	end
end

function createParticles(x, y, z, ftype, count, strength, color)
	particlesTable = {}
	color = initColor(color)
	if ftype == "partification" then
		for i = 1, count do
			local rot = math.floor(360/count) * i
			setElementRotation(fireworkObject, 0, 0, rot)
			vx, vy, vz = getPositionFromElementOffset(fireworkObject, 0, strength, 0)
			table.insert(particlesTable, {0, 0, 0, vx, vy, vz, 255, color})
		end
	elseif ftype == "explosion" then
		for i = 1, count do
			for c = 1, count do
				local rotZ = math.floor(360/count) * i
				local rotX = math.floor(360/count) * c
				setElementRotation(fireworkObject, rotX, 0, rotZ)
				vx, vy, vz = getPositionFromElementOffset(fireworkObject, 0, strength, 0)
				table.insert(particlesTable, {0, 0, 0, vx, vy, vz, 255, color})
			end
		end
	else
		if patterns[ftype] then
			for k,v in pairs(patterns[ftype]) do
				if tonumber(k) and v == 1 then
					z = math.floor(k / patterns[ftype].max)
					x = k - (patterns[ftype].max * (z)) + 1 - (patterns[ftype].max/2)
					setElementRotation(fireworkObject, 0, 0, 0)
					vx, vy, vz = getPositionFromElementOffset(fireworkObject, -x/strength, 0, -z/strength)
					table.insert(particlesTable, {0, 0, 0, vx, vy, vz, 255, color})
				end
			end
			--table.insert(particlesTable, {0, 0, 0, vx, vy, vz, 255, color})
		end
	end
	return particlesTable
end

function createFirework(x, y, z, ftype, count, strength, height, color)
	local particlesTable = {}

	particlesTable = createParticles(x, y, z, ftype, count, strength, color)

	local newTable = {
		x, y, z, z + height, particles=particlesTable, boom=false
	}
	soundHandler = playSound3D("sounds/launch" .. math.random(1, 2) .. ".mp3", x, y, z)
	setSoundMinDistance(soundHandler, 100)
	setSoundMaxDistance(soundHandler, 150)
    table.insert(fireworks, newTable)
end

addEvent("createFirework", true)
addEventHandler("createFirework", localPlayer, createFirework)

addEventHandler("onClientRender", root, function()
	px, py, pz = getElementPosition(localPlayer)
	for k,v in pairs(fireworks) do
		if v[3] < v[4] then
			v[3] = v[3] + 0.5
		end
		if #v.particles < 1 then
			fireworks[k] = nil
		else
			for id,c in pairs(v.particles) do
				x, y, z = v[1] + c[1], v[2] + c[2], (v[3] + c[3])
				dist = math.min(getDistanceBetweenPoints3D(px, py, pz, x, y, z) / 100, 1)
				if v[3] >= v[4] then
					if not v.boom then
						v.boom = true
						soundHandler = playSound3D("sounds/explode" .. math.random(1, 3) .. ".mp3", v[1], v[2], v[3])
						setSoundMinDistance(soundHandler, 250)
						setSoundMaxDistance(soundHandler, 400)
					end
					c[1], c[2], c[3] = c[1] + c[4], c[2] + c[5], c[3] + c[6]
					c[4] = c[4] * 0.95
					c[5] = c[5] * 0.95
					c[6] = c[6] * 0.95
					c[7] = c[7] * 0.97
					if c[7] < 5 then
						v.particles[id] = nil
						break
					end
					dxDrawMaterialLine3D(x, y, z-dist, x, y, z+dist, fireTexture, dist*2, tocolor(c[8][1], c[8][2], c[8][3], c[7]))
				else
					dxDrawMaterialLine3D(x, y, z-1, x, y, z+1, fireTexture, 1*2, tocolor(107, 36, 0, 10))
				end
			end
		end
	end
end)