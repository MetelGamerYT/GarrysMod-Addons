AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/prop/junk/unique_rock_02.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
    end
end

function ENT:OnTakeDamage(dmginfo)
    local ply = dmginfo:GetAttacker()

    if ply:IsPlayer() and IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() == "pickaxe" then
        if(math.random(1,20) <= 4) then
            DarkRP.notify(ply, 1, 3, "You have found an ore!")
            local ore = ents.Create(table.Random(MetelMining_Config.Ores))
            //ore:SetPos(self:GetPos())
            ore:SetPos(self:GetPos() + Vector(0, 20, 0))
            ore:Spawn()
        end
    end
end