-- Font 
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

-- Ragdoll creation
hook.Add("CreateClientsideRagdoll","metelmedic_ragdoll",function(ownEnt,ragEnt)
    if ragEnt:GetClass() == "class C_HL2MPRagdoll" then
      ragEnt:SetNoDraw(true)
    end
end)

-- Deathscreen
net.Receive("metelmedic_deathtimer", function()
    local ply = LocalPlayer()
    hook.Add("PostDrawHUD", "metelmedic_deathscreen", DrawDeathHud)
    if not MetelMedic_Config.NoMedic[ply:getJobTable().name] and ply:GetNWBool("MetelMedic_DieInstant", nil) == false then
        timer.Create(ply:SteamID().."_deathtimer", MetelMedic_Config.DieTimer, 1, function() end)
        timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer + MetelMedic_Config.DieTimer, 1, function()
            hook.Remove("PostDrawHUD", "metelmedic_deathscreen")
        end)
    else
        timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer, 1, function()
            hook.Remove("PostDrawHUD", "metelmedic_deathscreen")
        end)
    end
end)

function DrawDeathHud()
    local ply = LocalPlayer()
    if ply:Alive() then return end
    surface.SetDrawColor(0,0,0,255)
    surface.DrawRect(-1, -1, ScrW() + 1, ScrH() + 1)
    if timer.Exists(ply:SteamID().."_deathtimer") then
        draw.SimpleText("You're dying!", "MedicDeath", ScrW() / 2, ScrH() / 2 - 100, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("You die in "..math.Round(timer.TimeLeft(ply:SteamID().."_deathtimer")).." Seconds", "MedicDeath", ScrW() / 2, ScrH() / 2 - 70, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
        draw.SimpleText("You died!", "MedicDeath", ScrW() / 2, ScrH() / 2 - 100, Color(200,0,0), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("You respawn in "..math.Round(timer.TimeLeft(ply:SteamID().."_RespawnTimer")).." Seconds", "MedicDeath", ScrW() / 2, ScrH() / 2 - 70, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
end

-- Removes red death screen
hook.Add( "HUDShouldDraw", "metelmedic_removeredscreen", function( name ) 
    if ( name == "CHudDamageIndicator" ) then 
       return false 
    end
end )

hook.Add("ScalePlayerDamage", "MetelMedic_DisableBloodEffects", function(ply)
    if MetelMedic_Config.NoBloodEffects[ply:getJobTable().name] then
        return true
    end
end)

-- From Luctus SMedic
local NearbyCorpses = {}
timer.Create("MetelMedic_GetNearCorpses",0.5,0,function()
    NearbyCorpses = {}
    if not IsValid(LocalPlayer()) then return end
    local own = nil
    if IsValid(LocalPlayer():GetObserverTarget()) then
        own = LocalPlayer():GetObserverTarget()
    end
    for k,ent in pairs(ents.FindInSphere(LocalPlayer():GetPos(),256)) do
        if ent:GetClass() ~= "prop_ragdoll" then continue end --C_HL2MPRagdoll ?
        if ent == own then continue end
        table.insert(NearbyCorpses,ent)
    end
end)

local margin = 15
local boxSize = 85
local iconSize = boxSize * 0.6
local iconMargin = (boxSize - iconSize) / 2
local iconVehicleSize = 100

local help = surface.GetTextureID("ggui/death")

local COLORS
local MAT_USER =  Material("edgehud/icon_user.png", "smooth")

hook.Add("HUDPaint","MetelMedic_DrawHUDForCorpses",function()
    COLORS = COLORS or table.Copy(EdgeHUD.Colors)
	if !COLORS then return end

    for k,ent in pairs(NearbyCorpses) do
        if not IsValid(ent) then continue end
        -- if not ent.lragdoll then continue end

        local ply = ent:GetNWEntity("metel_ragdollowner_ent")
        if not IsValid(ply) then return end
        local name = ply:Name()
        local job = ply:Team()

        local pos = ent:GetPos():ToScreen()

		--Get the text size of the name.
		surface.SetFont("EdgeHUD:3D2D:Large")
		local nameTextWidth, _ = surface.GetTextSize(name)

		--Get the text size of the job.
		surface.SetFont("EdgeHUD:3D2D:Small")
		local jobTextWidth, _ = surface.GetTextSize(job)

        local boxPos = -((boxSize + margin + math.max(nameTextWidth,jobTextWidth)) / 2)

        surface.SetDrawColor(COLORS["Black_Transparent"])
        surface.DrawRect(pos.x + boxPos,pos.y + 0,boxSize,boxSize)

        --Draw health.
        surface.SetDrawColor(ColorAlpha(COLORS["Red"],70 * math.Round(CurTime() % 1)))
        surface.DrawRect(pos.x + boxPos,pos.y + 0,boxSize,boxSize)

        --Draw the outline.
        surface.SetDrawColor(COLORS["White_Outline"])
        surface.DrawOutlinedRect(boxPos,0,boxSize,boxSize)

        --Draw edges.
        surface.SetDrawColor(COLORS["White_Corners"])
        EdgeHUD.DrawEdges(pos.x + boxPos,pos.y + 0,boxSize,boxSize,8)

        --Draw icon.
        surface.SetDrawColor(COLORS["White"])
        surface.SetMaterial(MAT_USER)	
        surface.DrawTexturedRect(pos.x + boxPos + iconMargin,pos.y + 0 + iconMargin,iconSize,iconSize)

        draw.SimpleText(name,"EdgeHUD:3D2D:Large", pos.x + boxPos + boxSize + margin, pos.y + 0, Color(200,200,200,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
        draw.SimpleText(team.GetName(job),"EdgeHUD:3D2D:Small", pos.x + boxPos + boxSize + margin,pos.y + boxSize, team.GetColor(job), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

        local textCol = COLORS["Red"]
        local respawnTime = ent:GetNWString("respawnTime","")
        if respawnTime == "" or respawnTime - CurTime() <= 0 or ply:GetNWBool("MetelMedic_DieInstant") then
            draw.SimpleText("Deceased","EdgeHUD:3D2D:Small",pos.x + boxPos  + boxSize + margin,pos.y + boxSize + 35,textCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        else
            draw.SimpleText("Dies in (" .. string.ToMinutesSeconds(math.max(0,math.Round(respawnTime-CurTime()))).. ")","EdgeHUD:3D2D:Small",pos.x + boxPos  + boxSize + margin,pos.y + boxSize + 35,textCol, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
        end
    end
end)