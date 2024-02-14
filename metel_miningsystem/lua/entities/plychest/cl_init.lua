include("shared.lua")

surface.CreateFont( "Metel_Mining_System", {
	font = "Roboto",
	size = 35,
	weight = 700,
} )

local black = Color(44,44,44)

function ENT:Draw()
	if IsValid(self:GetNWEntity("MetelMining_CrateOwner")) then
		local ply = self:GetNWEntity("MetelMining_CrateOwner"):Name()
		self:DrawModel()

		if (self:GetPos():DistToSqr(LocalPlayer():GetPos()) > 300*300) then return end
		local a = Angle(0,0,0)
		a:RotateAroundAxis(Vector(1,0,0),90)
		a.y = LocalPlayer():GetAngles().y - 90
		cam.Start3D2D(self:GetPos() + Vector(0,0, 25), a , 0.074)	
			draw.SimpleText("Mine chest","Trebuchet24",0,-75,Color(255,255,255,255) , 1 , 1)
			draw.SimpleText("Owner: "..ply,"Trebuchet24",0,-50,Color(255,255,255,255) , 1 , 1)
			draw.SimpleText("Ores: "..self:GetNWInt("MetelMining_OreValue").." / 10","Trebuchet24",0,-25,Color(255,255,255,255) , 1 , 1)
		cam.End3D2D()
	end
end