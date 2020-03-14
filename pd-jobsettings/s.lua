sharedData = createElement("jobdata")
data = {}
Async:setPriority("medium")

addEventHandler("onResourceStart", resourceRoot, function()
	-- ładowanie ustawień prac
	local xml = xmlLoadFile("jobdata.xml")
	if not xml then return end
	local childrens = xmlNodeGetChildren(xml) 
	for id, child in ipairs(childrens) do
		local childname = xmlNodeGetName(child)
		local attributes = xmlNodeGetAttributes(child)
		data[childname] = {}
		for name, value in pairs(attributes) do 
			data[childname][name] = value
		end
	end
	xmlUnloadFile(xml)
	setElementData(sharedData, "data", data)

	-- ładowanie topek

	local query = exports["pd-mysql"]:query("SELECT uid, nick, job_stats FROM `pd-players`")
	local data = {}
	for k, v in ipairs(query) do 
		local stats = fromJSON(v.job_stats)
		if stats then
			for accJob, score in pairs(stats) do 
				if not data[accJob] then data[accJob] = {} end
				table.insert(data[accJob], {name=v.nick, uid=v.uid, stats=score})
			end
		end
	end

	for k, v in pairs(data) do
		table.sort(data[k], function(a, b)
			return a.stats > b.stats
		end)
	end 
	topData = data

	addEvent("onPlayerEnterGame", true)
	addEventHandler("onPlayerEnterGame", root, function()
		local uid = getElementData(source, "player:uid")
		local query = exports["pd-mysql"]:query("SELECT `job_upgrades` FROM `pd-players` WHERE uid=? LIMIT 1", uid)[1]
		local upgrades = fromJSON(query["job_upgrades"]) or {}
		setElementData(source, "player:job_upgrades", upgrades)
	end)
end)

function addPlayerTopData(player, job, value)
	if isElement(player) and job and value then
		local uid = getElementData(player, "player:uid")
		local query = exports["pd-mysql"]:query("SELECT `job_stats` FROM `pd-players` WHERE uid=? LIMIT 1", uid)[1]
		local stats = fromJSON(query.job_stats) or {}
		if stats[job] then 
			stats[job] = stats[job]+value
			
			-- sporo statystyk
			Async:foreach(topData[job], function(playerData, index)
				if playerData.uid == uid then 
					topData[job][index].stats = topData[job][index].stats+value
					table.sort(topData[job], function(a, b)
						return a.stats > b.stats
					end)
				end
			end)
		else 
			stats[job] = value
			
			if not topData[job] then topData[job] = {} end
			table.insert(topData[job], {name=getPlayerName(player), uid=uid, stats=value})
		end
		
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `job_stats`=? WHERE uid=?", toJSON(stats), uid)
		return true
	end 
	
	return false
end 

function getPlayerTopData(player, job)
	if isElement(player) and job then
		local uid = getElementData(player, "player:uid")
		local query = exports["pd-mysql"]:query("SELECT `job_stats` FROM `pd-players` WHERE uid=? LIMIT 1", uid)[1]
		local stats = fromJSON(query.job_stats) or {}
		if stats[job] then 
			return stats[job]
		else 
			return 0
		end
	end 
	
	return false
end 

function getTopJobData(job)
	return topData[job] or {}
end

function setJobData(job, dataName, dataValue)
	local xml = xmlLoadFile("jobdata.xml")
	if xml then 
		local child = xmlFindChild(xml, job, 0)
		if not child then return end
		
		local data = getElementData(sharedData, "data")
		data[job][dataName] = dataValue
		setElementData(sharedData, "data", data)
		
		xmlNodeSetAttribute(child, dataName, dataValue)
		xmlSaveFile(xml)
		xmlUnloadFile(xml)
		
		return true
	end
	
	return false
end

function getJobData(job, dataName)
	local data = getElementData(sharedData, "data")
	if data[job] and data[job][dataName] then 
		return data[job][dataName]
	else
		return false
	end
end

--struktura
--[[
	job_upgrades = {
		["praca"] = {
			points=0, -- dostępne punkty
			upgrades={}, -- zainstalowane ulepszenia
		}
	}
--]]

function isPlayerHaveUpgrade(player, job, upgrade)
	if isElement(player) and job then
		upgrades = getElementData(player, "player:job_upgrades")
		if upgrades[job] and upgrades[job].upgrades then
			for k,v in pairs(upgrades[job].upgrades) do
				if v == upgrade then
					return true
				end
			end
		end
	end
	return false
end

function getPlayerJobPoints(player, job)
	if isElement(player) and job then
		upgrades = getElementData(player, "player:job_upgrades")
		if upgrades[job] and upgrades[job].points then
			return upgrades[job].points
		end
	end
	return false
end

function addPlayerJobUpgrade(player, job, name, cost, force)
	if isElement(player) and job and name and cost then 
		local uid = getElementData(player, "player:uid")
		local query = exports["pd-mysql"]:query("SELECT `job_upgrades` FROM `pd-players` WHERE uid=? LIMIT 1", uid)[1]
		local upgrades = fromJSON(query.job_upgrades) or {}
		if not upgrades[job] then
			upgrades[job] = {
				points=0,
				upgrades={}
			}
		end
		upgrades[job].points = upgrades[job].points-cost
		if upgrades[job].points < 0 then
			if not force then
				print("false")
				return false
			else
				upgrades[job].points = 0
			end
		end
		
		table.insert(upgrades[job].upgrades, name)
		
		exports["pd-mysql"]:query("UPDATE `pd-players` SET `job_upgrades`=? WHERE uid=?", toJSON(upgrades), uid)
		setElementData(player, "player:job_upgrades", upgrades)
		
		return true
	end
	
	return false
end

function addPlayerJobUpgradePoints(player, job, value)
	local uid = getElementData(player, "player:uid")
	local query = exports["pd-mysql"]:query("SELECT `job_upgrades` FROM `pd-players` WHERE uid=? LIMIT 1", uid)[1]
	local upgrades = fromJSON(query["job_upgrades"]) or {}
	if not upgrades[job] then
		upgrades[job] = {
			points=value,
			upgrades={}
		}
	else 
		upgrades[job].points = upgrades[job].points+value
	end
	exports["pd-mysql"]:query("UPDATE `pd-players` SET `job_upgrades`=? WHERE uid=?", toJSON(upgrades), uid)
	setElementData(player, "player:job_upgrades", upgrades)
end