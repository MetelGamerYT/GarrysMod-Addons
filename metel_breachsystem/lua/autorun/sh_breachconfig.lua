// Breach System by OverlordAkise & DerMetelGamerYT
// Version 1.0

Breach_Config = {}

Breach_Config.Time = 60*45 // When may an SCP can breach | 60*45 seconds = 45 minutes

Breach_Config.TimeToAccept = 60*5 // How long does the player have to accept the breach | 60*5 seconds = 5 minutes

hook.Add("postLoadCustomDarkRPItems", "luctus_darkrp_init", function()
	Breach_Config.SCPBreachSettings = {
		[TEAM_SCP173] = {"scp173_cell_knopf_fuer_manfred"},
	}
end)