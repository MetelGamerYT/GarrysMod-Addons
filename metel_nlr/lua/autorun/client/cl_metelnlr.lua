surface.CreateFont("MetelNLR", {font = "Roboto", size = 17, weight = 0})

net.Receive("metelnlr_startnlr", function()
    if not MetelNLR_Config.ShowNLR then return end
    local ply = net.ReadEntity()
    if timer.Exists(ply:SteamID().."_nlrtimer") then timer.Remove(ply:SteamID().."_nlrtimer") end
    timer.Create(ply:SteamID().."_nlrtimer", MetelNLR_Config.NLRTime, 1, function()
        hook.Remove("HUDPaint", "MetelNLR_HUD")
    end)
    hook.Add("HUDPaint", "MetelNLR_HUD", MetelNLR_DrawHUD)
end)

local edgeWidth = 2
function DrawEdges( x, y, width, height, edgeSize )
	surface.DrawRect(x,y,edgeSize,edgeWidth)
	surface.DrawRect(x,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local XRight = x + width

	surface.DrawRect(XRight - edgeSize,y,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,y + edgeWidth,edgeWidth,edgeSize - edgeWidth)

	local YBottom = y + height

	surface.DrawRect(XRight - edgeSize,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(XRight - edgeWidth,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)

	surface.DrawRect(x,YBottom - edgeWidth,edgeSize,edgeWidth)
	surface.DrawRect(x,YBottom - edgeSize,edgeWidth,edgeSize - edgeWidth)
end

function MetelNLR_DrawHUD()
    local ply = LocalPlayer()
    surface.SetDrawColor(Color(50,50,50,200))
    surface.DrawRect(330,ScrH()-55, 200, 40)

    draw.SimpleText("NLR: "..math.Round(timer.TimeLeft(ply:SteamID().."_nlrtimer")).." Seconds", "MetelNLR", 365, ScrH()-43, Color(255,255,255))
    surface.SetDrawColor(Color(255,255,255))
    DrawEdges(330,ScrH()-55, 200, 40, 8)
end