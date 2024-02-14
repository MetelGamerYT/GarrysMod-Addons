AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/items/ammocrate_smg1.mdl")
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
	if not IsValid(activator:GetActiveWeapon()) then return end
	if MetelENT_Forbiddenstack[activator:GetActiveWeapon():GetClass()] then return end
    if activator:GetAmmoCount(activator:GetActiveWeapon():GetPrimaryAmmoType()) < 250 then
        activator:GiveAmmo(50, activator:GetActiveWeapon():GetPrimaryAmmoType())
        activator:GiveAmmo(50, activator:GetActiveWeapon():GetSecondaryAmmoType())
    end
end

-- Class names for which no ammunition may be replenished
MetelENT_Forbiddenstack = {
	["weapon_sh_electricgrenade"] = true,
	["weapon_mustardgas"] = true,
	["cw_flash_grenade"] = true,
	["cw_frag_grenade"] = true,
	["cw_smoke_grenade"] = true,
}