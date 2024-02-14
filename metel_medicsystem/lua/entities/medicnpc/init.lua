AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

    if SERVER then
        self:SetModel("models/player/kleiner.mdl")
		self:SetUseType( SIMPLE_USE )
		self:DropToFloor()
    end

    self:SetSolid(  SOLID_BBOX )
	local seq = self:LookupSequence("pose_standing_02")
	self:ResetSequence(seq)
	self:SetSequence(seq)
end

function ENT:Use(activator, caller)
    local count = 0
    for k,v in pairs(player.GetAll()) do
        if MetelMedic_Config.Medics[v:getJobTable().name] then
            count = count + 1
        end
    end
    if count >= 1 then
        activator:ChatPrint("[Günther] Sorry, I'm just taking a break!")
    else
        net.Start("metelmedic_showguenther")
        net.Send(activator)
    end
end