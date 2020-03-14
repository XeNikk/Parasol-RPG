addEventHandler('onPlayerConnect', root, function(nick, ip, _, serial)
    local query = exports['pd-mysql']:query('SELECT * FROM `pd-whitelist` where `serial`=?', serial)
    if query and #query < 1 then
        cancelEvent(true, 'Brak dostępu!\nhttps://discord.gg/Vw5VDNQ')
    end
end)