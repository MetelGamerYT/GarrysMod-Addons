AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/medicmod/bloodbag/bloodbag.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:SetBodygroup( 0,1 )
	self:SetNWBool("IsBloodPck", true)
	timer.Simple(300, function()
		self:Remove()
	end)
end

function ENT:Use(activator, caller, usetype)
	if not activator:IsPlayer() then return end
	if self.usingply then return end
	self.startusetime = CurTime()
	self.usingply = activator
	self:EmitSound("physics/wood/wood_strain4.wav")
	net.Start("metelmedic_isusingbloodpck")
	net.WriteBool(true)
	net.Send(activator)
end

function ENT:Think()
	if self.startusetime then 
		if IsValid(self.usingply) and self:GetPos():Distance(self.usingply:GetPos()) < 300 and self.usingply:KeyDown(IN_USE) and self.usingply:GetEyeTrace().Entity == self then
			if CurTime() - self.startusetime >= 5 then
				self.usingply:SetNWInt("MetelMedic_Blood", 100)
				net.Start("metelmedic_isusingbloodpck")
				net.WriteBool(false)
				net.Send(self.usingply)
				self.startusetime = nil
				self.usingply = nil
				self:Remove()
			end
		else
			net.Start("metelmedic_isusingbloodpck")
			net.WriteBool(false)
			net.Send(self.usingply)
			self.startusetime = nil
			self.usingply = nil
		end
	end
	self:NextThink(CurTime() + 0.3)
end