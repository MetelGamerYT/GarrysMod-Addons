SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "MetelGames MedicSystem"
SWEP.Author = "DerMetelGamerYT & Gonzo"
SWEP.ViewModelFOV = 62

SWEP.Primary.ClipSize = -1
SWEP.Primary.Ammo = "none"
SWEP.Primary.DefaultClip = -1

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1

SWEP.PrintName = "Defibrilator"
SWEP.ViewModel = "models/weapons/c_defib_gonzo.mdl"
SWEP.WorldModel = "models/weapons/c_defib_gonzo.mdl"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "Charge")

end

function SWEP:CreateEffect(pos, ent)
	local vPoint = pos
	local effectdata = EffectData()
	effectdata:SetOrigin( vPoint )
	effectdata:SetMagnitude(20)
	effectdata:SetScale(20)
	effectdata:SetEntity(ent)
	util.Effect( "TeslaHitboxes", effectdata )
end

function SWEP:PrimaryAttack()
	if !IsFirstTimePredicted() then return end
	if self:GetCharge() <= 0 then return end
    local trace = self.Owner:GetEyeTrace().Entity
	if IsValid(trace) and trace:IsRagdoll() and not self.isreviving then
		if not timer.Exists(trace:GetOwner():SteamID().."_deathtimer") then return end
		self.isreviving = true
        if self.Owner:GetPos():DistToSqr(trace:GetPos()) <= 6000 then
            self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
            timer.Simple(0.3, function()
                self:SetCharge(0)
                self:EmitSound( "ambient/energy/spark"..math.random(1,5)..".wav" )
                self:CreateEffect(self.Owner:GetShootPos(), trace.Entity)
				if not trace:GetNWString("metel_ragdollowner") then return end
				local target = trace:GetOwner()
				if SERVER then
					local traceragdoll = trace:GetPos()
					target:Spawn()						
					target:SetPos(self:FindPosition(self.Owner))		
					target:SetHealth(target:GetMaxHealth() / 2)
					for k,v in pairs(target.medicdeathweapons) do
						target:Give(v)
					end
					if timer.Exists(target:SteamID().."_nlrtimer") then timer.Remove(target:SteamID().."_nlrtimer") end
				end
				self.isreviving = false
            end)
		end
	end
	self:SetNextSecondaryFire(CurTime() + 1)
end

local Positions = {}
for i=0,360,22.5 do table.insert( Positions, Vector(math.cos(i),math.sin(i),0) ) end -- Populate Around Player
table.insert(Positions, Vector(0, 0, 1)) -- Populate Above Player

function SWEP:FindPosition(ply)
  local size = Vector(32, 32, 72)
  
  local StartPos = ply:GetPos() + Vector(0, 0, size.z/2)
  
  local len = #Positions
  
  for i = 1, len do
    local v = Positions[i]
    local Pos = StartPos + v * size * 1.5
    
    local tr = {}
    tr.start = Pos
    tr.endpos = Pos
    tr.mins = size / 2 * -1
    tr.maxs = size / 2
    local trace = util.TraceHull(tr)
    
    if(not trace.Hit) then
      return Pos - Vector(0, 0, size.z/2)
    end
  end

  return false
end

function SWEP:Reload()
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
end

function SWEP:SecondaryAttack()
	if  self:GetCharge() > 0 then return end
	self:SetNextSecondaryFire(CurTime() + 4)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	if SERVER or !IsFirstTimePredicted() then
		self.Owner:EmitSound("buttons/button1.wav")
		timer.Simple(1.3, function()
			if (IsValid(self) and self.Owner:GetActiveWeapon() == self) then
				self:SetCharge(100)
			end
		end)
	end
end

function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )

	local bone, pos, ang
	if (tab.rel and tab.rel != "") then

		local v = basetab[tab.rel]

		if (!v) then return end

		// Technically, if there exists an element with the same name as a bone
		// you can get in an infinite loop. Let's just hope nobody's that stupid.
		pos, ang = self:GetBoneOrientation( basetab, v, ent )

		if (!pos) then return end

		pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
		ang:RotateAroundAxis(ang:Up(), v.angle.y)
		ang:RotateAroundAxis(ang:Right(), v.angle.p)
		ang:RotateAroundAxis(ang:Forward(), v.angle.r)
		//76561198268686825
	else
		bone = ent:LookupBone(bone_override or tab.bone)
		if (!bone) then return end
		
		pos, ang = Vector(0,0,0), Angle(0,0,0)
		local m = ent:GetBoneMatrix(bone)
		if (m) then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end

		if (IsValid(self.Owner) and self.Owner:IsPlayer() and
			ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
			ang.r = -ang.r // Fixes mirrored models
		end

	end

	return pos, ang
end

function SWEP:Think()
	if (self:GetCharge() > 0) then
		self:SetCharge(self:GetCharge() - 1)
	end
end

function SWEP:ViewModelDrawn(vm)
	
    local pos,ang = self:GetBoneOrientation( {}, {}, vm, "screen_l" )
    pos = pos + ang:Up() * 0.1
    ang:RotateAroundAxis(ang:Forward(),60)

    cam.Start3D2D(pos, ang, 0.02)
        surface.SetDrawColor(Color(200,0,0,255))
        surface.DrawRect(0, 72 * (1 - self:GetCharge() / 100), 68, 72 * (self:GetCharge() / 100))
    cam.End3D2D()

    local pos,ang = self:GetBoneOrientation( {}, {}, vm, "screen_r" )
    pos = pos + ang:Up() * 0.1
    ang:RotateAroundAxis(ang:Forward(),60)

    cam.Start3D2D(pos, ang, 0.02)
        surface.SetDrawColor(Color(200,0,0,255))
        surface.DrawRect(0, 72 * (1 - self:GetCharge() / 100), 68, 72 * (self:GetCharge() / 100))
    cam.End3D2D()

	vm:SetBodygroup(0, 1)
end

function SWEP:DrawWorldModel()
	self:DrawModel()
    self:SetModelScale(0.8, 0)
end

function SWEP:Initialize()
	self:SetHoldType("knife")
end

function SWEP:Deploy()
	self:SetCharge(0)
	self.Owner.Discharge = false
	return true
end