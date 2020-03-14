model_packs = {
	["job_hunter"] = {
		["wolf"] = 308,
		["bear"] = 309,
		["hunter"] = 28,
		["ghillie"] = 29,
	},
	["required"] = {
		["NASA"] = 2769,
		["NASAadd"] = 2768,
		["battery"] = 2767,
		["bus"] = 431,
		["coach"] = 437,
	}
}

function loadModels(pack)
	if model_packs[pack] then
		for k,v in pairs(model_packs[pack]) do
			local location = "models/" .. pack .. "/" .. k
			if fileExists(location .. ".col") then
				engineReplaceCOL(engineLoadCOL(location .. ".col"), v)
			end
			if fileExists(location .. ".txd") then
				engineImportTXD(engineLoadTXD(location .. ".txd"), v)
			end
			if fileExists(location .. ".dff") then
				engineReplaceModel(engineLoadDFF(location .. ".dff"), v)
			end
		end
	end
end

loadModels("required")

function unloadModels(pack)
	if model_packs[pack] then
		for k,v in pairs(model_packs[pack]) do
			engineUnloadModel(v)
		end
	end
end