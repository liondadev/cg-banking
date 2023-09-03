-- This is the panel used for simple money prompts
-- like the transfer and deposit menu
local PANEL = {}
PANEL.OnSubmit = function(ans) end
PANEL.CalculateNewBalance = function(cur, diff)
    return cur + diff
end
PANEL.Submit = function(amt)
    print(amt)
end

surface.CreateFont("CGBanking.Balance", {
    font = "Inter Medium",
    weight = 500,
    size = ScreenScale(4),
})
surface.CreateFont("CGBanking.TextEntry", {
    font = "Inter Medium",
    weight = 500,
    size = ScreenScale(4),
})
surface.CreateFont("CGBanking.Button", {
    font = "Inter Medium",
    weight = 500,
    size = ScreenScale(4),
})

function PANEL:Init()
    self.b = 0 -- the user's current balance
    self.bL = false -- has the balance been loaded????

    self.submit = self:Add("DButton")
    self.submit:Dock(BOTTOM)
    self.submit:SetText(CGBanking.Lang["submit"])
    self.submit:SetFont("CGBanking.Button")
    self.submit:SetColor(CGBanking.Theme.Text)
    self.submit:InvalidateParent(true)
    self.submit:SizeToContentsY(16)
    self.submit:SetEnabled(false)
    self.submit.alphaLerp = 0
    self.submit.Paint = function(s, w, h)
        s.alphaLerp = Lerp(15 * FrameTime(), s.alphaLerp, s:IsHovered() and 100 or 0)

        draw.RoundedBox(6, 0, 0, w, h, CGBanking.Config.CommunityColor)
        draw.RoundedBox(6, 0, 0, w, h, ColorAlpha(color_black, s.alphaLerp))
    end


    self.submit.DoClick = function(s)
        local n = self.entry:GetFloat()
        if not n or n == nil then return end

        self.Submit(n)

        if IsValid(CGBanking.ATMMenu) then
            CGBanking.ATMMenu:Remove()
        end
    end

    self.balance = self:Add("DLabel")
    self.balance:Dock(TOP)
    self.balance:SetText(CGBanking.Lang["balance_loading"])
    self.balance:SetFont("CGBanking.Balance")
    self.balance:SetColor(CGBanking.Theme.Text)
    self.balance:SetContentAlignment(5)
    self.balance:SizeToContentsY(16)

    self.balance.Think = function(s)
        if not self.bL then
            self:SetText(CGBanking.Lang["balance_loading"])
            return
        end

        -- s:SetText("Balance: " .. DarkRP.formatMoney(self.b))
        s:SetText(string.gsub(CGBanking.Lang["balance_money"], "{AMT}", DarkRP.formatMoney(self.b or 0)))
    end

    self.newBalance = self:Add("DLabel")
    self.newBalance:Dock(TOP)
    self.newBalance:SetText(CGBanking.Lang["new_balance_waiting"])
    self.newBalance:SetFont("CGBanking.Balance")
    self.newBalance:SetColor(CGBanking.Theme.Text)
    self.newBalance:SetContentAlignment(5)
    self.newBalance:SizeToContentsY(16)

    self.entry = self:Add("DTextEntry")
    self.entry:Dock(BOTTOM)
    self.entry:SetFont("CGBanking.TextEntry")
    self.entry:SetPlaceholderText(CGBanking.Lang["amount"])
    self.entry:SetTall(draw.GetFontHeight("CGBanking.TextEntry") + 16)
    self.entry:DockMargin(0, 0, 0, 3)

    self.entry.Paint = function(s, w, h)
        draw.RoundedBox(6, 0, 0, w, h, CGBanking.Theme.FrameBackground)
        s:DrawTextEntryText(CGBanking.Theme.Text, CGBanking.Config.CommunityColor, CGBanking.Config.CommunityColor)
    end

    self.entry.OnChange = function(s)
        if not self.bL then return end

        local n = s:GetFloat()
        if n == nil or n <= 0 then
            self.submit:SetEnabled(false)
            return
        else
            self.submit:SetEnabled(true)
        end

        local newBalance = self.CalculateNewBalance(self.b, n)
        if newBalance > CGBanking.Config.MaxMoney or newBalance < 0 then
            self.submit:SetEnabled(false)
        end
        if newBalance < 0 then
            newBalance = 0
        end
        -- self.newBalance:SetText("New Balance: " .. DarkRP.formatMoney(newBalance or 0))
        self.newBalance:SetText(string.gsub(CGBanking.Lang["new_balance_money"], "{AMT}", DarkRP.formatMoney(newBalance or 0)))
    end

    self.NextTry = CurTime()
end

function PANEL:Think()
    if self.NextTry <= CurTime() then
        local bal = CGBanking.GetAccountBalance(LocalPlayer():SteamID64())
        if bal == nil then
            return
        end

        self.b = bal
        self.bL = true

        self.NextTry = CurTime() + 1
    end
end

vgui.Register("CGBanking.SimpleMoneyPrompt", PANEL, "Panel")
