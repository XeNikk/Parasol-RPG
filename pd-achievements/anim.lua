animations = {}
a = {}

function setAnimation( id, start, stop, time, interpolateType )
    animations[id] = {start, stop, getTickCount(), time, interpolateType}
    a[id] = start
end

function getAnimationProgress( id )
    fProgress = (getTickCount() - animations[id][3]) / animations[id][4]
    if fProgress > 1 then fProgress = 1 end
    return fProgress
end

addEventHandler( "onClientRender", root, function()
    tickCount = getTickCount()
    for k,v in pairs( animations ) do
        fProgress = (tickCount - v[3]) / v[4]
        if fProgress > 1 then fProgress = 1 end
        interpolate = interpolateBetween( v[1], 0, 0, v[2], 0, 0, fProgress, v[5] )
        a[k] = interpolate
    end
end )