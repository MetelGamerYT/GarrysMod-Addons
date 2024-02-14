net.Receive("metelbaumarkt_openmenu", function()
    openbaumarktmenu()
end)

local grey2 = Color(25,25,25,255)
local white = Color(255,255,255,100)
local green = Color(10,255,50)
local redg = Color(255, 50, 50)

function openbaumarktmenu()
    local ply = LocalPlayer()
    baumarktmenu = vgui.Create("DFrame")
    baumarktmenu:SetSize(600,550)
    baumarktmenu:MakePopup()
    baumarktmenu:SetTitle("Ronny's Building Market")
    baumarktmenu:Center()

    function baumarktmenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, Color(100,37,0))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local DScrollPanel = vgui.Create("DScrollPanel", baumarktmenu)
    DScrollPanel:Dock(LEFT)
    DScrollPanel:SetSize(150)

    local namelabel = baumarktmenu:Add("DLabel")
    namelabel:SetPos(210, 250)
    namelabel:SetSize(350,35)
    namelabel:SetText("")

    local pricelabel = baumarktmenu:Add("DLabel")
    pricelabel:SetPos(210, 280)
    pricelabel:SetSize(350,35)
    pricelabel:SetText("")

    local previewmodel = vgui.Create("DModelPanel", baumarktmenu) 
    for k,v in pairs(MetelBuilding_Config.BuyableObjects) do
        local DButton = DScrollPanel:Add("DButton")
        DButton:SetColor(white)
        DButton:SetText(k)
        DButton:Dock( TOP )
        DButton:SetSize(50,20)
        DButton:DockMargin( 5, 2, 2, 2 )
        DButton.Paint = function(self,w,h)
            draw.RoundedBox(0,0,0,w,h,grey2)
            surface.SetDrawColor(white)
            surface.DrawOutlinedRect(0,0,w,h,1)
        end

        previewmodel:SetSize(300,400)
        previewmodel:SetPos(200,-150)
        previewmodel:SetModel("")
        -- function previewmodel:LayoutEntity( Entity ) return end
        previewmodel:SetFOV(v[3])

        DButton.DoClick = function()
            
            local wep = ents.FindByModel(v[1])
            if wep ~= nil then
                previewmodel:SetModel(v[1])
                namelabel:SetText("Article: "..k)
                pricelabel:SetText("Price: "..v[2].."$")

                //Nehmen button
                local givebutton = baumarktmenu:Add("DButton")
                givebutton:SetColor(green)
                givebutton:SetText("Buy")
                givebutton:SetSize(350,35)
                givebutton:SetPos(210,320)
                givebutton.Paint = function(self,w,h)
                    draw.RoundedBox(0,0,0,w,h,grey2)
                    surface.SetDrawColor(green)
                    surface.DrawOutlinedRect(0,0,w,h,1)
                end

                givebutton.DoClick = function()
                    if ply:getDarkRPVar("money") < v[2] then
                        ply:ChatPrint("You don't have enough money")
                    else
                        net.Start("metelbaumarkt_spawnobject")
                        net.WriteEntity(ply) -- Player
                        net.WriteString(v[1]) -- Model
                        net.WriteString(v[4]) -- HP
                        net.WriteString(v[2]) -- Price
                        net.SendToServer()
                    end
                end
            end
        end
    end
end