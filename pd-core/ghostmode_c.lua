alphaVehicles = {}

setTimer(function()
    for _,veh in pairs(getElementsByType("vehicle")) do
        for _,v in pairs(getElementsByType("player")) do
            setElementCollidableWith(v, veh, true)
            setElementCollidableWith(veh, v, true)
        end
        for _,v in pairs(getElementsByType("vehicle")) do
            setElementCollidableWith(v, veh, true)
            setElementCollidableWith(veh, v, true)
        end
        alphaVehicles[veh] = 255
    end
    for _,veh in pairs(getElementsByType("player")) do
        for _,v in pairs(getElementsByType("player")) do
            setElementCollidableWith(v, veh, true)
            setElementCollidableWith(veh, v, true)
        end
        for _,v in pairs(getElementsByType("vehicle")) do
            setElementCollidableWith(v, veh, true)
            setElementCollidableWith(veh, v, true)
        end
        alphaVehicles[veh] = 255
    end
    for k,v in pairs(getElementsByType("ghostElement")) do
        v = getElementData(v, "ghostElement")
        if v and isElement(v) then
            for _,veh in pairs(getElementsByType("vehicle")) do
                if not getElementData(veh, "vehicle:ghost:off") then
                    if v ~= veh then
                        dist = getDistanceBetweenPoints3D(Vector3(getElementPosition(v)), Vector3(getElementPosition(veh)))
                        dist = ((dist + 5) / 11) * 255
                        if alphaVehicles[veh] > dist then
                            alphaVehicles[veh] = dist
                        end
                    end
                    setElementCollidableWith(v, veh, false)
                    setElementCollidableWith(veh, v, false)
                end
            end
			for _,plr in pairs(getElementsByType("player")) do
				if getElementType(v) == "vehicle" and getVehicleController(v) == plr then
					alphaVehicles[v] = 255
				else
					if not getElementData(plr, "player:ghost:off") then
						if v ~= plr then
							dist = getDistanceBetweenPoints3D(Vector3(getElementPosition(v)), Vector3(getElementPosition(plr)))
							dist = ((dist + 6) / 11) * 255
							if alphaVehicles[plr] > dist then
								alphaVehicles[plr] = dist
							end
						end
						setElementCollidableWith(v, plr, false)
						setElementCollidableWith(plr, v, false)
					end
				end
            end
        end
	end
	for _,veh in pairs(getElementsByType("vehicle")) do
		if not getElementData(veh, "vehicle:ghost:off") then
			setElementAlpha(veh, alphaVehicles[veh])
		end
	end
	for _,veh in pairs(getElementsByType("player")) do
		if not getElementData(veh, "vehicle:ghost:off") then
			setElementAlpha(veh, alphaVehicles[veh])
		end
	end
end, 2000, 0)