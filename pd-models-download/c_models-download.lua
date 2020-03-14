wheels = {
    {"1", 1076},
    {"2", 1073},
    {"3", 1074},
    {"4", 1075},
    {"5", 1076},
    {"6", 1077},
    {"7", 1079},
    {"8", 1080},
    {"9", 1081},
    {"10", 1082},
    {"11", 1083},
    {"12", 1084},
    {"13", 1085},
    {"14", 1096},
    {"15", 1097},
    {"16", 1098},
    {"17", 1025},
}


for k, v in ipairs(wheels) do 

    txd = engineLoadTXD("models/wheels/tex.txd", v[2])
    engineImportTXD(txd,v[2])
    dff = engineLoadDFF("models/wheels/"..v[1]..".dff", v[2])
    engineReplaceModel(dff,v[2])

end

skins = {
    {9},
    {10},
    {11},
    {13},
    {14},
    {15},
    {32},
    {35},
    {36},
    {37},
    {38},
    {39},
    {40},
    {41},
    {43},
    {44},
    {53},
    {57},
    {58},
    {94},
    {95},
    {96},
    {128},
    {129},
    {130},
    {132},
    {133},
    {135},


}


for k, v in ipairs(skins) do 

    txd = engineLoadTXD("models/skins/"..v[1]..".txd", v[1])
    engineImportTXD(txd,v[1])
    dff = engineLoadDFF("models/skins/"..v[1]..".dff", v[1])
    engineReplaceModel(dff,v[1])

end

sapdskins = {
    {280},
    {281},
    {282},
    {283},
    {284},
    {285},
    {286},
    {287},
}

for k, v in ipairs(sapdskins) do 

    txd = engineLoadTXD("models/skins/sapd/"..v[1]..".txd", v[1])
    engineImportTXD(txd,v[1])
    dff = engineLoadDFF("models/skins/sapd/"..v[1]..".dff", v[1])
    engineReplaceModel(dff,v[1])

end

for i = 1, 10000 do 
    engineSetModelLODDistance ( i, 300 ) 
end 


vehicles = {
    {494},
}

for k, v in ipairs(vehicles) do 

    txd = engineLoadTXD("models/vehicles/"..v[1]..".txd", v[1])
    engineImportTXD(txd,v[1])
    dff = engineLoadDFF("models/vehicles/"..v[1]..".dff", v[1])
    engineReplaceModel(dff,v[1])

end