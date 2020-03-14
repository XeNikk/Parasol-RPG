z = 0
camera = function()
	local x, y, z2 = getElementPosition(localPlayer)
	setCameraMatrix(1375.0437011719, -256.08676147461, 2.15659596025944, x, y, z2 + z)
	z = z + 0.001
end

addCommandHandler("came", function()
	addEventHandler("onClientRender", root, camera)
	p = createObject(1681, 1487.5959472656, -2322.3923339844, 134.132629394531, 0, 0, -90)
	moveObject(p, 10000, 1806.8375244141, -2322.3747558594, 32.649837493896, 20, 0, 0)
	engineSetModelLODDistance(1681, 10000)
end)