net.Receive("metelmedic_openselfbody", function()
    metelmedicopenplayerinfo()
end)

local grey = Color(50,50,50,255)
local white = Color(255,255,255,255)
local red = Color(150, 20, 20, 255)
local green = Color(50,250,50,255)

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
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, green)
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))

        -- Head
        surface.SetDrawColor(green)
        surface.DrawRect(150, 50, 100, 100)

        -- Chest 
        surface.SetDrawColor(green)
        surface.DrawRect(139, 160, 120, 140)

        -- Stomach
        surface.SetDrawColor(green)
        surface.DrawRect(139, 305, 120, 50)

        -- Left Leg
        surface.SetDrawColor(green)
        surface.DrawRect(139, 360, 30, 100)

        -- Right Leg
        surface.SetDrawColor(green)
        surface.DrawRect(229, 360, 30, 100)

        -- Right Arm
        surface.SetDrawColor(green)
        surface.DrawRect(263, 160, 30, 170)

        -- Left Arm
        surface.SetDrawColor(green)
        surface.DrawRect(105, 160, 30, 170)

        local currentblood = ply:GetNWInt("MetelMedic_Blood") 
        local ABlood = math.Clamp(currentblood,0,100)
        local CBlood = ABlood / 100 * 399

        surface.SetDrawColor(red)
        surface.DrawRect(10, 465, 628 + (150 - CBlood), 26)

        surface.SetDrawColor(white)
        surface.DrawOutlinedRect(10, 465, 380, 26, 1)
        draw.SimpleText("Blood", "CloseCaption_Bold", 10, 440, white)
        draw.SimpleText(tostring(ply:GetNWInt("MetelMedic_Blood", 6000)).." / 100%", "Trebuchet24", 200, 465, white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
    end
end