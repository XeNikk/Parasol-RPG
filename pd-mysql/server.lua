username = "parasol_db"
dbname = "parasol-serwer"
password = "xQujeVRadH"
server = "127.0.0.1"

connection = dbConnect( "mysql", "dbname=" .. dbname .. ";host=" .. server .. ";charset=utf8", username, password, "share=1" )

function query(...)
    local queryHandle = dbQuery(connection, ...)
    if (not queryHandle) then
        return nil
    end
    local rows, num, lastID = dbPoll(queryHandle, -1)
    return rows, num, lastID
end