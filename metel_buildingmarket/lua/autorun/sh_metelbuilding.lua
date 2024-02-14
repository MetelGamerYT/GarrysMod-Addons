MetelBuilding_Config = {}

-- Objects that can be purchased
MetelBuilding_Config.BuyableObjects = {
    //["Display Name"] = {"Path to Model", Price, FOV, HP}
    ["Pylon"] = {"models/props/cs_assault/BarrelWarning.mdl", 25, Vector(0,0,0), 15},
    ["Radio"] = {"models/props_lab/citizenradio.mdl", 60, Vector(0,0,0), 25},
}

-- Maximum objects that a player can buy
MetelBuilding_Config.BuyLimit = 10