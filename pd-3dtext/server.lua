function create3DText(text, x, y, z)
	element = createElement("3dtext")
	setElementPosition(element, x, y, z)
	setElementData(element, "3dtext", text)
	return element
end

function setVehicle3DText(vehicle, text)
	setElementData(vehicle, "3dtext", text)
end

function change3DTextText(element, text)
	setElementData(element, "3dtext", text)
end