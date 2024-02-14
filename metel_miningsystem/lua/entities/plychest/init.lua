AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/prop/crates/miningcrate.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
        self:SetNWInt("MetelMining_OreValue", 0)
        self:SetNWInt("MetelMining_OreTotal", 0)
    end

end

function ENT:Use(activator)
    activator:PickupObject(self)
end

function ENT:StartTouch(ent)
	if table.HasValue(MetelMining_Config.Ores, ent:GetClass()) then
        if self:GetNWInt("MetelMining_OreValue") <= 9 then
            self:SetNWInt("MetelMining_OreTotal", self:GetNWInt("MetelMining_OreTotal") + ent.Worth)
            ent:Remove()
            self:SetNWInt("MetelMining_OreValue", self:GetNWInt("MetelMining_OreValue") + 1)
        end
    end 
end