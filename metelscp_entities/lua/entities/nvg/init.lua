AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/cpthazama/scp/items/nvg.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
        timer.Create("RemoveTimer_Entity_"..self:EntIndex(),300, 1, function()
            self:Remove()
        end)
    end

end

function ENT:Use(activator)
    if activator:KeyDown(IN_SPEED) then
        activator:PickupObject(self)
    else
        if activator:GetNWBool("NVG_Equipped") then return end
        DarkRP.notify(activator, 0,5,"You have picked up a night vision device")
        activator:ChatPrint("Use !nvgtoggle to switch the night vision device on/off")
        activator:ChatPrint("Use !dropnvg to drop the night vision device")
        activator:SetNWBool("NVG_Equipped", true)
        self:Remove()
    end
end

function ENT:OnRemove()
    if timer.Exists("RemoveTimer_Entity_"..self:EntIndex()) then
        timer.Remove("RemoveTimer_Entity_"..self:EntIndex())
    end
end