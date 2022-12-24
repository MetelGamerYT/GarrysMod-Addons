AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/medicmod/stretcher/stretcher.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:Wake()
	end
	self:SetUseType(3)

end

function ENT:Use(activator)
	if not self.plyragdoll then return end
	local plyowner = self.plyragdoll:GetOwner()
	plyowner:SetNWBool("metelmedic_isonstretcher", false)
	plyowner:SetNWEntity("metelmedic_isonstretcher_entity", nil)
	local playercorpse = ents.Create("prop_ragdoll")
	playercorpse:SetPos(self:GetPos() + Vector(0, 15, 0))
	//playercorpse:SetPos(self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*35, 10)
	playercorpse:SetAngles(Angle(-90,self:GetAngles().Yaw,-90))
	playercorpse:SetModel(plyowner:GetModel())
	playercorpse:Spawn()
	playercorpse:SetOwner(self.plyragdoll)
	playercorpse:SetNWString("metel_ragdollowner", plyowner)
	self.plyragdoll:GetOwner():SpectateEntity(playercorpse)
	self:SetNWString("metel_ragdoll", nil)
	self.plyragdoll:Remove()
	plyowner.lragdoll = playercorpse
	
	self.pylragdoll = nil
end

local boneAngles = {
	[1] = {
		bone = "ValveBiped.Bip01_R_Foot",
		ang = Angle(0,0,0)
	},
	[2] = {
		bone = "ValveBiped.Bip01_L_Foot",
		ang = Angle(-0,0,0)
	},
	[3] = {
		bone = "ValveBiped.Bip01_R_ForeArm",
		ang = Angle(-20,0,0)
	},
	[4] = {
		bone = "ValveBiped.Bip01_L_ForeArm",
		ang = Angle(20,0,0)
	},
	[5] = {
		bone = "ValveBiped.Bip01_L_UpperArm",
		ang = Angle(20,-0,0)
	},
	[6] = {
		bone = "ValveBiped.Bip01_R_UpperArm",
		ang = Angle(-20,-0,0)
	},
	[7] = {
		bone = "ValveBiped.Bip01_Head1",
		ang = Angle(20,0,45)
	},
}

function ENT:Touch(ent)
    if IsValid(ent) and ent:IsRagdoll() and not IsValid(self.plyragdoll) then
        deathragdoll = ents.Create("prop_physics")
        deathragdoll:SetPos(self:GetPos()+self:GetAngles():Up() * 12+self:GetAngles():Right()*35, 10)
        deathragdoll:SetAngles(Angle(-90,self:GetAngles().Yaw,-90))
        deathragdoll:SetModel(ent:GetModel())
        deathragdoll:Spawn()
        deathragdoll:SetParent(self)
		deathragdoll:SetOwner(ent:GetNWString("metel_ragdollowner"))

        for _, inf in pairs( boneAngles ) do
            local bone = deathragdoll:LookupBone(inf.bone)
            if bone then
                deathragdoll:ManipulateBoneAngles(bone, inf.ang)
            end
        end

		deathragdoll:GetOwner():SetNWBool("metelmedic_isonstretcher", true)
		deathragdoll:GetOwner():SetNWEntity("metelmedic_isonstretcher_entity", deathragdoll)

        ent:Remove()
        self.plyragdoll = deathragdoll
    end
end

