include("shared.lua")
local black = Color(44,44,44)

surface.CreateFont( "Metel_Mining", {
	font = "Roboto",
	size = 60,
	weight = 700,
} )

function ENT:Draw()
	self:DrawModel()

	if (self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 300*300) then return end
	local a = Angle(0,0,0)
	a:RotateAroundAxis(Vector(1,0,0),90)
	a.y = LocalPlayer():GetAngles().y - 90
	cam.Start3D2D(self:GetPos() + Vector(0,0, 25), a , 0.074)	
		draw.SimpleText("Equipment rental","Metel_Mining",0,-205,Color(255,255,255,255) , 1 , 1)
		draw.SimpleText("[E] to receive/deliver equipment","Metel_Mining",0,-150,Color(255,255,255,255) , 1 , 1)
		draw.SimpleText("Sell ores here","Metel_Mining",0,-85,Color(255,255,255,255) , 1 , 1)
	cam.End3D2D()
end