addEvent("setDimension", true)
addEventHandler("setDimension", resourceRoot, function(plr, dim)
	setElementDimension(plr, dim)
end)

addEvent("giveWeapon", true)
addEventHandler("giveWeapon", resourceRoot, function(plr, id)
	giveWeapon(plr, id, 300)
end)

addEvent("takeWeapon", true)
addEventHandler("takeWeapon", resourceRoot, function(plr, id)
	takeWeapon(plr, id)
end)