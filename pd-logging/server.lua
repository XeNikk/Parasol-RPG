exports["pd-mysql"]:query("CREATE TABLE IF NOT EXISTS `pd-players` (`uid` int NOT NULL AUTO_INCREMENT, `nick` text NOT NULL, `password` text NOT NULL, `rp` int NOT NULL DEFAULT 0, `email` text NOT NULL, `skin` int NOT NULL, `money` int NOT NULL DEFAULT 0, `bank_money` int NOT NULL DEFAULT 0, `pj` text NOT NULL, `job_stats` text NOT NULL, `job_upgrades` text NOT NULL, `last-login` text NOT NULL, `achievements` text NOT NULL, `addData` text NOT NULL, PRIMARY KEY (`uid`))")

addEvent("registerAccount", true)
addEventHandler("registerAccount", resourceRoot, function(player, login, password, email)
	q = exports["pd-mysql"]:query("SELECT * FROM `pd-players` WHERE `nick`=?", login)
	if #q > 0 then
		return triggerClientEvent(player, "addNotification", player, "Takie konto już istnieje", "error")
	end
	q = exports["pd-mysql"]:query("INSERT INTO `pd-players`(`nick`, `password`, `email`, `skin`, `money`, `bank_money`, `rp`, `pj`, `job_upgrades`, `job_stats`, `last-login`, `achievements`, `addData`) VALUES (?, ?, ?, 0, 0, 0, 0, ?, 0, 0, ?, ?, ?)", login, md5(password), email, "A,0,B,0,C,0,D,0", "", toJSON({}), toJSON({}))
	triggerClientEvent(player, "addNotification", player, "Pomyślnie założono konto", "success")
end)

addEvent("loginToAccount", true)
addEventHandler("loginToAccount", resourceRoot, function(player, login, password)
	q = exports["pd-mysql"]:query("SELECT * FROM `pd-players` WHERE `nick`=? AND `password`=?", login, md5(password))
	if #q < 1 then
		exports["pd-mysql"]:query("INSERT INTO `pd_logs_login`(`action`, `text`) VALUES (?,?)", "Logowanie nieudane (błędne dane)", ""..login.." | "..getPlayerSerial(player).." | "..getPlayerIP(player) )
		return triggerClientEvent(player, "addNotification", player, "Dane się nie zgadzają", "error")
	end
	logged = false
	for k,v in pairs(getElementsByType("player")) do
		if getPlayerName(v) == login and getElementData(v, "player:uid") then
			return triggerClientEvent(player, "addNotification", player, "Już zalogowany!", "error")
		end
	end
	triggerClientEvent(player, "loginToServer", player)
	setElementData(player, "player:last:uid", q[1]["uid"])
	exports["pd-mysql"]:query("INSERT INTO `pd_logs_login`(`action`, `text`) VALUES (?,?)", "Pomyślne logowanie", ""..q[1]["nick"].." ("..q[1]["uid"]..") | "..getPlayerSerial(player).." | "..getPlayerIP(player) )
	exports["pd-mysql"]:query('UPDATE `pd-players` SET `active`=1 WHERE `uid`=?', q[1]["uid"])
end)

function savePlayerData(plr)
	if not plr then return end
	local uid = getElementData(plr, "player:uid")
	if not uid then return end
	local rp = getElementData(plr, "player:rp")
	local skin  = getElementData(plr, "player:skin")
	local achievements  = getElementData(plr, "player:achievements")
	local money = getPlayerMoney(plr)
	local pj = getElementData(plr, "player:pj")
	local pj = exports["pd-core"]:tableToString(pj)
	local addData = getElementData(plr, "player:addData")
	local bank_money = getElementData(plr, "player:bank")
	local saldoPP = getElementData(plr, "player:saldoPP")
	local warns = getElementData(plr, "player:warns")

	if warns == 5 then 
		warny = 0
	else 
		warny = warns
	end

	exports["pd-mysql"]:query('UPDATE `pd-players` SET `rp`=?, `warns`=?, `saldoPP`=?, `skin`=?, `money`=?, `bank_money`=?, `pj`=?, `last-login`=?, `achievements`=?, `addData`=?, `active`=0 WHERE `uid`=?', rp, warny, saldoPP, skin, money, bank_money, pj, toJSON({serial=getPlayerSerial(plr), ip=getPlayerIP(plr)}), toJSON(achievements), toJSON(addData), uid)
