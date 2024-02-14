include("shared.lua")

surface.CreateFont( "MetelKR", {
	font = "Roboto",
	extended = false,
	size = 60,
	weight = 100,
} )

function ENT:Draw()
	self:DrawModel()
	if (self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 300*300) then return end
	local a = Angle(0,0,0)
	a:RotateAroundAxis(Vector(1,0,0),90)
	a.y = LocalPlayer():GetAngles().y - 90
	cam.Start3D2D(self:GetPos() + Vector(0,0, 25), a , 0.074)	
		draw.SimpleText("Kr charging station","MetelKR",0,-1025,Color(255,255,255,255) , 1 , 1)
		draw.SimpleText("[E] to charge","MetelKR",0,-975,Color(255,255,255,255) , 1 , 1)
        if self:GetNWInt("krloadingstationbattery") == 100 then
		    draw.SimpleText("Battery full","MetelKR",0,-920,Color(255,255,255,255) , 1 , 1)
        else
		    draw.SimpleText("Battery is charging: "..self:GetNWInt("krloadingstationbattery").."%","MetelKR",0,-920,Color(255,255,255,255) , 1 , 1)
        end
	cam.End3D2D()
end