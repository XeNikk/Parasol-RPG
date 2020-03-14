sx, sy = guiGetScreenSize()

zoom = exports["pd-gui"]:getInterfaceZoom()

help = {
    enabled = false,
    actual = "main",
}

help.updates = {
    {"Start serwera Parasol RPG", "10.02.2020"},
}


help.textures = {
    background = dxCreateTexture("images/background.png"),
    category_background = dxCreateTexture("images/category_background.png"),
    option_background = dxCreateTexture("images/option_background.png"),
    scrollbar = dxCreateTexture("images/scrollbar.png"),
    scrollbar_point = dxCreateTexture("images/scrollbar_point.png")
}



help.draw = function()
	dxDrawImage(sx/2-550/zoom, sy/2-350/zoom, 1100/zoom, 690/zoom, help.textures.background)
	dxDrawImage(sx/2-550/zoom, sy/2-350/zoom, 230/zoom, 680/zoom, help.textures.category_background)
	
	if help.actual == "main" then 
		dxDrawImage(sx/2-550/zoom, sy/2-350/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("O serwerze", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		dxDrawImage(sx/2-60/zoom, sy/2-220/zoom, 350/zoom, 150/zoom, ":pd-scoreboard/images/logo.png")
		dxDrawText("Parasol jest nowatorskim projektem na platformie Multi Theft Auto, który tworzony\n jest z myślą o graczach, którzy szukają nowoczesnej rozgrywki na wysokim poziomie.\n Nasz serwer jest w pełni autorski, a nasza kreatywność pozwoli Wam na\nniezapomnianą rozgrywkę na naszym serwerze.\nGwarantujemy świetną zabawę, niezapomniane chwile, fantastyczną przygodę oraz\nmnóstwo atrakcji!", sx/2+110/zoom, sy/2-50/zoom, sx/2+110/zoom, sy/2-50/zoom, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	elseif help.actual == "learn" then
		dxDrawImage(sx/2-550/zoom, sy/2-275/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Przewodnik", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")

		dxSetRenderTarget( przewodnikRT, true )
		dxDrawText ( "Na sam początek udaj się wykonać prawo jazdy kat. B w Szkole Jazdy, które jest\ndarmowe. Pozwoli Ci ono na pracę w wielu pracach dorywczych. Na serwerze\nwyróżniamy również kategorię prawa jazdy A, C oraz D. Po ukończeniu\negzaminu na prawo jazdy kategorii B, możesz udać się do pracy dorywczej, aby\nzarobić swoje pierwsze pieniądze, które później będziesz mógł spożytkować na\n mieszkanie, samochód, licencję na broń oraz inne atrakcyjne rzeczy. Istnieją\nrównież prace, które nie wymagają owego kursu.\nNa serwerze wyróżniamy 6 prac dorywczych, oznaczone one są dolarem na\n mapie pod f11. Większość prac ma swoje zapotrzebowanie, niesie jednakże\nrównież za sobą dodatkowe przywileje, które możesz odblokować wraz z\npoświęconym na daną pracę czasem. Pracując zbierasz punkty, które później\nmożesz wymienić na dodatki. Zarobki wszystkich prac są zbalansowane. Poza\npracami dorywczymi istnieją również frakcje, do których nabór odbywa się\nnieregularnie na discordzie serwera. Każda z nich działa w `amerykańskim stylu`.\n\nNa serwerze wyróżniamy 3 frakcje:\n» San Andreas Police Department (SAPD) - Policja.\n» San Andreas Medical Center (SAMC) - Pogotowie Ratunkowe.\n» San Andreas Fire Department (SAFD) - Straż pożarna.\nPraca we frakcjach polega na wykonywaniu odpowiednich obowiązków\nzarzuconych przez Zarząd danej jednostki.\nWynagrodzenie otrzymywane jest za ilość spędzonych godzin na służbie\noraz od posiadanej rangi.\n\nJeżeli na którejś z prac utracisz życie, możesz je odnowić poprzez zasięganie do\nspecjalnie utworzonych budek z żywnością. Innym sposobem na odnowienie\nżycia jest zakup leków w szpitalu lub poproszenie ratownika medycznego o\npomoc.\nPo zarobieniu swojej pierwsze gotówki możesz zakupić swój pierwszy pojazd.\nSamochody gorszej marki, z większym przebiegiem odnajdziesz u cygana, ikona\nwąsów z oczami na mapie. Jeśli uzbierasz większą gotówkę, możesz ją\nspożytkować zakupując pojazd wyższej klasy w salonie, oznaczony na mapie\nikoną samochodu.\nDodatkowo, możesz stuningować lub naprawić swój pojazd w Warsztacie, w\nktórym może pracować każdy - wystarczy przebrać się w szatni. Warsztat jest\noznaczony ikoną klucza na mapie. Stacje benzynowe oznaczone sąikoną\ndystrybutora na mapie. Możesz zatankować tam swój pojazd uwzględniając\nrodzaj paliwa, jaki Twój pojazd spożywa.\nUrząd oznaczony jest ikoną ratusza na mapie, możesz tam opłacić swoje\nmandaty oraz odebrać wypłatę z frakcji.\nNa serwerze istnieje również przechowalnia pojazdów. Możesz odstawić tam\nswój wóz i czuć się bezpiecznie, że nie zostanie odholowany. Oznaczone są\none literką 'P' na mapie.\nW przypadku, gdy zauważysz jakiś incydent na drodze, zgłoś to służbom\nmundurowany. Do tego możesz posłużyć się telefonem, który ukryty jest pod\nprzyciskiem F4.\nJeśli potrzebujesz pomocy administracji, możesz posłużyć się komendą\n- /report nick/id powód. Jeżeli ktoś uprzykrza Ci rozgrywkę to napisz report na \njego nick lub ID z odpowiednim powodem, natomiast jeżeli potrzebujesz pomocy\nto napisz report na swój nick/id podając jak najdokładniejszy powód wezwania,\naby uprościć sprawę administracji.\n\nŻyczymy miłej gry!\nPrzewodnik wykonał: VHX", 445/zoom, 10-(exports["pd-gui"]:getScrollProgress(Scroll)*1350)/zoom, 445/zoom, 10-(exports["pd-gui"]:getScrollProgress(Scroll)*1350)/zoom, white, 1/zoom,  exports["pd-gui"]:getGUIFont("normal"), "center")
		dxSetRenderTarget()
		dxDrawImage( sx/2-270/zoom,  sy/2-250/zoom,  750/zoom, 550/zoom, przewodnikRT)
		exports["pd-gui"]:renderScroll(Scroll)
	elseif help.actual == "premium" then
		dxDrawImage(sx/2-550/zoom, sy/2-200/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Premium", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		dxDrawText("Konto premium to płatny pakiet, który rozszerza grę o nowe możliwości oraz ją ułatwia.\nPremium możemy kupić w panelu gracza pod F2, ze środków Portfela. Portfel możemy\ndoładować na stronie parasol-rpg.pl. Każde kupno konta premium wspiera nasz serwer,\nza co serdecznie dziękujemy!\n\nPrzywileje konta premium:\n- 500$ za przegraną godzinę gry oraz 2 punkty reputacji (RP)\n- Czat premium ($ <wiadomość>)\n- Skiny premium\n- Pisanie ogłoszeń w dowolnym pasku HUD (/ogloszenie)\n- Gwiazdka nad głową skina\n- Zwiększone zarobki w pracach dorywczych o 20%\n- Złote wyróżnienie nicku\n- Boombox pod F2 (odtwarzanie muzyki słyszalne dla wszystkich wokół ciebie)\n- Miejsce na 100 piosenek w panelu F2 (bez premium 50)", sx/2+110/zoom, sy/2-260/zoom, sx/2+110/zoom, sy/2-260/zoom, white, 0.85/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	elseif help.actual == "rules" then
		dxDrawImage(sx/2-550/zoom, sy/2-125/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Regulamin", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")

		dxSetRenderTarget( regulaminRT, true )
		dxDrawText ( "§ 1. Ogólne\n1.1 Parasol jest serwerem RPG, odgrywanie RP na tym serwerze nie jest\nobowiązkowe lecz opcjonalne.\n1.2 Poniższy regulamin jest oparty na zasadach netykiety i dobrego wychowania\n- powinieneś instynktowanie wyczuwać, co jest dozwolone, a co nie. Ponad tymi\nsuchymi regułami stoi zdrowy rozsądek, dlatego też nieznajomość regulaminu\nbądź słowa ,,nie widziałem punktu, który tego zabrania,, nie stanowią żadnego\nwytłumaczenia.\n\n§ 2. Zakazy\n2.1 - Zakazuje się reklamowania serwerów konkurencyjnych.\n2.2 - Zakazuje się używania wszelkich wspomagaczy, które chociażby w małym\nstopniu ułatwiają rozgrywkę.\n2.3 - Zakazuje się nadmiernego używania wulgaryzmów.\n2.4 - Zakazuje się wyzywania, obrażania administracji czy graczy serwera.\n2.5 - Zakazuje się przeszkadzania graczom w grze np. przeszkadzanie w pracy.\n2.6 - Zakazuje się udostępniania linków do treści pornograficznych,\nrasistowskich i innych, które mogłyby urazić innych graczy.\n2.7 - Zakazuje się wszelakiego rodzaju trollingu.\n2.8 - Zakazuje się wszelakich prowokacji do kłótni.\n2.9 - Zakazuje się nadużywania funkcji grup czy frakcji do celów własnych.\n2.10 - Zakazuje się wszelkich czynów wprowadzających graczy w błąd lub\n mających na celu ich oszukanie.\n2.11 - Zakazuje się używania wszelkich błędów na serwerze, należy jest\nnatychmiast zgłsić administracji.\n2.12 - Zakazuje się handlu gotówką, kontem i innymi dobrami na serwerze.\n\n§ 3. Prawa\n3.1 - Gracz ma prawo do wyrażania swojej opinii o serwerze nawet jeśli jest ona\nnegatywna, jeżeli odpowiednio uargumentuje swoją wypowiedź i wyrazi ją w\nkulturalny sposób.\n3.2 - Gracz ma prawo do napisania skargi na wszelkiego gracza czy\nadministratora jeżeli łamie on regulamin serwera bądź jego zachowanie nie\n jest odpowiednie.\n3.3 - Gracz ma prawo do angażowania się w życie serwera, pisanie propozycji\nczy sugestii, proponowania ewentualnych zmian na serwerze.\n3.4 - Gracz ma prawo do apelacji od kary jeżeli została ona niesłusznie nadana.\n\n§ 4. Inne\n4.1 - Jeżeli w jakikolwiek sposób oszukasz gracza w grze zostaniesz zbanowany\n4.2 - Okazując skruchęm czy wcześniej przyznając się do popełnionej winy,\nadministracja może odwołać karę ewentualnie ją skrócić.\n4.3 - Przekazując pieniądze i inne dobra w grze, przekazujesz je na własną\nodpowiedzialność.", 400/zoom, 10-(exports["pd-gui"]:getScrollProgress(Scroll)*1000)/zoom, 400/zoom, 10-(exports["pd-gui"]:getScrollProgress(Scroll)*1000)/zoom, white, 0.9/zoom,  exports["pd-gui"]:getGUIFont("normal"), "center")
		dxSetRenderTarget()
		dxDrawImage( sx/2-270/zoom,  sy/2-250/zoom,  750/zoom, 550/zoom, regulaminRT)
		exports["pd-gui"]:renderScroll(Scroll)
	elseif help.actual == "cmds" then
		dxDrawImage(sx/2-550/zoom, sy/2-50/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Komendy", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		dxDrawText("/admins - lista dostępnej administracji\n/ogloszenie (dostępne dla graczy z kontem premium) - globalne ogłoszenie.\n/report - funkcja umożliwiająca zgłoszenie gracza do administracji.\n/showchat - chowanie/odkrywanie czatu.\n/binds klawisz (konsola) - sprawdzanie przynależności danego binda do klawisza.\n/bind klawisz komenda - nadawanie klawiszowi komendy\n/pm Nick/ID - wysyłanie prywatnej wiadomości do gracza o podanym Nicku/ID.\n/przelej Nick/ID ilość - przelewanie danej ilości gotówki do gracza o podanym Nicku/ID. ", sx/2+110/zoom, sy/2-260/zoom, sx/2+110/zoom, sy/2-260/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")
	elseif help.actual == "keys" then
		dxDrawImage(sx/2-550/zoom, sy/2+25/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Klawiszologia", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		dxDrawText("F1 - informacje o serwerze.\nF2 - ustawienia radia, boombox.\nF3 - ustawienia gry.\nF11 - mapa San Andreas\nF12 (domyślnie) - wykonywanie zrzutu ekranu (screenshot).\nE - interakcja z otoczeniem.\n Lewy SHIFT - interakcja w pojeździe.\n. - zmiana paliwa na LPG (jeśli zamontowane).\n[ i ] - kontrola zawieszenia w pojeździe (jeśli zamontowane).\nM, N - kontrola syren pojazdu (jeśli zamontowane).", sx/2+110/zoom, sy/2-260/zoom, sx/2+110/zoom, sy/2-260/zoom, white, 0.8/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")

	elseif help.actual == "updates" then
		dxDrawImage(sx/2-550/zoom, sy/2+100/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Aktualizacje", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		local x = 0
		for i,v in ipairs(help.updates) do 
			scroll = (80/zoom)*(x-1)
			x = x+1
			dxDrawText(v[2], sx/2+110/zoom, sy/2-180/zoom+scroll, sx/2+110/zoom, sy/2-180/zoom+scroll, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
			dxDrawText(v[1], sx/2+110/zoom, sy/2-160/zoom+scroll, sx/2+110/zoom, sy/2-160/zoom+scroll, white, 1/zoom, exports["pd-gui"]:getGUIFont("normal_small"), "center", "top")
		end
	elseif help.actual == "authors" then
		dxDrawImage(sx/2-550/zoom, sy/2+175/zoom, 230/zoom, 75/zoom, help.textures.option_background)
		dxDrawText("Autorzy", sx/2+110/zoom, sy/2-330/zoom, sx/2+110/zoom, sy/2-330/zoom, tocolor(200,0,200,255), 0.9/zoom, exports["pd-gui"]:getGUIFont("normal_big"), "center")
		dxDrawText("Założyciele: Liberty, XeN\nSkrypt: Liberty, XeN\nGrafika: Virelox\n\nPodziękowania dla:\nDyByNy, neku, Kusar, Aiquit, balki, DaNiel, Gruby, Quizorr, Rudyy, SZADEU, VemcziN,\n Whitee, Malisz, Zbigniewqq, xQwerty, KAPI, KarwaK, klamka, NotPaladyn, PLzdzichu,\n Rick, shuffle*, Youke, czechu102, Hyper., Kryso, Lisu126p\n za pomoc w Beta Testach.", sx/2+110/zoom, sy/2-260/zoom, sx/2+110/zoom, sy/2-260/zoom, white, 0.9/zoom, exports["pd-gui"]:getGUIFont("normal"), "center", "top")

	end

	exports["pd-gui"]:renderButton(oserwerze)
	exports["pd-gui"]:renderButton(przewodnik)
	exports["pd-gui"]:renderButton(premium)
	exports["pd-gui"]:renderButton(regulamin)
	exports["pd-gui"]:renderButton(komendy)
	exports["pd-gui"]:renderButton(klawiszologia)
	exports["pd-gui"]:renderButton(aktualizacje)
	exports["pd-gui"]:renderButton(autorzy)
	exports["pd-gui"]:renderButton(animacje)
end

bindKey("F1", "down", function()
    if (getElementData(localPlayer, "player:showingGUI") and getElementData(localPlayer, "player:showingGUI") ~= "help") then return end
    if help.enabled == true then 
        help.enabled = false
        setElementData(localPlayer, "player:showingGUI", false)
        removeEventHandler("onClientRender", root, help.draw)
        showCursor(false)
    else
        help.enabled = true
        help.actual = "main"
        setElementData(localPlayer, "player:showingGUI", "help")
        addEventHandler("onClientRender", root, help.draw)
        showCursor(true)
    end
end)


bindKey("mouse1", "down", function()
    if not help.enabled == true then return end
    if isMouseIn(sx/2-550/zoom, sy/2-350/zoom, 230/zoom, 75/zoom) then 
        help.actual = "main"
    elseif isMouseIn(sx/2-550/zoom, sy/2-275/zoom, 230/zoom, 75/zoom) then 
        help.actual = "learn"
        exports["pd-gui"]:setScrollProgress(Scroll, 0.014)
    elseif isMouseIn(sx/2-550/zoom, sy/2-200/zoom, 230/zoom, 75/zoom) then 
        help.actual = "premium"
    elseif isMouseIn(sx/2-550/zoom, sy/2-125/zoom, 230/zoom, 75/zoom) then 
        help.actual = "rules"
        exports["pd-gui"]:setScrollProgress(Scroll, 0.014)
    elseif isMouseIn(sx/2-550/zoom, sy/2-50/zoom, 230/zoom, 75/zoom) then 
        help.actual = "cmds"
    elseif isMouseIn(sx/2-550/zoom, sy/2+25/zoom, 230/zoom, 75/zoom) then 
        help.actual = "keys"
    elseif isMouseIn(sx/2-550/zoom, sy/2+100/zoom, 230/zoom, 75/zoom) then 
        help.actual = "updates"
    elseif isMouseIn(sx/2-550/zoom, sy/2+175/zoom, 230/zoom, 75/zoom) then 
		help.actual = "authors"
    end
end)

bindKey("mouse_wheel_down", "both", function()
	if help.enabled == false then return end
    exports["pd-gui"]:moveScroll(Scroll, "down", (1000/zoom)/30)
end)

bindKey("mouse_wheel_up", "both", function()
	if help.enabled == false then return end
    exports["pd-gui"]:moveScroll(Scroll, "up", (1000/zoom)/30)
end)


addEventHandler("onClientResourceStart", resourceRoot, function()
    oserwerze = exports["pd-gui"]:createButton("O serwerze", sx/2-550/zoom, sy/2-350/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(oserwerze, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    przewodnik = exports["pd-gui"]:createButton("Przewodnik", sx/2-550/zoom, sy/2-275/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(przewodnik, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    premium = exports["pd-gui"]:createButton("Premium", sx/2-550/zoom, sy/2-200/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(premium, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    regulamin = exports["pd-gui"]:createButton("Regulamin", sx/2-550/zoom, sy/2-125/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(regulamin, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    komendy = exports["pd-gui"]:createButton("Komendy", sx/2-550/zoom, sy/2-50/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(komendy, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    klawiszologia = exports["pd-gui"]:createButton("Klawiszologia", sx/2-550/zoom, sy/2+25/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(klawiszologia, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    aktualizacje = exports["pd-gui"]:createButton("Aktualizacje", sx/2-550/zoom, sy/2+100/zoom, 230/zoom, 75/zoom)
    exports["pd-gui"]:setButtonFont(aktualizacje, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)

    autorzy = exports["pd-gui"]:createButton("Autorzy", sx/2-550/zoom, sy/2+175/zoom, 230/zoom, 75/zoom)
	exports["pd-gui"]:setButtonFont(autorzy, exports["pd-gui"]:getGUIFont("normal"), 1/zoom)
	


    local sw, sh = dxGetMaterialSize(help.textures.scrollbar)
    local gripSize = dxGetMaterialSize(help.textures.scrollbar_point)
    Scroll = exports["pd-gui"]:createScroll(sx/2+500/zoom, sy/2-330/zoom, math.floor(sw/zoom), 640/zoom, {background=help.textures.scrollbar, grip=help.textures.scrollbar_point}, (gripSize*1)/zoom )

    przewodnikRT = dxCreateRenderTarget( 880/zoom, 600/zoom, true )   

	regulaminRT = dxCreateRenderTarget( 800/zoom, 600/zoom, true ) 
	
end)

addEventHandler("onClientResourceStop", resourceRoot, function()
    exports["pd-gui"]:destroyButton(oserwerze)
    exports["pd-gui"]:destroyButton(przewodnik)
    exports["pd-gui"]:destroyButton(premium)
    exports["pd-gui"]:destroyButton(regulamin)
    exports["pd-gui"]:destroyButton(komendy)
    exports["pd-gui"]:destroyButton(klawiszologia)
    exports["pd-gui"]:destroyButton(aktualizacje)
    exports["pd-gui"]:destroyButton(autorzy)
    exports["pd-gui"]:destroyScroll(Scroll)
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



