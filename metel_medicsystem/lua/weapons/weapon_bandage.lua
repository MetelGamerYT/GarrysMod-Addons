AddCSLuaFile()

SWEP.Instructions = "LMB um andere zu Bandagieren / RMB zum selbst Bandagieren"
SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Category = "MetelGaming MedicSystem"
SWEP.Author = "DerMetelGamerYT & Gonzo"
SWEP.ViewModelFOV = 50

if CLIENT then
	language.Add("ammo_bandage_ammo", "Bandagen")
end

SWEP.Primary.Ammo = "ammo_bandage"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 1

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Ammo = -1

SWEP.PrintName = "Bandage"
SWEP.ViewModel = "models/weapons/c_bandage.mdl"
SWEP.WorldModel = "models/weapons/c_bandage.mdl"

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "Charge")
end

sound.Add( {
	name = "flesh_scrapple",
	channel = CHAN_STATIC,
	sound = "physics/flesh/flesh_scrape_rough_loop.wav"
} )

function SWEP:PrimaryAttack()
	
	if !IsFirstTimePredicted() or self.Busy then return end
    if self.Owner:GetNWString("MetelMedic_Bleeding") == "none" then return end
	
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Busy = true

	timer.Simple(self:SequenceDuration() * 0.9, function()
		if self.Owner:GetMaxHealth() >= self.Owner:Health() + 15 then
			self.Owner:SetHealth(self.Owner:GetMaxHealth())
		else
			self.Owner:SetHealth(self.Owner:Health() + 15)
		end
        self.Owner:SetNWString("MetelMedic_Bleeding", "none")

        if SERVER then
            timer.Destroy("MetelMedic_BleedingTimer_"..self.Owner:SteamID64())
			net.Start("metelmedic_disablebleedingeffect")
			net.Send(self.Owner)
        end

		self:TakePrimaryAmmo(1)
	end)

	timer.Simple(self:SequenceDuration() + 0.5, function()
		self.Busy = false
		if (self.Owner:GetAmmoCount("ammo_bandage") <= 0) then
			if SERVER then
				self:Remove()
			else
				RunConsoleCommand("lastinv")
			end
		else
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	end)

	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:SecondaryAttack()
	local tr = util.QuickTrace(self.Owner:GetShootPos(), self.Owner:GetAimVector() * 96, self.Owner)
	if !IsFirstTimePredicted() or !tr.Entity:IsPlayer() or self.Busy then return end
	local target = tr.Entity

	if target:GetNWString("MetelMedic_Bleeding") == "none" then return end
	
	self:EmitSound("physics/wood/wood_strain2.wav")
	timer.Simple(0.6, function()
		self:EmitSound("flesh_scrapple")
		timer.Simple(0.8, function()
			self:StopSound("flesh_scrapple")
		end)
	end)
	self.Busy = true
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)

    timer.Create(self.Owner:SteamID64().."_bandagetime", self:SequenceDuration() * 0.9, 1, function()
		if target:GetMaxHealth() >= target:Health() + 15 then
       		target:SetHealth(target:GetMaxHealth())
		else
			target:SetHealth(target:Health() + 15)
		end
        target:SetNWString("MetelMedic_Bleeding", "none")

        if SERVER then
            timer.Destroy("MetelMedic_BleedingTimer_"..target:SteamID64())
			net.Start("metelmedic_disablebleedingeffect")
			net.Send(target)
        end

		self:TakePrimaryAmmo(1)
    end)

	local owner = self.Owner
	timer.Simple(self:SequenceDuration() + 0.5, function()
		self.Busy = false
		if (!IsValid(owner)) then return end
		if (owner:GetAmmoCount("ammo_bandage") <= 0) then
			if SERVER then
				self:Remove()
			else
				RunConsoleCommand("lastinv")
			end
		else
			self:SendWeaponAnim(ACT_VM_DRAW)
		end
	end)


	self:SetNextSecondaryFire(CurTime() + 1)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
end

if SERVER then return end

function SWEP:DrawHUD()
	local target = self.Owner:GetEyeTrace().Entity
	if (!target:IsPlayer()) then return end
	
    if not target:GetNWString("MetelMedic_Bleeding") == "none" then
		draw.SimpleText(target:Name().." is Bleeding", "Trebuchet18", ScrW() / 2 + 272, ScrH() / 2 - 28, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function SWEP:GetViewModelPosition( pos, ang )
	return pos + Vector(0,0,-8), ang + Angle(-16,0,0)
end
