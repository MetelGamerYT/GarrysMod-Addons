function ulx.unjail(calling_ply, target_ply)
    if target_ply:isArrested() then
        MetelPolice_UnjailPlayer(target_ply)
        ulx.fancyLogAdmin(calling_ply, false, "#A has unjailed #T", target_ply)
    else
        DarkRP.notify(calling_ply,0,5,"[MetelPolice] This Player is not jailed!")
    end
end
local unjail = ulx.command("MetelPolice", "ulx unjail", ulx.unjail, "!unjail", true, false, true)
unjail:defaultAccess( ULib.ACCESS_ADMIN )
unjail:addParam{ type=ULib.cmds.PlayerArg }
unjail:help("Unjail a player")

function ulx.getjailtime(calling_ply, target_ply)
    if target_ply:isArrested() then
        MetelPolice_GetPlayerArrestTime(calling_ply, target_ply)
    else
        DarkRP.notify(calling_ply,0,5,"[MetelPolice] This Player is not jailed!")
    end
end
local getjailtime = ulx.command("MetelPolice", "ulx getjailtime", ulx.getjailtime, "!getjailtime", true, false, true)
getjailtime:defaultAccess( ULib.ACCESS_ADMIN )
getjailtime:addParam{ type=ULib.cmds.PlayerArg }
getjailtime:help("Get the JailTime from a player")