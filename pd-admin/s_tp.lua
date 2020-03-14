teleports = {
    {"przecho", 771.67297363281, -1333.0397949219, 13.543611526489},
    {"osk", 1738.2047119141, -2064.302734375, 13.606069564819},
    {"spawn", 1479.6776123047, -1684.9522705078, 14.046875},
    {"kosmonauta", 284.67318725586, 1399.4053955078, 10.5859375},
    {"g1", 2343.9948730469, 1518.2624511719, 42.81559753418},
    {"lv", 2435.1950683594, 2371.8596191406, 10.8203125},
    {"przebieralnia", 505.64544677734, -1364.9013671875, 16.125158309937},
    {"cygan", -69.219100952148, -1561.22265625, 2.6107201576233},
    {"mysliwy", -663.90856933594, -2108.3256835938, 28.055727005005},
    {"mechanik", 910.98767089844, -1228.5377197266, 16.9765625},
    {"skladanie", 1109.1993408203, -1786.0576171875, 16.59375},
    {"busy", 1771.1234130859, -1105.6180419922, 24.078125},
    {"kurier", 2176.7722167969, -2260.2453613281, 14.917186737061}
}

for i,v in pairs(teleports) do

addCommandHandler(v[1], function(plr, cmd)
    if not isPlayerAdmin(plr) and not getElementData(plr, "player:admin") then return end
        if cmd == v[1] then 
            setElementPosition(plr, v[2], v[3], v[4])
            triggerClientEvent(plr, "admin:addNoti", plr, "Teleportowałeś się do "..v[1]..".", "success")
    end
end)


end