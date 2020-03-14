SW, SH = guiGetScreenSize()

-- skalowanie 
local baseX = 2048
zoom = 1 
local minZoom = 2.2
if SW < baseX then
	zoom = math.min(minZoom, baseX/SW)
end 

function getInterfaceZoom()
	return zoom
end

addEventHandler("onClientClick", root, function(button, state)
	onClientClickButton(button, state)
	onClientClickEditbox(button, state)
end)

addEventHandler("onClientKey", root, function(button, state)
	onClientClickList(button, state)
	onClientClickScroll(button, state)
	onClientClickGridlist(button, state)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	loadGUIFonts()
end)

function playHoverSound()
	local sound = playSound("sounds/hover.wav", false)
	setSoundVolume(sound, 0.7)
end 

function playClickSound()
	local sound = playSound("sounds/click.wav", false)
	setSoundVolume(sound, 1)
end 

function isCursorOnElement(x, y, w, h)
	local mx, my = getCursorPosition ()
	cursorx, cursory = mx*SW, my*SH

	return cursorx > x and cursorx < x + w and cursory > y and cursory < y + h
end

-- https://wiki.multitheftauto.com/wiki/CreateAnimation
-- poprawiona
local anims = { }
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
    table.insert(anims, {from = f, to = t, easing = easing, duration = duration, start = getTickCount( ), onChange = onChange, onEnd = onEnd})
end
