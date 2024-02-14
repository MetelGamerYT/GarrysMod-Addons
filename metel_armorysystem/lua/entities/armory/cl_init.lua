include("shared.lua")
local imgui = include("imgui.lua")

surface.CreateFont( "Metel_Armory", {
	font = "Roboto",
	size = 80,
	weight = 700,
} )

local grey = Color(60,60,60)
local black = Color(44,44,44)

function ENT:Draw()
	local ply = LocalPlayer()
	self:DrawModel()

	if imgui.Entity3D2D(self, Vector(8.4, -25, 18), Angle(0, 90, 90), 0.1) then
        draw.SimpleText("Armory", "Metel_Armory", 30,-100, Color_White)
        if imgui.xTextButton("Öffnen", "Metel_Armory", 130, 60, 240, 80) then
            openarmory()
        end
	imgui.End3D2D()
	end
end