end

addEventHandler("onPlayerQuit", root, function()
		savePlayerData(source)
end)

addCommandHandler("zapisz", function(plr, cmd, target)
    if not getElementData(plr, "player:admin", true) then return end
    if not target then return end
	local fromNick = getPlayerFromName(target)
	savePlayerData(fromNick)
	print("Zapisano statystyki gracza "..getPlayerName(fromNick)..".")

end)



addEvent("spawnPlayer", true)
addEventHandler("spawnPlayer", resourceRoot, function(player, x, y, z)
	spawnPlayer(player, x, y, z)
	toggleControl(player, "fire", false)
	toggleControl(player, "aim_weapon", false)
	fadeCamera(player, true)
	setCameraTarget(player, player)
	showChat(player, true)
	loadPlayerData(player, getElementData(player, "player:last:uid"))
end)

function loadPlayerData(player, uid)
	q = exports["pd-mysql"]:query("SELECT * FROM `pd-players` WHERE `uid`=?", uid)
	data = q[1]
	local upgrades = fromJSON(data["job_upgrades"]) or {}
	setElementData(player, "player:job_upgrades", upgrades)
	setElementData(player, "player:uid", data["uid"])
	setElementData(player, "player:rp", data["rp"])
	setElementData(player, "player:addData", fromJSON(data["addData"]) or {})
	setElementData(player, "player:skin", data["skin"])
	setElementData(player, "player:spaned", true)
	setElementModel(player, tonumber(data["skin"]))
	setElementData(player, "player:pj", exports["pd-core"]:tableFromString(data["pj"]))
	setElementData(player, "player:logged", true)
	setElementData(player, "player:spawned", true)
	setElementData(player, "player:achievements", fromJSON(data["achievements"]) or {})
	setElementData(player, "player:showingGUI", false)
	setElementData(player, "player:bank", data["bank_money"])
	setElementData(player, "player:saldoPP", data["saldoPP"])
	setElementData(player, "player:warns", data["warns"])
	setPlayerName(player, data["nick"])
	setPlayerMoney(player, tonumber(data["money"]))
	setElementModel(player, tonumber(data["skin"]))

	local checkpremium = exports["pd-mysql"]:query("SELECT * FROM `pd-players` WHERE `uid`=? AND `premiumDate`>NOW() LIMIT 1;", getElementData(player, "player:uid"))
	if checkpremium and #checkpremium > 0 then
		setElementData(player, "player:premium", true)
		setElementData(player, "player:premiumdate", data["premiumDate"])
		setTimer(premiumMoney, 60 * 1000 * 60, 0, player, 500)
	else
		setElementData(player, "player:premium", false)
	end

	local checkmute = exports["pd-mysql"]:query("SELECT * FROM `pd-punishments` WHERE `serial`=? AND `active`=1 AND `timeout`>NOW() LIMIT 1;", getPlayerSerial(player))
	if checkmute and #checkmute > 0 then
		setElementData(player, "player:mute", true)
	else
		setElementData(player, "player:mute", false)
	end



	setPlayerNametagShowing(player, false)
	exports["pd-core"]:assignPlayerID(player)
	exports["pd-core"]:randomPedClothes(player)
	triggerEvent("onPlayerEnterGame", player)
end

function premiumMoney(plr, money)
	givePlayerMoney(plr, money)
	setElementData(plr, "player:rp", getElementData(plr, "player:rp")+2)
	exports["pd-hud"]:showPlayerNotification(plr, "Otrzymujesz 500$ i 2 RP za pełną godzinę gry.", "success", nil, 5000, "success")
end

function checkBan(plr)
	local check = exports["pd-mysql"]:query("SELECT * from `pd-bans` WHERE `serial`=? AND `active`=1 AND `timeout`>NOW() LIMIT 1", getPlayerSerial(plr))
    if check and #check > 0 then 
		triggerClientEvent(plr, "logging:stopDraw", plr)
		triggerClientEvent(plr, "logging:drawBan", plr, check[1].serial, check[1].reason,check[1].admin,check[1].date, check[1].timeout )
	end
	if #check < 0 then
end
end
addEvent("logging:checkBan", true)
addEventHandler("logging:checkBan", root, checkBan)

