util.AddNetworkString("MetelTraining_ChangeTeam")
util.AddNetworkString("MetelTraining_ChangeGameStatus")
util.AddNetworkString("MetelTraining_ChangeGame")
util.AddNetworkString("Metel_Training_Leave")
util.AddNetworkString("Metel_Training_SyncGameRound")
util.AddNetworkString("luctus_zone_delete")
util.AddNetworkString("MetelTraining_Notfiyply")

hook.Add("PlayerInitialSpawn", "Metel_TrainingStart", function(ply)
    ply:SetNWBool("MetelTrain_TeamRed", false)
    ply:SetNWBool("MetelTrain_TeamBlue", false)
    ply:SetNWBool("MetelTrain_HasFlagBlue", false)
    ply:SetNWBool("MetelTrain_HasFlagRed", false)
    ply:SetNWBool("MetelTrain_IsOut", false)
    ply:SetNWInt("MetelTraining_TrainHP", 100)

    local res = sql.Query("CREATE TABLE IF NOT EXISTS training_zones(pos_one VARCHAR(200), pos_two VARCHAR(200), colorisread BOOLEAN)")
    if res == false then 
        print("[luctus_zones] ERROR DURING TABLE CREATION!")
        print(sql.LastError())
        return
    end
    if res == nil then print("[luctus_zones] PreInit Done!") end
  
    res = sql.Query("SELECT *, rowid FROM training_zones")
    if res == false then
        print("[luctus_zones] ERROR DURING SAFEZONE LOADING FROM DB!")
        print(sql.LastError())
        return
    end
  
    if res and #res > 0 then
        for k,v in pairs(res) do
            p1 = Vector(v["pos_one"])
            p2 = Vector(v["pos_two"])
            local ent = ents.Create("luctus_zone")
            ent:SetPos( (p1 + p2) / 2 )
            ent.min = p1
            ent.max = p2
            ent:SetIsRed(tobool(v["colorzone"]))
            //print(tobool(v["colorisread"]))
            ent:Spawn()
            ent:SetID(v["rowid"])
            //PrintTable(v)
        end
    end
end)

net.Receive("MetelTrain_ZoneColor", function()
    local colorget = net.ReadBool() // Wenn true = Rot Wenn false = Blau
end)

net.Receive("MetelTraining_ChangeTeam", function(len, ply)
    local switchteam = net.ReadString()
    if switchteam == "red" then
        ply:SetNWBool("MetelTrain_TeamRed", true)
        ply:SetNWBool("MetelTrain_TeamBlue", false)
        ply:SetNWInt("MetelTraining_TrainHP", 100)
    end
    if switchteam == "blue" then
        ply:SetNWBool("MetelTrain_TeamRed", false)
        ply:SetNWBool("MetelTrain_TeamBlue", true)
        ply:SetNWInt("MetelTraining_TrainHP", 100)
    end
    if switchteam == "none" then
        ply:SetNWBool("MetelTrain_TeamRed", false)
        ply:SetNWBool("MetelTrain_TeamBlue", false)
        ply:SetNWInt("MetelTraining_TrainHP", 100)
    end
end)

net.Receive("MetelTraining_ChangeGame", function()
    local board = net.ReadEntity()
    local plygame = net.ReadString()

    board:SetNWBool("MetelTraining_RunGame", false)
    if timer.Exists("MetelTraining_StartRound") then
        timer.Remove("MetelTraining_StartRound")
    end
    Metel_Training.trainingroundtime = 0
    syncRoundTime()

    if plygame == "vs" then
        board:SetNWBool("MetelTraining_IsVS", true)
        board:SetNWBool("MetelTraining_IsCapture", false)
    
        for k,v in pairs(ents.GetAll()) do
            if v:GetClass() == "flag_blue" or v:GetClass() == "flag_red" then
                v:Remove()
            end 
        end
    
        for k,v in pairs(player.GetAll()) do
            v:SetNWBool("MetelTrain_HasFlagBlue", false)
            v:SetNWBool("MetelTrain_HasFlagRed", false)
            v:SetNWBool("MetelTrain_IsOut", false)
            v:SetNWInt("MetelTraining_TrainHP", 100)
        end
    end
    if plygame == "ctf" then
        board:SetNWBool("MetelTraining_IsCapture", true)
        board:SetNWBool("MetelTraining_IsVS", false)
        
        local redflag = ents.Create("flag_red")
        redflag:SetPos(Vector(2188.033691, -5645.791992, -181.968750))
        redflag:DropToFloor()
        redflag:SetColor(Color(255,0,0))
        redflag:Spawn()
        redflag:Activate()
    
        local blueflag = ents.Create("flag_blue")
        blueflag:SetPos(Vector(3373.239258, -5439.186035, -181.968750))
        blueflag:DropToFloor()
        blueflag:SetColor(Color(0,0,255))
        blueflag:Spawn()
        blueflag:Activate()

        for k,v in pairs(player.GetAll()) do
            v:SetNWBool("MetelTrain_HasFlagBlue", false)
            v:SetNWBool("MetelTrain_HasFlagRed", false)
            v:SetNWBool("MetelTrain_IsOut", false)
            v:SetNWInt("MetelTraining_TrainHP", 100)
        end
    end
end)

