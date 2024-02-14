include("shared.lua")

function ENT:Draw()
	local ply = LocalPlayer()
	self:DrawModel()
end