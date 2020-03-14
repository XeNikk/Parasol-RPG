addEvent("onClientAcceptConfirmation", true)
addEvent("onClientDenyConfirmation", true)

local windowID = 0
local textures = {} 

local backgroundSize = Vector2(378, 158)
local buttonSize = Vector2(87, 29)

local windowPos = {x=math.floor(SW/2-backgroundSize.x/2), y=math.floor(SH/2-backgroundSize.y/2), w=backgroundSize.x, h=backgroundSize.y}
local buttonPos = {
	["ok"] = {x=windowPos.x+buttonSize.x+10, y=windowPos.y+windowPos.h-buttonSize.y-20, w=buttonSize.x, h=buttonSize.y},
	["no"] = {x=windowPos.x+windowPos.w-buttonSize.x*2-10, y=windowPos.y+windowPos.h-buttonSize.y-20, w=buttonSize.x, h=buttonSize.y},
}

function createConfirmationWindow(info)
	if type(info) == "string" then
		confirmations = getElementsByType("pd_confirmation")
		if #confirmations > 0 then 
			for k,v in pairs(confirmations) do
				destroyConfirmationWindow(v)
			end
		end 
		
		windowID = windowID+1
		
		local el = createElement("pd_confirmation", "pd_confirmation"..tostring(windowID)) 
		setElementData(el, "info", info, false)
		
		if not textures.background then 
			textures.background = dxCreateTexture("images/confirmation_window/background.png")
			textures.button = dxCreateTexture("images/confirmation_window/button.png")
		end
		
		local buttons = {} 
		buttons[1] = createButton("Tak", buttonPos["ok"].x, buttonPos["ok"].y, buttonPos["ok"].w, buttonPos["ok"].h)
		addEventHandler("onClientClickButton", buttons[1], function()
			triggerEvent("onClientAcceptConfirmation", el)
			destroyConfirmationWindow(el)
		end)
		
		buttons[2] = createButton("Nie", buttonPos["no"].x, buttonPos["no"].y, buttonPos["no"].w, buttonPos["no"].h)
		addEventHandler("onClientClickButton", buttons[2], function()
			triggerEvent("onClientDenyConfirmation", el)
			destroyConfirmationWindow(el)
		end)
		
		for k, v in ipairs(buttons) do 
			setButtonTextures(v, {default=textures.button, hover=textures.button, press=textures.button})
			setButtonFont(v, getGUIFont("normal_small"), 0.65)
		end 
		
		setElementData(el, "buttons", buttons, false)
		
		return el
	end
	
	return false
end 

function destroyConfirmationWindow(window)
	if isElement(window) and getElementType(window) == "pd_confirmation" then 
		local buttons = getElementData(window, "buttons")
		for k, v in ipairs(buttons) do 
			destroyButton(v)
		end 
		
		destroyElement(window)
		
		-- czyszczenie tekstur 
		if #getElementsByType("pd_confirmation") == 0 then 
			for k, v in pairs(textures) do 
				if isElement(v) then 
					destroyElement(v)
				end
			end
			textures = {}
		end 
		
		return true
	end
	
	return false
end 

function renderConfirmationWindow(window)
	if isElement(window) and getElementType(window) == "pd_confirmation" then 
		dxDrawImage(windowPos.x, windowPos.y, windowPos.w, windowPos.h, textures.background, 0, 0, 0, tocolor(255, 255, 255, 255))
		dxDrawText("Potwierdzenie", windowPos.x, windowPos.y+15, windowPos.x+windowPos.w, windowPos.h, tocolor(255, 255, 255, 255), 0.7, getGUIFont("normal"), "center", "top")
		dxDrawText(getElementData(window, "info"), windowPos.x, windowPos.y-20, windowPos.x+windowPos.w, windowPos.y+windowPos.h, tocolor(240, 240, 240, 255), 0.7, getGUIFont("normal_small"), "center", "center", false, true)
		
		for k, v in ipairs(getElementData(window, "buttons")) do 
			renderButton(v)
		end
	end
end
