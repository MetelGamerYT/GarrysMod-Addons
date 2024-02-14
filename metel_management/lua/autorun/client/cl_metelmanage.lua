net.Receive("MetelManage_OpenMenu", function()
    metelmanage_main()
end)

function metelmanage_main()
    local ply = LocalPlayer()
    metelmanage_mainmenu = vgui.Create("DFrame")
    metelmanage_mainmenu:SetSize(300,200)
    metelmanage_mainmenu:MakePopup()
    metelmanage_mainmenu:SetTitle("Foundation administration")
    metelmanage_mainmenu:Center()

    function metelmanage_mainmenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, Color(255,0,0))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local changecode = vgui.Create("DButton", metelmanage_mainmenu)
    changecode:SetSize(280, 40)
    changecode:SetPos(10,40, TEXT_ALIGN_CENTER)
    changecode:SetTextColor(color_white)
    changecode:SetText("Change code")
    function changecode:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(35, 35, 35, 255))

        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 5))
        end
    end

    changecode.DoClick = function()
		surface.PlaySound("ui/buttonclick.wav")

        local newcode = Derma_StringRequest(
            "Management - Change code",
            "Enter the new code",
            "",
            function(text)
                net.Start("MetelManage_ChangeCode")
                net.WriteString(text)
                net.SendToServer()
            end,
            function(text) end
        )
	end

    local openemergencybutton = vgui.Create("DButton", metelmanage_mainmenu)
    openemergencybutton:SetSize(280, 40)
    openemergencybutton:SetPos(10, 90, TEXT_ALIGN_CENTER)
    openemergencybutton:SetTextColor(color_white)
    openemergencybutton:SetText("Manage emergency units")
    function openemergencybutton:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(35, 35, 35, 255))

        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 5))
        end
    end

    openemergencybutton.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        metelmanage_mainmenu:Close()
        metelmanage_emergency()
    end

    local opendemotemenu = vgui.Create("DButton", metelmanage_mainmenu)
    opendemotemenu:SetSize(280, 40)
    opendemotemenu:SetPos(10, 140, TEXT_ALIGN_CENTER)
    opendemotemenu:SetTextColor(color_white)
    opendemotemenu:SetText("Demote System")
    function opendemotemenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(35, 35, 35, 255))

        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 5))
        end
    end

    opendemotemenu.DoClick = function()
        surface.PlaySound("ui/buttonclick.wav")
        metelmanage_mainmenu:Close()
        metelmanage_demotemenu_func()
    end

end

function metelmanage_emergency()
    local ply = LocalPlayer()
    metelmanage_emergencymenu = vgui.Create("DFrame")
    metelmanage_emergencymenu:SetSize(300,150)
    metelmanage_emergencymenu:MakePopup()
    metelmanage_emergencymenu:SetTitle("Manage emergency units")
    metelmanage_emergencymenu:Center()

    function metelmanage_emergencymenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, Color(255,0,0))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local DScrollPanel = vgui.Create("DScrollPanel", metelmanage_emergencymenu)
    DScrollPanel:Dock(FILL)

    for k,v in pairs(MetelManage_Config_EmergencyTroops) do
        local emergencybutton = DScrollPanel:Add("DButton")
        emergencybutton.key = k
        emergencybutton:DockMargin(1,1,1,1)
        emergencybutton:SetTextColor(Color(255,255,255))
        emergencybutton:Dock(TOP)
        function emergencybutton:Paint(w,h)
            draw.RoundedBox(0, 0, 0, w, h, Color(25, 25, 25))
            if (self.Hovered) then
              draw.RoundedBox(0, 0, 0, w, h, Color(66, 70, 77))
            end
          end
        if not GetGlobal2Bool("metelmanage_emergency_"..k) then
            emergencybutton:SetText(k.." call out")
            emergencybutton.DoClick = function(s)
                net.Start("MetelManage_Emergency")
                net.WriteString(k)
                net.WriteString(v[1])
                net.WriteBool(true)
                net.SendToServer()
                surface.PlaySound("ui/buttonclick.wav")
            end
        else
            emergencybutton:SetText(k.." recall")
            emergencybutton.DoClick = function(s)
                net.Start("MetelManage_Emergency")
                net.WriteString(k)
                net.WriteString(v[1])
                net.WriteBool(false)
                net.SendToServer()
                surface.PlaySound("ui/buttonclick.wav")
            end
        end
    end
end

function metelmanage_demotemenu_func()
    local ply = LocalPlayer()
    metelmanage_demotemenu = vgui.Create("DFrame")
    metelmanage_demotemenu:SetSize(300,200)
    metelmanage_demotemenu:MakePopup()
    metelmanage_demotemenu:SetTitle("Demote System")
    metelmanage_demotemenu:Center()

    function metelmanage_demotemenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, Color(255,0,0))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local selectuserlabel = vgui.Create("DLabel", metelmanage_demotemenu)
    selectuserlabel:SetPos(12, 22)
    selectuserlabel:SetWidth(200)
    selectuserlabel:SetFont("Trebuchet18")
    selectuserlabel:SetText("Select a player!")

    local selectdemoteplayer = vgui.Create("DComboBox", metelmanage_demotemenu)
    selectdemoteplayer:SetPos(10, 40)
    selectdemoteplayer:SetSize(280, 25)
    selectdemoteplayer:SetTextColor(Color(255,255,255))

    function selectdemoteplayer:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(35, 35, 35, 255))
    end

    for k,v in pairs(player.GetAll()) do
        if MetelManage_Config.CanDemote[v:getJobTable().name] then
            selectdemoteplayer:AddChoice(v:Name())
        end
    end

    local reasoninput = vgui.Create("DTextEntry", metelmanage_demotemenu)
    reasoninput:SetPos(10, 90)
    reasoninput:SetSize(280,25)
    reasoninput:SetText("Enter a reason!")

    local demotebutton = vgui.Create("DButton", metelmanage_demotemenu)
    demotebutton:SetSize(280, 40)
    demotebutton:SetPos(10, 140, TEXT_ALIGN_CENTER)
    demotebutton:SetTextColor(color_white)
    demotebutton:SetText("Player demotes")
    function demotebutton:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(60, 60, 60, 255))
        draw.RoundedBox(0, 2, 2, w - 4, h - 4, Color(35, 35, 35, 255))
        if self:IsHovered() then
            draw.RoundedBox(0, 0, 0, w, h, Color(150, 150, 150, 5))
        end
    end

    demotebutton.DoClick = function()
        if selectdemoteplayer:GetSelected() == nil then
            ply:ChatPrint("You must select a player!")
            return
        end
        if reasoninput:GetText() == "Enter a reason!" then 
            ply:ChatPrint("You have to give a reason!")
            return
        end
        surface.PlaySound("ui/buttonclick.wav")
        net.Start("MetelManage_DemotePlayer")
        net.WriteString(selectdemoteplayer:GetSelected())
        net.WriteString(reasoninput:GetText())
        net.SendToServer()
        metelmanage_demotemenu:Close()
    end
end

net.Receive("MetelManage_SendMessage", function(len, ply)
    local msg = net.ReadString()
    local playsound = net.ReadBool()
    local soundpath = net.ReadString()

    if playsound then
        LocalPlayer():EmitSound(soundpath)
    end
    chat.AddText(Color(255,0,0), msg)
end)