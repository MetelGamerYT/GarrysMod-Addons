AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/eft_paca_armor/paca_soft_armor.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        timer.Create("RemoveTimer_Entity_"..self:EntIndex(),300, 1, function()
            self:Remove()
        end)
        self:SetUseType(3)
    end

end

function ENT:Use(activator)
    if activator:KeyDown(IN_SPEED) then
        activator:PickupObject(self)
    else
        if activator:Armor() <= 75 then
            activator:SetArmor(activator:Armor() + 25)
            self:Remove()
        end
    end
end

function ENT:OnRemove()
    if timer.Exists("RemoveTimer_Entity_"..self:EntIndex()) then
        timer.Remove("RemoveTimer_Entity_"..self:EntIndex())
    end
end