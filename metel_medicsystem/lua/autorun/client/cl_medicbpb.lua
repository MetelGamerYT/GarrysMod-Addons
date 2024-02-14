local BleedingEffects = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0.0,
	[ "$pp_colour_addb" ] = 0.0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 1,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

function UseBleedingEffects()
	BleedingEffects[ "$pp_colour_addr" ] = math.abs(math.sin( CurTime() * 1.5 )) * 0.08
	
	DrawColorModify( BleedingEffects )
end

net.Receive("metelmedic_togglebleeding", function()
	if net.ReadBool() then
		hook.Add("RenderScreenspaceEffects", "MetelMedic_Effects", UseBleedingEffects)
	else
		hook.Remove("RenderScreenspaceEffects", "MetelMedic_Effects") 
	end
end)