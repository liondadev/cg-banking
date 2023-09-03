CGBanking.SetupPlayers = CGBanking.SetupPlayers or {} -- used to cache when players are setup properly
CGBanking.Print("Initalizing Database")
CGBanking.InitDatabase()

util.AddNetworkString("CGBanking.RequestPlayerBalance")
util.AddNetworkString("CGBanking.SendBalance")
util.AddNetworkString("CGBanking.Deposit")
util.AddNetworkString("CGBanking.Withdraw")
util.AddNetworkString("CGBanking.OpenMenu")

-- CGBanking.SendPlayerBalance(target: Player, sid: string) sends the balance of the user with the steamid to the user
function CGBanking.SendPlayerBalance(target, sid)
    local balance = CGBanking.GetAccountBalance(sid)

    net.Start("CGBanking.SendBalance")
        net.WriteString(sid)
        net.WriteFloat(balance)
    net.Send(target)
end

-- CGBanking.ForceOpenMenu(ply: Player) will open the ATM menu on a client's screen
function CGBanking.ForceOpenMenu(ply)
    net.Start("CGBanking.OpenMenu")
    net.Send(ply)
end

hook.Add("PlayerInitialSpawn", "CGBanking.SetupPlayerData", function(ply)
    local sid = ply:SteamID64()
    if not CGBanking.SetupPlayers[sid] then
        CGBanking.PreSetupSteamID(sid)
        CGBanking.SetupPlayers[sid] = true
    end
end)

net.Receive("CGBanking.RequestPlayerBalance", function(_, ply)
    if not IsValid(ply) then return end

    local sid = net.ReadString()
    if not sid or sid == "" then return end

    CGBanking.SendPlayerBalance(ply, sid)
end)

net.Receive("CGBanking.Deposit", function(_, ply)
    local amt = net.ReadFloat()
    if amt <= 0 or amt > CGBanking.Config.MaxMoney then return end

    if not ply:canAfford(amt) then
        ply:ChatPrint(CGBanking.Lang["cant_afford"])
        return
    end

    local curBal = CGBanking.GetAccountBalance(ply:SteamID64())
    if curBal + amt > CGBanking.Config.MaxMoney then return end

    local newBal = curBal + amt
    math.Clamp(newBal, 0, CGBanking.Config.MaxMoney)

    ply:addMoney(amt * -1)
    CGBanking.SetAccountBalance(ply:SteamID64(), newBal)
    ply:ChatPrint(string.gsub(CGBanking.Lang["deposit_complete"], "{AMT}", DarkRP.formatMoney(amt or 0) or 0))
end)

net.Receive("CGBanking.Withdraw", function(_, ply)
    local amt = net.ReadFloat()
    if amt <= 0 or amt > CGBanking.Config.MaxMoney then return end

    local curBal = CGBanking.GetAccountBalance(ply:SteamID64())
    if curBal - amt <= 0 then
        ply:ChatPrint(CGBanking.Lang["cant_withdraw"])
    end

    local newBal = curBal - amt
    math.Clamp(newBal, 0, CGBanking.Config.MaxMoney)

    ply:addMoney(amt * 1)
    CGBanking.SetAccountBalance(ply:SteamID64(), newBal)
    ply:ChatPrint(string.gsub(CGBanking.Lang["withdraw_complete"], "{AMT}", DarkRP.formatMoney(amt or 0) or 0))
end)

timer.Create("CGBanking.InterestTimer", CGBanking.Config.InterestTimer, 0, function()
    for _, v in pairs(player.GetAll()) do
        if not IsValid(v) or v:IsBot() then return end
        local curBal = CGBanking.GetAccountBalance(v:SteamID64())
        local interest = math.ceil(curBal * CGBanking.Config.MaxInterest)
        if curBal + interest > CGBanking.Config.MaxMoney then
            interest = CGBanking.Config.MaxMoney - interest
        end
        if interest > CGBanking.Config.MaxInterest then
            interest = CGBanking.Config.MaxInterest
        end

        v:ChatPrint(string.gsub(CGBanking.Lang["interest_payment"], "{AMT}", DarkRP.formatMoney(interest or 0)))
        CGBanking.SetAccountBalance(v:SteamID64(), curBal + interest)
    end
end)
