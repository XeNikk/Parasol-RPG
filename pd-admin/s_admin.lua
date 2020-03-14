exports["pd-mysql"]:query("CREATE TABLE IF NOT EXISTS `pd-admin` (`id` int NOT NULL AUTO_INCREMENT, `nick` text NOT NULL, `serial` text NOT NULL, `rank` text NOT NULL, PRIMARY KEY (`id`))") 


staffhex = {
	["Administrator RCON"] = "910000",
	["Administrator"] = "e80000",
	["Moderator"] = "009127",
	["Support"] = "00d4f5"
}


function isPlayerAdmin(plr)
	local query = exports["pd-mysql"]:query("SELECT * from `pd-admin` WHERE `serial`=?", getPlayerSerial(plr))
	if query and #query > 0 then 
		return true 
	else 
		return false 
	end
end

function getPlayerRank(plr)
	local query = exports["pd-mysql"]:query("SELECT `rank` from `pd-admin` WHERE `serial`=? limit 1", getPlayerSerial(plr))
	if query and #query > 0 then
	if query[1].rank then
		return query[1].rank
	else
		return false
		end
	end
end

function duty(plr, cmd)
	if not isPlayerAdmin(plr) then triggerClientEvent(plr, "admin:addNoti", plr, "Nie posiadasz uprawnień.", "error") return end
		if getElementData(plr, "player:admin") == true then 
			setElementData(plr, "player:admin", false)
			setElementData(plr, "player:admin:rank", false)
			triggerClientEvent(plr, "admin:csideDuty", plr, plr, false)
		else 
			setElementData(plr, "player:admin", true)
			setElementData(plr, "player:admin:rank", getPlayerRank(plr))
			triggerClientEvent(plr, "admin:csideDuty", plr, plr, true, getPlayerRank(plr))
		end
	end
addCommandHandler("aduty", duty)

savereports = createElement("admin:data")
reports = {{"#00ff00Lista reportów:", 0}}
setElementData(savereports,"reports",reports)

function sendReport(id, text)
	reports[#reports+1] = {text, id}
	setElementData(savereports, "reports", reports)
end

function removeReport(id)
	for i=#reports, 2, -1 do if reports[i][2] == id then 
		table.remove(reports, i) 
	end 
end
	setElementData(savereports, "reports", reports)
end

function isPlayerReported(id)
	local reported = false
	for i=#reports, 2, -1 do if reports[i][2] == id then 
		reported = true
	end 
	return reported
end
	setElementData(savereports, "reports", reports)
end



function report(plr, cmd, target, ...)
	if getElementData(plr, "player:report:delay") then triggerClientEvent(plr, "admin:addNoti", plr, "Zgłoszenie możesz wysłać raz na 60 sekund.", "error") return end
	if not target then 
		--triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie /report [nick] [powód].", "error")
	return end
	local tar = findPlayer(plr, target)
	if not tar then 
		--triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")
	return end
	local text = table.concat({...}, " ")
	if string.len(text) > 1 then 
		local time = getRealTime()
		local hours = time.hour+1
		if hours < 10 then hours = "0"..hours end
		local minutes = time.minute
		if minutes < 10 then minutes = "0"..minutes end
		local seconds = time.second
		if seconds < 10 then seconds = "0"..seconds end
		sendReport(getElementData(plr, "player:id"), "#ababab("..hours..":"..minutes..":"..seconds..") #00cc47["..getElementData(plr, "player:id").."] #e8e8e8"..getPlayerName(plr).." #e8e8e8-> #b00000["..getElementData(tar, "player:id").."] #e8e8e8"..getPlayerName(tar)..": "..text )
		--triggerClientEvent(plr, "admin:addNoti", plr, "Twoje zgłoszenie zostało wysłane.", "success")
		setElementData(plr, "player:report:delay", true)
		setTimer(function()
		removeElementData(plr, "player:report:delay")
		end, 5000, 1)
	else 
		triggerClientEvent(plr, "admin:addNoti", plr, "Podaj powód zgłoszenia.", "error")
	end
end
addCommandHandler("report", report)

function clReport(plr, cmd, target, ...)
	if getElementData(plr, "player:admin") == true then 
		if not target then 
			triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie /cl [id].", "error")
		return end
		local reason = table.concat({...}, " ")
		local search = findPlayer(plr, target)
		if not search then 
			triggerClientEvent(plr, "admin:addNoti", plr, "Nie znaleziono podanego gracza.", "error")
			return end
		if tonumber(target) == nil then 
			target = tonumber(getElementData(search, "player:id"))
		else 
			target = tonumber(target)
		end
		if reason then 
			removeReport(target)
			exports["pd-hud"]:showPlayerNotification(search, "Twoje zgłoszenie zostało rozpatrzone przez "..getPlayerName(plr).."\n"..reason, "success")
			for _, v in ipairs(getElementsByType("player")) do
				if isPlayerAdmin(v) then 
					outputChatBox("#ebebeb> Administrator #878787["..getElementData(plr, "player:id").."] "..getPlayerName(plr).." #ebebebrozpatrzył zgłoszenie gracza #878787["..getElementData(search, "player:id").."] "..getPlayerName(search)..".\n#ebebebTreść: "..reason..".",v, 255,255,255, true )
				end
			end
		else 
			removeReport(target)
			exports["pd-hud"]:showPlayerNotification(search, "Twoje zgłoszenie zostało rozpatrzone przez "..getPlayerName(plr), "success")
			for _, v in ipairs(getElementsByType("player")) do
				if isPlayerAdmin(v) then 
					outputChatBox("#ebebeb> Administrator #878787["..getElementData(plr, "player:id").."] "..getPlayerName(plr).." #ebebebrozpatrzył zgłoszenie gracza #878787["..getElementData(search, "player:id").."] "..getPlayerName(search)..".",v, 255,255,255, true )
				end
			end
		end
	end
end
addCommandHandler("cl", clReport)


function staffChat(plr, cmd, ...)
	if isPlayerAdmin(plr) then 
		local text = table.concat({...}, " ")
		if string.len(text) < 1 then 
			--triggerClientEvent(plr, "admin:addNoti", plr, "Poprawne użycie /e [Treść wiadomości].", "error")
			return end
			for _, v in ipairs(getElementsByType("player")) do
				if isPlayerAdmin(v) then 
					local hex = "#"..staffhex[getPlayerRank(plr)]
					outputChatBox("#6b6b6b[Chat Administracji] "..hex..""..getPlayerName(plr).." #ffffff["..getElementData(plr, "player:id").."]#ffffff: "..text,v, 255,255,255, true )
				end
			end

	end
end
addCommandHandler("e", staffChat)

savelogs = createElement("admin:data")
logs = {{"Logi:", 0}}
setElementData(savelogs,"logs",logs)

function insertLog(text)
	logs[#logs+1] = {text}
	if #logs + 1 > 15 then table.remove(logs, 2) end
	setElementData(savelogs, "logs", logs)
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





