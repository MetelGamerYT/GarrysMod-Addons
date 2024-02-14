util.AddNetworkString("metelbaumarkt_openmenu")
util.AddNetworkString("metelbaumarkt_spawnobject")

net.Receive("metelbaumarkt_spawnobject", function()
    local owner = net.ReadEntity() -- Player
    local modelpath = net.ReadString() -- Model
    local objecthealth = net.ReadString() -- HP
    local price = net.ReadString()

    if owner:GetNWInt("metelbuilding_buildinglimit") >= MetelBuilding_Config.BuyLimit then
        owner:ChatPrint("You already have the maximum number of objects("..MetelBuilding_Config.BuyLimit..")")
        return
    end
    local spawnobject = ents.Create("metelbuilding_base")
    spawnobject:SetPos(MetelLib_FindPosition(owner))
    spawnobject:SetNWEntity("metelbuilding_owner", owner)
    spawnobject:SetNWString("metelbuilding_modelpath", modelpath)
    spawnobject:SetNWString("metelbuilding_ownername", owner:GetName())
    spawnobject:SetHealth(objecthealth)
    spawnobject:SetMaxHealth(objecthealth)
    spawnobject:Spawn()
    spawnobject:SetModel(modelpath)
    owner:SetNWInt("metelbuilding_buildinglimit", owner:GetNWInt("metelbuilding_buildinglimit") + 1)
    owner:setDarkRPVar("money", owner:getDarkRPVar("money") - price)
	DarkRP.notify(owner,0,5,"Thank you for your purchase!")
end)