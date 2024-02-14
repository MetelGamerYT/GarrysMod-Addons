AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/prop/crates/sellcrate.mdl")
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

function ENT:Use(activator)
    if not activator:HasWeapon("pickaxe") then
        local crate = ents.Create("plychest")
        crate:SetNWEntity("MetelMining_CrateOwner", activator)
        crate:SetPos(self:GetPos())
        crate:Spawn()
        activator:Give("pickaxe")
        activator:SelectWeapon("pickaxe")
    else
        activator:StripWeapon("pickaxe")
        for k,v in pairs(ents.GetAll()) do
            if v:GetClass() == "plychest" and v:GetNWEntity("MetelMining_CrateOwner") == activator then
                v:Remove()
            end
        end
    end
end

function ENT:StartTouch(ent)
    if ent:GetClass() == "plychest" then
        if ent:GetNWInt("MetelMining_OreValue") >= 1 then
            local value = ent:GetNWInt("MetelMining_OreValue")
            if IsValid(ent:GetNWEntity("MetelMining_CrateOwner")) then
                local ply = ent:GetNWEntity("MetelMining_CrateOwner")
                ply:addMoney(ent:GetNWInt("MetelMining_OreTotal"))
                DarkRP.notify(ply, 1, 3, "You got "..ent:GetNWInt("MetelMining_OreTotal").."$ by selling ores!")
                ent:SetNWInt("MetelMining_OreTotal", 0)
                ent:SetNWInt("MetelMining_OreValue", 0)
                ply:addXP(10)
                if GetGlobalInt("MetelLogic_FoundationCap") > MetelLogistic_Config.Capacity - value then return end
                SetGlobalInt("MetelLogic_FoundationCap", GetGlobalInt("MetelLogic_FoundationCap") + value)
            end
        end
    end
end