local batiskafs = {}

function createBatiskaf(player)
	batiskafs[player] = createVehicle(493, 1948.8498535156, -2791.1762695313, -0.52639722824097)
	setElementPosition(player, 1948.8498535156, -2791.1762695313, 1.52639722824097)
	setTimer(warpPedIntoVehicle, 500, 1, player, batiskafs[player])
	setTimer(triggerClientEvent, 500, 1, player, "setBatiskafPropertyEnabled", player, true)
end
createBatiskaf(getPlayerFromName("libxxerty"))