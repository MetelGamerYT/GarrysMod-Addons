AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/toju/mg_ctf/flag.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_NONE)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetModelScale(0.6, 0)
        self:SetUseType(3)
    end

end

function ENT:Use(activator)
    if activator:GetNWBool("MetelTrain_IsOut") then return end
    if activator:GetNWBool("MetelTrain_TeamRed") then
        activator:SetNWBool("MetelTrain_HasFlagBlue", true)
        self:Remove()

        MetelTraining_NotifyPlayer(Color(0,120,255), activator:Name().." has now received the Blue Flag!")
    end
end