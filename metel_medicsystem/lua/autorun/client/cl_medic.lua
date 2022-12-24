//Font 
surface.CreateFont( "MedicDeath", {
	font = "Roboto",
	size = 25,
	weight = 500,
} )
surface.CreateFont( "MedicText", {
	font = "Roboto",
	size = 20,
	weight = 500,
} )

//Ragdoll Erstellung
hook.Add("CreateClientsideRagdoll","metelmedic_ragdoll",function(ownEnt,ragEnt)
    if ragEnt:GetClass() == "class C_HL2MPRagdoll" then
      ragEnt:SetNoDraw(true)
    end
end)

//Deathscreen

net.Receive("metelmedic_deathtimer", function()
    local ply = LocalPlayer()
    hook.Add("PostDrawHUD", "metelmedic_deathscreen", DrawDeathHud)
    if not MetelMedic_Config.NoMedic[ply:getJobTable().name] then
        timer.Create(ply:SteamID().."metelmedic_deathtimer", MetelMedic_Config.DieTimer, 1, function()

        end)
        timer.Create(ply:SteamID().."metelmedic_RespawnTimer", MetelMedic_Config.RespawnTimer + MetelMedic_Config.DieTimer, 1, function()
            hook.Remove("PostDrawHUD", "metelmedic_deathscreen")
        end)
    else
        timer.Create(ply:SteamID().."metelmedic_RespawnTimer", MetelMedic_Config.RespawnTimer, 1, function()
            hook.Remove("PostDrawHUD", "metelmedic_deathscreen")
        end)
    end
end)

function DrawDeathHud()
    local ply = LocalPlayer()
    if ply:Alive() then return end
    surface.SetDrawColor(0,0,0,255)
    surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
    if timer.Exists(ply:SteamID().."metelmedic_deathtimer") then
        draw.SimpleText("You are dying!", "MedicDeath", ScrW() / 2, ScrH() / 2 - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("You die in "..math.Round(timer.TimeLeft(ply:SteamID().."metelmedic_deathtimer")).." Seconds", "MedicDeath", ScrW() / 2, ScrH() / 2 - 70, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("You died!", "MedicDeath", ScrW() / 2, ScrH() / 2 - 100, Color(200,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("You respawn in "..math.Round(timer.TimeLeft(ply:SteamID().."metelmedic_RespawnTimer")).." Seconds", "MedicDeath", ScrW() / 2, ScrH() / 2 - 70, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

// Entfernt Roten Death Screen Suchfilter: RedScreen
hook.Add( "HUDShouldDraw", "metelmedic_removeredscreen", function( name ) 
    if ( name == "CHudDamageIndicator" ) then 
       return false 
    end
end )