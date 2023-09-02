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

local tblName = tp("balances")

CGBanking.DB = CGBanking.DB or mysqloo.connect(creds.hostname, creds.username, creds.password, creds.database, creds.port)

-- q will perform a query, and log the error if there was one
local function q(queryStr)
    local query = CGBanking.DB:query(queryStr)
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

    q([[CREATE TABLE IF NOT EXISTS ]] .. tblName .. [[ (
        steam_id VARCHAR(32) PRIMARY KEY,
        balance DECIMAL(14, 2) NOT NULL DEFAULT 0
    );]])
end

-- CGBanking.PreSetupSteamID is called when the player joins the server, and needs to have their banking stuff setup
-- this can be used for creating tables, or maybe nothing
function CGBanking.PreSetupSteamID(sid)
    local bal = CGBanking.GetAccountBalance(sid)
    if bal == -1 then
        q([[
            INSERT INTO ]] .. tblName .. [[ (steam_id, balance)
            VALUES ("]] .. sid .. "\"," .. CGBanking.Config.StartingBankAccountBalance .. ");")
    end
end

-- CGBanking.GetAccountBalance(sid: string): int will get the account balance of a user
-- this will return nil if the user wasn't found or something else bad happened.
function CGBanking.GetAccountBalance(sid)
    local query = [[SELECT * FROM ]] .. tblName .. [[
        WHERE steam_id = "]] .. CGBanking.DB:escape(sid) ..  [["
        LIMIT 1;]]

    local data = q(query)
    if data == nil or not istable(data) then
        return -1
    end

    local row = data[1]
    if row == nil or not istable(row) then
        CGBanking.Print("Failed to get row data ", row)
        return -1
    end
    return row.balance or 0
end

-- CGBanking.SetAccountBalance(sid: string, amt: int): string? will set the balance of an account
-- this will also check if the action was successful
function CGBanking.SetAccountBalance(sid, amt)
    sid = CGBanking.DB:escape(sid)
    local query = [[UPDATE ]] .. tblName .. [[
        SET balance = ]] .. CGBanking.DB:escape(amt) .. [[
        WHERE steam_id = "]] .. sid .. "\";"
    q(query)

    CGBanking.SendPlayerBalance(player.GetAll(), sid)
end

for _, ply in pairs(player.GetAll()) do
    CGBanking.SetAccountBalance(ply:SteamID64(), 800)
end
