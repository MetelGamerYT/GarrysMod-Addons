AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/misc/potato_launcher_chamber.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
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

function ENT:Use(activator, caller)
    if activator:GetNWBool("MetelMedic_HasCast", nil) == true then return end
    self:Remove()
    activator:SetNWBool("MetelMedic_HasCast", true)

    timer.Simple(10, function()
        activator:SetDuckSpeed(activator.duckspeed)
        activator:SetWalkSpeed(activator.walkspeed)
        activator:SetRunSpeed(activator.runspeed)
        activator:SetNWBool("MetelMedic_HasCast", false)
        activator:SetNWBool("MetelMedic_Brokenleg", false)
    end)
end

function ENT:OnRemove()
    if timer.Exists("RemoveTimer_Entity_"..self:EntIndex()) then
        timer.Remove("RemoveTimer_Entity_"..self:EntIndex())
    end
end