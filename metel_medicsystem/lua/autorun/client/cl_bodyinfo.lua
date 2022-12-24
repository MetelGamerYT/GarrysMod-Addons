net.Receive("metelmedic_openplayerinfo", function()
    metelmedicopenplayerinfo()
end)

surface.CreateFont("MetelMedicInfo", { font = "Roboto", size = 25, weight = 500 })
surface.CreateFont("MetelMedicInfo2", { font = "Roboto", size = 22, weight = 500 })

local lgrey = Color(70,70,70,255)
local grey = Color(50,50,50,255)
local white = Color(255,255,255,255)
local red = Color(157,26,26)
local green = Color(50,250,50,255)
local black = Color(35,35,35, 255)

local scrh = ScrH()
local function screencalc(size)
  return size / 1080 * scrh
end

function metelmedicopenplayerinfo()
    local ply = LocalPlayer()
    medicinfomenu = vgui.Create("DFrame")
    medicinfomenu:SetSize(screencalc(400),screencalc(500))
    medicinfomenu:MakePopup()
    medicinfomenu:SetTitle("My Body")
    medicinfomenu:Center()

    function medicinfomenu:Paint(w,h)
        draw.RoundedBox(0,0,0,w,h, grey)

        --Info Viereck
        surface.SetDrawColor(lgrey)
        surface.DrawRect(screencalc(20),screencalc(47), screencalc(180), screencalc(400))

        surface.SetDrawColor(black)
        surface.DrawOutlinedRect(screencalc(20),screencalc(47), screencalc(180), screencalc(400), screencalc(2))

        draw.SimpleText( "Bloodamount: " .. tostring(ply:GetNWInt("MetelMedic_Blood", nil)) .. "%" , "MetelMedicInfo", w / 2, h - screencalc(45), color_white, 1 )

        draw.SimpleText("Body Informations", "MetelMedicInfo2", 25, 50, white)
        draw.SimpleText("―――――――――――", "MetelMedicInfo2", 22, 58, white)
        draw.SimpleText("Legfracture: ", "MetelMedicInfo2", screencalc(75), screencalc(80), color_white, 1  )
        draw.SimpleText("Bleeding: ", "MetelMedicInfo2", screencalc(65), screencalc(110), color_white, 1 )

        // Bein Bruch Ja/Nein
        if(ply:GetNWBool("MetelMedic_Brokenleg") == true) then
            draw.SimpleText("Yes", "MetelMedicInfo2", screencalc(130), screencalc(80), red, 1)
        else
            draw.SimpleText("No", "MetelMedicInfo2", screencalc(140), screencalc(80), green, 1)
        end

        // Blutung ja/nein
        if ply:GetNWString("MetelMedic_Bleeding", nil) == "none" then
            draw.SimpleText("No", "MetelMedicInfo2", screencalc(115), screencalc(110), green, 1)
        else
            draw.SimpleText("Yes", "MetelMedicInfo2", screencalc(150), screencalc(110), red, 1)
        end

        surface.SetDrawColor(lgrey)
        surface.DrawRect(screencalc(230),screencalc(47), screencalc(150), screencalc(400), screencalc(40))

        local currentblood = ply:GetNWInt("MetelMedic_Blood") 
        local ABlood = math.Clamp(currentblood,0,100)
        local CBlood = ABlood / 100 * screencalc(399)

        surface.SetDrawColor(red)
        surface.DrawRect(screencalc(230),screencalc(297) + (screencalc(150) - CBlood), screencalc(150), CBlood, screencalc(40))

        --Blut Viereck
        surface.SetDrawColor(black)
        surface.DrawOutlinedRect(screencalc(230),screencalc(47), screencalc(150), screencalc(400), screencalc(2))

    end
end 