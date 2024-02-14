local flag = ClientsideModel("models/toju/mg_ctf/flag.mdl")
flag:SetNoDraw(true)

hook.Add("PostPlayerDraw", "Metel_Train_FlagDraw", function(ply)
    if not IsValid(ply) or not ply:Alive() then return end
    if ply:GetNWBool("MetelTrain_HasFlagRed") then
        local headbone = ply:LookupBone("ValveBiped.Bip01_Head1")
        flag:SetModelScale(0.2, 0)
        flag:SetPos(ply:GetBonePosition(headbone))
        flag:SetRenderOrigin(ply:LookupBone("ValveBiped.Bip01_Head1"))
        flag:SetupBones()
        flag:DrawModel()
        flag:SetRenderOrigin()
    end 
    if ply:GetNWBool("MetelTrain_HasFlagBlue") then
        local headbone = ply:LookupBone("ValveBiped.Bip01_Head1")
        flag:SetModelScale(0.2, 0)
        flag:SetPos(ply:GetBonePosition(headbone))
        flag:SetRenderOrigin(ply:LookupBone("ValveBiped.Bip01_Head1"))
        flag:SetupBones()
        flag:DrawModel()
        flag:SetRenderOrigin()
    end
end)

net.Receive("MetelTraining_Notfiyply", function()
    local col = net.ReadColor()
    local msg = net.ReadString()
    chat.AddText(col, msg)
end)

hook.Add("PreDrawHalos", "MetelTrain_Halos", function()
    local ply = LocalPlayer()
    local allplayer = player.GetAll()
    local allplayerred = {}
    local allplayerblue = {}
    local allplayerout = {}
    
    for k,v in pairs(allplayer) do 
        if v:GetNWBool("MetelTrain_TeamRed") and v:GetNWBool("MetelTrain_IsOut") == false then
            table.insert(allplayerred, v)
        end
        if v:GetNWBool("MetelTrain_TeamBlue") and v:GetNWBool("MetelTrain_IsOut") == false then
            table.insert(allplayerblue, v)
        end
        if v:GetNWBool("MetelTrain_IsOut") and (v:GetNWBool("MetelTrain_TeamRed") or v:GetNWBool("MetelTrain_TeamBlue")) then
            table.insert(allplayerout, v)
        end
    end  
    
    halo.Add(allplayerred, Color(255,0,0), 5, 5, 2)
    halo.Add(allplayerblue, Color(0,0,255), 5, 5, 2)
    halo.Add(allplayerout, Color(255,166,0), 5, 5, 2)    
end)