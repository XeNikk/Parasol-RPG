-- // Ustawienia \\ --

local renderowanieCuboid = false
local pozycjaCuboid

-- // Komenda na wywołanie tworzenia strefy \\ --

addCommandHandler('cuboid',
function()
	renderowanieCuboid = true
	pozycjaCuboid = {getElementPosition(localPlayer)}
	if renderowanieCuboid then removeEventHandler('onClientPreRender', root, strefaCuboid) end
	addEventHandler('onClientPreRender', root, strefaCuboid)
	outputChatBox('/showcol - podgląd cuboida', 255, 200, 0, false)
	outputChatBox('/zapiszcuboid : zapis cuboida', 255, 200, 0, false)
	outputChatBox('/usuncuboid : usunięcie cuboida', 255, 200, 0, false)
end)

-- // Komenda na zapis cuboida po utworzeniu \\ --

addCommandHandler('zapiszcuboid',
function()
	if not renderowanieCuboid then outputChatBox('Stwórz pierwszy cuboid!', 240, 0, 0, false) return end
	removeEventHandler('onClientPreRender', root, strefaCuboid)
	pokazCuboidGUI()
end)

-- // Usuwanie cuboida po utworzeniu \\ --

addCommandHandler('usuncuboid',
function()
	if not renderowanieCuboid then outputChatBox('Stwórz pierwszy cuboid!', 240, 0, 0, false) return end
	renderowanieCuboid = false
	if isElement(strefa) then destroyElement(strefa) end
	removeEventHandler('onClientPreRender', root, strefaCuboid)
end)

-- // Rysowanie cuboida \\ --

function strefaCuboid()
	x, y, z = unpack(pozycjaCuboid)
	local cx, cy, cz = getElementPosition(localPlayer)
	w, d, h = cx-x, cy-y, cz-z+1.9
	if isElement(strefa) then destroyElement(strefa) end
	strefa = createColCuboid(x, y, z-1, w, d, h)
end

-- // GUI \\ --

local strefa = {}
function pokazCuboidGUI()
	if strefa['cuboidGUI'] then destroyElement(strefa['cuboidGUI']) strefa['cuboidGUI'] = nil end
	strefa['cuboidGUI'] = guiCreateWindow(398,157,540,483,"Panel Cuboida",false)
	strefa['cuboidPozycja'] = guiCreateMemo(10,25,520,371,
	[[addEventHandler('onResourceStart', resourceRoot,
    function()
        local strefa = createColCuboid(]]..string.format('%.2f', x)..[[, ]]..string.format('%.2f', y)..[[, ]]..string.format('%.2f', z-1)..[[, ]]..string.format('%.2f', w)..[[, ]]..string.format('%.2f', d)..[[, ]]..string.format('%.2f', h)..[[)
    end)]],false,strefa['cuboidGUI'])
	strefa['cuboidZapisz'] = guiCreateButton(10,406,255,28,'Zapisz w Cuboid/strefa.txt',false,strefa['cuboidGUI'])
	strefa['cuboidKopiuj'] = guiCreateButton(275,406,255,28,'Kopiuj do schowka',false,strefa['cuboidGUI'])
	strefa['cuboidOdswiez'] = guiCreateButton(10,444,255,28,'Odśwież',false,strefa['cuboidGUI'])
	strefa['cuboidZamknij'] = guiCreateButton(275,444,255,28,'Zamknij',false,strefa['cuboidGUI'])
	guiMemoSetReadOnly(strefa['cuboidPozycja'],true)
	guiWindowSetSizable(strefa['cuboidGUI'],false)
	guiSetAlpha(strefa['cuboidGUI'],0.759)
	centerWindow(strefa['cuboidGUI'])
	addEventHandler('onClientGUIClick', strefa['cuboidGUI'], przyciskCuboidGUI)
	showCursor(true)
end

-- // Funkcje przycisków \\ --

function przyciskCuboidGUI(button, state)
	if button == 'left' and state == 'up' then
		if source == strefa['cuboidZapisz'] then
			triggerServerEvent('strefa:zapiszPlik', localPlayer, guiGetText(strefa['cuboidPozycja']))
		elseif source == strefa['cuboidKopiuj'] then
			setClipboard(guiGetText(strefa['cuboidPozycja']))
			outputChatBox('Skopiowano do schowka!', 0, 240, 0, false)
		elseif source == strefa['cuboidOdswiez'] then
			if isTimer(refreshTimer) then return end
			refreshTimer = setTimer(pokazCuboidGUI, 350, 1)
			guiSetText(strefa['cuboidPozycja'], "")
		elseif source == strefa['cuboidZamknij'] then
			destroyElement(strefa['cuboidGUI'])
			strefa['cuboidGUI'] = nil
			showCursor(false)
		end
	end
end

-- // Środkowanie GUI \\ --

function centerWindow(center_window)
    local screenW,screenH=guiGetScreenSize()
    local windowW,windowH=guiGetSize(center_window,false)
    local x,y = (screenW-windowW)/2,(screenH-windowH)/2
    guiSetPosition(center_window,x,y,false)
end

-- // Development mode \\ --

setDevelopmentMode(true)