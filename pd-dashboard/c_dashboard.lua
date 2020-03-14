sx, sy = guiGetScreenSize()


dash = {
	enabled = false,
	actual = "main",
	delay = false,
	scroll = 0
}
limit = 4

zoom = exports["pd-gui"]:getInterfaceZoom()
achievementsTable = exports["pd-achievements"]:getAchievements()

local k = 1
local n = 6
local m = 6

setElementData(localPlayer, "player:pmoff", true)
setElementData(localPlayer, "player:hud", false)
setElementData(localPlayer, "player:fps", false)
setElementData(localPlayer, "player:obrotomierz", true)

dash.texbg = dxCreateTexture("images/background.png")
dash.texbutton = dxCreateTexture("images/button.png")
dash.texeditline = dxCreateTexture("images/edit_line.png")
dash.texlogo = dxCreateTexture("images/logo.png")
dash.texscrollbar = dxCreateTexture("images/scrollbar.png")
dash.texscrollbarpoint = dxCreateTexture("images/scrollbar_point.png")
dash.texswitchoff = dxCreateTexture("images/switch_off.png")
dash.texswitchon = dxCreateTexture("images/switch_on.png")

dash.texstats = dxCreateTexture("images/icons/stats.png")
dash.texstatshover = dxCreateTexture("images/icons/stats_hover.png")
dash.texshop = dxCreateTexture("images/icons/shop.png")
dash.texshophover = dxCreateTexture("images/icons/shop_hover.png")
dash.texsettings = dxCreateTexture("images/icons/settings.png")
dash.texsettingshover = dxCreateTexture("images/icons/settings_hover.png")
dash.texachievement = dxCreateTexture("images/icons/achievement.png")
dash.texachievementhover = dxCreateTexture("images/icons/achievement_hover.png")
dash.texreturn = dxCreateTexture("images/icons/return.png")
dash.texreturnhover = dxCreateTexture("images/icons/return_hover.png")
dash.texsettingsuser = dxCreateTexture("images/icons/settings_user.png")
dash.texsettingsuserhover = dxCreateTexture("images/icons/settings_user_hover.png")
dash.texgamesettings = dxCreateTexture("images/icons/game_settings.png")
dash.texgamesettingshover = dxCreateTexture("images/icons/game_settings_hover.png")
dash.texsettingsgraphic = dxCreateTexture("images/icons/settings_graphic.png")
dash.texsettingsgraphichover = dxCreateTexture("images/icons/settings_graphic_hover.png")
dash.texhome = dxCreateTexture("images/icons/home.png")
dash.texhomehover = dxCreateTexture("images/icons/home_hover.png")
dash.texchangepassword = dxCreateTexture("images/icons/change_password.png")
dash.texchangepasswordhover = dxCreateTexture("images/icons/change_password_hover.png")
dash.texchangenick = dxCreateTexture("images/icons/change_nick.png")
dash.texchangenickhover = dxCreateTexture("images/icons/change_nick_hover.png")
dash.texchangeemail = dxCreateTexture("images/icons/change_email.png")
dash.texchangeemailhover = dxCreateTexture("images/icons/change_email_hover.png")

dash.texshopbg = dxCreateTexture("images/shop/background.png")
dash.texshopbutton = dxCreateTexture("images/shop/button.png")
dash.texshoppremiumicon = dxCreateTexture("images/shop/premium_icon.png")



