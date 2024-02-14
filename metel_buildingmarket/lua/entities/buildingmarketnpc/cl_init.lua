include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if (self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 300*300) then return end
	local a = Angle(0,0,0)
	a:RotateAroundAxis(Vector(1,0,0),90)
	a.y = LocalPlayer():GetAngles().y - 90
	cam.Start3D2D(self:GetPos() + Vector(0,0, 25), a , 0.074)	
		draw.SimpleText("Ronny's Building Market","Trebuchet24",0,-650,Color(255,255,255,255) , 1 , 1)
	cam.End3D2D()
end