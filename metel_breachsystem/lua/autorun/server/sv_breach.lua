// Breach System by OverlordAkise & DerMetelGamerYT
// Version 1.1

util.AddNetworkString("metelbreach_sendbreach");

LuctusLog = LuctusLog or function()end

hook.Add("OnPlayerChangedTeam", "BreachLogic", function(ply, beforejob, afterjob)
	if Breach_Config.SCPBreachSettings[afterjob] then
        breachtimer(ply);
    end
end)

function breachtimer(ply) 
    ply.canbreach = false
    timer.Create(ply:SteamID64().."_breachtime", Breach_Config.Time, 0, function()
        ply.canbreach = true
        
        net.Start("metelbreach_sendbreach")
        net.Send(ply)

        timer.Create(ply:SteamID().."_breachaccept_time", Breach_Config.TimeToAccept, 1, function()
            ply.canbreach = false
        end)
    end)
end

hook.Add("PlayerSay", "BreachCommand", function(ply, text)
    if text == "!breach" then
        if ply.canbreach == true then
            if Breach_Config.SCPBreachSettings[ply:Team()] then
                for k,v in pairs(Breach_Config.SCPBreachSettings[ply:Team()]) do
                    if(ents.FindByName(v)[1]:GetSaveTable(true)["m_toggle_state"] == 1) then
                        ents.FindByName(v)[1]:Use(ply)
                    end
                end
            end
            if timer.Exists(ply:SteamID().."_breachaccept_time") then timer.Remove(ply:SteamID().."_breachaccept_time") end

            DarkRP.notify(ply, 1,5, "[Breach] Your breach will now start.")
            ply.canbreach = false
        else 
            DarkRP.notify(ply, 1,5, "You can't breach yet!");
        end
        return ""
	end
end)