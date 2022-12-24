hook.Add("PostEntityTakeDamage", "MetelMedic_TakeDamage", function(ent, dmg)
    if ent:IsPlayer() then
        local ply = ent
        if MetelMedic_Config.NoMedic[ent:getJobTable().name] then return end
        if dmg:IsBulletDamage() then
            local percent = math.random(1, 100)
            local chance = 100 - MetelMedic_Config.BleedingPercent

            if percent >= chance then
                if dmg:GetDamage() <= 25 then
                    ent:SetNWString("MetelMedic_Bleeding", "light")
                    MetelMedic_StartBleeding(ent, 2, 3)
                elseif dmg:GetDamage() >= 26 and dmg:GetDamage() <= 74 then
                    ent:SetNWString("MetelMedic_Bleeding", "medium")
                    MetelMedic_StartBleeding(ent, 4, 5)
                elseif dmg:GetDamage() >= 75 then
                    ent:SetNWString("MetelMedic_Bleeding", "heavy")
                    MetelMedic_StartBleeding(ent, 5, 10)
                end
                //print(percent)
                //print("Blutung")
                net.Start("metelmedic_enablebleedingeffect")
                net.Send(ent)
            end
        elseif dmg:IsFallDamage() then // Fügt Brüche hinzu
            if dmg:GetDamage() >= 40 then
                MetelMedic_StartLegFracture(ent)
            end
        end
    end
end)

function MetelMedic_StartBleeding(plystring, damage, bloodlose)  
    if timer.Exists("MetelMedic_BleedingTimer_"..plystring:SteamID64()) and plystring:GetNWInt("MetelMedic_Blood") <= 0 then
        timer.Destroy("MetelMedic_BleedingTimer_"..plystring:SteamID64())
        plystring:Kill()
        return
    end

    for k,v in pairs(plystring:GetNWString("MetelMedic_Bleeding")) do
        timer.Create("MetelMedic_BleedingTimer_"..plystring:SteamID64(), 5, 0, function()
            plystring:TakeDamage(damage,ent,ent)
            plystring:SetNWInt("MetelMedic_Blood", plystring:GetNWInt("MetelMedic_Blood", nil) - bloodlose)
        end)
    end
end

function MetelMedic_StartLegFracture(plystrings)
    plystrings:SetNWBool("MetelMedic_Brokenleg", true)
    if plystrings:GetNWBool("MetelMedic_Brokenleg") == true then
        plystrings:SetDuckSpeed(100)
        plystrings:SetWalkSpeed(100)
        plystrings:SetRunSpeed(100)
    end
end