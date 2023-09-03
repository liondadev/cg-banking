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
