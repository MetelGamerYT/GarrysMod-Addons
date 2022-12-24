include("shared.lua")

function ENT:Draw()
    self:DrawModel()
	local dist = LocalPlayer():GetPos():Distance(self:GetPos())
	if dist > 500 then return end
	local angle = self.Entity:GetAngles()	
	local position = self.Entity:GetPos()
	
	angle:RotateAroundAxis(angle:Forward(), 0);
	angle:RotateAroundAxis(angle:Right(),0);
	angle:RotateAroundAxis(angle:Up(), 90);
	
	cam.Start3D2D(position, angle, 0.2)
		local blood = 100
		local bloodqt = math.Clamp(blood/100,0,1)
		draw.RoundedBox( 8, -13,16 - 32* bloodqt, 26, 35 * bloodqt, Color(150,0,0) )		
	cam.End3D2D()
end

net.Receive("metelmedic_isusingbloodpck", function()
	local search_starttime = CurTime()
	local time_search_done = 0
	local SmoothedProgress = 0
	local SW, SH = ScrW(), ScrH()
	local isusing = net.ReadBool()

	hook.Add( "HUDPaint", "metelmedic_usingbloodpck", function()
		if isusing then
			if search_starttime ~= 0 then
				search_progress = ((CurTime() - search_starttime) / 5) * 100
				if search_progress > 100 then search_progress = 100 end
				SmoothedProgress = math.Approach(SmoothedProgress, search_progress, (search_progress - SmoothedProgress) / 2)
		
				surface.SetDrawColor(0,0,0,255)
				surface.DrawOutlinedRect( SW*0.3-2, SH/2+300, SW*0.4+4, 20+4, 2 )
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawRect( SW*0.3, SH/2+302, (SW*0.4)*(SmoothedProgress*0.01), 20 )
				surface.SetDrawColor( 255, 255, 255, 5 )
				surface.DrawRect( SW*0.3, SH/2+302, SW*0.4, 20 )
				draw.SimpleTextOutlined( "Blood is injected...", "Trebuchet24", SW/2, SH/2+312, Color( 255, 255, 255, 255 ),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER,1,Color(0,0,0,255))
			end
		end
	end)
end)