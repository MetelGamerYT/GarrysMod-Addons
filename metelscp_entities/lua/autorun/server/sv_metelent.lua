util.AddNetworkString("MetelENT_NVGToggle")
util.AddNetworkString("MetelENT_Use500")
util.AddNetworkString("metelent_repairingserver")

hook.Add("Initialize", "MetelEnt_LoadStuff", function()
    SetGlobalBool("MetelEnt_IsServerRunning", true)
end)

hook.Add("PlayerSay", "MetelEnt_Commands", function(ply, text)
    if not ply:GetNWBool("NVG_Equipped") then return end
    if text == "!nvgtoggle" then
        if ply.nvgactive then
            net.Start("MetelENT_NVGToggle")
            net.WriteBool(false)
            net.Send(ply)
            ply.nvgactive = false
            ply:EmitSound("items/nvg_off.wav")
        else
            net.Start("MetelENT_NVGToggle")
            net.WriteBool(true)
            net.Send(ply)
            ply.nvgactive = true
            ply:EmitSound("items/nvg_on.wav")
        end
        return ""
    end
    if text == "!dropnvg" then
        if not ply:GetNWBool("NVG_Equipped") then return end
        if ply.nvgactive then
            net.Start("MetelENT_NVGToggle")
            net.WriteBool(false)
            net.Send(ply)
            ply.nvgactive = false
            ply:EmitSound("items/nvg_off.wav")
        end
        ply:SetNWBool("NVG_Equipped", false)

        local ent = ents.Create("nvg")
        ent:SetPos(ply:GetPos() + Vector(35, 0, 0))
        ent:Spawn()
        return ""
    end
end)

hook.Add("PostPlayerDeath", "MetelEnt_Death", function(ply)
    ply:SetNWBool("NVG_Equipped", false)
    net.Start("MetelENT_NVGToggle")
    net.WriteBool(false)
    net.Send(ply)
    ply.nvgactive = false
    ply:EmitSound("items/nvg_off.wav")
end)