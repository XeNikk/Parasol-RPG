exports["pd-mysql"]:query("CREATE TABLE IF NOT EXISTS `pd_logs_chat` (`id` int NOT NULL AUTO_INCREMENT, `nick` text NOT NULL, `date` timestamp NOT NULL, `text` text NOT NULL, PRIMARY KEY (`id`))") 



-- Czat lokalny --
addEventHandler("onPlayerChat", root, function(message, typ)
	local plr = source
	if not plr then return end
	if typ == 0 then
		cancelEvent()
		if not message:match("%S") then return end
		message = string.gsub(message, "  ", "")
		if string.match(message, "#") then
			message = string.gsub(message, "#", "# ")
		end
		if getElementData(plr, "player:mute") == true then
			exports["pd-hud"]:showPlayerNotification(plr, "Jesteś wyciszony. Nie możesz pisać na chacie.", "error", nil, 5000, "error")
			return
		end
		if getElementData(plr, "player:bw") == true then 
			exports["pd-hud"]:showPlayerNotification(plr, "Masz BW. Nie możesz pisać na chacie.", "error", nil, 5000, "error")
			return 
		end
		if string.sub(message, 1, 1) == "$" then 
		if not getElementData(plr, "player:premium") then return end
		msg = string.sub(message, 2)
		local nick = getPlayerName(plr)
		if getElementData(plr, "player:admin:rank") == "Administrator RCON" then
			nick = "#910000"..nick
		elseif getElementData(plr, "player:admin:rank") == "Administrator" then
			nick = "#e80000"..nick
		elseif getElementData(plr, "player:admin:rank") == "Moderator" then
			nick = "#009127"..nick
		elseif getElementData(plr, "player:admin:rank") == "Support" then
			nick = "#00d4f5"..nick
		elseif getElementData(plr, "player:premium") then
			nick = "#f7da00"..nick
		end
		for i,v in ipairs(getElementsByType("player", getRootElement(), true)) do
			if getElementData(v, "player:premium") then
				if getElementData(v, "settings:premium") then return end
			outputChatBox("#f7da00[$] #adadad["..getElementData(plr, "player:id").."] #f7da00"..nick.."#ffffff: "..msg, v, 255, 255, 255, true)
			end
		end
		exports["pd-admin"]:insertLog("#f7da00CHAT PREMIUM > #ffffff"..getPlayerName(plr).."["..getElementData(plr, "player:id").."]: "..msg)
		exports["pd-mysql"]:query("INSERT INTO `pd_logs_chat`(`type`, `nick`, `text`) VALUES (?,?,?)","Czat Premium", getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", msg)

		return end
		if getElementData(plr, "player:chat:delay") == 9 then outputChatBox("Odczekaj chwilę...",plr, 255,0,0) return end
		local id = getElementData(plr, "player:id")
		if id then
			exports["pd-admin"]:insertLog("#b5b5b5CHAT LOKALNY > #ffffff"..getPlayerName(plr).."["..id.."]: "..message)
		end
		exports["pd-mysql"]:query("INSERT INTO `pd_logs_chat`(`type`, `nick`, `text`) VALUES (?,?,?)","Czat lokalny", getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", message)
		for i,v in ipairs(getElementsByType("player", getRootElement(), true)) do
			local id = getElementData(plr, "player:id")
			local nick = getPlayerName(plr)
			if getElementData(plr, "player:admin:rank") == "Administrator RCON" then
				nick = "#910000"..nick
			elseif getElementData(plr, "player:admin:rank") == "Administrator" then
				nick = "#e80000"..nick
			elseif getElementData(plr, "player:admin:rank") == "Moderator" then
				nick = "#009127"..nick
			elseif getElementData(plr, "player:admin:rank") == "Support" then
				nick = "#00d4f5"..nick
			elseif getElementData(plr, "player:premium") then
				nick = "#f7da00"..nick
			end
			local x, y, z = getElementPosition(plr)
			local x2, y2, z2 = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			
			if (dist <=25) then
				if getElementInterior(plr) == getElementInterior(v) then
					if getElementDimension(plr) == getElementDimension(v) then
						outputChatBox("#a6a6a6["..id.."] #ffffff"..nick..": #ffffff"..message, v, 255, 255, 255, true)

						local warns = getElementData(plr, "player:chat:delay") or 0
						setElementData(plr, "player:chat:delay", warns+1)
						setTimer(function()
						
						setElementData(plr, "player:chat:delay", 0)
						end, 5000, 1)
						cancelEvent()
					end
				end
			end
			--outputChatBox("#807669["..id.."] #ffffff"..nick..": #ffffff"..message, v, 255, 255, 255, true)
			--cancelEvent()
		end
	elseif typ == 1 then
		cancelEvent()
		if not message:match("%S") then return end
		message = string.gsub(message, "  ", "")
		if string.match(message, "#") then
			message = string.gsub(message, "#", "# ")
		end
		if getElementData(plr, "player:mute") == true then
			exports["pd-hud"]:showPlayerNotification(plr, "Jesteś wyciszony. Nie możesz pisać na chacie.", "error", nil, 5000, "error")
			return
		end
		if getElementData(plr, "player:chat:delay") == 9 then outputChatBox("Odczekaj chwilę...",plr, 255,0,0) return end
		exports["pd-admin"]:insertLog("#ff00ffCHAT ME > #ffffff"..getPlayerName(plr).."["..getElementData(plr, "player:id").."]: "..message)
		exports["pd-mysql"]:query("INSERT INTO `pd_logs_chat`(`type`, `nick`, `text`) VALUES (?,?,?)","Czat ME", getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", message)
		for i,v in ipairs(getElementsByType("player", getRootElement(), true)) do
			local id = getElementData(plr, "player:id")
			local nick = getPlayerName(plr)
			local x, y, z = getElementPosition(plr)
			local x2, y2, z2 = getElementPosition(v)
			local dist = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
			if (dist <=25) then
				if getElementInterior(plr) == getElementInterior(v) then
					if getElementDimension(plr) == getElementDimension(v) then
						outputChatBox("#FF00FF"..nick.." "..message, v, 255, 255, 255, true)
						local warns = getElementData(plr, "player:chat:delay") or 0
						setElementData(plr, "player:chat:delay", warns+1)
						setTimer(function()
						
						setElementData(plr, "player:chat:delay", 0)
						end, 5000, 1)
						cancelEvent()
					end
				end
			end
			--outputChatBox("#807669["..id.."] #ffffff"..nick..": #ffffff"..message, v, 255, 255, 255, true)
			--cancelEvent()
		end

	end

end)

-- Do

addCommandHandler("do", function(plr, cmd, ...)
	if getElementData(plr, "player:mute") == true then
		exports["pd-hud"]:showPlayerNotification(plr, "Jesteś wyciszony. Nie możesz używać komendy /do.", "error", nil, 5000, "error")
		return
	end
	local x, y, z = getElementPosition(plr)
	local msg=table.concat({...}, " ")
	if (string.len(msg)<1) then
		return
	end
	if string.match(msg,"#") then
		msg=string.gsub(msg, "#", "# ")
	end
	if getElementData(plr, "player:chat:delay") == 9 then outputChatBox("Odczekaj chwilę...",plr, 255,0,0) return end
	exports["pd-admin"]:insertLog("#1478c8CHAT DO > #ffffff"..getPlayerName(plr).."["..getElementData(plr, "player:id").."]: "..msg)
	exports["pd-mysql"]:query("INSERT INTO `pd_logs_chat`(`type`, `nick`, `text`) VALUES (?,?,?)","Czat DO", getPlayerName(plr).." ("..getElementData(plr, "player:uid")..")", msg)
	for i, v in ipairs(getElementsByType("player", getRootElement(), true)) do
		local x2, y2, z2 = getElementPosition(v)
		local dist = getDistanceBetweenPoints3D(x ,y ,z, x2, y2, z2)
		local nick = getPlayerName(plr)
		if (dist <= 25) then
			if getElementInterior(plr) == getElementInterior(v) then
				if getElementDimension(plr) == getElementDimension(v) then
					outputChatBox("* "..msg.." #9f9f9f("..nick..")", v, 20, 120, 200, true)
					local warns = getElementData(plr, "player:chat:delay") or 0
					setElementData(plr, "player:chat:delay", warns+1)
					setTimer(function()
					
					setElementData(plr, "player:chat:delay", 0)
					end, 5000, 1)
				end
			end
		end
	end
end)

-- PM

addCommandHandler("pm", function(plr, cmd, cel, ...)
    if getElementData(plr, "player:mute") == true then
        exports["pd-hud"]:showPlayerNotification(plr, "Jesteś wyciszony. Nie możesz używać komendy /pm.", "error", nil, 5000, "error")
        return
	end
	if getElementData(plr, "player:pmoff") ~= true then exports["pd-hud"]:showPlayerNotification(plr, "Posiadasz wyłączone prywatne wiadomości.", "error") return end
	target = getPlayerFromPartialName(tostring(cel))
	if (not target) then
        exports["pd-hud"]:showPlayerNotification(plr, "Nie znaleziono gracza o podanym nicku/id", "error")
        return
	end
	if getElementData(target, "player:pmoff") ~= true then exports["pd-hud"]:showPlayerNotification(plr, "Ten gracz posiada wyłączone prywatne wiadomości.", "error") return end
    local msg=table.concat({...}, " ")
    if (string.len(msg)<1) then
        return
    end
    if string.match(msg,"#") then
        msg=string.gsub(msg, "#", "# ")
    end
    if ((not cel)) then
        exports["pd-hud"]:showPlayerNotification(plr, "Użyj: /pm <nick/id> <treść>.", "info", nil, 5000, "error")
        return
    end
    local target = getPlayerFromPartialName(cel)
    if (not target) then
        exports["pd-hud"]:showPlayerNotification(plr, "Nie znaleziono gracza o podanym nicku/id", "error", nil, 5000, "error")
        return
	end
	if getElementData(plr, "player:chat:delay") == 9 then outputChatBox("Odczekaj chwilę...",plr, 255,0,0) return end
    outputChatBox("#f0d800[PM] << "..getPlayerName(plr).." ["..getElementData(plr, "player:id").."]: "..msg, target, 255, 255, 255, true)
	outputChatBox("#f0d800[PM] >> "..getPlayerName(target).." ["..getElementData(target, "player:id").."]: "..msg, plr, 255, 255, 255, true)
	exports["pd-admin"]:insertLog("#f0d800CHAT PRYWATNY > #ffffff"..getPlayerName(plr).."["..getElementData(plr, "player:id").."] >> "..getPlayerName(target).."["..getElementData(target, "player:id").."]: "..msg)
	exports["pd-mysql"]:query("INSERT INTO `pd_logs_pw`(`from`, `to`, `text`) VALUES (?,?,?)", getPlayerName(plr).." ("..getElementData(plr, "player:id")..")",getPlayerName(target).." ("..getElementData(target, "player:id")..")", msg )
	local warns = getElementData(plr, "player:chat:delay") or 0
	setElementData(plr, "player:chat:delay", warns+1)
	setTimer(function()
	
	setElementData(plr, "player:chat:delay", 0)
	end, 5000, 1)
end)

addCommandHandler("pmoff", function(plr, cmd)
	setElementData(plr, "player:pmoff", true)
end)

addCommandHandler("pmon", function(plr, cmd)
	setElementData(plr, "player:pmoff", false)
end)

function getPlayerFromPartialName(ce)
	local targett = nil
	if (tonumber(ce) ~= nil) then 
		for _, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "player:id") == tonumber(ce) then
				targett = player
			end
		end
	else
		for _,thePlayer in ipairs(Element.getAllByType("player")) do
			if string.find(string.gsub(thePlayer.name:lower(),"#%x%x%x%x%x%x", ""), ce:lower(), 0, true) then
				if targett then
					triggerClientEvent(plr, "admin:addNoti", plr, "Znaleziono kilku graczy o podobnym nicku. Podaj więcej liter.", "success")
					return nil
				end
				targett = thePlayer
			end
		end
	end
	return targett
end


