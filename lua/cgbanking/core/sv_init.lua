CGBanking.SetupPlayers = CGBanking.SetupPlayers or {} -- used to cache when players are setup properly
CGBanking.Print("Initalizing Database")
CGBanking.InitDatabase()

hook.Add("PlayerInitialSpawn", "CGBanking.SetupPlayerData", function(ply)
    local sid = ply:SteamID64()
    if not CGBanking.SetupPlayers[sid] then
        CGBanking.PreSetupSteamID(sid)
        CGBanking.SetupPlayers[sid] = true
    end
end)
