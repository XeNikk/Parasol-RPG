function createFirework(x, y, z, ftype, count, strength, height, color)
	triggerClientEvent(root, "createFirework", root, x, y, z, ftype, count, strength, height, color)
end

setTimer(function()
	createFirework(1422.005859375, -1160.6745605469, 23.65625, "logo", 0.1, 50, 80, {255, 0, 0})
	end, 1000, 1)
	setTimer(function()
		createFirework(1969.5679931641, -1057.0015869141, 68.273490905762, "start", 0.1, 50, 80, {255, 0, 0})
		end, 3000, 1)
		