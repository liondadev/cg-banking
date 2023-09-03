function CGBanking.OpenATM()
    if IsValid(CGBanking.ATMMenu) then
        CGBanking.ATMMenu:Remove()
    end

    CGBanking.ATMMenu = vgui.Create("DFrame")
    CGBanking.ATMMenu:SetSize(ScrW() * .15, ScrH() * .15)
    CGBanking.ATMMenu:Center()
    CGBanking.ATMMenu:SetTitle(CGBanking.Config.CommunityName)
    CGBanking.ATMMenu:MakePopup(true)

    CGBanking.ATMMenu.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, CGBanking.Theme.FrameBackground)
    end

    local nav = CGBanking.ATMMenu:Add("CGBanking.Navbar")
    nav:Dock(TOP)
    nav:SetBodyPanel(CGBanking.ATMMenu)

    nav:AddTab(CGBanking.Lang["deposit"], "CGBanking.SimpleMoneyPrompt", function(p)
        p.submit:SetText(CGBanking.Lang["deposit"])
        p.Submit = function(amt)
            net.Start("CGBanking.Deposit")
                net.WriteFloat(amt)
            net.SendToServer()
        end
    end)

    nav:AddTab(CGBanking.Lang["withdraw"], "CGBanking.SimpleMoneyPrompt", function(p)
        p.submit:SetText(CGBanking.Lang["withdraw"])
        p.CalculateNewBalance = function(c, d) return c - d end
        p.Submit = function(amt)
            net.Start("CGBanking.Withdraw")
                net.WriteFloat(amt)
            net.SendToServer()
        end
    end)
end

hook.Add("OnPlayerChat", "CGBanking.OpenMenu", function(ply, text)
    if not CGBanking.Config.ATMCommand then return end
    if ply ~= LocalPlayer() then return end
    for _, cmd in pairs(CGBanking.Config.ATMCommands) do
        if cmd == string.Trim(string.lower(text)) then
            CGBanking.OpenATM()
        end
    end
end)

net.Receive("CGBanking.OpenMenu", function()
    CGBanking.OpenATM()
end)
