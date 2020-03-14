function enableHLCForNPC(npc,walkspeed,accuracy,drivespeed)
	addEventHandler("onElementDataChange",npc,cleanUpDoneTasks)
	addEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)
	all_npcs[npc] = true
	setElementData(npc,"npc_hlc",true)
	addNPCToUnsyncedList(npc)
	
	setNPCWalkSpeed(npc,walkspeed or "run")
	setNPCWeaponAccuracy(npc,accuracy or 1)
	setNPCDriveSpeed(npc,drivespeed or 40/180)

	return true
end

function disableHLCForNPC(npc)

	clearNPCTasks(npc)

	removeEventHandler("onElementDataChange",npc,cleanUpDoneTasks)
	removeEventHandler("onElementDestroy",npc,destroyNPCInformationOnDestroy)
	destroyNPCInformation(npc)
	removeElementData(npc,"npc_hlc")
	
	removeElementData(npc,"npc_hlc:walk_speed")
	removeElementData(npc,"npc_hlc:accuracy")
	removeElementData(npc,"npc_hlc:drive_speed")

	return true
end

function setNPCWalkSpeed(npc,speed)
	setElementData(npc,"npc_hlc:walk_speed",speed)
	return true
end

function setNPCWeaponAccuracy(npc,accuracy)
	setElementData(npc,"npc_hlc:accuracy",accuracy)
	return true
end

function setNPCDriveSpeed(npc,speed)
	setElementData(npc,"npc_hlc:drive_speed",speed)
	return true
end

------------------------------------------------

function addNPCTask(npc,task)
	local lasttask = getElementData(npc,"npc_hlc:lasttask")
	if not lasttask then
		lasttask = 1
		setElementData(npc,"npc_hlc:thistask",1)
	else
		lasttask = lasttask+1
	end
	setElementData(npc,"npc_hlc:task."..lasttask,task)
	setElementData(npc,"npc_hlc:lasttask",lasttask)
	return true
end

function clearNPCTasks(npc)
	local thistask = getElementData(npc,"npc_hlc:thistask")
	if not thistask then return end
	local lasttask = getElementData(npc,"npc_hlc:lasttask")
	if thistask and lasttask then
		for task = thistask,lasttask do
			removeElementData(npc,"npc_hlc:task."..task)
		end
	end
	removeElementData(npc,"npc_hlc:thistask")
	removeElementData(npc,"npc_hlc:lasttask")
	return true
end

function setNPCTask(npc,task)
	clearNPCTasks(npc)
	setElementData(npc,"npc_hlc:task.1",task)
	setElementData(npc,"npc_hlc:thistask",1)
	setElementData(npc,"npc_hlc:lasttask",1)
	return true
end

function isTaskValid(task)
	local taskFunc = taskValid[task[1]]
	return taskFunc and taskFunc(task) or false
end

