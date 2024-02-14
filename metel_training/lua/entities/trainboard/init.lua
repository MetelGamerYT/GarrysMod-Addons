AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("imgui.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/hunter/plates/plate3x8.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
        self:SetNWBool("MetelTraining_IsCapture", false)
        self:SetNWBool("MetelTraining_IsVS", false)
        self:SetNWBool("MetelTraining_RunGame", false)
        self:SetColor(Color(255,255,255,1))
    end

end