dash.draw = function()
   --dxDrawImage(0,0,1920,1080, "sample.png")
	exports["pd-gui"]:drawBWRectangle(0/zoom, 0/zoom, sx, sy, tocolor(0,0,0,a[0]), false)
	dxDrawImage(sx/2 -150/zoom, sy/2 - a[1]/zoom, 299/zoom, 130/zoom, dash.texlogo,0,0,0, tocolor(255,255,255,a[0]))

	if dash.actual == "main" then
	
	if isMouseIn(sx/2 -(308 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom) then
	dxDrawImage(sx/2 -(308 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texstatshover,0,0,0, tocolor(255,255,255,a[0]))
	else 
		dxDrawImage(sx/2 -(308 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texstats,0,0,0, tocolor(255,255,255,a[0]))
	end
	if isMouseIn(sx/2 -(111 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom) then
	dxDrawImage(sx/2 -(111 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texshophover,0,0,0, tocolor(255,255,255,a[0]))
	else
		dxDrawImage(sx/2 -(111 + a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texshop,0,0,0, tocolor(255,255,255,a[0]))
	end
	if isMouseIn(sx/2 +(88 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom) then
	dxDrawImage(sx/2 +(88 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texsettingshover,0,0,0, tocolor(255,255,255,a[0]))
	else 
		dxDrawImage(sx/2 +(88 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texsettings,0,0,0, tocolor(255,255,255,a[0]))
	end
	if isMouseIn(sx/2 +(286 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom) then
	dxDrawImage(sx/2 +(286 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texachievementhover,0,0,0, tocolor(255,255,255,a[0]))
	else 
		dxDrawImage(sx/2 +(286 - a["menu"]/2)/zoom, sy/2 - (a["menu"]/2)/zoom, a["menu"]/zoom, a["menu"]/zoom, dash.texachievement,0,0,0, tocolor(255,255,255,a[0]))
	end

	end
	if dash.actual == "stats" then

		dash.uid = getElementData(localPlayer, "player:uid") or "?"
		dash.nick = getPlayerName(localPlayer) or "?"
		dash.skin = getElementModel(localPlayer) or "?"
		dash.pj = table.concat(getElementData(localPlayer, "player:pj"),", ")
		dash.osiag = #getElementData(localPlayer, "player:achievements") or "?"
		dash.money = getElementData(localPlayer, "player:bank") + getPlayerMoney(localPlayer)
		dash.warns = getElementData(localPlayer, "player:warns")
		dash.sesion = getElementData(localPlayer, "player:session_time")
		if getElementData(localPlayer, "player:premium") == true then dash.premium = "\nKonto premium ważne do "..getElementData(localPlayer,"player:premiumdate").."" else dash.premium = "" end
		dash.vehicles = vehiclesCount or 0

		dxDrawImage(sx/2 -491/zoom, sy/2 - a["window"]/zoom, 985/zoom, 656/zoom, dash.texbg,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Twoje statystyki", sx/2, sy/2 + (60 -  a["window"])/zoom, sx/2, sy/2 + (60 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, false, false, true)
		dxDrawText("UID: "..dash.uid.. "\nNick: "..dash.nick.."\nSkin: "..dash.skin.."\nFrakcja: Brak\nOrganizacja: Brak\nCzas gry: siema\nCzas aktualnej sesji: "..secondsToClock(dash.sesion).."\nIlość pojazdów: "..dash.vehicles.."\nIlość nieruchomości: 0\nŁącznie posiadanych pieniędzy: $"..dash.money.."\nZdobyte osiągnięcia: "..achievements.."\nPosiadane licencje: "..licenses..""..dash.premium.."\nOstrzeżenia: "..dash.warns.."/5", sx/2 -437/zoom, sy/2 + (120 - a["window"])/zoom, sx/2 -437/zoom, sy/2 + (120 - a["window"])/zoom, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)

		if isMouseIn(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
		dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
		else 
			dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
		end

	end
	if dash.actual == "shop" then
		dxDrawImage(sx/2 -491/zoom, sy/2 - a["window"]/zoom, 985/zoom, 656/zoom, dash.texbg,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Sklep", sx/2, sy/2 + (60 -  a["window"])/zoom, sx/2, sy/2 + (60 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, false, false, true)

		portfel = getElementData(localPlayer, "player:saldoPP") or "?"
	
		dxDrawText("Portfel: "..portfel.."pkt", sx/2 + 378/zoom, sy/2 + (100 - a["window"])/zoom, sx/2 + 378/zoom, sy/2 + (100 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "right", "top", false, false, false, true)

		dxDrawText("#d60ae8Premium 7 dni", sx/2 -305/zoom, sy/2 + (132 - a["window"])/zoom, 1400/zoom, sy/2 + (132 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
		dxDrawText("Daje dostęp do konta premium na 7 dni", sx/2 -305/zoom, sy/2 + (158 - a["window"])/zoom, 1400/zoom, sy/2 + (158 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false, true)
		dxDrawImage(sx/2 -418/zoom, sy/2 + (100 - a["window"])/zoom, 100/zoom, 100/zoom, dash.texshoppremiumicon,0,0,0, tocolor(255,255,255,255))

		dxDrawText("#d60ae8375pkt", sx/2 + 335/zoom, sy/2 + (135 - a["window"])/zoom, sx/2 + 335/zoom, sy/2 + (135 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)
		dxDrawImage(sx/2 +275/zoom, sy/2 + (165 - a["window"])/zoom, 112/zoom, 44/zoom, dash.texshopbutton,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Kup", sx/2 + 332/zoom, sy/2 + (173 - a["window"])/zoom, sx/2 + 332/zoom, sy/2 + (173 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)

		dxDrawText("#d60ae8Premium 14 dni", sx/2 -305/zoom, sy/2 + (230 - a["window"])/zoom, 1400/zoom, sy/2 + (230 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
		dxDrawText("Daje dostęp do konta premium na 14 dni", sx/2 -305/zoom, sy/2 + (255 - a["window"])/zoom, 1400/zoom, sy/2 + (255 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false, true)
		dxDrawImage(sx/2 -418/zoom, sy/2 + (200 - a["window"])/zoom, 100/zoom, 100/zoom, dash.texshoppremiumicon,0,0,0, tocolor(255,255,255,255))

		dxDrawText("#d60ae8750pkt", sx/2 + 335/zoom, sy/2 + (230 - a["window"])/zoom, sx/2 + 335/zoom, sy/2 + (230 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)
		dxDrawImage(sx/2 +275/zoom, sy/2 + (264 - a["window"])/zoom, 112/zoom, 44/zoom, dash.texshopbutton,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Kup", sx/2 + 332/zoom, sy/2 + (272 - a["window"])/zoom, sx/2 + 332/zoom, sy/2 + (272 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)

		dxDrawText("#d60ae8Premium 30 dni", sx/2 -305/zoom, sy/2 + (328 - a["window"])/zoom, 1400/zoom, sy/2 + (328 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
		dxDrawText("Daje dostęp do konta premium na 30 dni", sx/2 -305/zoom, sy/2 + (355 - a["window"])/zoom, 1400/zoom, sy/2 + (355 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "left", "top", false, false, false, true)
		dxDrawImage(sx/2 -418/zoom, sy/2 + (300 - a["window"])/zoom, 100/zoom, 100/zoom, dash.texshoppremiumicon,0,0,0, tocolor(255,255,255,255))

		dxDrawText("#d60ae81500pkt", sx/2 + 335/zoom, sy/2 + (330 - a["window"])/zoom, sx/2 + 335/zoom, sy/2 + (330 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)
		dxDrawImage(sx/2 +275/zoom, sy/2 + (360 - a["window"])/zoom, 112/zoom, 44/zoom, dash.texshopbutton,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Kup", sx/2 + 332/zoom, sy/2 + (368 - a["window"])/zoom, sx/2 + 332/zoom, sy/2 + (368 - a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)

		

		if isMouseIn(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
			else 
				dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
			end

	end
	if dash.actual == "settings" then

		if isMouseIn(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
			dxDrawImage(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texsettingsuserhover,0,0,0, tocolor(255,255,255,255))
			else
				dxDrawImage(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texsettingsuser,0,0,0, tocolor(255,255,255,255))
			end
			if isMouseIn(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
				dxDrawImage(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texgamesettingshover,0,0,0, tocolor(255,255,255,255))
				else
					dxDrawImage(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texgamesettings,0,0,0, tocolor(255,255,255,255))
				end
				if isMouseIn(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
					dxDrawImage(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texsettingsgraphichover,0,0,0, tocolor(255,255,255,255))
					else
						dxDrawImage(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texsettingsgraphic,0,0,0, tocolor(255,255,255,255))
					end
					if isMouseIn(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
						dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
						else 
							dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
						end

	end
	if dash.actual == "accountsettings" then
		if isMouseIn(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
			dxDrawImage(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangepasswordhover,0,0,0, tocolor(255,255,255,255))
		else
			dxDrawImage(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangepassword,0,0,0, tocolor(255,255,255,255))
		end
		if isMouseIn(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
			dxDrawImage(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangenickhover,0,0,0, tocolor(255,255,255,255))
		else
			dxDrawImage(sx/2 -(11+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangenick,0,0,0, tocolor(255,255,255,255))
		end
		if isMouseIn(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then
			dxDrawImage(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangeemailhover,0,0,0, tocolor(255,255,255,255))
		else
			dxDrawImage(sx/2 +(188-a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom, dash.texchangeemail,0,0,0, tocolor(255,255,255,255))
		end
		if isMouseIn(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
		else 
			dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
		end
		if isMouseIn(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhomehover,0,0,0, tocolor(255,255,255,255))
		else 
			dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhome,0,0,0, tocolor(255,255,255,255))
		end
	end
	if dash.actual == "achievements" then
		dxDrawImage(sx/2 -491/zoom, sy/2 - a["window"]/zoom, 985/zoom, 656/zoom, dash.texbg,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Osiągnięcia", sx/2, sy/2 + (60 -  a["window"])/zoom, sx/2, sy/2 + (60 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, false, false, true)
		dxDrawText("Odblokowane: "..achievements.."/16", sx/2 +165/zoom, sy/2 + (100 -  a["window"])/zoom, 1450/zoom, sy/2 + (100 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top", false, false, false, true)
		exports["pd-gui"]:renderScroll(scroll) 

		if isMouseIn(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
			else 
				dxDrawImage(sx/2 -14-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
			end
			achievementsAll = getElementData(localPlayer, "player:achievements")
			if not achievementsAll then achievementsAll = {} end
			i = 1
			c = 1
			for k,v in pairs(achievementsAll) do
				if i > dash.scroll and i <= dash.scroll + limit then
					if achievementsTable[k] then
						dxDrawImage(sx/2 - 400/zoom, sy/2 + (20 - a["window"])/zoom + (100/zoom*c), 100/zoom, 100/zoom, achievementsTable[k][2], 0, 0, 0, tocolor(255, 255, 255, 255))
						dxDrawText(k, sx/2 - 300/zoom, sy/2 + (50 - a["window"]) + (100/zoom*c), sx, sy, tocolor(200, 0, 200, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"))
						dxDrawText(achievementsTable[k][1], sx/2 - 300/zoom, sy/2 + (80 - a["window"]) + (100/zoom*c), sx, sy, tocolor(255, 255, 255, 255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_small"))
					end
					c = c + 1
				end
				i = i + 1
			end

	end
	if dash.actual == "gamesettings" then
		dxDrawImage(sx/2 -491/zoom, sy/2 - a["window"]/zoom, 985/zoom, 656/zoom, dash.texbg,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Ustawienia gry", sx/2, sy/2 + (60 -  a["window"])/zoom, sx/2, sy/2 + (60 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, false, false, true)

		if isMouseIn(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
			else 
				dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
			end
			if isMouseIn(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
				dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhomehover,0,0,0, tocolor(255,255,255,255))
				else 
					dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhome,0,0,0, tocolor(255,255,255,255))
				end

				pm = getElementData(localPlayer, "player:pmoff")
				f11 = getElementData(localPlayer, "player:hud")
				fps = getElementData(localPlayer, "player:fps")
				rpm = getElementData(localPlayer, "settings:rpm")
				prem = getElementData(localPlayer, "settings:premium")


				dxDrawText("Prywatne wiadomości", sx/2 -273/zoom, sy/2 + (130 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (130 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				if pm == true then 
					dxDrawImage(sx/2 -420/zoom, sy/2 + (115 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchon,0,0,0, tocolor(255,255,255,255))
				else
				dxDrawImage(sx/2 -420/zoom, sy/2 + (115 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				end
				dxDrawText("Ukrycie HUD", sx/2 -273/zoom, sy/2 + (180 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (180 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				if f11 == true then 
					dxDrawImage(sx/2 -420/zoom, sy/2 + (167 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchon,0,0,0, tocolor(255,255,255,255))
				else
				dxDrawImage(sx/2 -420/zoom, sy/2 + (167 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				end
				dxDrawText("Licznik klatek na sekunde (FPS)", sx/2 -273/zoom, sy/2 + (229 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (229 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				if fps == true then
				dxDrawImage(sx/2 -420/zoom, sy/2 + (218 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchon,0,0,0, tocolor(255,255,255,255))
				else 
					dxDrawImage(sx/2 -420/zoom, sy/2 + (218 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				end
				dxDrawText("Obrotomierz", sx/2 -273/zoom, sy/2 + (282 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (282 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				if rpm == false then 
				dxDrawImage(sx/2 -420/zoom, sy/2 + (270 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchon,0,0,0, tocolor(255,255,255,255))
				else 
					dxDrawImage(sx/2 -420/zoom, sy/2 + (270 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				end
				dxDrawText("Czat premium", sx/2 -273/zoom, sy/2 + (335 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (335 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				if prem == false then 
				dxDrawImage(sx/2 -420/zoom, sy/2 + (322 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchon,0,0,0, tocolor(255,255,255,255))
				else 
					dxDrawImage(sx/2 -420/zoom, sy/2 + (322 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				end

	end
	if dash.actual == "graphicsettings" then
		dxDrawImage(sx/2 -491/zoom, sy/2 - a["window"]/zoom, 985/zoom, 656/zoom, dash.texbg,0,0,0, tocolor(255,255,255,255))
		dxDrawText("Ustawienia graficzne", sx/2, sy/2 + (60 -  a["window"])/zoom, sx/2, sy/2 + (60 -  a["window"])/zoom, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top", false, false, false, true)

		if isMouseIn(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
			dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturnhover,0,0,0, tocolor(255,255,255,255))
			else 
				dxDrawImage(sx/2 +88-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texreturn,0,0,0, tocolor(255,255,255,255))
			end
			if isMouseIn(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom) then 
				dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhomehover,0,0,0, tocolor(255,255,255,255))
				else 
					dxDrawImage(sx/2 - 113-(a["return"]/2)/zoom, sy/2 + (374 - a["return"]/2)/zoom, a["return"]/zoom, a["return"]/zoom, dash.texhome,0,0,0, tocolor(255,255,255,255))
				end


				dxDrawText("Dynamiczne oświetlenie", sx/2 -273/zoom, sy/2 + (130 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (130 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (115 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Błyszczący lakier w pojazdach", sx/2 -273/zoom, sy/2 + (180 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (180 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (167 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Dynamiczne niebo", sx/2 -273/zoom, sy/2 + (229 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (229 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (218 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Woda", sx/2 -273/zoom, sy/2 + (282 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (282 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (270 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Detale tekstur", sx/2 -273/zoom, sy/2 + (333 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (333 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (321 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Żywa paleta kolorów", sx/2 -273/zoom, sy/2 + (385 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (385 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (373 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Gładkie efekty cząsteczkowe", sx/2 -273/zoom, sy/2 + (435 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (435 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (425 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))
				dxDrawText("Głębia ostrości", sx/2 -273/zoom, sy/2 + (488 - a["window"])/zoom, sx/2 -273/zoom, sy/2 + (488 - a["window"])/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "left", "top", false, false, false, true)
				dxDrawImage(sx/2 -420/zoom, sy/2 + (477 - a["window"])/zoom, 126/zoom, 56/zoom, dash.texswitchoff,0,0,0, tocolor(255,255,255,255))

	end


end


dash.start = function()
	if dash.enabled == false then
	--if getAnimationProgress(1) == "1" then return end
	addEventHandler("onClientRender", root, dash.draw)
	setElementData(localPlayer, "player:showingGUI", "dashboard")
	exports["pd-hud"]:showHUD(false)
	dash.enabled = true 
	dash.delay = true
	dash.actual = "main"
	showChat(false)
	showCursor(true) 
	setAnimation(1, 800, 511, 1000, "OutQuad")
	setAnimation(0, 0, 255, 1000, "OutQuad")
	setAnimation("menu", 0, 200, 700, "OutBack")
	setTimer(function()
		
		dash.delay = false
	
	end, 1000, 1)
	else
		showChat(true)
		showCursor(false)
		setElementData(localPlayer, "player:showingGUI", false)
		setAnimation(1, 511, 1000, 1000, "OutQuad")
		setAnimation(0, 255, 0, 1000, "OutQuad")
		setAnimation("menu", 200, 0, 700, "InBack")
		setAnimation("window", 328, -800, 600, "OutQuad")
		setAnimation("return", 200, 0, 700, "InBack")
		setAnimation("menusettings", 207, 0, 700, "InBack")
		dash.delay = true
		setTimer(function()
		
			removeEventHandler("onClientRender", root, dash.draw)
			dash.enabled = false 
			dash.delay = false
			exports["pd-hud"]:showHUD(true)
		
		end, 1000, 1)
	end

end


bindKey("F3", "down", function ()
	if dash.delay == true then return end
	if (getElementData(localPlayer, "player:showingGUI") and getElementData(localPlayer, "player:showingGUI") ~= "dashboard") then return end
	dash.start()
end)
bindKey("mouse1", "down", function()
	if dash.delay == true then return end
	if dash.enabled == false then return end
	if isMouseIn(sx/2 -429/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) and dash.actual == "main" then 
		dash.delay = true
		setTimer(function()
			dash.delay = false
		dash.actual = "stats"
		triggerServerEvent("getPlayerVehicles", resourceRoot, localPlayer)
		achievementsAll = getElementData(localPlayer, "player:achievements")
		if not achievementsAll then achievementsAll = {} end
		achievements = 0
		for k,v in pairs(achievementsAll) do
			achievements = achievements + 1
		end

		licenses = ""
		licensesAll = getElementData(localPlayer, "player:pj")
		for k,v in pairs(licensesAll) do
			if tonumber(v) == 1 then
				if licenses ~= "" then
					licenses = licenses .. ", "
				end
				licenses = licenses .. k
			end
		end

		setAnimation("return", 0, 200, 700, "OutBack")
		setAnimation("window", -800, 328, 400, "OutQuad")
		end, 700, 1)
		setAnimation("menu", 200, 0, 700, "InBack")
	elseif isMouseIn(sx/2 -218/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) and dash.actual == "main" then 
		dash.delay = true
		setTimer(function()
			dash.actual = "shop"
			dash.delay = false
			setAnimation("return", 0, 200, 700, "OutBack")
			setAnimation("window", -800, 328, 400, "OutQuad")
			end, 700, 1)
			setAnimation("menu", 200, 0, 700, "InBack")
		elseif isMouseIn(sx/2 -6/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) and dash.actual == "main" then 
			dash.delay = true
			setTimer(function()
				dash.actual = "settings"
				dash.delay = false
				setAnimation("menusettings", 0, 207, 700, "OutBack")
				setAnimation("return", 0, 200, 700, "OutBack")
				end, 700, 1)
			setAnimation("menu", 200, 0, 700, "InBack")
		elseif isMouseIn(sx/2 +205/zoom, sy/2 - 100/zoom, 200/zoom, 200/zoom) and dash.actual == "main" then 
			dash.delay = true
			setTimer(function()
				dash.actual = "achievements"
				dash.delay = false
				achievementsAll = getElementData(localPlayer, "player:achievements")
				if not achievementsAll then achievementsAll = {} end
				achievements = 0
				for k,v in pairs(achievementsAll) do
					achievements = achievements + 1
				end
				setAnimation("return", 0, 200, 700, "OutBack")
				setAnimation("window", -800, 328, 400, "OutQuad")
				end, 700, 1)
			setAnimation("menu", 200, 0, 700, "InBack")
			
			
		elseif isMouseIn(sx/2 -115/zoom, sy/2 - 103/zoom, 207/zoom, 205/zoom) and dash.actual == "settings" then 
			dash.delay = true
			setTimer(function()
			dash.actual = "gamesettings"
			dash.delay = false
			setAnimation("window", -800, 328, 400, "OutQuad")
			setAnimation("return", 0, 200, 700, "OutBack")
			end, 700, 1)
			setAnimation("menusettings", 207, 0, 700, "InBack")
			setAnimation("return", 200, 0, 700, "InBack")
		elseif isMouseIn(sx/2 +97/zoom, sy/2 - 103/zoom, 207/zoom, 205/zoom) and dash.actual == "settings" then 
			dash.delay = true
			setTimer(function()
			dash.actual = "graphicsettings"
			dash.delay = false
			setAnimation("window", -800, 328, 400, "OutQuad")
			setAnimation("return", 0, 200, 700, "OutBack")
			end, 700, 1)
			setAnimation("menusettings", 207, 0, 700, "InBack")
			setAnimation("return", 200, 0, 700, "InBack")
		elseif dash.actual == "settings" and isMouseIn(sx/2 -(210+a["menusettings"]/2)/zoom, sy/2 - 1 - (a["menusettings"]/2)/zoom, a["menusettings"]/zoom, a["menusettings"]/zoom) then 
			dash.delay = true
			setTimer(function()
			dash.actual = "accountsettings"
			dash.delay = false
			setAnimation("menusettings", 0, 207, 700, "OutBack")
			setAnimation("return", 0, 200, 700, "OutBack")
			end, 700, 1)
			setAnimation("menusettings", 207, 0, 700, "InBack")
			
			setAnimation("return", 200, 0, 700, "InBack")
		 elseif isMouseIn(sx/2 -115/zoom, sy/2 + (374 - a["return"]/2)/zoom, 200/zoom, 200/zoom) then
		   if dash.actual == "stats" or dash.actual == "shop" or dash.actual == "settings" or dash.actual == "achievements" then 
				dash.delay = true
				setTimer(function()
					dash.actual = "main"
					dash.delay = false
					setAnimation("menu", 0, 200, 700, "OutBack")
				end, 700, 1)
				if dash.actual == "achievments" then 
					exports["pd-gui"]:destroyScroll(scroll)
				end
			setAnimation("menusettings", 207, 0, 700, "InBack")
			setAnimation("return", 200, 0, 700, "InBack")
			setAnimation("window", 328, -800, 600, "OutQuad")
		
			end
		elseif isMouseIn(sx/2 -223/zoom, sy/2 + 298/zoom, 207/zoom, 205/zoom) then 
			if dash.actual == "gamesettings" or dash.actual == "accountsettings" or dash.actual == "graphicsettings" then 
				dash.delay = true
				setTimer(function()
					dash.delay = false
				dash.actual = "main"
				setAnimation("menu", 0, 200, 700, "OutBack")
				end, 700, 1)
				setAnimation("window", 328, -800, 600, "OutQuad")
				setAnimation("return", 200, 0, 700, "InBack")
				setAnimation("menusettings", 207, 0, 700, "InBack")
			end
		elseif isMouseIn(sx/2 -9/zoom, sy/2 + 298/zoom, 207/zoom, 205/zoom) then 
			if dash.actual == "gamesettings" or dash.actual == "accountsettings" or dash.actual == "graphicsettings" then 
				dash.delay = true
				setTimer(function()
					dash.delay = false
				dash.actual = "settings"
				setAnimation("menusettings", 0, 207, 700, "OutBack")
				setAnimation("return", 0, 200, 700, "OutBack")
				end, 700, 1)
				setAnimation("window", 328, -800, 600, "OutQuad")
				setAnimation("return", 200, 0, 700, "InBack")
				setAnimation("menusettings", 207, 0, 700, "InBack")
				
				
			end


		elseif isMouseIn(sx/2 -420/zoom, sy/2 + (115 - a["window"])/zoom, 126/zoom, 56/zoom) and dash.actual == "gamesettings" then 
			setElementData(localPlayer, "player:pmoff", not getElementData(localPlayer, "player:pmoff"))
		elseif isMouseIn(sx/2 -420/zoom, sy/2 + (167 - a["window"])/zoom, 126/zoom, 56/zoom) and dash.actual == "gamesettings" then 
			setElementData(localPlayer, "player:hud", not getElementData(localPlayer, "player:hud"))
		elseif isMouseIn(sx/2 -420/zoom, sy/2 + (218 - a["window"])/zoom, 126/zoom, 56/zoom) and dash.actual == "gamesettings" then 
			setElementData(localPlayer, "player:fps", not getElementData(localPlayer, "player:fps"))
		elseif isMouseIn(sx/2 -420/zoom, sy/2 + (270 - a["window"])/zoom, 126/zoom, 56/zoom) and dash.actual == "gamesettings" then 
			setElementData(localPlayer, "settings:rpm", not getElementData(localPlayer, "settings:rpm"))
		elseif isMouseIn(sx/2 -420/zoom, sy/2 + (322 - a["window"])/zoom, 126/zoom, 56/zoom) and dash.actual == "gamesettings" then 
			setElementData(localPlayer, "settings:premium", not getElementData(localPlayer, "settings:premium"))
		elseif isMouseIn(sx/2 +275/zoom, sy/2 + (165 - a["window"])/zoom, 112/zoom, 44/zoom) and dash.actual == "shop" then 
			if getElementData(localPlayer, "player:saldoPP") < 375 then exports["pd-hud"]:addNotification("Nie posiadasz wystarczającej ilości punktów.", "error", 5000, nil, "error") return end
			triggerServerEvent("dashboard:addPremium", localPlayer, localPlayer, 7, 375)
			exports["pd-hud"]:addNotification("Zakupiono Premium 7 dni pomyślnie!", "success", 5000, nil, "success")
		elseif isMouseIn(sx/2 +275/zoom, sy/2 + (264 - a["window"])/zoom, 112/zoom, 44/zoom) and dash.actual == "shop" then 
			if getElementData(localPlayer, "player:saldoPP") < 750 then exports["pd-hud"]:addNotification("Nie posiadasz wystarczającej ilości punktów.", "error", 5000, nil, "error") return end
			triggerServerEvent("dashboard:addPremium", localPlayer, localPlayer, 14, 750)
			exports["pd-hud"]:addNotification("Zakupiono Premium 14 dni pomyślnie!", "success", 5000, nil, "success")
		elseif isMouseIn(sx/2 +275/zoom, sy/2 + (360 - a["window"])/zoom, 112/zoom, 44/zoom) and dash.actual == "shop" then 
			if getElementData(localPlayer, "player:saldoPP") < 1500 then exports["pd-hud"]:addNotification("Nie posiadasz wystarczającej ilości punktów.", "error", 5000, nil, "error") return end
			triggerServerEvent("dashboard:addPremium", localPlayer, localPlayer, 30, 1500)
			exports["pd-hud"]:addNotification("Zakupiono Premium 30 dni pomyślnie!", "success", 5000, nil, "success")

		end 
end)



bindKey("mouse_wheel_down", "both", function()
	if dash.enabled == false then return end
	if dash.actual == "achievements" then
		achievementsAll = getElementData(localPlayer, "player:achievements")
		if not achievementsAll then achievementsAll = {} end
		achievements = 0
		for k,v in pairs(achievementsAll) do
			achievements = achievements + 1
		end
		if dash.scroll + limit < achievements then
			dash.scroll = dash.scroll + 1
		end
	end
end)

bindKey("mouse_wheel_up", "both", function()
	if dash.enabled == false then return end
	if dash.actual == "achievements" then
		achievementsAll = getElementData(localPlayer, "player:achievements")
		if dash.scroll > 0 then
			dash.scroll = dash.scroll - 1
		end
	end
end)





addEvent("returnVehiclesCount", true)
addEventHandler("returnVehiclesCount", localPlayer, function(count)
	vehiclesCount = count
end)

function isMouseIn(psx,psy,pssx,pssy,abx,aby)
	if not isCursorShowing() then return end
	cx,cy=getCursorPosition()
	cx,cy=cx*sx,cy*sy
	if cx >= psx and cx <= psx+pssx and cy >= psy and cy <= psy+pssy then
		return true,cx,cy
	else
		return false
	end
end

function secondsToClock(seconds)
	seconds = seconds or 0
	if seconds <= 0 then
		return "00h 00min"
	else
		hours = string.format("%02.f", math.floor(seconds/3600))
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)))
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60))
		return ""..hours.."h "..mins.."min"
	end
end