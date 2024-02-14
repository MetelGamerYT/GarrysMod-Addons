if( SERVER ) then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Spawnable		= true
SWEP.AdminSpawnable	= true

SWEP.Category		= "MetelMining"
SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.PrintName 		= "Spitzhacke"
SWEP.Primary.Damage	= 5
SWEP.Primary.Delay 	= 1.0

SWEP.ViewModelFOV = 72
SWEP.ViewModel		= "models/pickaxe/pickaxe_v.mdl"
SWEP.WorldModel		= "models/pickaxe/pickaxe_w.mdl"

function SWEP:Precache()
	util.PrecacheSound("pickaxe/deploy.wav")
	util.PrecacheSound("pickaxe/hitrock.wav")
	util.PrecacheSound("pickaxe/hit.wav")
	util.PrecacheSound("pickaxe/slash.wav")
end

function SWEP:Initialize()
	self:SetWeaponHoldType("melee2")
	self.Hit 		= Sound( "pickaxe/deploy.wav" )
	self.FleshHit 	= Sound( "pickaxe/hit.wav" )
	self.Slash		= Sound( "pickaxe/slash.wav" )
end

function SWEP:Deploy()
	self.Owner:SetViewOffset( Vector( 0, 0, 62 ) )
	self.Owner:EmitSound("pickaxe/deploy.wav")

	return true
end

function SWEP:OnDrop()
	if IsValid(self.Shield) then self.Shield:Remove() end
end

function SWEP:OnRemove()
	if IsValid(self.Shield) then self.Shield:Remove() end
end

function SWEP:DoHitEffects()
	local trace = self.Owner:GetEyeTraceNoCursor();
	
	if (((trace.Hit or trace.HitWorld) and self.Owner:GetShootPos():Distance(trace.HitPos) <= 64) and IsValid(trace.Entity) and string.StartWith( trace.Entity:GetClass(), "brickscrafting_mining" )) then
		self:SendWeaponAnim(ACT_VM_HITCENTER);
		self:EmitSound("physics/concrete/rock_impact_hard5.wav");

		local bullet = {}
		bullet.Num    = 1
		bullet.Src    = self.Owner:GetShootPos()
		bullet.Dir    = self.Owner:GetAimVector()
		bullet.Spread = Vector(0, 0, 0)
		bullet.Tracer = 0
		bullet.Force  = 3
		bullet.Damage = 0
		self.Owner:DoAttackEvent()
		self.Owner:FireBullets(bullet) 
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER);
		self:EmitSound("npc/vort/claw_swing2.wav");
	end;
end;


function SWEP:DoAnimations(idle)
	if (!idle) then
		self.Owner:SetAnimation(PLAYER_ATTACK1);
	end;
end;

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	self:DoAnimations();
	self:DoHitEffects();
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK_1 )
	
    local trace = self.Owner:GetEyeTraceNoCursor();
    if (self.Owner:GetShootPos():Distance(trace.HitPos) <= 80) then
        if (IsValid(trace.Entity)) then
            local bullet = {}
            bullet.Num    = 1
            bullet.Src    = self.Owner:GetShootPos()
            bullet.Dir    = self.Owner:GetAimVector()
            bullet.Spread = Vector(0, 0, 0)
            bullet.Tracer = 0
            bullet.Force  = 3
            bullet.Damage = 0
            self.Owner:DoAttackEvent()
            self.Owner:FireBullets(bullet) 
        end
    end

	if (SERVER) then
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(true);
		end;
		
		if (self.Owner.LagCompensation) then
			self.Owner:LagCompensation(false);
		end;
	end;
end

function SWEP:SecondaryAttack()
end

function SWEP:Holster()
	if self:GetNextPrimaryFire() > CurTime() then return end
	if IsValid(self.Shield) then self.Shield:Remove() end
	
	return true
end

function SWEP:Remove()
end