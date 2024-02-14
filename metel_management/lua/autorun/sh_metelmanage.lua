-- Metel-Management System v1.2
-- By DerMetelGamerYT

MetelManage_Config = {}

-- Who can open the management Menu
MetelManage_Config.AllowedJobs = {
    ["O5"] = true,
	["Staff"] = true,
}

-- Emergency units
MetelManage_Config_EmergencyTroops = {
	-- ["Name of Job"] = {"path/to/custom/sound/if/called.mp3"},
    ["Riot Trooper"] = {"scprp/site/prison_alarm.mp3"},
    ["MTF Epsilon-11"] = {"scprp/site/foundation_alarm.wav"},
}

-- How long a player may not change jobs after a demote
MetelManage_Config.JobDemoteCooldown = 300

-- Which jobs can be demoted
MetelManage_Config.CanDemote = {
    ["Hobo"] = true,
    ["Cook"] = true,
}