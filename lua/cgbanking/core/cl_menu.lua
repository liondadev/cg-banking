-- This is the panel used for simple money prompts
-- like the transfer and deposit menu
local PANEL = {}

function PANEL:Init()

    self.submit = self:Add("DButton")
    self.submit:Dock(BOTTOM)
    self.submit:SetText("Submit")
    self.submit:InvalidateParent(true)
    self.submit:SizeToContentsY(16)
end

function PANEL:SetTitle()

end

vgui.Register("CGBanking.SimpleMoneyPrompt", PANEL, "Panel")

function CGBanking.OpenATM()
    if IsValid(CGBanking.ATMMenu) then
        CGBanking.ATMMenu:Remove()
    end

    CGBanking.ATMMenu = vgui.Create("DFrame")
    CGBanking.ATMMenu:SetSize(ScrW() * .15, ScrH() * .15)
    CGBanking.ATMMenu:Center()
    CGBanking.ATMMenu:SetTitle(CGBanking.Config.CommunityName)
    CGBanking.ATMMenu:MakePopup(true)

    local tabs = CGBanking.ATMMenu:Add("DPropertySheet")
    tabs:Dock(FILL)

    local deposit = tabs:Add("CGBanking.SimpleMoneyPrompt")
    deposit.submit:SetText("Deposit")
    tabs:AddSheet(CGBanking.Lang["deposit"], deposit, "icon16/money_add.png")

    local withdraw = tabs:Add("CGBanking.SimpleMoneyPrompt")
    withdraw.submit:SetText("Withdraw")
    tabs:AddSheet(CGBanking.Lang["withdraw"], withdraw, "icon16/money_delete.png")

    local transfer = tabs:Add("DPanel")
    tabs:AddSheet(CGBanking.Lang["transfer"], transfer, "icon16/arrow_refresh.png")
end

CGBanking.OpenATM()
