local replace = {
	[8594] = "floor_1",
	[8593] = "floor_2",
	[8087] = "floor_3",
	[8081] = "wall_1",
	[8082] = "wall_2",
	[8083] = "wall_3",
	[8084] = "wall_4",
	[8085] = "wall_5",
	[8086] = "wall_6",
	[8595] = "wall_7",
}
local shaders = {}
local textures = {}
local txd = engineLoadTXD("data/models/textures.txd")

for k,v in pairs(replace) do
	engineImportTXD(txd, k)
	engineReplaceModel(engineLoadDFF("data/models/" .. v .. ".dff"), k)
	engineReplaceCOL(engineLoadCOL("data/models/" .. v .. ".col"), k)
end

function setObjectTexture(object, texture, textureid)
	if not textures[texture] then
		textures[texture] = dxCreateTexture("data/images/" .. texture .. ".jpg")
	end
	if not shaders[object] then
		shaders[object] = {}
	end
	if not shaders[object][textureid] then
		shaders[object][textureid] = dxCreateShader("shader.fx")
	end
	dxSetShaderValue(shaders[object][textureid], "PdTexture", textures[texture])
	engineApplyShaderToWorldTexture(shaders[object][textureid], textureid, object)
end

local loadedObjects = {}

function reloadObjectsTextures()
	for k,v in pairs(getElementsByType("object")) do
		if not loadedObjects[v] then
			if getElementData(v, "aTexture") then
				setObjectTexture(v, getElementData(v, "aTexture"), "a")
			end
			if getElementData(v, "bTexture") then
				setObjectTexture(v, getElementData(v, "bTexture"), "b")
			end
			loadedObjects[v] = true
		end
	end
end
setTimer(reloadObjectsTextures, 1000, 0)

addEventHandler("onClientElementDataChange", root, function(theKey, oldValue, newValue)
	if source and getElementType(source) == "object" then
		if theKey == "aTexture" then
			setObjectTexture(source, newValue, "a")
			loadedObjects[source] = true
		elseif theKey == "bTexture" then
			setObjectTexture(source, newValue, "b")
			loadedObjects[source] = true
		end
	end
end)