--[[
    ############################
    @client: liberty (Paradice RPG)
    @resource: pd-core/ghostmode_s.lua
    ############################
]]

function toggleElementGhostmode(element, bool)
	if bool then
		ghost = createElement("ghostElement")
		setElementData(ghost, "ghostElement", element)
	else
		for k,v in pairs(getElementsByType("ghostElement")) do
			if getElementData(v, "ghostElement") == element then
				destroyElement(v)
			end
		end
	end
end