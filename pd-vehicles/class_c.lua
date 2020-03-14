classTable = {
	["A"] = {230, 300},
	["B"] = {220, 250},
	["C"] = {170, 220},
	["D"] = {150, 170},
	["E"] = {0, 150},
}

function getModelClass(model)
	local handling = getOriginalHandling(model)
	local class = false
	for k,v in pairs(classTable) do
		if handling["maxVelocity"] >= v[1] and handling["maxVelocity"] <= v[2] then
			class = k
			break
		end
	end
	return class
end