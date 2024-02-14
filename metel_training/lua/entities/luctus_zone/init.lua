--Luctus Safezones
--Made by OverlordAkise

AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
	local BBOX = (self.max - self.min) / 2

	self:SetSolid( SOLID_BBOX )
	self:PhysicsInitBox( -BBOX, BBOX )
	self:SetCollisionBoundsWS( self.min, self.max )

	self:SetTrigger( true )
	self:DrawShadow( false )
	self:SetNotSolid( true )
	self:SetNoDraw( false )

	self.Phys = self:GetPhysicsObject()
	if self.Phys and self.Phys:IsValid() then
		self.Phys:Sleep()
		self.Phys:EnableCollisions( false )
	end
end

function ENT:StartTouch( ent )  
	if IsValid(ent) and ent:IsPlayer() then
    	if self:GetIsRed() then
			if ent:GetNWBool("MetelTrain_HasFlagBlue") then
				for k,v in pairs(ents.GetAll()) do
					if v:GetClass() == "flag_blue" or v:GetClass() == "flag_red" then
						v:Remove()
					elseif v:GetClass() == "trainboard" then
						v:SetNWBool("MetelTraining_IsCapture", false)
						v:SetNWBool("MetelTraining_RunGame", false)
					end
				end
			
				for k,v in pairs(player.GetAll()) do
					v:SetNWBool("MetelTrain_HasFlagBlue", false)
					v:SetNWBool("MetelTrain_HasFlagRed", false)
					v:SetNWBool("MetelTrain_IsOut", false)

					MetelTraining_NotifyPlayer(Color(255,0,0),"Team Red has won! \nThe flag had "..ent:Name())
				end
				timer.Remove("MetelTraining_StartRound")
				Metel_Training.trainingroundtime = 0
				syncRoundTime()
			end
		else
			if ent:GetNWBool("MetelTrain_HasFlagRed") then
				for k,v in pairs(ents.GetAll()) do
					if v:GetClass() == "flag_blue" or v:GetClass() == "flag_red" then
						v:Remove()
					elseif v:GetClass() == "trainboard" then
						v:SetNWBool("MetelTraining_IsCapture", false)
						v:SetNWBool("MetelTraining_RunGame", false)
					end
				end
			
				for k,v in pairs(player.GetAll()) do
					v:SetNWBool("MetelTrain_HasFlagBlue", false)
					v:SetNWBool("MetelTrain_HasFlagRed", false)
					v:SetNWBool("MetelTrain_IsOut", false)

					if v:GetNWBool("MetelTrain_TeamRed") or v:GetNWBool("MetelTrain_TeamBlue") then
						MetelTraining_NotifyPlayer(Color(0,120,255),"Team Blue has won! \nThe flag had "..ent:Name())
					end
				end
				timer.Remove("MetelTraining_StartRound")
				Metel_Training.trainingroundtime = 0
				syncRoundTime()
			end
		end
	end
end