NOTIFICATION_TIME = 6000 -- domyślny czas notyfikacji 
NOTIFICATION_LIMIT = 5
NOTIFICATION_CATEGORIES = {
	["info"] = {66, 134, 244},
	["error"] = {255, 61, 61},
	["success"] = {3, 216, 0},
}

local screenW, screenH = guiGetScreenSize()
-- pozycje 
local zoom = exports["pd-gui"]:getInterfaceZoom()
local notificationPos= {x=screenW, y=10, w=math.floor(552/zoom), h=math.floor(92/zoom)}
notificationPos.x = notificationPos.x - notificationPos.w - math.floor(25/zoom)

-- zmienne 
local textures = {}
local notifications = {}
local visibleNotifications = 0 

function deleteNotification(id)
	if notifications[id] and not notifications[id].hiding and not notifications[id].hidden then 
		local id = id 
		
		notifications[id].hiding = true
		createAnimation(0, notificationPos.w*2, "InOutQuad", 750, function(progress)
			notifications[id].offsetX = progress
		end)
		
		createAnimation(255, 0, "InOutQuad", 1000, 
			function(progress)
				notifications[id].alpha = progress
			end,
			
			function()
				notifications[id].hidden = true
				if notifications[id].icon and notifications[id].icon ~= textures.info_icon and notifications[id].icon ~= textures.error_icon and notifications[id].icon ~= textures.success_icon then 
					destroyElement(notifications[id].icon)
				end
			end
		)
		
	end
end 

function addNotification(text, category, sound, time, icon)
	if type(text) == "string" and NOTIFICATION_CATEGORIES[category] then 
		if visibleNotifications+1 > NOTIFICATION_LIMIT then 
			for k, v in ipairs(notifications) do 
				if not v.hidden then 
					v.hidden = true
					break
				end 
			end
		end 
		
		if icon then
			icon = dxCreateTexture("images/notifications/" .. icon .. "_icon.png")
		else 
			icon = textures[category.."_icon"]
		end
		
		local allowSound = true
		if type(sound) == "boolean" then
			allowSound = sound
		end 
		
		if allowSound then 
			local snd = playSound("sounds/"..tostring(category)..".mp3", false)
			setSoundVolume(snd, 0.7)
		end
		
		table.insert(notifications, {text=text, category=category, offsetX=notificationPos.w*2, offsetY=0, icon=icon, alpha=0})
		outputConsole("["..category.."] "..text)
		if #notifications > 1 then
			for k, v in ipairs(notifications) do 
				if v.offsetY_anim then 
					finishAnimation(v.offsetY_anim)
				end
			end 
			
			for k, v in ipairs(notifications) do
				if k < #notifications then
					local offsetY = v.offsetY
					local notification = k
					v.offsetY_anim = createAnimation(0, notificationPos.h, "InOutQuad", 300, function(progress)
						notifications[notification].offsetY = offsetY+progress
					end)
				end
			end
		end

		
		local notification = #notifications
		createAnimation(notificationPos.w*2, 0, "InOutQuad", 500, function(progress)
			notifications[notification].offsetX = progress
		end)
		
		createAnimation(0, 255, "InOutQuad", 1000, function(progress)
			notifications[notification].alpha = progress
		end)
		
		setTimer(deleteNotification, time or 6000, 1, notification)
		
		return notification
	end
end 
addEvent("onClientAddNotification", true)
addEventHandler("onClientAddNotification", resourceRoot, addNotification)

function showPlayerNotification(...)
	return addNotification(...)
end 

addEventHandler("onClientRender", root, function()
	local hidden = 0
	visibleNotifications = 0
	
	for k, notification in ipairs(notifications) do 
		if notification.hidden then 
			hidden = hidden+1
		else 
			visibleNotifications = visibleNotifications+1
			local offsetX, offsetY = notification.offsetX, notification.offsetY
			dxDrawImage(notificationPos.x+offsetX, notificationPos.y+offsetY, notificationPos.w, notificationPos.h, textures[notification.category], 0, 0, 0, tocolor(255, 255, 255, notification.alpha), true)
			
			local x, y, w, h = math.floor(notificationPos.x+offsetX+notificationPos.w*0.2), math.floor(notificationPos.y+offsetY-math.floor(10/zoom)), math.floor(notificationPos.w*0.75), notificationPos.y+notificationPos.h
			dxDrawText(notification.text, x, y, x+w, y+h, tocolor(255, 255, 255, notification.alpha), 0.95/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "center", false, true, true)
			if notification.icon then
				local color = NOTIFICATION_CATEGORIES[notification.category]
				dxDrawImage(notificationPos.x+offsetX+math.floor(15/zoom), notificationPos.y+offsetY+math.floor((notificationPos.h*0.2)/2), math.floor(notificationPos.h*0.8), math.floor(notificationPos.h*0.8), notification.icon, 0, 0, 0, tocolor(color[1], color[2], color[3], notification.alpha), true)
			end
		end
	end
	
	if hidden == #notifications then 
		notifications = {}
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	textures.info = dxCreateTexture("images/notifications/info.png")
	textures.error = dxCreateTexture("images/notifications/error.png")
	textures.success = dxCreateTexture("images/notifications/success.png")
	textures.info_icon = dxCreateTexture("images/notifications/info_icon.png")
	textures.error_icon = dxCreateTexture("images/notifications/error_icon.png")
	textures.success_icon = dxCreateTexture("images/notifications/success_icon.png")
end)
