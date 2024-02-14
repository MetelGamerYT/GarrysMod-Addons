util.AddNetworkString("metelnlr_startnlr")

hook.Add("PostPlayerDeath", "MetelNLR_StartNLR", function(ply)
    ply:SetNWBool("MetelNLR_HasNLR", true)
    net.Start("metelnlr_startnlr")
    net.WriteEntity(ply)
    net.Send(ply)
	if timer.Exists(ply:SteamID().."_nlrtimer") then timer.Remove(ply:SteamID().."_nlrtimer") end
    timer.Create(ply:SteamID().."_nlrtimer", MetelNLR_Config.NLRTime, 1, function()
        ply:SetNWBool("MetelNLR_HasNLR", false)
	end)
end)

hook.Add("PlayerDisconnected", "MetelNLR_Disconnect", function(ply)
    if timer.Exists(ply:SteamID().."_nlrtimer") then timer.Remove(ply:SteamID().."_nlrtimer") end
end)