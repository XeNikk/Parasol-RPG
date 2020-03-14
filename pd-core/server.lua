function changeMoneyAmount(plr, amount)
	if amount > 0 then
		givePlayerMoney(plr, amount)
		if getPlayerMoney(plr) >= 10000 then
			exports["pd-achievements"]:exportAchievement(plr, "Biznesmen I", 5)
		end
		if getPlayerMoney(plr) >= 50000 then
			exports["pd-achievements"]:exportAchievement(plr, "Biznesmen II", 10)
		end
		if getPlayerMoney(plr) >= 100000 then
			exports["pd-achievements"]:exportAchievement(plr, "Biznesmen III", 15)
		end
		if getPlayerMoney(plr) >= 1000000 then
			exports["pd-achievements"]:exportAchievement(plr, "Milioner", 20)
		end
	elseif amount < 0 then
		takePlayerMoney(plr, -amount)
	end
end
addEvent("changeMoneyAmount", true)
addEventHandler("changeMoneyAmount", resourceRoot, changeMoneyAmount)

function takeMoney(plr, amount)
	changeMoneyAmount(plr, -amount)
end

function giveMoney(plr, amount)
	changeMoneyAmount(plr, amount)
end

function wykonajprzelew(plr, cmd, target, kwota)
    value = string.match(kwota, "%d*")
	value = tonumber(value)
	if getElementData(plr, "player:chat:delay") == 9 then outputChatBox("Odczekaj chwilę...",plr, 255,0,0) return end
if not kwota then triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /przelej [nick/id] [kwota].", "error") return end 
if value == nil then triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /przelej [nick/id] [kwota].", "error") return end 
if not target then return triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /przelej [nick/id] [kwota].", "error") end
if not findPlayer(plr, target) then triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /przelej [nick/id] [kwota].", "error") return end
if value > getPlayerMoney(plr) then triggerClientEvent(plr, "admin:addNoti", plr, "Nie posiadasz wystarczającej ilości pieniędzy.", "error") return end
if not getElementData(findPlayer(plr, target), "player:uid") then triggerClientEvent(plr, "admin:addNoti", plr, "Gracz nie jest zalogowany.", "error") return end
if value < 0 or value == 0 then triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie: /przelej [nick/id] [kwota].", "error") return end
if findPlayer(plr, target) == plr then triggerClientEvent(plr, "admin:addNoti", plr, "Nie możesz przelać pieniędzy do siebie.", "error") return end

local warns = getElementData(plr, "player:chat:delay") or 0
setElementData(plr, "player:chat:delay", warns+1)
setTimer(function()

setElementData(plr, "player:chat:delay", 0)
end, 5000, 1)
takeMoney(plr, value)
triggerClientEvent(plr, "admin:addNoti", plr, "Przelałeś $"..value.." do "..getPlayerName(findPlayer(plr, target))..".", "success")
giveMoney(findPlayer(plr, target), value)
triggerClientEvent(findPlayer(plr, target), "admin:addNoti", findPlayer(plr, target), "Otrzymujesz $"..value.." od "..getPlayerName(plr)..".", "success")
exports["pd-admin"]:insertLog("#00a61ePRZELEW > #ffffff"..getPlayerName(plr).."["..getElementData(plr, "player:id").."] >> "..getPlayerName(findPlayer(plr, target)).."["..getElementData(findPlayer(plr, target), "player:id").."]: #00a61e$"..value)
exports["pd-mysql"]:query("INSERT INTO `pd_logs_money_transfer`(`from`, `to`, `money`) VALUES (?,?,?)", getPlayerName(plr).." ("..getElementData(plr, "player:id")..")",getPlayerName(findPlayer(plr, target)).." ("..getElementData(findPlayer(plr, target), "player:id")..")", "$"..value)

end
addCommandHandler("przelej", wykonajprzelew)
addCommandHandler("zaplac", wykonajprzelew)
addCommandHandler("dajkase", wykonajprzelew)

local realtime = getRealTime()
setTime(realtime.hour+1, realtime.minute)
setMinuteDuration(60000)

function tableToString(t)
	s = ""
	for k,v in pairs(t) do
		if type(v) == "boolean" then
			if v then
				v = 1
			else
				v = 0
			end
		end
		s = s .. k .."," .. v .. ","
	end
	return s
end

function tableFromString(s)
	t = {}
	for k, v in string.gmatch(s, '([^,]+),([^,]+)') do
		if string.len(k) > 0 and string.len(v) > 0 then
			t[k] = v
		end
	end
	return t
end

function findPlayer(plr, cel)
	local target = nil
	if (tonumber(cel) ~= nil) then 
		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "player:id") == tonumber(cel) then
				target = player
			end
		end
	else
		for _,thePlayer in ipairs(Element.getAllByType("player")) do
			if string.find(string.gsub(thePlayer.name:lower(),"#%x%x%x%x%x%x", ""), cel:lower(), 0, true) then
				if target then
					triggerClientEvent(plr, "admin:addNoti", plr, "Znaleziono kilku graczy o podobnym nicku. Podaj więcej liter.", "success")
					return nil
				end
				target = thePlayer
			end
		end
	end
	return target
end

function onPlayerDamage ( attacker, weapon, bodypart, loss )
	if (attacker and attacker ~= source ) then
        exports["pd-achievements"]:exportAchievement(source, "Pierwsza krew", 5)
	end
end
addEventHandler ( "onPlayerDamage", root, onPlayerDamage)