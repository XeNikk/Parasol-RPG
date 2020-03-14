sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()

firstcar = dxCreateTexture("images/icons/pierwsze_auto.png")
firstjob = dxCreateTexture("images/icons/pierwsza_fucha.png")
haker = dxCreateTexture("images/icons/haker.png")
zboczeniec = dxCreateTexture("images/icons/zboczeniec.png")
szpan = dxCreateTexture("images/icons/szpan.png")
biznesmen1 = dxCreateTexture("images/icons/biznesmen_1.png")
biznesmen2 = dxCreateTexture("images/icons/biznesmen_2.png")
biznesmen3 = dxCreateTexture("images/icons/biznesmen_3.png")
milioner = dxCreateTexture("images/icons/milioner.png")
pierwszy_zgon = dxCreateTexture("images/icons/pierwszy_zgon.png")
pierwsza_krew = dxCreateTexture("images/icons/pierwsza_krew.png")
niszczyciel = dxCreateTexture("images/icons/niszczyciel.png")
nolife = dxCreateTexture("images/icons/no_life.png")
nocny_gracz = dxCreateTexture("images/icons/nocny_gracz.png")
sluzyc = dxCreateTexture("images/icons/sluzyc.png")
przestepca = dxCreateTexture("images/icons/przestepca.png")

achievements = {
	["Pierwsze auto"] = {"Zakup na serwerze swoje pierwsze auto", firstcar},
	["Pierwsza fucha"] = {"Zatrudnij się w pierwszej pracy dorywczej", firstjob},
	["Haker pseudoli"] = {"Wpisz komendę /hania", haker},
	["Udobruchaj barabasza"] = {"Wpisz komendę /walisz", zboczeniec},
	["Chwila słabości"] = {"Strać przytomność", pierwszy_zgon},
	["Pierwsza krew"] = {"Zostań zaatakowany przez gracza", pierwsza_krew},
	["Niszczyciel"] = {"Zniszcz pojazd tak, aby nie odpalił", niszczyciel},
	["No life"] = {"Przegraj 8 godzin podczas jednej sesji", nolife},
	["Nocny gracz"] = {"Bądź online na serwerze o 1:00", nocny_gracz},
	["Służyć i chronić"] = {"Wejdź na duty organizacji porządkowej", sluzyc},
	["Przestępca"] = {"Zostań zakuty w kajdanki", przestepca},
	["Biznesmen I"] = {"Zdobądź swoje pierwsze $10000", biznesmen1},
	["Biznesmen II"] = {"Zdobądź swoje pierwsze $50000", biznesmen2},
	["Biznesmen III"] = {"Zdobądź swoje pierwsze $100000", biznesmen3},
	["Milioner"] = {"Zdobądź swój pierwszy $1000000", milioner},
	["Szpan musi być"] = {"Stuninguj swój pojazd", szpan}
}

function getAchievements()
	return achievements
end

function draw()
	if not getElementData(localPlayer, "player:spawned") then return end
	dxDrawImage(sx/2-100/zoom, sy/2+a["skok"]-40/zoom, 200/zoom, 200/zoom ,desc[2],0,0,0, tocolor(255,255,255,a["alpha"]))
	dxDrawText(tytul, sx/2+2/zoom, sy/2+150+a["skok"]/zoom, sx/2+2/zoom, sy/2+150+a["skok"]/zoom, tocolor(236, 0, 247, a["alpha"]), 1/zoom, exports["pd-gui"]:getGUIFont("normal"), "center")
	dxDrawText(desc[1], sx/2+2/zoom, sy/2+185+a["skok"]/zoom, sx/2+2/zoom, sy/2+185+a["skok"]/zoom, tocolor(255,255,255,a["alpha"]), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
	dxDrawText( "+"..repu.." RP", sx/2+2/zoom, sy/2+220+a["skok"]/zoom, sx/2+2/zoom, sy/2+220+a["skok"]/zoom, tocolor(236, 0, 247, a["alpha"]), 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center")
end

function init(title, rp)
	tytul = title
	desc = achievements[title]
	repu = rp

	playSound("sounds/achievement.wav")
	addEventHandler("onClientRender", root, draw)
	setAnimation("alpha", 0, 255, 1000, "OutQuad")
	setAnimation("skok", -250, 0, 4000, "OutElastic")
	setTimer(function()
	    setAnimation("alpha", 255, 0, 2000, "OutQuad")
	end, 7000, 1)
	setTimer(function()
	    removeEventHandler("onClientRender", root, draw)
	end, 9000, 1)
end
addEvent("achievements:draw", true)
addEventHandler("achievements:draw", root, init)