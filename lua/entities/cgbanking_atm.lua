-- I know how to do multi file entities, but this is so simple it's not needed here

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "ATM"
ENT.Category = "CGBanking"
ENT.Author = "@liondadev"
ENT.Spawnable = true
ENT.AdminOnly = false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if SERVER then
    function ENT:Initialize()
        self:SetModel("models/props_lab/reciever_cart.mdl")

        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)

        local phys = self:GetPhysicsObject()
        if not phys:IsValid() then return end
        phys:Wake()
    end

    function ENT:Use(ply)
        CGBanking.ForceOpenMenu(ply)
    end
end

if CLIENT then
    surface.CreateFont("CGBanking.OverEnt", {
        font = "Inter Bold",
        weight = 500,
        size = 100
    })

    function ENT:Draw()
        self:DrawModel()
        if self:GetPos():Distance(LocalPlayer():GetPos()) >= 500 then return end

        surface.SetFont("CGBanking.OverEnt")
        local tw, th = surface.GetTextSize(CGBanking.Lang["atm"])
        tw = tw + 32
        th = th + 16

        cam.Start3D2D(self:GetPos() + self:GetUp() * 45, Angle(0, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
            draw.RoundedBox(6, (tw / 2) * -1, (th / 2) * -1, tw, th, CGBanking.Theme.AtmBackground)
            draw.SimpleText(CGBanking.Lang["atm"], "CGBanking.OverEnt", 0, 0, CGBanking.Theme.AtmText, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end
