local usedLODModels = {}

function onResourceStartOrStop ( )
	for _, object in ipairs ( getElementsByType ( "removeWorldObject", source ) ) do
		local model = getElementData ( object, "model" )
		local lodModel = getElementData ( object, "lodModel" )
		local posX = getElementData ( object, "posX" )
		local posY = getElementData ( object, "posY" )
		local posZ = getElementData ( object, "posZ" )
		local interior = getElementData ( object, "interior" ) or 0
		local radius = getElementData ( object, "radius" )
		if ( eventName == "onResourceStart" ) then
			removeWorldModel ( model, radius, posX, posY, posZ, interior )
			removeWorldModel ( lodModel, radius, posX, posY, posZ, interior )
		else
			restoreWorldModel ( model, radius, posX, posY, posZ, interior )
			restoreWorldModel ( lodModel, radius, posX, posY, posZ, interior )
		end
	end
	if (eventName == "onResourceStart") then
		for i, object in ipairs(getElementsByType("object", source)) do
			local objID = getElementModel(object)
			lodModel = objID
			if (lodModel) then
				local x,y,z = getElementPosition(object)
				local rx,ry,rz = getElementRotation(object)
				local lodObj = createObject(lodModel,x,y,z,rx,ry,rz,true)
				setElementInterior(lodObj, getElementInterior(object) )
				setElementDimension(lodObj, getElementDimension(object) )
				setElementParent(lodObj, object)
				setLowLODElement(object, lodObj)
				table.insert(usedLODModels, lodModel)
			end
		end
	end
end
addEventHandler ( "onResourceStart", resourceRoot, onResourceStartOrStop )
addEventHandler ( "onResourceStop", resourceRoot, onResourceStartOrStop )

function receiveLODsClientRequest()
	triggerClientEvent(client, "setLODsClient", resourceRoot, usedLODModels)
end
addEvent("requestLODsClient", true)
addEventHandler("requestLODsClient", resourceRoot, receiveLODsClientRequest)