include("shared.lua")
local imgui = include("imgui.lua")

surface.CreateFont( "Metel_FoundationMNG", {
	font = "Roboto",
	size = 50,
	weight = 700,
} )

surface.CreateFont( "Metel_FoundationMNG2", {
	font = "Roboto",
	size = 30,
	weight = 700,
} )

function ENT:Draw()
	self:DrawModel()

    if imgui.Entity3D2D(self, Vector(-1, -12, 5), Angle(0, 90, 90), 0.1) then
        draw.SimpleText("Foundation administration", "Metel_FoundationMNG2", -10, -120, Color(255,255,255))
        if imgui.xTextButton("Login", "Metel_FoundationMNG", 20, -20, 200, 80) then
            openfoundationmainmenu(self:EntIndex())
            net.Start("MetelManage_ChangePCStatus")
            net.WriteString("active") 
            net.WriteString("#"..self:EntIndex())
            net.SendToServer()
        end
        imgui.End3D2D()
    end
end