//Made by DerMetelGamerYT Version 1.3

util.AddNetworkString("metelmedic_deathtimer")
util.AddNetworkString("metelmedic_showguenther")
util.AddNetworkString("metelmedic_togglebleeding")
util.AddNetworkString("metelmedic_isusingbloodpck")
util.AddNetworkString("metelmedic_bloodtreat")
util.AddNetworkString("metelmedic_fractreat")
util.AddNetworkString("metelmedic_heilth")
util.AddNetworkString("metelmedic_openselfbody")

//Sorgt das man nicht mehr selbst respawnen kann
hook.Add("PlayerDeathThink", "MetelMedic_DisableRespawn", function(ply)
    if not ply.respawnTime then return true end
    return ply.respawnTime < CurTime()
end)

hook.Add("PostPlayerDeath", "MetelMedic_Death", function(ply)
    ply.medicdeathweapons = {}

    for k,v in pairs(ply:GetWeapons()) do
        table.insert(ply.medicdeathweapons, v:GetClass())
    end

    if not MetelMedic_Config.NoMedic[ply:getJobTable().name] and ply:GetNWBool("MetelMedic_DieInstant") == false then
	if not IsValid(ply) then return end
		timer.Create(ply:SteamID().."_deathtimer", MetelMedic_Config.DieTimer, 1, function()
            if ply.lragdoll then
                ply.lragdoll:SetNWInt("respawnTime", 0)
            end
		end)
		timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer + MetelMedic_Config.DieTimer, 1, function()
			ply:Spawn()
		end)

        ply.respawnTime = CurTime() + MetelMedic_Config.DieTimer
    else
        ply:SetNWBool("MetelMedic_DieInstant", true)
        timer.Create(ply:SteamID().."_RespawnTimer", MetelMedic_Config.RespawnTimer, 1, function()
            ply:Spawn()
        end)

        ply.respawnTime = CurTime() + MetelMedic_Config.RespawnTimer
    end

    timer.Simple(0.5, function()
        ply.lragdoll:SetNWInt("respawnTime", ply.respawnTime)
    end)

    net.Start("metelmedic_deathtimer")
    net.Send(ply)
end)

-- Removes shit beeping when dying lol
hook.Add("PlayerDeathSound", "MetelMedic_MuteSound", function()
    return true
end)

hook.Add("PlayerSpawn", "MetelMedic_Spawn", function(ply) 
    net.Start("metelmedic_togglebleeding")
        net.WriteBool(false)
    net.Send(ply)
    if timer.Exists(ply:SteamID().."_RespawnTimer") then
        timer.Destroy(ply:SteamID().."_RespawnTimer")
    end
    ply:StopZooming()
    ply:SetCanZoom(false)

    -- Setzt Player Infos
    MetelMedic_FullHeal(ply)
    MetelMedic_RemoveRag(ply)
end)

-- Erstellt die Ragdoll
hook.Add("CreateEntityRagdoll","MeteMedic_CreateRagdoll",function(ply,rag)
    ply.lragdoll = rag
    ply.lragdoll:SetNWString("metel_ragdollowner", ply)
    ply.lragdoll:SetHealth(300)
    ply.lragdoll:SetMaxHealth(300)
    ply.lragdoll:SetNWEntity("metel_ragdollowner_ent", ply)    
    ply.lragdoll:SetNWInt("respawnTime", MetelMedic_Config.DieTimer)
    ply:Spectate(OBS_MODE_CHASE)
    ply:SpectateEntity(rag)
    ply:SetShouldServerRagdoll(true)
end)

hook.Add("PlayerButtonDown", "MetelMedic_DragRagdoll", function(ply, button)
    if button == KEY_B then
        net.Start("metelmedic_openselfbody")
        net.Send(ply)
    end
    -- Ragdoll ziehen
    tr = {}
    tr.start = ply:GetShootPos()
    tr.endpos = ply:GetShootPos() + ( ply:GetAimVector() * 95 )
    tr.filter = ply
    tr.mask = MASK_SHOT
    trace = util.TraceLine(tr)
    if IsValid(trace.Entity) and trace.Entity:GetPos():Distance(ply:GetPos()) > 512 then return end
    if not trace.Entity:IsRagdoll() then return end

    if button == KEY_R then
        if trace.Entity:IsPlayerHolding() then return end
        ply:PickupObject(trace.Entity)
    end
end)

hook.Add("PlayerDisconnected", "MetelMedic_RemoveRagdoll", function(ply)
    MetelMedic_RemoveRag(ply)
end)

function MetelMedic_RemoveRag(ply)
    if ply.lragdoll and IsValid(ply.lragdoll) then
        if not ply.ragdoll == nil then
            ply.lragdoll:Remove()
            ply.lragdoll = nil
        end
        ply.lragdoll:Remove()
        ply.lragdoll = nil
    end
    ply:SetShouldServerRagdoll(true)

    if ply:GetNWBool("metelmedic_isonstretcher", false) then
        local ent = ply:GetNWEntity("metelmedic_isonstretcher_entity", nil)
        ent:Remove()
        print(ply:GetNWEntity("metelmedic_isonstretcher_enity", nil))
        ply:SetNWBool("metelmedic_isonstretcher", false)
    end
end

function MetelMedic_FullHeal(ply)
    ply:SetNWString("MetelMedic_Bleeding", "none")
    ply:SetNWBool("MetelMedic_Brokenleg", false)
    ply:SetNWInt("MetelMedic_Blood", 100)
    ply:SetNWBool("MetelMedic_DieInstant", false)

    net.Start("metelmedic_togglebleeding")
    net.WriteBool(false)
    net.Send(ply)
    if timer.Exists("MetelMedic_BleedingTimer_"..ply:SteamID64()) then
        timer.Destroy("MetelMedic_BleedingTimer_"..ply:SteamID64())
    end
end