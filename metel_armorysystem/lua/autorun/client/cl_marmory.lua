surface.CreateFont("Metel_ArmoryFont", { font = "Roboto", size = 19, weight = 500 })

local grey = Color(50,50,50,255)
local white = Color(255,255,255,100)
local grey2 = Color(25,25,25,255)
local red = Color(150, 20, 20, 255)
local black = Color(35,35,35, 255)

local green = Color(10,255,50)
local redg = Color(255, 50, 50)

local scrh = ScrH()
local function screencalc(size)
  return size / 1080 * scrh
end

function openarmory()
    local ply = LocalPlayer()
    armorymenu = vgui.Create("DFrame")
    armorymenu:SetSize(screencalc(600),screencalc(500))
    armorymenu:MakePopup()
    armorymenu:SetTitle("Armory - By DerMetelGamerYT")
    armorymenu:Center()

    function armorymenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, team.GetColor(LocalPlayer():Team()))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local DScrollPanel = vgui.Create("DScrollPanel", armorymenu)
    DScrollPanel:Dock(LEFT)
    DScrollPanel:SetSize(screencalc(150))

    local weaponmodel = vgui.Create("DModelPanel", armorymenu)
    
    for k,v in pairs(armory_weapons) do
        if table.HasValue(v[2], ply:getJobTable().name) then
            local arm_weapon = k
            local DButton = DScrollPanel:Add("DButton")
            DButton:SetColor(white)
            DButton:SetText(v[1])
            DButton:Dock( TOP )
            DButton:SetSize(screencalc(50),screencalc(50))
            DButton:DockMargin( 5, 2, 2, 2 )
            DButton.Paint = function(self,w,h)
                draw.RoundedBox(0,0,0,w,h,grey2)
                surface.SetDrawColor(white)
                surface.DrawOutlinedRect(0,0,w,h,1)
            end

            weaponmodel:SetSize(300,400)
            weaponmodel:SetPos(200,-150)
            weaponmodel:SetModel("")
              
            DButton.DoClick = function()
                
                local wep = weapons.Get(k)
                if wep ~= nil then
                    weaponmodel:SetModel(wep.WorldModel)

                    //Nehmen button
                    local givebutton = armorymenu:Add("DButton")
                    givebutton:SetColor(green)
                    givebutton:SetText("Take")
                    givebutton:SetSize(120,50)
                    givebutton:SetPos(210,250)
                    givebutton.Paint = function(self,w,h)
                        draw.RoundedBox(0,0,0,w,h,grey2)
                        surface.SetDrawColor(green)
                        surface.DrawOutlinedRect(0,0,w,h,1)
                    end

                    givebutton.DoClick = function()
                        if table.HasValue(v[2], ply:getJobTable().name) then
                            net.Start("Metel_Armory_GiveWeapon")
                            net.WriteEntity(ply)
                            net.WriteString(k)
                            net.SendToServer()
                        end
                    end

                    // Zurückgebe Button
                    local backgivebutton = armorymenu:Add("DButton")
                    backgivebutton:SetColor(redg)
                    backgivebutton:SetText("Return")
                    backgivebutton:SetSize(120,50)
                    backgivebutton:SetPos(400,250)
                    backgivebutton.Paint = function(self,w,h)
                        draw.RoundedBox(0,0,0,w,h,grey2)
                        surface.SetDrawColor(redg)
                        surface.DrawOutlinedRect(0,0,w,h,1)
                    end

                    backgivebutton.DoClick = function()
                        net.Start("Metel_Armory_RemoveWeapon")
                        net.WriteEntity(ply)
                        net.WriteString(k)
                        net.SendToServer()
                    end
                end
            end
        end
    end
end
