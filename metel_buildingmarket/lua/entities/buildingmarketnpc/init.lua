AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/player/eli.mdl")
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()
    end

    self:SetSolid(  SOLID_BBOX )
	local seq = self:LookupSequence("pose_standing_02")
	self:ResetSequence(seq)
	self:SetSequence(seq)
end

function ENT:Use(activator)
    net.Start("metelbaumarkt_openmenu")
    net.Send(activator)
end