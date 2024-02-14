local fdbackground = Material("metelfd/scpbackground2.jpg")

function openfoundationmainmenu(pcid)
    local ply = LocalPlayer()
    fdmainmenu = vgui.Create("DFrame")
    fdmainmenu:SetSize(1200,700)
    fdmainmenu:MakePopup()
    fdmainmenu:SetTitle("")
    fdmainmenu:Center()
    fdmainmenu:ShowCloseButton(false)

    local folderb = Material("metelfd/scpfolder.png")
    local folderused = Material("metelfd/scpfolderused.png")
    local shutdown = Material("metelfd/poweroff.png")
    local refresh = Material("metelfd/refresh.png")

    function fdmainmenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, h, Color(255, 255, 255))
        surface.SetMaterial(fdbackground)
        surface.DrawTexturedRect(0,0,w,h)
        draw.RoundedBox(5, 30, 130, 210, 100, Color(192,192,192)) -- Management Kästchen
        draw.RoundedBox(5, 30, 280, 210, 100, Color(192,192,192)) -- Wissenschafts Kästchen
        draw.RoundedBox(5, 30, 430, 210, 100, Color(192,192,192)) -- Anderes
        --draw.RoundedBox(5, 950, 120, 230, 400, Color(192,192,192)) -- FD User online
        draw.SimpleText("Management", "Metel_FoundationMNG2", 55, 130, Color(0,0,0))
        draw.SimpleText("Science", "Metel_FoundationMNG2", 55, 280, Color(0,0,0))
        draw.SimpleText("External", "Metel_FoundationMNG2", 100, 430, Color(0,0,0))

        draw.SimpleText("Welcome, "..ply:GetName(), "Metel_FoundationMNG2", 7,30, Color(255,255,255), TEXT_ALIGN_TOP, TEXT_ALIGN_CENTER)
        draw.SimpleText("You are using the PC: "..ply:GetNWInt("MetelManage_PCID"), "Metel_FoundationMNG2", 7, 40, Color(255,255,255))

        draw.SimpleText("Other users online:", "Metel_FoundationMNG2", 950, 80, Color(255,255,255))

        draw.SimpleText("Code management", "Default", 35, 210, Color(0,0,0))
        draw.SimpleText("Emergency management", "Default", 135, 210, Color(0,0,0))
        draw.SimpleText("Protocol-System", "Default", 90, 360, Color(0,0,0))
        draw.SimpleText("MetelWiki", "Default", 110, 510, Color(0,0,0))
    end

    local wstests = vgui.Create("DButton", fdmainmenu)
    wstests:SetPos(100,300)
    wstests:SetSize(70,70)
    wstests:SetText("")
    function wstests:Paint(w,h)
        surface.SetMaterial(folderused)
        surface.DrawTexturedRect(0,0,70,70)
    end

    wstests.DoClick = function()
        if lucidResearchAllowedJobs[LocalPlayer():getJobTable().name] then
			net.Start("luctus_research_getall")
				local t = util.TableToJSON(luctusGetPapers(0))
				local a = util.Compress(t)
				net.WriteInt(#a,17)
				net.WriteData(a,#a)
			net.Send(LocalPlayer())
            return ""
        end
    end

    local wikilink = vgui.Create("DButton", fdmainmenu)
    wikilink:SetPos(100,450)
    wikilink:SetSize(70,70)
    wikilink:SetText("")
    function wikilink:Paint(w,h)
        surface.SetMaterial(folderused)
        surface.DrawTexturedRect(0,0,70,70)
    end

    wikilink.DoClick = function()
        metelwikiopen()
    end

    local emergency = vgui.Create("DButton", fdmainmenu)
    emergency:SetPos(150,150)
    emergency:SetSize(70,70)
    emergency:SetText("")
    function emergency:Paint(w,h)
        surface.SetMaterial(folderused)
        surface.DrawTexturedRect(0,0,70,70)
    end

    emergency.DoClick = function()
        if not MetelManage_Config.AllowedJobs[LocalPlayer():getJobTable().name] then return end
        metelmanage_emergency()
    end

    local codechange = vgui.Create("DButton", fdmainmenu)
    codechange:SetPos(40,150)
    codechange:SetSize(70,70)
    codechange:SetText("")
    function codechange:Paint(w,h)
        surface.SetMaterial(folderused)
        surface.DrawTexturedRect(0,0,70,70)
    end

    codechange.DoClick = function()
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

    local refreshbtn = vgui.Create("DButton", fdmainmenu)
    refreshbtn:SetPos(1060,15)
    refreshbtn:SetSize(70,70)
    refreshbtn:SetText("")
    function refreshbtn:Paint(w,h)
        surface.SetMaterial(refresh)
        surface.DrawTexturedRect(0,0,60,60)
    end

    refreshbtn.DoClick = function()
        fdmainmenu:Close()
        openfoundationmainmenu(ply:GetNWInt("MetelManage_PCID"))
    end

    local shutdownbtn = vgui.Create("DButton", fdmainmenu)
    shutdownbtn:SetPos(1125,10)
    shutdownbtn:SetSize(70,70)
    shutdownbtn:SetText("")
    function shutdownbtn:Paint(w,h)
        surface.SetMaterial(shutdown)
        surface.DrawTexturedRect(0,0,70,70)
    end

    shutdownbtn.DoClick = function()
        fdmainmenu:Close()
        net.Start("MetelManage_ChangePCStatus")
        net.WriteString("inactive") 
        net.WriteString("nil")
        net.SendToServer()
    end

    local useronlinebar = vgui.Create( "DScrollPanel", fdmainmenu )
    local sbar = useronlinebar:GetVBar()
    function sbar:Paint(w, h)
        surface.SetDrawColor(0,0,0,0)
        surface.DrawRect(0,0,w,h)
    end
    function sbar.btnUp:Paint(w, h)
        surface.SetDrawColor(0,0,0,0)
        surface.DrawRect(0,0,w,h)
    end
    function sbar.btnDown:Paint(w, h)
        surface.SetDrawColor(0,0,0,0)
        surface.DrawRect(0,0,w,h)
    end
    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor(0,0,0,0)
        surface.DrawRect(0,0,w,h)
    end

    useronlinebar:SetPos(960, 120)
    useronlinebar:SetSize(220,400)

    for k,v in pairs(player.GetAll()) do
        if ply:GetNWBool("MetelManage_IsOnline") then
            local onlineplayer = useronlinebar:Add( "DButton" )
            onlineplayer:Dock( TOP )
            onlineplayer:DockMargin( 0, 0, 0, 5 )
            --onlineplayer:SetPos(150,450)
            if v:Name() == ply:Name() then
                onlineplayer:SetTextColor(Color(255,20,0))
                onlineplayer:SetText(v:Name().."(You) - ID: " .. v:GetNWInt("MetelManage_PCID") )
            else
                onlineplayer:SetText(v:Name().." - ID: " .. v:GetNWInt("MetelManage_PCID") )
            end
            onlineplayer:SetSize(120, 30)

            function onlineplayer:Paint(w,h)                
                draw.RoundedBox(0,0,0,w,h,Color(25,25,25,255))
                surface.SetDrawColor(255,255,255)
                surface.DrawOutlinedRect(0,0,w,h,1)
            end

            onlineplayer.DoClick = function()
                local newcode = Derma_StringRequest(
                    "MetelMSG",
                    "Send the person a message (Attention team members can see this)",
                    "Feature to be added in the near future!",
                    function(text)
                        net.Start("MetelManage_SendMessage")
                        net.WriteString(text)
                        net.SendToServer()
                    end,
                    function(text) end
                )
            end
        end
    end
end

function metelwikiopen()
    local ply = LocalPlayer()
    wikimenu = vgui.Create("DFrame")
    wikimenu:SetSize(1200,700)
    wikimenu:MakePopup()
    wikimenu:SetTitle("")
    wikimenu:Center()
    wikimenu:ShowCloseButton(true)

    function wikimenu:Paint(w,h)
        draw.RoundedBox(0, 0, 0, w, 24, Color(30, 30, 30, 255))
        draw.RoundedBox(0, 0, 23, w, 1, team.GetColor(ply:Team()))
        draw.RoundedBox(0, 0, 24, w, h - 24, Color(50, 50, 50, 240))
    end

    local html = vgui.Create( "DHTML", wikimenu )
    html:Dock( FILL )
    html:OpenURL( "metelgames.com/scprp-wiki/" )
end