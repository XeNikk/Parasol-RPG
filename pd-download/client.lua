textures = {}
shaders = {}

board1 = createObject(3077, 1707, -2073.2014, 2.91168, 0, 0, 345)
board2 = createObject(3077, 1724.75, -2067.1428, 2.91168, 0, 0.5, 73.248)
board3 = createObject(3077, 1706.8815, -2051.9797, 2.91168, 0, 0, 188.998)
board4 = createObject(3077, 1719.2396, -2061.0732, 2.91168, 0, 0, 344.998)
setObjectScale(board1, 0.8)
setObjectScale(board2, 0.8)
setObjectScale(board3, 0.8)
setObjectScale(board4, 0.8)

local replaces = {
	{"A", "nf_blackbrd", board1},
	{"B", "nf_blackbrd", board2},
	{"C", "nf_blackbrd", board3},
	{"D", "nf_blackbrd", board4},
}

local modelReplaces = {
	[3578] = "sjmla_las",
	[599] = "copcarru",
	[596] = "copcarla",
	[597] = "copcarsf",
	[598] = "copcarvg",
	[8607] = "L",
}

for k,v in pairs(modelReplaces) do
	if fileExists("data/" .. v .. ".txd") then
		engineImportTXD(engineLoadTXD("data/" .. v .. ".txd"), k)
	end
	if fileExists("data/" .. v .. ".dff") then
		engineReplaceModel(engineLoadDFF("data/" .. v .. ".dff"), k)
	end
	if fileExists("data/" .. v .. ".col") then
		engineReplaceCOL(engineLoadCOL("data/" .. v .. ".col"), k)
	end
end

for k,v in pairs(replaces) do
	if not textures[v[1]] or not shaders[v[1]] then
		textures[v[1]] = dxCreateTexture("data/" .. v[1] .. ".png")
		shaders[v[1]] = dxCreateShader("replace.fx")
		dxSetShaderValue(shaders[v[1]], "gTexture", textures[v[1]])
	end
	engineApplyShaderToWorldTexture(shaders[v[1]], v[2], v[3])
end