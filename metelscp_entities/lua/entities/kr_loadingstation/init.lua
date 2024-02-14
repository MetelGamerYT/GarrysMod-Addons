AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/props/de_nuke/equipment1.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetRenderMode(RENDERMODE_TRANSALPHA)
        self:SetSolid(SOLID_VPHYSICS)
        local phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:Wake()
        end
        self:SetUseType(3)
        self:SetNWInt("krloadingstationbattery", 100)
    end

end

function ENT:Use(activator)
    if activator:getJobTable().name == "KR-Einheit" then
        if self:GetNWInt("krloadingstationbattery") == 100 then
            activator:SetHealth(activator:GetMaxHealth())
            self:SetNWInt("krloadingstationbattery", 0)
            startkrbattery(self)
        else
            DarkRP.notify(activator,0,5,"The battery of the charging station is still charging! "..self:GetNWInt("krloadingstationbattery").."%")
        end
    end
end

function startkrbattery(ent)
    local i = 1
    timer.Create("krloadingstationtimer", 3, 100, function()
        ent:SetNWInt("krloadingstationbattery", i)
        i = i + 1
    end)
end