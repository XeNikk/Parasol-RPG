randomClothesData = {
	[0] = 67,
	[1] = 32,
	[2] = 44,
	[3] = 37,
	[4] = 2,
	[5] = 3,
	[6] = 3,
	[7] = 3,
	[8] = 6,
	[9] = 5,
	[10] = 6,
	[11] = 6,
	[12] = 5,
	[13] = 11,
	[14] = 11,
	[15] = 16,
	[16] = 56,
}

idSystem = {}

local function findFreeValue(idSystem)
	table.sort(idSystem)
	local wolne_id=0
	for i,v in ipairs(idSystem) do
		if (v==wolne_id) then wolne_id=wolne_id+1 end
		if (v>wolne_id) then return wolne_id end
	end
	return wolne_id
end

function assignPlayerID(plr)
	local gracze=getElementsByType("player")
	local idSystem = {}
	for i,v in ipairs(gracze) do
		local lid=getElementData(v, "player:id")
		if (lid) then
			table.insert(idSystem, tonumber(lid))
		end
	end
	local free_id=findFreeValue(idSystem)
	
	setElementData(plr,"player:id", free_id)
	return free_id
end

function setAddData(player, data, value)
	local addData = getElementData(player, "player:addData")
	addData[data] = value
	setElementData(player, "player:addData", addData)
end

function getAddData(player, data)
	local addData = getElementData(player, "player:addData")
	return addData[data]
end

function setPedClothes(thePed, clothingSlot, clothingID)
	if not isElement(thePed) or type(clothingSlot) ~= "number" then return end
	if not clothingID then
		return removePedClothes(thePed, clothingSlot)
	end
	local hasClothes = getPedClothes(thePed, clothingSlot) 
	if hasClothes then
		removePedClothes(thePed, clothingSlot)
	end
	local texture, model = getClothesByTypeIndex(clothingSlot, clothingID)
	return addPedClothes(thePed, texture, model, clothingSlot)
end

function randomPedClothes(player)
	if getElementModel(player) == 0 then
		for k,v in pairs(randomClothesData) do
			setPedClothes(player, k, math.random(0, v))
		end
	end
end

local playerBlips = {}

function reloadPlayerBlip(plr)
	if not playerBlips[plr] and plr and isElement(plr) then
		playerBlips[plr] = createBlip(0, 0, 0, 8)
		setBlipVisibleDistance(playerBlips[plr], 350)
		attachElements(playerBlips[plr], plr)
	end
end

for k,v in ipairs(getElementsByType("player")) do
	reloadPlayerBlip(v)
end

addEventHandler("onPlayerEnterGame", root, function()
	reloadPlayerBlip(source)
end)

addEventHandler("onPlayerQuit", root, function()
	if playerBlips[source] then
		destroyElement(playerBlips[source])
		playerBlips[source] = nil
	end
end)

function bwspawnPlayer(plr)
local x,y,z = getElementPosition(plr)

spawnPlayer(plr, x,y,z)
setElementModel(plr, getElementData(plr, "player:skin"))

end
addEvent("core:BWSpawnPlayer", true)
addEventHandler("core:BWSpawnPlayer", root, bwspawnPlayer)