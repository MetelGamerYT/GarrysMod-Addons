//Made by DerMetelGamerYT Version 1.0

util.AddNetworkString("metelmedic_deathtimer")
util.AddNetworkString("metelmedic_RespawnTimer")
util.AddNetworkString("metelmedic_openplayerinfo")
util.AddNetworkString("metelmedic_enablebleedingeffect")
util.AddNetworkString("metelmedic_disablebleedingeffect")
util.AddNetworkString("metelmedic_isusingbloodpck")

hook.Add("PlayerInitialSpawn", "MetelMedic_DisableZoom", function(ply, key)
    ply:StopZooming()
    ply:SetCanZoom(false)
end)

//Sorgt das man nicht mehr selbst respawnen kann
hook.Add("PlayerDeathThink", "MetelMedic_DisableRespawn", function(ply)
    return false
end)

hook.Add("PostPlayerDeath", "MetelMedic_Death", function(ply)
    ply.medicdeathweapons = {}

    for k,v in pairs(ply:GetWeapons()) do
        table.insert(ply.medicdeathweapons, v:GetClass())
        print(v:GetClass())
    end
    net.Start("metelmedic_deathtimer")
    net.Send(ply)
    if not MetelMedic_Config.NoMedic[ply:getJobTable().name] then
        timer.Create(ply:SteamID().."_deathtimer", MetelMedic_Config.DieTimer, 1, function()

        end)
        timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer + MetelMedic_Config.DieTimer, 1, function()
            ply:Spawn()
        end)
    else
        timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer, 1, function()
            ply:Spawn()
        end)
    end
end)

//Entfernt scheiß Piepen beim Sterben lol
hook.Add("PlayerDeathSound", "MetelMedic_MuteSound", function()
    return true
end)

hook.Add("PlayerSpawn", "MetelMedic_Spawn", function(ply) 
    net.Start("metelmedic_disablebleedingeffect")
    net.Send(ply)
    if timer.Exists(ply:SteamID().."_RespawnTimer") then
        timer.Destroy(ply:SteamID().."_RespawnTimer")
    end
    if ply:GetNWBool("metelmedic_isonstretcher", false) then
        local ent = ply:GetNWEntity("metelmedic_isonstretcher_entity", nil)
        ent:Remove()
        print(ply:GetNWEntity("metelmedic_isonstretcher_enity", nil))
        ply:SetNWBool("metelmedic_isonstretcher", false)
    end

    if ply.lragdoll and IsValid(ply.lragdoll) then
        if not ply.ragdoll == nil then
            ply.lragdoll:Remove()
            ply.lragdoll = nil
        end
        ply.lragdoll:Remove()
        ply.lragdoll = nil
    end
    ply:SetShouldServerRagdoll(true)

    //Set Player Infos
    ply:SetNWString("MetelMedic_Bleeding", "none")
    ply:SetNWBool("MetelMedic_Brokenleg", false)
    ply:SetNWInt("MetelMedic_Blood", 100)
    ply.walkspeed = ply:GetWalkSpeed()
    ply.duckspeed = ply:GetDuckSpeed()
    ply.runspeed = ply:GetRunSpeed()

    if timer.Exists("MetelMedic_BleedingTimer_"..ply:SteamID64()) then
        timer.Destroy("MetelMedic_BleedingTimer_"..ply:SteamID64())
    end
end)

// Erstellt die Ragdoll
hook.Add("CreateEntityRagdoll","MeteMedic_CreateRagdoll",function(ply,rag)
    ply.lragdoll = rag
    ply.lragdoll:SetNWString("metel_ragdollowner", ply)
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(rag)
    ply:SetShouldServerRagdoll(true)
end)

hook.Add("PlayerButtonDown", "MetelMedic_OpenBodyInfo", function(ply, button)
    if button == KEY_B then
        net.Start("metelmedic_openplayerinfo")
        net.Send(ply)
    end
end)