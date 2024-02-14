--Made by DerMetelGamerYT Version 1.2.1

MetelMedic_Config = {}

MetelMedic_Config.DieTimer = 90 -- How long until you die / Lie dying

MetelMedic_Config.RespawnTimer = 10 -- How long it takes to respawn after death

MetelMedic_Config.BleedingPercent = 5 -- How high is the chance of bleeding from bullets

MetelMedic_Config.BleedingStopPercent = 10 -- What is the chance that bleeding will stop on its own?

-- Which jobs cannot bleed and respawn in RespawnTimer seconds
MetelMedic_Config.NoMedic = {
    ["Hobo"] = true,
    ["Staff"] = true,
}

-- Which jobs are medical jobs
MetelMedic_Config.Medics = {
    ["Medic"] = true,
}

-- Which jobs do not bleed (effect, does not always work at the moment)
MetelMedic_Config.NoBloodEffects = {
    ["Hobo"] = true,
}