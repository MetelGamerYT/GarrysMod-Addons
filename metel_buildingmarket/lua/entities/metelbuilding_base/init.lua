AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel(self:GetNWString("metelbuilding_modelpath"))
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
    if not activator == self:GetNWEntity("metelbuilding_owner") then return end
    if activator:KeyDown(IN_SPEED) then
        if self:IsMotionEnabled() then
            self:EnableMotion(false)
        else
            self:EnableMotion(true)
        end
    else
        activator:PickupObject(self)
    end
end

function ENT:OnTakeDamage(damageinfo)
    local damage = damageinfo:GetDamage()
    local entowner = self:GetNWEntity("metelbuilding_owner")
    self:SetHealth(self:Health() - damage)
    self:SetColor(MetelENT_GetColor(self))
    if self:Health() <= 0 then
        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())
        util.Effect("effect_devour", effectdata, true, true)
        self:EmitSound("physics/concrete/concrete_break"..math.random(2,3)..".wav")
        self:Remove()
        entowner:SetNWInt("metelbuilding_buildinglimit", entowner:GetNWInt("metelbuilding_buildinglimit") - 1)
    end
end

function MetelENT_GetColor(ent)
	if ent:Health() then
		local health = ent:Health()
		local max_health = ent:GetMaxHealth()

		if health == max_health then
			return color_white
		end

		local health = (max_health - health) / max_health
		local col = Color(255, 255 * -health, 255 * -health, 255)
		return col
	end
	return color_white
end