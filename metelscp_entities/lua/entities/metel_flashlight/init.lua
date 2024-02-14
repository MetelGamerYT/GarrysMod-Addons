AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/maxofs2d/lamp_flashlight.mdl")
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
        self:SetModelScale(0.7, 0)
    end

end

function ENT:Use(activator)
    if activator:KeyDown(IN_SPEED) then
        activator:PickupObject(self)
    else
        activator:SetNWBool("MetelENT_HasFlashlight", true)
        self:Remove()
    end
end

function ENT:OnRemove()
    if timer.Exists("RemoveTimer_Entity_"..self:EntIndex()) then
        timer.Remove("RemoveTimer_Entity_"..self:EntIndex())
    end
end