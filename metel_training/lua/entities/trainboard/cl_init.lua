include("shared.lua")
local imgui = include("imgui.lua")

surface.CreateFont( "Metel_Training", {
	font = "Roboto",
	size = 80,
	weight = 700,
} )

surface.CreateFont( "Metel_Training1", {
	font = "Roboto",
	size = 140,
	weight = 700,
} )

surface.CreateFont( "Metel_Training2", {
	font = "Roboto",
	size = 50,
	weight = 700,
} )

local black = Color(44,44,44)
local white = Color(255, 255, 255)
local blue = Color(53,26,201)

local green = Color(23,167,26)
local red = Color(153,0,0)

net.Receive("Metel_Training_SyncGameRound",function()
	Metel_Training.trainingroundtime = net.ReadInt(32)
end)

function ENT:Draw()
	local ply = LocalPlayer()
	self:DrawModel()

	if imgui.Entity3D2D(self, Vector(8, -15, 1.7), Angle(0, 90, 360), 0.1) then
        draw.RoundedBox(1, -1748, -791, 3795, 1420, black)
        draw.SimpleText("Trainings-System v1.2 - Welcome, "..ply:Name(), "Metel_Training", -1700, -750, white)
        draw.SimpleText("Current round: "..Metel_Training.trainingroundtime.." Seconds", "Metel_Training", 1100, -750, white)
	
        if not ply:GetNWBool("MetelTrain_TeamBlue") then
            if imgui.xTextButton("Team Blau", "Metel_Training", -1700, -250, 350, 200) then
                net.Start("MetelTraining_ChangeTeam")
                net.WriteString("blue")
                net.SendToServer()
                Metel_Training.blue = Metel_Training.blue + 1
            end
        end

        if not ply:GetNWBool("MetelTrain_TeamRed") then
            if imgui.xTextButton("Team Rot", "Metel_Training", -1150, -250, 350, 200) then
                net.Start("MetelTraining_ChangeTeam")
                net.WriteString("red")
                net.SendToServer()
                Metel_Training.red = Metel_Training.red + 1
            end
        end

        -- Current team Leave button
        if ply:GetNWBool("MetelTrain_TeamBlue") == true or ply:GetNWBool("MetelTrain_TeamRed") == true then
            if imgui.xTextButton("Current Team Leave", "Metel_Training", -1650, 10, 800, 200) then
                if ply:GetNWBool("MetelTrain_TeamRed") then 
                    net.Start("MetelTraining_ChangeTeam")
                    net.WriteString("none")
                    net.SendToServer()
                    Metel_Training.red = Metel_Training.red - 1
                else
                    net.Start("MetelTraining_ChangeTeam")
                    net.WriteString("none")
                    net.SendToServer()
                    Metel_Training.blue = Metel_Training.blue - 1
                end
            end
        end

        -- Capture The Flag Button
        if not self:GetNWBool("MetelTraining_IsCapture") then
            if imgui.xTextButton("Capture the Flag", "Metel_Training", -400, -250, 500, 200) then
                net.Start("MetelTraining_ChangeGame")
                net.WriteEntity(self)
                net.WriteString("ctf")
                net.SendToServer()
            end
        end

        -- VS Button
        if not self:GetNWBool("MetelTraining_IsVS") then
            if imgui.xTextButton("Versus", "Metel_Training", 200, -250, 500, 200) then
                net.Start("MetelTraining_ChangeGame")
                net.WriteEntity(self)
                net.WriteString("vs")
                net.SendToServer()
            end
        end

        if self:GetNWBool("MetelTraining_IsCapture") or self:GetNWBool("MetelTraining_IsVS") then
            if imgui.xTextButton("End current game", "Metel_Training", -225, 350, 800, 200) then
                net.Start("Metel_Training_Leave")
                net.WriteEntity(self)
                net.SendToServer()
            end
            
            if self:GetNWBool("MetelTraining_RunGame") == false then
                if imgui.xTextButton("Start game", "Metel_Training", -225, 100, 800, 200) then
                    net.Start("MetelTraining_ChangeGameStatus")
                    net.WriteBool(true)
                    net.WriteEntity(self)
                    net.SendToServer()

                    for k,v in pairs(player.GetAll()) do
                        if v:GetNWBool("MetelTrain_TeamBlue") or v:GetNWBool("MetelTrain_TeamRed") then
                            v:ChatPrint("Let the game begin!")
                        end
                    end
                end
            else
                if imgui.xTextButton("Stop game", "Metel_Training", -225, 100, 800, 200) then
                    net.Start("MetelTraining_ChangeGameStatus")
                    net.WriteBool(false)
                    net.WriteEntity(self)
                    net.SendToServer()

                    for k,v in pairs(player.GetAll()) do
                        if v:GetNWBool("MetelTrain_TeamBlue") or v:GetNWBool("MetelTrain_TeamRed") then
                            v:ChatPrint("The game is over!")
                        end
                    end
                end
            end
        end

        draw.SimpleText("Select your team", "Metel_Training1", -1700, -500, white)
        draw.SimpleText("Game settings", "Metel_Training1", -350, -500, white)
        draw.SimpleText("Current players", "Metel_Training1", 1050, -500, white)

        draw.SimpleText("Team Red:", "Metel_Training", 1050, -305, white)
        draw.SimpleText("Team Blue:", "Metel_Training", 1600, -300, white)

        local count = 0

        // Team Blau
        for k,v in pairs(player.GetAll()) do
            if v:GetNWBool("MetelTrain_TeamBlue") then
                if v:GetNWBool("MetelTrain_IsOut") then
                    draw.SimpleText("- "..v:Name(), "Metel_Training2", 1550, -150 - count*60, red)
                else
                    draw.SimpleText("- "..v:Name(), "Metel_Training2", 1550, -150 - count*60, green)
                end
                count = count + 1
            end
        end

        local count = 0

        //Team Rot
        for k,v in pairs(player.GetAll()) do
            if v:GetNWBool("MetelTrain_TeamRed") then
                if v:GetNWBool("MetelTrain_IsOut") then
                    draw.SimpleText("- "..v:Name(), "Metel_Training2", 1000, -150 - count*60, red)
                else
                    draw.SimpleText("- "..v:Name(), "Metel_Training2", 1000, -150 - count*60, green)
                end
                count = count + 1
            end
        end

        //Aids Code incoming
        draw.SimpleText("|", "Metel_Training", 1500, -300, white)
        draw.SimpleText("|", "Metel_Training", 1500, -245, white)
        draw.SimpleText("|", "Metel_Training", 1500, -190, white)
        draw.SimpleText("|", "Metel_Training", 1500, -135, white)
        draw.SimpleText("|", "Metel_Training", 1500, -80, white)
        draw.SimpleText("|", "Metel_Training", 1500, -25, white)
        draw.SimpleText("|", "Metel_Training", 1500, 30, white)
        draw.SimpleText("|", "Metel_Training", 1500, 80, white)
        draw.SimpleText("|", "Metel_Training", 1500, 120, white)
        draw.SimpleText("|", "Metel_Training", 1500, 170, white)
        draw.SimpleText("|", "Metel_Training", 1500, 220, white)
        draw.SimpleText("|", "Metel_Training", 1500, 270, white)
        draw.SimpleText("|", "Metel_Training", 1500, 320, white)
        draw.SimpleText("|", "Metel_Training", 1500, 360, white)
    imgui.End3D2D()
	end
end