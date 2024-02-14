util.AddNetworkString("MetelManage_ChangeCode")
util.AddNetworkString("MetelManage_ChangePCStatus")
util.AddNetworkString("MetelManage_SendMessage")

MetelManage_Config = {}

MetelManage_Config.AllowedJobs = {
    ["O5"] = true,
    ["Hobo"] = true,
}

net.Receive("MetelManage_ChangeCode", function(len, ply)
    if not MetelManage_Config.AllowedJobs[ply:getJobTable().name] then 
        ply:EmitSound("metelfd/fderror.ogg")
    return end

    local code = net.ReadString()
    if OverMetel_ChangeCode then
        OverMetel_ChangeCode(code)
    end
end)

net.Receive("MetelManage_ChangePCStatus", function(len, ply)
    local status = net.ReadString()
    local pcid = net.ReadString()

    if status == "active" then
        ply:SetNWBool("MetelManage_IsOnline", true)
        ply:SetNWInt("MetelManage_PCID", pcid)
    end
end)

net.Receive("MetelManage_SendMessage", function(len, ply)
    local message = net.ReadString()
end)