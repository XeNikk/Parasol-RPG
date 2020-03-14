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

function getJobData(job, dataName)
	local sharedData = getElementsByType("jobdata")[1]
	if sharedData then
		local data = getElementData(sharedData, "data")
		if data[job] and data[job][dataName] then 
			return data[job][dataName]
		else
			return false
		end
	end
end