replaceTextures = {
	["lasdockbar"] = dxCreateTexture("data/replace/white.png")
}

local replaceShaders = {}

for k,v in pairs(replaceTextures) do
	replaceShaders[k] = dxCreateShader("shader.fx")
	dxSetShaderValue(replaceShaders[k], "PdTexture", v)
	engineApplyShaderToWorldTexture(replaceShaders[k], k)
end