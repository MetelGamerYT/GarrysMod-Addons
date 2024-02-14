--Inspired by Overlordakise's management system

util.AddNetworkString("MetelManage_OpenMenu")
util.AddNetworkString("MetelManage_ChangeCode")
util.AddNetworkString("MetelManage_SendMessage")
util.AddNetworkString("MetelManage_Emergency")
util.AddNetworkString("MetelManage_DemotePlayer")

function MetelManage_IsEmergency(name)
    for k,v in pairs(MetelManage_Config_EmergencyTroops) do
        if k == name then return k end
    end
    return false
end

hook.Add("PlayerSay", "MetelManage_Management", function(ply, text)
    if MetelManage_Config.AllowedJobs[ply:getJobTable().name] then
		if text == "!management" then
			net.Start("MetelManage_OpenMenu")
			net.Send(ply)
			return ""
		end
	end
end)

net.Receive("MetelManage_ChangeCode", function(len, ply)
    if not MetelManage_Config.AllowedJobs[ply:getJobTable().name] then return end
    local code = net.ReadString()
    if OverMetel_ChangeCode then
        OverMetel_ChangeCode(code)
    end
end)

hook.Add("playerCanChangeTeam", "MetelManage_CanChangeToEmergency", function(ply, newTeam, force)
    if force then return true, "The job is locked" end
    local jobcat = MetelManage_IsEmergency(team.GetName(newTeam))
    if jobcat then
        if not GetGlobal2Bool("metelmanage_emergency_"..jobcat) then return false, "This job is currently not needed! We will get in touch with you" end
    end
    if ply:GetNW2Bool("MetelManage_HasDemoteCooldown") then return false, "You currently have a job lock due to your last demote. Please be patient" end
end)

net.Receive("MetelManage_Emergency", function(len, ply)
    if not MetelManage_Config.AllowedJobs[ply:getJobTable().name] then return end
    local emergency_name = net.ReadString()
    local emergency_sound = net.ReadString()
    local isCalling = net.ReadBool()

    if isCalling then
        net.Start("MetelManage_SendMessage")
        net.WriteString("[Foundation] The "..emergency_name.." was called by management due to an emergency. The job will be activated in 30 seconds.")
        net.WriteBool(true)
        net.WriteString(emergency_sound)
        net.Broadcast()

        timer.Create("MetelManage_UnlockJobTimer_"..emergency_name, 30, 1, function()
            SetGlobal2Bool("metelmanage_emergency_"..emergency_name, true)
            net.Start("MetelManage_SendMessage")
            net.WriteString("[Foundation] The "..emergency_name.." job is now activated!")
            net.WriteBool(false)
            net.WriteString(emergency_sound)
            net.Broadcast()
        end)
    else
        net.Start("MetelManage_SendMessage")
        net.WriteString("[Foundation] The "..emergency_name.." has been ordered to move off. The job will be locked in 60 seconds.")
        net.WriteBool(false)
        net.WriteString(emergency_sound)
        net.Broadcast()

        timer.Create("MetelManage_LockJobTimer_"..emergency_name, 60, 1, function()
            SetGlobal2Bool("metelmanage_emergency_"..emergency_name, false)
            for k,v in pairs(player.GetAll()) do
                if team.GetName(v:Team()) == emergency_name then
                    v:changeTeam(GAMEMODE.DefaultTeam, true)
                end
            end
        end)
    end
end)

net.Receive("MetelManage_DemotePlayer", function(ply)
    local demoteplayer = net.ReadString()
    local reason = net.ReadString()

    for k,v in pairs(player.GetAll()) do
        if v:Name() == demoteplayer then
            v:changeTeam(TEAM_CLASSD, true)
            DarkRP.notify(v, 1,5, "You have been demoted to Class-D. Reason: "..reason)

            v:SetNW2Bool("MetelManage_HasDemoteCooldown", true)

            timer.Create("MetelManage_PlayerDemoteCooldown_"..v:SteamID(), MetelManage_Config.JobDemoteCooldown, 1, function()
                v:SetNW2Bool("MetelManage_HasDemoteCooldown", false)
            end)
        end
    end
end)