startResource(getResourceFromName("pd-mysql"))
q=exports["pd-mysql"]:query("select * from `pd-autostart`")
for i,v in ipairs(q) do
	startResource(getResourceFromName(v.resource))
end

function admin(plr)
	local accName = getAccountName ( getPlayerAccount ( plr ) )
	if not accName then return true end
	if isObjectInACLGroup ("user."..accName, aclGetGroup ( "Admin" ) ) then
		return false
	else
		return true
	end
end

function autostart(plr)
	if admin(plr) then return end
	outputDebugString("Trwa przeładowywanie autostartu...")
	exports["pd-mysql"]:query("truncate `pd-autostart`")
	for i,v in ipairs(getResources()) do
		if getResourceState(v)=="running" then
			exports["pd-mysql"]:query("insert into `pd-autostart` values(?)",getResourceName(v))
			outputDebugString("Dodano "..getResourceName(v).." do autostartu.")
		end
	end
	outputDebugString("Autostart przeładowany pomyślnie!")
end
addCommandHandler("autostartreload",autostart)