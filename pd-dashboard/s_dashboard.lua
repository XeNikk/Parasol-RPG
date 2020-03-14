addEvent("getPlayerVehicles", true)
addEventHandler("getPlayerVehicles", resourceRoot, function(plr)
	uid = getElementData(plr, "player:uid")
	if uid then
		q = exports["pd-mysql"]:query("SELECT * FROM `pd-vehicles` WHERE owner=" .. uid)
		triggerClientEvent(plr, "returnVehiclesCount", plr, #q)
	end
end)




addEvent("dashboard:addPremium", true)
addEventHandler("dashboard:addPremium", root, function(plr, days, saldo)

	check=exports["pd-mysql"]:query("SELECT `saldoPP`,DATEDIFF(`premiumDate`,now()) as roznica from `pd-players` WHERE `uid`=? limit 1",getElementData(plr, "player:uid"))[1]

	if check.roznica and check.roznica>0 then
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `premiumDate`=now() + interval ? day WHERE `uid`=? limit 1",days+check.roznica,getElementData(plr, "player:uid"))
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `saldoPP`=`saldoPP`-? WHERE `uid`=? limit 1",saldo,getElementData(plr, "player:uid"))
		setElementData(plr, "player:premium", true)
		refreshPremium(plr)
	else
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `premiumDate`=now() + interval ? day WHERE `uid`=? limit 1",days,getElementData(plr, "player:uid"))
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `saldoPP`=`saldoPP`-? WHERE `uid`=? limit 1",saldo,getElementData(plr, "player:uid"))
		setElementData(plr, "player:premium", true)
		refreshPremium(plr)
	end
end)

function refreshPremium(plr)
		data=exports["pd-mysql"]:query("SELECT `saldoPP`,`premiumDate`,DATEDIFF(`premiumDate`,now()) as roznica from `pd-players` where `uid`=? limit 1",getElementData(plr, "player:uid"))[1]
		setElementData(plr,"player:premiumdate",data.premiumDate)
		setElementData(plr, "player:saldoPP", data.saldoPP)
end