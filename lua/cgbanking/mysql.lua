-- This file contains some mysql things for CGBanking
-- usualy this would be in a server config file but this is serverside anyways soooo deal with it :)
local creds = {
    username = "user",
    password = "password",
    database = "cgbanking",
    hostname = "127.0.0.1", -- Do not use 'localhost'
    port = 3306,
}
local table_prefix = "cgbanking_" -- because people often use the same database, all the tables will have this prefix

-- Do not edit below here
require("mysqloo")

local function tp(t)
    return table_prefix .. t
end

CGBanking.DB = mysqloo.connect(creds.hostname, creds.username, creds.password, creds.database, creds.port)

-- q will perform a query, and log the error if there was one
local function q(queryStr)
    query = CGBanking.DB:query(queryStr)
    query:start()
    query:wait()
    err = query:error()
    if err != "" then
        CGBanking.Print("Failed to execute query \'" .. queryStr .. "\'\n\nError: " .. err)
        return nil
    end

    return query:getData()
end

-- This function is called on server startup, and will initalize the database and things
function CGBanking.InitDatabase()
    if CGBanking.DB:status() == mysqloo.DATABASE_NOT_CONNECTED then
        CGBanking.DB:connect()
    end

    q([[CREATE TABLE IF NOT EXISTS ]] .. tp("balances") .. [[ (
        steam_id VARCHAR(32) PRIMARY KEY,
        balance DECIMAL(14, 2) NOT NULL DEFAULT 0
    );]])
end

-- CGBanking.PreSetupSteamID is called when the player joins the server, and needs to have their banking stuff setup
-- this can be used for creating tables, or maybe nothing
function CGBanking.PreSetupSteamID(sid)
    print("setting up " .. sid)
end

-- CGBanking.GetAccountBalance(sid: string): int will get the account balance of a user
-- this will return nil if the user wasn't found or something else bad happened.
function CGBanking.GetAccountBalance(sid)

end

-- CGBanking.SetAccountBalance(sid: string, amt: int): string? will set the balance of an account
-- this will also check if the action was successful, and will return a string if something went wrong as an error message
function CGBanking.SetAccountBalance(sid, amt)

end
