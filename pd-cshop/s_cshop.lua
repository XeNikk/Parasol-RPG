function changeSkinSync(plr, id)
    setElementModel(plr, id)
    setElementData(plr, "player:skin", id)
end
addEvent("przeb:changeSkin", true)
addEventHandler("przeb:changeSkin", root, changeSkinSync)