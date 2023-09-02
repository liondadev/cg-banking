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

function PANEL:SetTitle()

end

vgui.Register("CGBanking.SimpleMoneyPrompt", PANEL, "Panel")

local PANEL = {}

AccessorFunc(PANEL, "pBody", "BodyPanel")

surface.CreateFont("CGBanking.Navbar", {
    font = "Inter Medium",
    weight = 500,
    size = ScreenScale(4),
})

local font = "CGBanking.Navbar"
local margin = 3

function PANEL:Init()
    self.tabs = {}
    self.buttons = {}
    self.curActive = ""
    self.curPanel = nil
    self:DockMargin(0, 0, 0, margin)

    self.barStartPos = 0
    self.barEndPos = 0
    self.wantedBarStartPos = 0
    self.wantedBarEndPos = 0

    self.barHeight = 3
    self.wantedBarHeight = 3
end

function PANEL:PerformLayout()
    local h = draw.GetFontHeight(font) + margin * 2.5
    self:SetTall(h)
end

function PANEL:AddTab(name, panel, panelCallback, buttonCallback)
    self.tabs[name] = {
        panel = panel,
        callback = panelCallback,
    }

    self.buttons[name] = self:Add("DButton")
    self.buttons[name]:Dock(LEFT)
    self.buttons[name]:SetText(name)
    self.buttons[name]:SetFont(font)
    self.buttons[name]:SizeToContentsX(16)
    self.buttons[name]:InvalidateParent(true)
    self.buttons[name]:SetColor(CGBanking.Theme.Text)
    self.buttons[name].Paint = nil
    self.buttons[name].id = name
    self.buttons[name].DoClick = function(s, w, h)
        self:SetActive(s:GetText()) -- the text is the name
    end

    if table.Count(self.buttons) <= 1 then
        self.buttons[name]:SetWide(self.buttons[name]:GetWide() + 8)
    end

    if buttonCallback then
        buttonCallback(self.buttons[name])
    end

    self.goingRight = true
end

function PANEL:Paint(w, h)
    self.barStartPos = Lerp(10 * FrameTime(), self.barStartPos, self.wantedBarStartPos)
    self.barEndPos = Lerp(10 * FrameTime(), self.barEndPos, self.wantedBarEndPos)

    if self.barStartPos - 10 <= self.wantedBarStartPos and self.barEndPos + 10 >= self.wantedBarEndPos then
        self.wantedBarHeight = self:GetTall()
    else
        self.wantedBarHeight = 3
    end

    self.barHeight = Lerp(10 * FrameTime(), self.barHeight, self.wantedBarHeight)
    draw.RoundedBox(0, self.barStartPos, h - self.barHeight, self.barEndPos - self.barStartPos, self.barHeight, CGBanking.Config.CommunityColor)
end

function PANEL:SetActive(name)
    if IsValid(self.curPanel) then
        self.curPanel:Remove()
    end

    local t = self.tabs[name]
    if not t or not istable(t) then return end

    self.curPanel = self:GetBodyPanel():Add(t.panel)
    self.curPanel:Dock(FILL)
    self.curPanel:InvalidateParent(true)

    -- Perform the callback
    if t.callback then
        -- Just incase we're using an html panel and we need to set website
        t.callback(self.curPanel)
    end

    local b = self.buttons[name]
    if not b or not IsValid(b) then return end

    self.wantedBarStartPos = b:GetX()
    self.wantedBarEndPos = b:GetX() + b:GetWide()

    self.curActive = name
end

vgui.Register("CGBanking.Navbar", PANEL, "DPanel")

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
    if ply ~= LocalPlayer() then return end
    if string.Trim(string.lower(text)) ~= "!banking" and string.Trim(string.lower(text)) ~= "/banking" then return end
    CGBanking.OpenATM()
end)
