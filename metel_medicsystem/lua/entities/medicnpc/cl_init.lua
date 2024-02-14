include("shared.lua")

surface.CreateFont( "MetelMedic_Guenter", {
	font = "Roboto",
	size = 50,
	weight = 700,
} )

local grey = Color(60,60,60)
local scrh = ScrH()
local function screencalc(size)
  return size / 1080 * scrh
end

function ENT:Draw()
	self:DrawModel()
    local ahshopAngles = self:GetAngles()
	local ahshopEyes = LocalPlayer():EyeAngles()

    cam.Start3D2D(self:GetPos()+self:GetUp()*79, Angle(0, ahshopEyes.y-90, 90), 0.08)
        draw.WordBox(8,-180,10,"Senior doctor Günther","MetelMedic_Guenter",grey,Color(255,255,255))
    cam.End3D2D()
end

net.Receive("metelmedic_showguenther", function(len, ply)
    openguenthermenu()
end)

function openguenthermenu()
    local ply = LocalPlayer()
    guenthermenu = vgui.Create("DFrame")
    guenthermenu:SetSize(screencalc(300),screencalc(210))
    guenthermenu:MakePopup()
    guenthermenu:SetTitle("Günther's Premium Treatment")
    guenthermenu:Center()

    function guenthermenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, Color(50,250,50,255))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local bloodtreat = vgui.Create("DButton", guenthermenu)
    bloodtreat:SetSize(280, 40, TEXT_ALIGN_CENTER)
    bloodtreat:SetPos(10,40)
    bloodtreat:SetTextColor(color_white)
    bloodtreat:SetText("Blood treatment (5$)")
    function bloodtreat:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35, 255))
        surface.SetDrawColor(Color(255,255,255,100))
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    bloodtreat.DoClick = function(s)
        if LocalPlayer():getDarkRPVar("money") >= 5 then 
            net.Start("metelmedic_bloodtreat")
            net.SendToServer()
        else
            LocalPlayer():ChatPrint("[Günther] You don't have enough money for the treatment!") 
        end
        guenthermenu:Close()
    end

    local fractreat = vgui.Create("DButton", guenthermenu)
    fractreat:SetSize(280, 40, TEXT_ALIGN_CENTER)
    fractreat:SetPos(10,100)
    fractreat:SetTextColor(color_white)
    fractreat:SetText("Fracture treatment (10$)")
    function fractreat:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35, 255))
        surface.SetDrawColor(Color(255,255,255,100))
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    fractreat.DoClick = function(s)
        if LocalPlayer():getDarkRPVar("money") >= 10 then 
           net.Start("metelmedic_fractreat")
           net.SendToServer()
        else
           LocalPlayer():ChatPrint("[Günther] You don't have enough money for the treatment!") 
        end
        guenthermenu:Close()
    end

    local heilthera = vgui.Create("DButton", guenthermenu)
    heilthera:SetSize(280, 40, TEXT_ALIGN_CENTER)
    heilthera:SetPos(10,160)
    heilthera:SetTextColor(color_white)
    heilthera:SetText("Healing therapy (75$)")
    function heilthera:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(35,35,35, 255))
        surface.SetDrawColor(Color(255,255,255,100))
        surface.DrawOutlinedRect(0,0,w,h,1)
    end
    heilthera.DoClick = function(s)
        if LocalPlayer():getDarkRPVar("money") >= 75 then 
           net.Start("metelmedic_heilth")
           net.SendToServer()
        else
           LocalPlayer():ChatPrint("[Günther] You don't have enough money for the treatment!") 
        end
        guenthermenu:Close()
    end
end