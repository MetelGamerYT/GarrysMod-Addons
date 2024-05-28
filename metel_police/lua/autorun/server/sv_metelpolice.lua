util.AddNetworkString("MetelPolice_ArrestPlayer")

net.Receive("MetelPolice_ArrestPlayer", function(len, ply)
    local arrestedPlayer = net.ReadEntity()
    local arrestReason = net.ReadString()
    local arrestLenght = tonumber(net.ReadString())

    if arrestLenght == nil or not arrestLenght or arrestLenght > MetelPolice_Config.MaxArrestTime then
        arrestLenght = MetelPolice_Config.StandardArrestTime
    end

    if not IsValid(arrestedPlayer) then
        DarkRP.notify(ply, 1,5, "The Player isnt Available anymore!")
        return
    end

    if arrestedPlayer:isArrested() then
        DarkRP.notify(ply, 1,5, "The Player is already arrested!")
        return
    end

    arrestedPlayer:arrest(arrestLenght * 60, ply)

    timer.Create(arrestedPlayer:SteamID64().."_MetelPolice_ArrestTime", arrestLenght * 60, 1, function()
        -- print(arrestedPlayer:Name() .. " is unarrested!")
    end)

    DarkRP.notify(arrestedPlayer, 1,5, "You were arrested by "..ply:Name().." for ".. arrestLenght.." minutes!")
    DarkRP.notify(ply, 1,5, "You were arrested "..arrestedPlayer:Name().." for ".. arrestLenght.." minutes!")
end)

function MetelPolice_UnjailPlayer(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end
    ply:unArrest()
end

function MetelPolice_GetPlayerArrestTime(call, target)
    if not IsValid(target) or not target:IsPlayer() then return end

    if timer.Exists(target:SteamID64().."_MetelPolice_ArrestTime") then
        call:ChatPrint("Player "..target:Name().." is still in arrest for "..math.Round(timer.TimeLeft(target:SteamID64().."_MetelPolice_ArrestTime")).." seconds!")
    end
end