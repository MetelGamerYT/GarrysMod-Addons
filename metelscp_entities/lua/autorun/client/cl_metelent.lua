net.Receive("MetelENT_NVGToggle", function()
    if net.ReadBool() then
        LocalPlayer():ScreenFade(1, Color(0,0,0), 2, 0.2)
        hook.Add("RenderScreenspaceEffects", "MetelENT_NVGEffects", MetelENT_RenderNVG)
    else
        LocalPlayer():ScreenFade(1, Color(0,0,0), 2, 0.2)
        hook.Remove("RenderScreenspaceEffects", "MetelENT_NVGEffects")
    end
end)

local tab = {
    ["$pp_colour_brightness"] = 0.75,
    ["$pp_colour_contrast"] = 1,
    ["$pp_colour_colour"] = 0.15,
    ["$pp_colour_mulr"] = 0,
    ["$pp_colour_mulg"] = 0,
    ["$pp_colour_mulb"] = 0,    
    ["$pp_colour_addr"] = -1,
    ["$pp_colour_addg"] = 0,
    ["$pp_colour_addb"] = -1
}

function MetelENT_RenderNVG()
    local ply = LocalPlayer()
    DrawMaterialOverlay("drg_nvg/drg_nvg.vmt", 0)
    DrawMaterialOverlay("drg_nvg/drg_nvg2.vmt", 0)
    DrawColorModify(tab)
    DrawSharpen(1, 1)
    DrawMaterialOverlay("drg_nvg/drg_nvg_goggle.vmt", 0)
end

net.Receive("MetelENT_Use500", function()
    chat.AddText(Color(255,0,0), "You have taken SCP-500. \nYou feel a lot better now!")
end)