
AddCSLuaFile()

SWEP.PrintName = "First aid kit"
SWEP.Author = ""
SWEP.Purpose = "LMB to treat others \nRMB to treat yourself"

SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_medkit.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = true

SWEP.Category = "MetelGames MedicSystem"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

local HealSound = Sound( "HealthKit.Touch" )
local DenySound = Sound( "WallHealth.Deny" )

function SWEP:Initialize()
	self:SetHoldType( "slam" )
	if ( CLIENT ) then return end
end

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
		filter = self.Owner
	} )

	local ent = tr.Entity

	if ( IsValid( ent ) && (ent:IsPlayer() or ent:IsNPC() ) && ent:Health() < ent:GetMaxHealth() ) then

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + 10 ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() 
			self:SendWeaponAnim( ACT_VM_IDLE ) 
		end )
	else
		self.Owner:EmitSound( DenySound )
		self:SetNextPrimaryFire( CurTime() + 1 )
	end
end

function SWEP:SecondaryAttack()
	if ( CLIENT ) then return end
	local ent = self.Owner

	if ( IsValid( ent ) && ent:Health() < ent:GetMaxHealth() ) then

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + 10 ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration() + (self:Clip1() >= 1 and 0 or -1), 1, function() 
            self:SendWeaponAnim( ACT_VM_IDLE ) 
		end )
	else
		ent:EmitSound( DenySound )
		self:SetNextSecondaryFire( CurTime() + 1 )
	end
end

function SWEP:OnRemove()
	timer.Stop( "medkit_ammo" .. self:EntIndex() )
	timer.Stop( "weapon_idle" .. self:EntIndex() )
end

function SWEP:Holster()
	timer.Stop( "weapon_idle" .. self:EntIndex() )
	return true
end