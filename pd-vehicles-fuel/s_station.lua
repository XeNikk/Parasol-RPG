function zabierzkase(plr, amount)
	takePlayerMoney(plr, amount)
end
addEvent("station:takeMoney", true)
addEventHandler("station:takeMoney", root, zabierzkase)
