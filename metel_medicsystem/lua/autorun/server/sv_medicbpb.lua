hook.Add("PostEntityTakeDamage", "MetelMedic_TakeDamage", function(ent, dmg)
    if ent:IsPlayer() then
        local ply = ent
        if MetelMedic_Config.NoMedic[ent:getJobTable().name] then return end
        if dmg:IsBulletDamage() then
            dmg:ScaleDamage(0.9)
            local percent = math.random(1, 100)
            local chance = 100 - MetelMedic_Config.BleedingPercent

            if percent >= chance then
                if dmg:GetDamage() <= 15 then
                    ent:SetNWString("MetelMedic_Bleeding", "light")
                    MetelMedic_StartBleeding(ent, 2, 3)
                elseif dmg:GetDamage() >= 26 and dmg:GetDamage() <= 69 then
                    ent:SetNWString("MetelMedic_Bleeding", "medium")
                    MetelMedic_StartBleeding(ent, 4, 5)
                elseif dmg:GetDamage() >= 70 then
                    ent:SetNWString("MetelMedic_Bleeding", "heavy")
                    MetelMedic_StartBleeding(ent, 5, 10)
                end
                net.Start("metelmedic_togglebleeding")
                net.WriteBool(true)
                net.Send(ent)
            end
        elseif dmg:IsFallDamage() then // Fügt Brüche hinzu
            dmg:ScaleDamage(0.6)
            if dmg:GetDamage() >= 40 then
                MetelMedic_StartLegFracture(ent)
            end
        end
    end
end)

function MetelMedic_StartBleeding(plystring, damage, bloodlose)  
    if not MetelMedic_Config.NoMedic[plystring:getJobTable().name] then
        if timer.Exists("MetelMedic_BleedingTimer_"..plystring:SteamID64()) and plystring:GetNWInt("MetelMedic_Blood") <= 0 then
            timer.Destroy("MetelMedic_BleedingTimer_"..plystring:SteamID64())
            plystring:Kill()
            return
        end

        --for k,v in pairs(plystring:GetNWString("MetelMedic_Bleeding")) do
            timer.Create("MetelMedic_BleedingTimer_"..plystring:SteamID64(), 7, 0, function()
				local bloodl = bloodlose
                plystring:TakeDamage(damage,ent,ent)
                plystring:SetNWInt("MetelMedic_Blood", plystring:GetNWInt("MetelMedic_Blood", nil) - bloodl)
                local percent = math.random(1, 100)
                local chance = 100 - MetelMedic_Config.BleedingStopPercent

                if percent >= chance then
                    timer.Destroy("MetelMedic_BleedingTimer_"..plystring:SteamID64())
                    plystring:SetNWString("MetelMedic_Bleeding", "none")
					net.Start("metelmedic_togglebleeding")
                    net.WriteBool(false)
					net.Send(plystring)
                end
            end)
        --end
    end
end

function MetelMedic_StartLegFracture(plystrings)
    if not MetelMedic_Config.NoMedic[plystrings:getJobTable().name] then
        plystrings:SetNWBool("MetelMedic_Brokenleg", true)
        if plystrings:GetNWBool("MetelMedic_Brokenleg") == true then
            plystrings:SetDuckSpeed(100)
            plystrings:SetWalkSpeed(100)
            plystrings:SetRunSpeed(100)
        end
    end
end

-- Behandlungen von Günther
net.Receive("metelmedic_bloodtreat", function(len, ply)
    if ply:GetNWInt("MetelMedic_Blood") >= 100 then
        ply:ChatPrint("[Günther] You already have enough blood in your body, why do you need more?")
    else
        ply:SetNWInt("MetelMedic_Blood", 100)
		timer.Destroy("MetelMedic_BleedingTimer_"..ply:SteamID64())
		ply:SetNWString("MetelMedic_Bleeding", "none")
		net.Start("metelmedic_togglebleeding")
        net.WriteBool(false)
		net.Send(ply)
        ply:ChatPrint("[Günther] I have now injected you with new blood.")
        ply:setDarkRPVar("money", ply:getDarkRPVar("money") - 5)
    end
end)

net.Receive("metelmedic_fractreat", function(len, ply)
    if not ply:GetNWBool("MetelMedic_Brokenleg") then
        ply:ChatPrint("[Günther] You don't have a hernia, or can't I see it?")
    else
        ply:SetNWBool("MetelMedic_Brokenleg", false)
        ply:SetDuckSpeed(ply.duckspeed)
        ply:SetWalkSpeed(ply.walkspeed)
        ply:SetRunSpeed(ply.runspeed)
        ply:ChatPrint("[Günther] I have now dealt with your faction(s).")
        ply:setDarkRPVar("money", ply:getDarkRPVar("money") - 10)
    end
end)

net.Receive("metelmedic_heilth", function(len,ply)
    if ply:Health() == ply:GetMaxHealth() then
        ply:ChatPrint("[Günther] Are you not healed yet?")
    else
        ply:SetHealth(ply:GetMaxHealth())
        ply:ChatPrint("[Günther] You have now been successfully treated by me.")
        ply:setDarkRPVar("money", ply:getDarkRPVar("money") - 75)
    end
end)