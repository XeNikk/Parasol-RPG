-- https://wiki.multitheftauto.com/wiki/CreateAnimation
-- poprawiona

local anims, animID = { }, 0
local rendering = false 

local function renderAnimations( )
    local now = getTickCount( )
    for k,v in ipairs(anims) do
        v.onChange(interpolateBetween(v.from, 0, 0, v.to, 0, 0, (now - v.start) / v.duration, v.easing))
        if now >= v.start+v.duration then
            table.remove(anims, k)
            if type(v.onEnd) == "function" then
                v.onEnd( )
            end
			if #anims == 0 then 
				rendering = false
				removeEventHandler("onClientRender", root, renderAnimations)
			end
        end
    end
end

function createAnimation(f, t, easing, duration, onChange, onEnd)
	if #anims == 0 and not rendering then 
		addEventHandler("onClientRender", root, renderAnimations)
		rendering = true
	end
    assert(type(f) == "number", "Bad argument @ 'createAnimation' [expected number at argument 1, got "..type(f).."]")
    assert(type(t) == "number", "Bad argument @ 'createAnimation' [expected number at argument 2, got "..type(t).."]")
    assert(type(easing) == "string", "Bad argument @ 'createAnimation' [Invalid easing at argument 3]")
    assert(type(duration) == "number", "Bad argument @ 'createAnimation' [expected number at argument 4, got "..type(duration).."]")
    assert(type(onChange) == "function", "Bad argument @ 'createAnimation' [expected function at argument 5, got "..type(onChange).."]")
    animID = animID+1
	table.insert(anims, {id=animID, from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
	return animID
end

function finishAnimation(anim)
	for k, v in ipairs(anims) do 
		if v.id == anim then 
			v.onChange(v.to)
			if v.onEnd then v.onEnd() end
			v.start = 0
			return true
		end
	end
end 

function deleteAnimation(anim)
	for k, v in ipairs(anims) do 
		if v.id == anim then 
			table.remove(anims, k)
			break
		end
	end
end 
