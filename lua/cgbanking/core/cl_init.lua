CGBanking.BalanceCache = CGBanking.BalanceCache or {}

-- CGBanking.GetPlayerBalance(sid: string) will get the balance of a user's account, if it has been networked from the server
-- it will also request it if it hasn't been networked from the server
function CGBanking.GetAccountBalance(sid)
    if not CGBanking.BalanceCache[sid] then
        net.Start("CGBanking.RequestPlayerBalance")
            net.WriteString(sid)
        net.SendToServer()
        return nil
    end

    return CGBanking.BalanceCache[sid]
end

-- gets the user's balance from the server and updates it in the cache
net.Receive("CGBanking.SendBalance", function()
    local sid = net.ReadString()
    local bal = net.ReadFloat(32)

    CGBanking.BalanceCache[sid] = bal
end)