net.Receive("Metel_Training_Leave", function(len, ply)
    local board = net.ReadEntity()

    board:SetNWBool("MetelTraining_IsCapture", false)
    board:SetNWBool("MetelTraining_IsVS", false)

    for k,v in pairs(ents.GetAll()) do
        if v:GetClass() == "flag_blue" or v:GetClass() == "flag_red" then
            v:Remove()
        end 
    end

    for k,v in pairs(player.GetAll()) do
        v:SetNWBool("MetelTrain_HasFlagBlue", false)
        v:SetNWBool("MetelTrain_HasFlagRed", false)
        v:SetNWBool("MetelTrain_IsOut", false)
        v:SetNWInt("MetelTraining_TrainHP", 100)
    end

    board:SetNWBool("MetelTraining_RunGame", false)
    timer.Remove("MetelTraining_StartRound")
    Metel_Training.trainingroundtime = 0
    syncRoundTime()
end)

function syncRoundTime()
    net.Start("Metel_Training_SyncGameRound")
        net.WriteInt(Metel_Training.trainingroundtime, 32)
    net.Broadcast()
end

net.Receive("MetelTraining_ChangeGameStatus", function()
    local startgame = net.ReadBool()
    local board = net.ReadEntity()
    
    if startgame then
        board:SetNWBool("MetelTraining_RunGame", true)

        timer.Create("MetelTraining_StartRound", 1, 0, function()
            Metel_Training.trainingroundtime = Metel_Training.trainingroundtime + 1
            syncRoundTime()
            print(Metel_Training.trainingroundtime)
        end)
    else
        board:SetNWBool("MetelTraining_RunGame", false)
        timer.Remove("MetelTraining_StartRound")
        Metel_Training.trainingroundtime = 0
        syncRoundTime()
    end
end)

hook.Add("ScalePlayerDamage", "MetelTraining_Airsoft", function(ply, hitgroup, dmginfo)
    local atk = dmginfo:GetAttacker()
    if atk:IsPlayer() and (atk:GetNWBool("MetelTrain_TeamRed") or atk:GetNWBool("MetelTrain_TeamBlue")) then
        ply:SetNWInt("MetelTraining_TrainHP", ply:GetNWInt("MetelTraining_TrainHP") - dmginfo:GetDamage())
        if ply:GetNWInt("MetelTraining_TrainHP", 100) < 1 then
            ply:SetNWBool("MetelTrain_IsOut", true)
            MetelTraining_NotifyPlayer(Color(0,90,55), "Spieler "..ply:Name().." ist raus!")
        end

        if ply:GetNWBool("MetelTrain_HasFlagRed") then
            ply:SetNWBool("MetelTrain_HasFlagRed", false)
            local redflag = ents.Create("flag_red")
            redflag:SetPos(ply:GetPos() + Vector(30,-5,0))
            redflag:DropToFloor()
            redflag:SetColor(Color(255,0,0))
            redflag:Spawn()
            redflag:Activate()
        end
        if ply:GetNWBool("MetelTrain_HasFlagBlue") then
            ply:SetNWBool("MetelTrain_HasFlagBlue", false)
            local blueflag = ents.Create("flag_blue")
            blueflag:SetPos(ply:GetPos() + Vector(30,-5,0))
            blueflag:DropToFloor()
            blueflag:SetColor(Color(0,0,255))
            blueflag:Spawn()
            blueflag:Activate()
        end
        return true
    end
end)

hook.Add("PlayerSay", "MetelTrain_Commands", function(ply, text)
    if not ply:IsSuperAdmin() then return end
    if text == "!changeblue" then
        ply:GetActiveWeapon().colorisread = false
        ply:ChatPrint("Your color: Blue")
        return ""
    elseif text == "!changered" then
        ply:GetActiveWeapon().colorisread = true
        ply:ChatPrint("Your color: Red")
        return ""
    end
end)

function luctusSavezone(posone, postwo, colorisread)
    local res = sql.Query("INSERT INTO training_zones VALUES("..sql.SQLStr(posone)..", "..sql.SQLStr(postwo)..", ".. tostring(colorisread) ..")")
    if res == false then 
      print("[luctus_zones] ERROR DURING SAVING SAFEZONE!")
      print(sql.LastError())
      return
    end
    if res == nil then print("[luctus_zones] Safezone saved successfully!") end
    
    local ent = ents.Create("luctus_zone")
    ent:SetPos( (posone + postwo) / 2 )
    ent.min = posone
    ent.max = postwo
    ent:SetIsRed(tobool(colorisread))
    ent:Spawn()
    
    res = sql.QueryRow("SELECT rowid FROM training_zones ORDER BY rowid DESC limit 1")
    if res == false then 
      print("[luctus_zones] ERROR DURING SETTING SAFEZONE ID!")
      print(sql.LastError())
      return
    end
    ent:SetID(tonumber(res["rowid"]))
end

net.Receive("luctus_zone_delete", function(len, ply)
    if not ply:IsAdmin() and not ply:IsSuperAdmin() then return end
    local rowid = net.ReadString()
    if not tonumber(rowid) then return end
    res = sql.QueryRow("DELETE FROM training_zones WHERE rowid = "..rowid)
    if res == false then 
      print("[luctus_zones] ERROR DURING SETTING SAFEZONE ID!")
      print(sql.LastError())
      return
    end
    print("[luctus_zones] DB Successfully deleted safezone!")
    
    for i=1,#ents.GetAll() do
      if ents.GetAll()[i]:GetClass() == "luctus_zone" and ents.GetAll()[i]:GetID() == tonumber(rowid) then
        ents.GetAll()[i]:Remove()
        break
      end
    end
    print("[luctus_zones] Successfully removed safezone from map!")
end)

function MetelTraining_NotifyPlayer(col, message)
    for k,v in pairs(player.GetAll()) do
        if v:GetNWBool("MetelTrain_TeamRed") or v:GetNWBool("MetelTrain_TeamBlue") then
            net.Start("MetelTraining_Notfiyply")
            net.WriteColor(col)
            net.WriteString(message)
            net.Send(v)
        end
    end
end