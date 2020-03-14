GUI = exports["pd-gui"]
zoom = GUI:getInterfaceZoom()
normal_small = GUI:getGUIFont("normal_small")


staffhex = {
	["Administrator RCON"] = "910000",
	["Administrator"] = "e80000",
	["Moderator"] = "009127",
	["Support"] = "00d4f5",
	["Premium"] = "F4D300",
	["Player"] = "FFFFFF",
}


addEventHandler("onClientRender", root, function()
	cx, cy, cz = getCameraMatrix()
	for k,v in pairs(getElementsByType("player")) do
		if v ~= localPlayer then
			px, py, pz = getPedBonePosition(v, 4)
			pz = pz + 0.5
			dist = getDistanceBetweenPoints3D(cx, cy, cz, px, py, pz)
			if isLineOfSightClear(cx, cy, cz, px, py, pz, true, false, false, true, false, false, true) and dist < 15 then
				x, y = getScreenFromWorldPosition(px, py, pz)
				name = getPlayerName(v)
				icons = {}
				local away = getElementData(v, "player:away") or false
				local chat = getElementData(v, "player:typing") or false
				local premium = getElementData(v, "player:premium") or false
				if away then
					table.insert(icons, "afk")
				end
				if chat then
					table.insert(icons, "chat")
				end
				if premium then
					table.insert(icons, "premium")
				end
				
				local iconSize = (20-dist)*4/zoom
				if iconSize > 0 then
					if x and y then
						if getElementData(v, "player:admin") then rank = getElementData(v, "player:admin:rank") elseif getElementData(v, "player:premium") then rank = "Premium" else rank = "Player" end
						dxDrawText("#9f9f9f[#ffffff" .. getElementData(v, "player:id") .. "#9f9f9f] #"..staffhex[rank].." " .. string.gsub(name, "#%x%x%x%x%x%x", ""), x, y, x, y, white, 1/zoom, normal_small, "center", "center", false, false, false, true)
						if #icons == 1 then
							startX = 0
						elseif #icons == 2 then
							startX = -iconSize/2 - 5
						elseif #icons == 3 then
							startX = -iconSize - 5
						end
						for k,v in pairs(icons) do
							dxDrawImage(x - iconSize/2 + startX + (iconSize + 5) * (k - 1), y - iconSize - 15, iconSize, iconSize, "images/icons/" .. v .. ".png")
						end
					end
				end
			end
		end
	end
end)


