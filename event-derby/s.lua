--[[
    Zasób został stworzony przez: boszboszek
    Korzystanie z pliku bez mojej zgody jest zabronione.
    @Skype: masteradolf1
    @E-mail: ptotczyk@gmail.com
]]--



-----------------------------------------------------------------Service script-------------------------------------------------------------------------------
--Teleportacja na event:/derby
--Otwieranie zapisów na event:/derbystart
--Sprawdzanie statusu zapisów:/derbystatus -- Jeżeli jest "true" to gracz może wejść na event, a jeżeli "false" to nie
--Start odliczania do rozpoczęcia:/odliczajderby
---------------------------------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------Script Settings-------------------------------------------------------------------------------
x1,y1,z1 = 3750.57959, -1530.70996, 86.66093  -- Koordynacja markeru wyjścia z eventu
x2,y2,z2 = 3752.8999, -1532.9, 123.6 -- Koordynacja tepania się na event
---------------------------------------------------------------------------------------------------------------------------------------------------------------



marker = createMarker(3750.57959, -1530.70996, 86.66093-1,"cylinder",8.5)


function eventExit(plr)
	setElementPosition(plr,x,y,z)
	--outputChatBox("Przeteleportowałeś się na swoją ostatnią pozycję")
end
addEventHandler("onMarkerHit",marker,eventExit)

miejsca={
	{444,3787.11,-1547.07,121.06,63.4},
	{444,3766.35,-1566.49,121.06,19.4},
	{444,3738.48,-1565.90,121.06,329.1},
	{444,3719.98,-1545.82,121.06,279.6},
	{444,3719.13,-1519.09,121.06,233.6},
	{444,3739.20,-1499.32,121.06,192.2},
	{444,3765.60,-1501.82,121.06,145.9},
	{444,3786.18,-1519.20,121.06,101.1},
}

auta_id={}

derbyStart = false

function consoleSetPlayerPosition ( source, commandName, posX, posY, posZ )
	if not derbyStart then return end
	x,y,z = getElementPosition(source)
	setElementPosition ( source, x2,y2,z2 )
	--outputChatBox("Przeteleportowałeś/aś się na event Derby", source)
end
addCommandHandler ( "derby", consoleSetPlayerPosition  )


function zaproszenie (thePlayer)
	local accName = getAccountName ( getPlayerAccount ( thePlayer ) )
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
	--outputChatBox("Zapraszamy na Event Derby wpisz /derby aby się przeteleportować!", thePlayer)
   end
end
addCommandHandler("derbystart", zaproszenie)

function zaproszenie (thePlayer)
	local accName = getAccountName ( getPlayerAccount ( thePlayer ) )
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
	derbyStart = not derbyStart
	--outputChatBox(tostring(derbyStart),thePlayer)
   end
end
addCommandHandler("derbystatus", zaproszenie)

for k,v in ipairs(miejsca) do
	auta_id[#auta_id+1] = createVehicle(v[1],v[2],v[3],v[4])
	setElementFrozen(auta_id[#auta_id],true)
	setElementRotation(auta_id[#auta_id],0,0,v[5])
end

function Odliczanie()
	local accName = getAccountName ( getPlayerAccount ( thePlayer ) )
	if not isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then --outputChatBox("Zająć pojazdy, oraz przygotwać się!",getRootElement(),255,0,0) end
	--outputChatBox("Za 1 minute startujemy",getRootElement(),255,0,0)
		setTimer(function()
			--outputChatBox("Zostało jeszcze 30 sekund do startu",getRootElement(),255,0,0)
		end,1000*30,1)	
		setTimer(function()
			--outputChatBox("Rozpoczęła się demolka! Powodzenia ;)",getRootElement(),255,0,0)
			for k,v in ipairs(auta_id) do
				setElementFrozen(v,false)
				if not getVehicleOccupant(v) then destroyElement(v) end 
			end
		end,1000*60,1)
end
addCommandHandler("odliczajderby",Odliczanie)
